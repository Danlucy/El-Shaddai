"""Firebase callable handler for atomic booking submission."""

from __future__ import annotations

from datetime import datetime, timezone
from typing import Any

from firebase_admin import firestore
from firebase_functions import https_fn, logger
from google.cloud.firestore_v1.base_document import DocumentSnapshot
from google.cloud.firestore_v1.base_query import FieldFilter
from google.cloud.firestore_v1.transaction import Transaction

from src.booking_logic import (
    BookingValidationError,
    ExistingBookingRange,
    ParsedBookingRequest,
    TimeRange,
    build_candidate_ranges,
    find_conflicting_dates,
    format_conflicting_dates,
    parse_request,
)


FUNCTION_REGIONS = ["asia-southeast1"]
CHURCHES_COLLECTION = "churches"
BOOKINGS_COLLECTION = "bookings"
BOOKING_REQUESTS_COLLECTION = "bookingRequests"
ALLOWED_BOOKING_ROLES = {"admin", "watchman", "watchLeader"}


def _payload_shape(value: object) -> dict[str, Any]:
    """Return safe structural details for production diagnostics."""
    if not isinstance(value, dict):
        return {"payload_type": type(value).__name__}

    time_range = value.get("timeRange")
    return {
        "payload_type": "dict",
        "payload_keys": sorted(value.keys()),
        "has_booking_key": "booking" in value,
        "time_range_type": type(time_range).__name__,
        "start_type": (
            type(time_range.get("start")).__name__
            if isinstance(time_range, dict)
            else None
        ),
        "end_type": (
            type(time_range.get("end")).__name__
            if isinstance(time_range, dict)
            else None
        ),
    }


@https_fn.on_call(region=FUNCTION_REGIONS)
def submitBooking(request: https_fn.CallableRequest) -> dict[str, Any]:
    """Create or update a booking in one idempotent Firestore transaction."""
    logger.info("submitBooking called", **_payload_shape(request.data))
    if request.auth is None or request.auth.uid is None:
        raise https_fn.HttpsError(
            code=https_fn.FunctionsErrorCode.UNAUTHENTICATED,
            message="You must be logged in.",
        )

    try:
        parsed = parse_request(request.data)
    except BookingValidationError as error:
        logger.warn(
            "submitBooking validation rejected",
            validation_error=str(error),
            **_payload_shape(request.data),
        )
        raise https_fn.HttpsError(
            code=https_fn.FunctionsErrorCode.INVALID_ARGUMENT,
            message=str(error),
        ) from error

    user_id = request.auth.uid
    db = firestore.client()
    user_snapshot = db.collection("users").document(user_id).get()
    user_data = user_snapshot.to_dict() or {}
    roles = user_data.get("roles")
    organization_role = (
        roles.get(parsed.organization_id) if isinstance(roles, dict) else None
    )
    has_booking_management_role = (
        isinstance(organization_role, str)
        and organization_role in ALLOWED_BOOKING_ROLES
    )

    if not has_booking_management_role and parsed.booking_id is None:
        raise https_fn.HttpsError(
            code=https_fn.FunctionsErrorCode.PERMISSION_DENIED,
            message=(
                "You do not have permission to create bookings for this "
                "organization."
            ),
        )

    try:
        result = _run_booking_transaction(
            db,
            parsed,
            user_id,
            has_booking_management_role,
        )
        logger.info(
            "submitBooking succeeded",
            request_id=parsed.request_id,
            booking_count=len(result.get("bookingIds", [])),
        )
        return result
    except https_fn.HttpsError:
        raise
    except Exception as error:
        logger.error("submitBooking failed", error=str(error))
        raise https_fn.HttpsError(
            code=https_fn.FunctionsErrorCode.INTERNAL,
            message=(
                "The booking could not be saved by the server. Please retry."
            ),
        ) from error


