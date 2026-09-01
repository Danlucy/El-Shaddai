"""Validation and scheduling logic for booking callable functions.

This module deliberately has no Firebase dependencies. Keeping the deterministic
parts separate makes them fast to test and prevents function discovery from
requiring local Google credentials.
"""

from __future__ import annotations

from dataclasses import dataclass
from datetime import datetime, timezone
import math
import time
from typing import Any, Literal, Never


RecurrenceState = Literal["none", "daily", "weekly"]
MILLISECONDS_PER_DAY = 24 * 60 * 60 * 1000
MAXIMUM_SAFE_INTEGER = (2**53) - 1


class BookingValidationError(ValueError):
    """Raised when callable booking data fails validation."""


@dataclass(frozen=True)
class TimeRange:
    start_millis: int
    end_millis: int


@dataclass(frozen=True)
class ExistingBookingRange(TimeRange):
    id: str


@dataclass(frozen=True,)
class Booking:
    title: str
    recurrence_state: RecurrenceState
    host: str
    start_millis: int
    end_millis: int
    location: dict[str, Any]
    description: str
    password: str | None


@dataclass(frozen=True)
class ParsedBookingRequest:
    request_id: str
    organization_id: str
    booking_id: str | None
    timezone_offset_minutes: int
    booking: Booking
    recurrence: dict[str, int | None] | None
    zoom_occurrence_ids: list[str | None]


def parse_request(
    value: object,
    *,
    now_millis: int | None = None,
) -> ParsedBookingRequest:
    """Parse and validate the flat public callable payload."""
    data = _read_record(value, "request")
    if "booking" in data:
        _invalid(
            "booking must not be nested. Send booking fields directly in "
            "the request."
        )

    time_range = _read_record(
        data.get("timeRange"),
        "timeRange",
    )
    location = _read_record(
        data.get("location"),
        "location",
    )
    recurrence_state = _read_required_string(
        data.get("recurrenceState"),
        "recurrenceState",
    )
    if recurrence_state not in ("none", "daily", "weekly"):
        _invalid("recurrenceState is invalid.")
    state: RecurrenceState = recurrence_state
    end_millis = _read_integer(
        time_range.get("end"),
        "timeRange.end",
    )
    start_millis = _read_integer(
        time_range.get("start"),
        "timeRange.start",
    )
  
    if end_millis <= start_millis:
        _invalid("The booking end time must be after its start time.")

    current_millis = (
        int(time.time() * 1000) if now_millis is None else now_millis
    )
    if start_millis < current_millis - 60_000:
        _invalid("The booking start time cannot be in the past.")

    duration = end_millis - start_millis
    maximum_duration = (
        7 * MILLISECONDS_PER_DAY
        if state == "weekly"
        else MILLISECONDS_PER_DAY
    )
    if duration > maximum_duration:
        _invalid(
            "Weekly bookings cannot be longer than 7 days."
            if state == "weekly"
            else "Bookings cannot be longer than 24 hours."
        )

    recurrence = _parse_recurrence(data.get("recurrence"), state)
    chords_value = location.get("chords")
    chords = (
        None if chords_value is None else _read_coordinates(chords_value)
    )
    timezone_offset_minutes = _read_integer(
        data.get("timezoneOffsetMinutes"),
        "timezoneOffsetMinutes",
    )
    if not -840 <= timezone_offset_minutes <= 840:
        _invalid("timezoneOffsetMinutes is invalid.")

    request_id = _read_document_id(data.get("requestId"), "requestId")
    organization_id = _read_document_id(
        data.get("organizationId"),
        "organizationId",
    )
    booking_id_value = data.get("bookingId")
    booking_id = (
        None
        if booking_id_value is None
        else _read_document_id(booking_id_value, "bookingId")
    )
    is_updating = _read_boolean(data.get("isUpdating"), "isUpdating")
    validate_booking_operation(is_updating, booking_id)

    occurrences_value = data.get("zoomOccurrences")
    zoom_occurrences = (
        []
        if occurrences_value is None
        else _read_array(occurrences_value, "zoomOccurrences")
    )
    zoom_occurrence_ids: list[str | None] = []
    for occurrence in zoom_occurrences:
        if occurrence is None:
            zoom_occurrence_ids.append(None)
            continue
        occurrence_record = _read_record(occurrence, "zoomOccurrence")
        zoom_occurrence_ids.append(
            _read_optional_string(
                occurrence_record.get("occurrence_id"),
                "zoomOccurrence.occurrence_id",
                200,
            )
        )

    return ParsedBookingRequest(
        request_id=request_id,
        organization_id=organization_id,
        booking_id=booking_id,
        timezone_offset_minutes=timezone_offset_minutes,
        booking=Booking(
            title=_read_limited_string(
                data.get("title"),
                "title",
                200,
            ),
            recurrence_state=state,
            host=_read_limited_string(
                data.get("host"),
                "host",
                200,
            ),
            start_millis=start_millis,
            end_millis=end_millis,
            location={
                "address": _read_optional_string(
                    location.get("address"),
                    "location.address",
                    500,
                ),
                "web": _read_optional_string(
                    location.get("web"),
                    "location.web",
                    2_000,
                ),
                "chords": chords,
            },
            description=_read_limited_string(
                data.get("description"),
                "description",
                10_000,
            ),
            password=_read_optional_string(
                data.get("password"),
                "password",
                200,
            ),
        ),
        recurrence=recurrence,
        zoom_occurrence_ids=zoom_occurrence_ids,
    )


