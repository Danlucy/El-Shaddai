"""Cloud Functions for Firebase entry point."""

from __future__ import annotations

from datetime import datetime, timezone
from typing import Any

from firebase_admin import auth, firestore, initialize_app
from firebase_functions import https_fn, logger

from src.booking import FUNCTION_REGIONS, submitBooking


initialize_app()

_OPTIONAL_USER_FIELDS = (
    "lastName",
    "image",
    "nationality",
    "phoneNumber",
    "description",
    "address",
    "birthAddress",
    "church",
    "beleifInGod",
    "prayerNetwork",
    "definitionOfGod",
    "godsCalling",
    "recommendation",
    "fcmToken",
)


def _auth_user_created_at(user_record: Any) -> datetime | Any:
    """Return the Authentication creation time or a server timestamp."""
    metadata = getattr(user_record, "user_metadata", None)
    creation_timestamp = getattr(metadata, "creation_timestamp", None)
    if isinstance(creation_timestamp, (int, float)):
        return datetime.fromtimestamp(
            creation_timestamp / 1000,
            tz=timezone.utc,
        )
    return firestore.SERVER_TIMESTAMP


def _build_user_repair(
    user_record: Any,
    existing_data: dict[str, Any],
) -> dict[str, Any]:
    """Build a non-destructive update matching the Dart UserModel schema."""
    update: dict[str, Any] = {
        "uid": user_record.uid,
        "email": user_record.email,
    }

    existing_name = existing_data.get("name")
    if not isinstance(existing_name, str) or not existing_name.strip():
        legacy_name = existing_data.get("displayName")
        display_name = (
            legacy_name
            if isinstance(legacy_name, str) and legacy_name.strip()
            else user_record.display_name
        )
        update["name"] = display_name or "Nameless"

    if not isinstance(existing_data.get("roles"), dict):
        update["roles"] = {}

    if not isinstance(existing_data.get("isPublic"), bool):
        update["isPublic"] = False

    if existing_data.get("createdAt") is None:
        update["createdAt"] = _auth_user_created_at(user_record)

    for field_name in _OPTIONAL_USER_FIELDS:
        if field_name not in existing_data:
            update[field_name] = None

    return update


@https_fn.on_call(region=FUNCTION_REGIONS)
def deleteUserAuth(request: https_fn.CallableRequest) -> dict[str, Any]:
    """Delete the requested Firebase Authentication user."""
    if request.auth is None:
        raise https_fn.HttpsError(
            code=https_fn.FunctionsErrorCode.UNAUTHENTICATED,
            message="You must be logged in.",
        )

    data = request.data if isinstance(request.data, dict) else {}
    target_uid = data.get("uid")
    if not target_uid:
        raise https_fn.HttpsError(
            code=https_fn.FunctionsErrorCode.INVALID_ARGUMENT,
            message="Missing 'uid'.",
        )

    try:
        auth.delete_user(target_uid)
        return {
            "success": True,
            "message": f"Deleted user {target_uid}",
        }
    except Exception as error:
        logger.error("Error deleting user", error=str(error))
        raise https_fn.HttpsError(
            code=https_fn.FunctionsErrorCode.INTERNAL,
            message="Failed to delete user.",
        ) from error


@https_fn.on_call(region=FUNCTION_REGIONS)
def backfillEmailsToFirestore(
    _request: https_fn.CallableRequest,
) -> dict[str, Any]:
    """Create or repair user documents from Firebase Authentication."""
    try:
        count = 0
        page_token: str | None = None
        db = firestore.client()
        users_collection = db.collection("users")

        while True:
            users_page = auth.list_users(
                max_results=1000,
                page_token=page_token,
            )
            pending_users = [
                user_record
                for user_record in users_page.users
                if user_record.email is not None
            ]

            # Firestore write batches accept at most 500 operations.
            for chunk_start in range(0, len(pending_users), 500):
                chunk = pending_users[chunk_start : chunk_start + 500]
                user_refs = [
                    users_collection.document(user_record.uid)
                    for user_record in chunk
                ]
                existing_documents = {
                    snapshot.id: snapshot.to_dict() or {}
                    for snapshot in db.get_all(user_refs)
                    if snapshot.exists
                }

                batch = db.batch()
                for user_record in chunk:
                    user_ref = users_collection.document(user_record.uid)
                    repair_data = _build_user_repair(
                        user_record,
                        existing_documents.get(user_record.uid, {}),
                    )
                    batch.set(
                        user_ref,
                        repair_data,
                        merge=True,
                    )
                batch.commit()

            count += len(pending_users)
            page_token = users_page.next_page_token
            if not page_token:
                break

        return {
            "success": True,
            "message": (
                f"Successfully synced {count} users to Firestore."
            ),
        }
    except Exception as error:
        logger.error("Backfill failed", error=str(error))
        raise https_fn.HttpsError(
            code=https_fn.FunctionsErrorCode.INTERNAL,
            message="An error occurred during backfill.",
        ) from error