def _run_booking_transaction(
    db: Any,
    parsed: ParsedBookingRequest,
    user_id: str,
    has_booking_management_role: bool,
) -> dict[str, Any]:
    organization_ref = (
        db.collection(CHURCHES_COLLECTION).document(parsed.organization_id)
    )
    bookings_ref = organization_ref.collection(BOOKINGS_COLLECTION)
    receipt_ref = (
        organization_ref.collection(BOOKING_REQUESTS_COLLECTION)
        .document(parsed.request_id)
    )
    schedule_guard_ref = (
        organization_ref.collection("system").document("bookingSchedule")
    )
    candidates = build_candidate_ranges(parsed)
    if parsed.booking_id is not None:
        target_ids = [parsed.booking_id]
    else:
        target_ids = [
            (
                parsed.request_id
                if len(candidates) == 1
                else f"{parsed.request_id}_{index}"
            )
            for index in range(len(candidates))
        ]

    @firestore.transactional
    def save(transaction: Transaction) -> dict[str, Any]:
        receipt_snapshot = receipt_ref.get(transaction=transaction)
        if receipt_snapshot.exists:
            receipt = receipt_snapshot.to_dict() or {}
            if receipt.get("userId") != user_id:
                raise https_fn.HttpsError(
                    code=https_fn.FunctionsErrorCode.PERMISSION_DENIED,
                    message=(
                        "This booking request ID belongs to another user."
                    ),
                )
            return {
                "success": True,
                "bookingIds": _read_string_array(receipt.get("bookingIds")),
                "message": "Booking was already saved.",
            }

        # This sentinel document serializes schedule writers for this church.
        schedule_guard_ref.get(transaction=transaction)

        existing_booking_data: dict[str, Any] | None = None
        if parsed.booking_id is not None:
            existing_snapshot = (
                bookings_ref.document(parsed.booking_id)
                .get(transaction=transaction)
            )
            if not existing_snapshot.exists:
                raise https_fn.HttpsError(
                    code=https_fn.FunctionsErrorCode.NOT_FOUND,
                    message="The booking being updated no longer exists.",
                )
            existing_booking_data = existing_snapshot.to_dict() or {}
            if (
                not has_booking_management_role
                and existing_booking_data.get("userId") != user_id
            ):
                raise https_fn.HttpsError(
                    code=https_fn.FunctionsErrorCode.PERMISSION_DENIED,
                    message=(
                        "Only the booking host or a booking manager can "
                        "update this booking."
                    ),
                )
        else:
            target_refs = [
                bookings_ref.document(target_id)
                for target_id in target_ids
            ]
            target_snapshots = db.get_all(
                target_refs,
                transaction=transaction,
            )
            if any(snapshot.exists for snapshot in target_snapshots):
                raise https_fn.HttpsError(
                    code=https_fn.FunctionsErrorCode.ALREADY_EXISTS,
                    message=(
                        "This booking request conflicts with an existing "
                        "request ID. Please reopen the form and try again."
                    ),
                )

        earliest_start = min(
            candidate.start_millis for candidate in candidates
        )
        latest_end = max(candidate.end_millis for candidate in candidates)
        overlapping_query = (
            bookings_ref.where(
                filter=FieldFilter(
                    "timeRange.start",
                    "<",
                    _millis_to_datetime(latest_end),
                )
            )
            .where(
                filter=FieldFilter(
                    "timeRange.end",
                    ">",
                    _millis_to_datetime(earliest_start),
                )
            )
        )
        overlapping_snapshots = overlapping_query.stream(
            transaction=transaction
        )
        existing_ranges = [
            booking_range
            for snapshot in overlapping_snapshots
            if snapshot.id != parsed.booking_id
            if (booking_range := _read_existing_range(snapshot)) is not None
        ]
        conflicting_dates = find_conflicting_dates(
            candidates,
            existing_ranges,
            parsed.timezone_offset_minutes,
        )

        if conflicting_dates:
            label = {
                "daily": "Daily booking",
                "weekly": "Weekly booking",
                "none": "Booking",
            }[parsed.booking.recurrence_state]
            date_label = "date" if len(conflicting_dates) == 1 else "dates"
            raise https_fn.HttpsError(
                code=https_fn.FunctionsErrorCode.ALREADY_EXISTS,
                message=(
                    f"{label} failed. Conflicting {date_label}: "
                    f"{format_conflicting_dates(conflicting_dates)}."
                ),
                details={"conflictingDates": conflicting_dates},
            )

        now = _iso_timestamp_now()
        existing_created_at = (
            existing_booking_data.get("createdAt")
            if existing_booking_data is not None
            else None
        )
        created_at = (
            existing_created_at
            if isinstance(existing_created_at, str)
            else now
        )
        if parsed.booking_id is not None:
            group_id = _read_nullable_string(
                (existing_booking_data or {}).get("groupId")
            )
        else:
            group_id = parsed.request_id if len(candidates) > 1 else None

        for index, candidate in enumerate(candidates):
            target_ref = bookings_ref.document(target_ids[index])
            if parsed.booking_id is not None:
                occurrence_id = _read_nullable_string(
                    (existing_booking_data or {}).get("occurrenceId")
                )
            else:
                occurrence_id = (
                    parsed.zoom_occurrence_ids[index]
                    if index < len(parsed.zoom_occurrence_ids)
                    else None
                )

            transaction.set(
                target_ref,
                {
                    "title": parsed.booking.title,
                    "recurrenceState": parsed.booking.recurrence_state,
                    "host": parsed.booking.host,
                    "createdAt": created_at,
                    "timeRange": {
                        "start": _millis_to_datetime(
                            candidate.start_millis
                        ),
                        "end": _millis_to_datetime(candidate.end_millis),
                    },
                    "userId": user_id,
                    "id": target_ref.id,
                    "location": parsed.booking.location,
                    "description": parsed.booking.description,
                    "password": parsed.booking.password,
                    "recurrenceModel": parsed.recurrence,
                    "occurrenceId": occurrence_id,
                    "groupId": group_id,
                },
            )

        transaction.set(
            schedule_guard_ref,
            {
                "lastBookingRequestId": parsed.request_id,
                "updatedAt": firestore.SERVER_TIMESTAMP,
            },
        )
        transaction.set(
            receipt_ref,
            {
                "userId": user_id,
                "bookingIds": target_ids,
                "createdAt": firestore.SERVER_TIMESTAMP,
            },
        )

        if len(target_ids) == 1:
            message = (
                "Booking updated successfully."
                if parsed.booking_id is not None
                else "Booking created successfully."
            )
        else:
            message = (
                f"{len(target_ids)} recurring bookings created successfully."
            )
        return {
            "success": True,
            "bookingIds": target_ids,
            "message": message,
        }

    return save(db.transaction())