def build_candidate_ranges(parsed: ParsedBookingRequest) -> list[TimeRange]:
    """Expand a booking request into the concrete ranges to persist."""
    if (
        parsed.booking_id is not None
        or parsed.booking.recurrence_state == "none"
    ):
        return [
            TimeRange(
                parsed.booking.start_millis,
                parsed.booking.end_millis,
            )
        ]

    frequency = (
        int(parsed.recurrence["end_times"])
        if parsed.recurrence is not None
        else 1
    )
    interval_days = (
        1 if parsed.booking.recurrence_state == "daily" else 7
    )
    interval_millis = interval_days * MILLISECONDS_PER_DAY
    return [
        TimeRange(
            parsed.booking.start_millis + (interval_millis * index),
            parsed.booking.end_millis + (interval_millis * index),
        )
        for index in range(frequency)
    ]


def find_conflicting_dates(
    candidates: list[TimeRange],
    existing_ranges: list[ExistingBookingRange],
    timezone_offset_minutes: int,
) -> list[str]:
    """Return sorted local calendar days on which ranges overlap."""
    day_keys: set[str] = set()
    offset_millis = timezone_offset_minutes * 60 * 1000

    for candidate in candidates:
        for existing in existing_ranges:
            if (
                candidate.start_millis >= existing.end_millis
                or candidate.end_millis <= existing.start_millis
            ):
                continue

            intersection_start = (
                max(candidate.start_millis, existing.start_millis)
                + offset_millis
            )
            intersection_end = (
                min(candidate.end_millis, existing.end_millis)
                + offset_millis
            )
            first_day = datetime.fromtimestamp(
                intersection_start / 1000,
                tz=timezone.utc,
            )
            day_cursor = _utc_day_millis(
                first_day.year,
                first_day.month,
                first_day.day,
            )

            while day_cursor < intersection_end:
                day = datetime.fromtimestamp(
                    day_cursor / 1000,
                    tz=timezone.utc,
                )
                day_keys.add(f"{day.year}-{day.month}-{day.day}")
                day_cursor += MILLISECONDS_PER_DAY

    return sorted(day_keys, key=_day_key_to_millis)


def format_conflicting_dates(day_keys: list[str]) -> str:
    """Format conflict dates exactly as expected by existing clients."""
    displayed: list[str] = []
    for key in day_keys[:3]:
        year, month, day = (int(part) for part in key.split("-"))
        displayed.append(f"[{day}/{month}/{str(year)[-2:]}]")
    suffix = " and more" if len(day_keys) > 3 else ""
    return f"{', '.join(displayed)}{suffix}"


def validate_booking_operation(
    is_updating: bool,
    booking_id: str | None = None,
) -> None:
    """Reject update payloads that cannot identify their target booking."""
    if is_updating and booking_id is None:
        _invalid(
            "Booking update failed because the booking ID is missing. "
            "Reopen the booking and try again."
        )


