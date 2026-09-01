"""Integration-oriented tests for the Firebase function entry point."""

from __future__ import annotations

from dataclasses import dataclass
from datetime import datetime, timezone
import inspect
from types import SimpleNamespace
import unittest
from unittest.mock import patch

import main


@dataclass
class _User:
    uid: str
    email: str | None
    display_name: str | None = None
    creation_timestamp: int | None = None

    @property
    def user_metadata(self) -> SimpleNamespace:
        return SimpleNamespace(creation_timestamp=self.creation_timestamp)


@dataclass
class _Snapshot:
    id: str
    data: dict[str, object] | None

    @property
    def exists(self) -> bool:
        return self.data is not None

    def to_dict(self) -> dict[str, object] | None:
        return self.data


class _Batch:
    def __init__(self) -> None:
        self.writes: list[tuple[object, object, bool]] = []
        self.committed = False

    def set(self, reference: object, data: object, merge: bool) -> None:
        self.writes.append((reference, data, merge))

    def commit(self) -> None:
        self.committed = True


class _Database:
    def __init__(
        self,
        existing_documents: dict[str, dict[str, object]] | None = None,
    ) -> None:
        self.batches: list[_Batch] = []
        self.existing_documents = existing_documents or {}

    def batch(self) -> _Batch:
        batch = _Batch()
        self.batches.append(batch)
        return batch

    def collection(self, name: str) -> SimpleNamespace:
        return SimpleNamespace(
            document=lambda document_id: f"{name}/{document_id}"
        )

    def get_all(self, references: list[str]) -> list[_Snapshot]:
        return [
            _Snapshot(
                id=reference.rsplit("/", maxsplit=1)[-1],
                data=self.existing_documents.get(
                    reference.rsplit("/", maxsplit=1)[-1]
                ),
            )
            for reference in references
        ]


class FunctionManifestTests(unittest.TestCase):
    def test_callable_names_and_regions_are_preserved(self) -> None:
        expected_regions = ["asia-southeast1"]
        for function, name in (
            (main.deleteUserAuth, "deleteUserAuth"),
            (
                main.backfillEmailsToFirestore,
                "backfillEmailsToFirestore",
            ),
            (main.submitBooking, "submitBooking"),
        ):
            endpoint = function.__firebase_endpoint__
            self.assertEqual(endpoint.entryPoint, name)
            self.assertEqual(endpoint.region, expected_regions)
            self.assertEqual(endpoint.callableTrigger, {})


class BackfillTests(unittest.TestCase):
    def test_backfill_chunks_large_pages_and_stops_on_empty_token(self) -> None:
        users = [
            _User(uid=f"user-{index}", email=f"{index}@example.com")
            for index in range(1_000)
        ]
        pages = [
            SimpleNamespace(users=users, next_page_token="next"),
            SimpleNamespace(
                users=[_User(uid="without-email", email=None)],
                next_page_token="",
            ),
        ]
        database = _Database()
        handler = inspect.unwrap(main.backfillEmailsToFirestore)

        with (
            patch.object(main.auth, "list_users", side_effect=pages) as list_users,
            patch.object(main.firestore, "client", return_value=database),
        ):
            response = handler(SimpleNamespace())

        self.assertEqual(list_users.call_count, 2)
        self.assertEqual(len(database.batches), 2)
        self.assertEqual(
            [len(batch.writes) for batch in database.batches],
            [500, 500],
        )
        self.assertTrue(all(batch.committed for batch in database.batches))
        self.assertEqual(
            response,
            {
                "success": True,
                "message": "Successfully synced 1000 users to Firestore.",
            },
        )

    def test_backfill_creates_the_complete_user_schema(self) -> None:
        created_at_millis = 1_735_689_600_000
        pages = [
            SimpleNamespace(
                users=[
                    _User(
                        uid="new-user",
                        email="new@example.com",
                        display_name="New User",
                        creation_timestamp=created_at_millis,
                    )
                ],
                next_page_token="",
            )
        ]
        database = _Database()
        handler = inspect.unwrap(main.backfillEmailsToFirestore)

        with (
            patch.object(main.auth, "list_users", side_effect=pages),
            patch.object(main.firestore, "client", return_value=database),
        ):
            handler(SimpleNamespace())

        _, data, merge = database.batches[0].writes[0]
        self.assertTrue(merge)
        self.assertEqual(data["name"], "New User")
        self.assertEqual(data["uid"], "new-user")
        self.assertEqual(data["email"], "new@example.com")
        self.assertEqual(data["roles"], {})
        self.assertFalse(data["isPublic"])
        self.assertEqual(
            data["createdAt"],
            datetime.fromtimestamp(
                created_at_millis / 1000,
                tz=timezone.utc,
            ),
        )
        self.assertTrue(
            all(field_name in data for field_name in main._OPTIONAL_USER_FIELDS)
        )
        self.assertNotIn("displayName", data)

    def test_backfill_repairs_missing_fields_without_overwriting_profile(self) -> None:
        existing_created_at = datetime(2025, 9, 2, tzinfo=timezone.utc)
        database = _Database(
            existing_documents={
                "existing-user": {
                    "displayName": "Legacy Name",
                    "email": "old@example.com",
                    "isPublic": True,
                    "createdAt": existing_created_at,
                    "roles": {"elShaddai": "intercessor"},
                    "church": "Existing Church",
                }
            }
        )
        pages = [
            SimpleNamespace(
                users=[
                    _User(
                        uid="existing-user",
                        email="current@example.com",
                        display_name="Authentication Name",
                    )
                ],
                next_page_token="",
            )
        ]
        handler = inspect.unwrap(main.backfillEmailsToFirestore)

        with (
            patch.object(main.auth, "list_users", side_effect=pages),
            patch.object(main.firestore, "client", return_value=database),
        ):
            handler(SimpleNamespace())

        _, data, merge = database.batches[0].writes[0]
        self.assertTrue(merge)
        self.assertEqual(data["name"], "Legacy Name")
        self.assertEqual(data["email"], "current@example.com")
        self.assertNotIn("roles", data)
        self.assertNotIn("isPublic", data)
        self.assertNotIn("createdAt", data)
        self.assertNotIn("church", data)
        self.assertIsNone(data["address"])


if __name__ == "__main__":
    unittest.main()