def _read_existing_range(
    document: DocumentSnapshot,
) -> ExistingBookingRange | None:
    document_data = document.to_dict() or {}
    time_range = document_data.get("timeRange")
    if not isinstance(time_range, dict):
        return None
    start_millis = _timestamp_to_millis(time_range.get("start"))
    end_millis = _timestamp_to_millis(time_range.get("end"))
    if start_millis is None or end_millis is None:
        return None
    return ExistingBookingRange(
        id=document.id,
        start_millis=start_millis,
        end_millis=end_millis,
    )


def _millis_to_datetime(value: int) -> datetime:
    return datetime.fromtimestamp(value / 1000, tz=timezone.utc)


def _timestamp_to_millis(value: object) -> int | None:
    if isinstance(value, datetime):
        aware_value = (
            value.replace(tzinfo=timezone.utc)
            if value.tzinfo is None
            else value
        )
        return int(aware_value.timestamp() * 1000)
    timestamp_method = getattr(value, "timestamp", None)
    if callable(timestamp_method):
        result = timestamp_method()
        if isinstance(result, (int, float)):
            return int(result * 1000)
    return None


def _read_nullable_string(value: object) -> str | None:
    return value if isinstance(value, str) else None


def _read_string_array(value: object) -> list[str]:
    if not isinstance(value, list):
        return []
    return [item for item in value if isinstance(item, str)]


def _iso_timestamp_now() -> str:
    return (
        datetime.now(tz=timezone.utc)
        .isoformat(timespec="milliseconds")
        .replace("+00:00", "Z")
    )