def _parse_recurrence(
    value: object,
    state: RecurrenceState,
) -> dict[str, int | None] | None:
    if state == "none":
        return None

    recurrence = _read_record(value, "recurrence")
    frequency = _read_integer(
        recurrence.get("end_times"),
        "recurrence.end_times",
    )
    if not 1 <= frequency <= 60:
        _invalid(
            "Recurring bookings must contain between 1 and 60 occurrences."
        )

    expected_type = 1 if state == "daily" else 2
    recurrence_type = _read_integer(
        recurrence.get("type"),
        "recurrence.type",
    )
    if recurrence_type != expected_type:
        _invalid("The recurrence type does not match the booking.")

    weekly_days_value = recurrence.get("weekly_days")
    return {
        "end_times": frequency,
        "weekly_days": (
            None
            if weekly_days_value is None
            else _read_integer(weekly_days_value, "recurrence.weekly_days")
        ),
        "type": recurrence_type,
        "repeat_interval": _read_integer(
            recurrence.get("repeat_interval"),
            "recurrence.repeat_interval",
        ),
    }


def _read_record(value: object, field: str) -> dict[str, Any]:
    if not isinstance(value, dict):
        _invalid(f"{field} must be an object.")
    return value


def _read_array(value: object, field: str) -> list[object]:
    if not isinstance(value, list):
        _invalid(f"{field} must be a list.")
    return value


def _read_integer(value: object, field: str) -> int:
    value = _unwrap_callable_int64(value, field)

    if isinstance(value, str):
        try:
            parsed_value = int(value)
        except ValueError:
            _invalid(f"{field} must be an integer.")
        if (
            str(parsed_value) != value
            or abs(parsed_value) > MAXIMUM_SAFE_INTEGER
        ):
            _invalid(f"{field} must be an integer.")
        return parsed_value

    if (
        isinstance(value, bool)
        or not isinstance(value, (int, float))
        or (isinstance(value, float) and not math.isfinite(value))
        or int(value) != value
        or abs(value) > MAXIMUM_SAFE_INTEGER
    ):
        _invalid(f"{field} must be an integer.")
    return int(value)


def _unwrap_callable_int64(value: object, field: str) -> object:
    if not isinstance(value, dict):
        return value
    if (
        value.get("@type")
        != "type.googleapis.com/google.protobuf.Int64Value"
        or not isinstance(value.get("value"), str)
    ):
        _invalid(f"{field} must be an integer.")
    return value["value"]


def _read_boolean(value: object, field: str) -> bool:
    if not isinstance(value, bool):
        _invalid(f"{field} must be true or false.")
    return value


def _read_required_string(value: object, field: str) -> str:
    if not isinstance(value, str) or len(value.strip()) == 0:
        _invalid(f"{field} is required.")
    return value.strip()


def _read_limited_string(
    value: object,
    field: str,
    maximum_length: int,
) -> str:
    result = _read_required_string(value, field)
    if _javascript_string_length(result) > maximum_length:
        _invalid(f"{field} is too long.")
    return result


def _read_optional_string(
    value: object,
    field: str,
    maximum_length: int,
) -> str | None:
    if value is None:
        return None
    if not isinstance(value, str):
        _invalid(f"{field} must be text.")
    if _javascript_string_length(value) > maximum_length:
        _invalid(f"{field} is too long.")
    return value


def _read_coordinates(value: object) -> dict[str, float | int]:
    coordinates = _read_record(value, "location.chords")
    latitude = coordinates.get("latitude")
    longitude = coordinates.get("longitude")
    if (
        isinstance(latitude, bool)
        or not isinstance(latitude, (int, float))
        or not math.isfinite(latitude)
        or not -90 <= latitude <= 90
        or isinstance(longitude, bool)
        or not isinstance(longitude, (int, float))
        or not math.isfinite(longitude)
        or not -180 <= longitude <= 180
    ):
        _invalid("location.chords is invalid.")
    return {"latitude": latitude, "longitude": longitude}


def _read_document_id(value: object, field: str) -> str:
    document_id = _read_required_string(value, field)
    if (
        _javascript_string_length(document_id) > 120
        or "/" in document_id
        or document_id in (".", "..")
    ):
        _invalid(f"{field} is invalid.")
    return document_id


def _utc_day_millis(year: int, month: int, day: int) -> int:
    return int(
        datetime(year, month, day, tzinfo=timezone.utc).timestamp() * 1000
    )


def _day_key_to_millis(key: str) -> int:
    year, month, day = (int(part) for part in key.split("-"))
    return _utc_day_millis(year, month, day)


def _javascript_string_length(value: str) -> int:
    """Return JavaScript's UTF-16 code-unit length for parity with TypeScript."""
    return len(value.encode("utf-16-le")) // 2


def _invalid(message: str) -> Never:
    raise BookingValidationError(message)
