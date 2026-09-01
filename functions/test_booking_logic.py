"""Behavioral regression tests for booking validation and scheduling."""

from datetime import datetime, timezone
import unittest

from src.booking_logic import (
    BookingValidationError,
    ExistingBookingRange,
    TimeRange,
    build_candidate_ranges,
    find_conflicting_dates,
    format_conflicting_dates,
    parse_request,
    validate_booking_operation,
)


def _millis(value: str) -> int:
    return int(
        datetime.fromisoformat(value.replace("Z", "+00:00")).timestamp()
        * 1000
    )


def _valid_request(**overrides: object) -> dict[str, object]:
    request: dict[str, object] = {
        "requestId": "request-1",
        "organizationId": "church-1",
        "bookingId": None,
        "timezoneOffsetMinutes": 480,
        "isUpdating": False,
        "title": "Sunday service",
        "recurrenceState": "none",
        "host": "Host",
        "timeRange": {
            "start": _millis("2026-08-02T02:00:00Z"),
            "end": _millis("2026-08-02T03:00:00Z"),
        },
        "location": {
            "address": "Main hall",
            "web": None,
            "chords": {"latitude": 3.139, "longitude": 101.687},
        },
        "description": "Weekly gathering",
        "password": None,
        "recurrence": None,
        "zoomOccurrences": [],
    }
    request.update(overrides)
    return request


class ConflictTests(unittest.TestCase):
    def test_touching_ranges_do_not_clash(self) -> None:
        conflicts = find_conflicting_dates(
            [TimeRange(start_millis=1_000, end_millis=2_000)],
            [
                ExistingBookingRange(
                    id="existing",
                    start_millis=2_000,
                    end_millis=3_000,
                )
            ],
            0,
        )
        self.assertEqual(conflicts, [])

    def test_conflict_dates_use_submitting_device_timezone(self) -> None:
        start = _millis("2026-07-02T18:30:00Z")
        end = _millis("2026-07-02T19:30:00Z")
        conflicts = find_conflicting_dates(
            [TimeRange(start_millis=start, end_millis=end)],
            [
                ExistingBookingRange(
                    id="existing",
                    start_millis=start,
                    end_millis=end,
                )
            ],
            8 * 60,
        )
        self.assertEqual(conflicts, ["2026-7-3"])

    def test_conflict_spanning_midnight_reports_both_days(self) -> None:
        start = _millis("2026-07-02T15:30:00Z")
        end = _millis("2026-07-02T17:30:00Z")
        conflicts = find_conflicting_dates(
            [TimeRange(start_millis=start, end_millis=end)],
            [
                ExistingBookingRange(
                    id="existing",
                    start_millis=start,
                    end_millis=end,
                )
            ],
            8 * 60,
        )
        self.assertEqual(conflicts, ["2026-7-2", "2026-7-3"])

    def test_only_three_conflict_dates_are_displayed(self) -> None:
        result = format_conflicting_dates(
            ["2026-7-3", "2026-7-4", "2026-7-5", "2026-7-6"]
        )
        self.assertEqual(
            result,
            "[3/7/26], [4/7/26], [5/7/26] and more",
        )


class ValidationTests(unittest.TestCase):
    def test_update_without_booking_id_fails_clearly(self) -> None:
        with self.assertRaisesRegex(
            BookingValidationError,
            "Booking update failed because the booking ID is missing",
        ):
            validate_booking_operation(True)

    def test_valid_request_preserves_firestore_shape(self) -> None:
        parsed = parse_request(
            _valid_request(),
            now_millis=_millis("2026-08-01T00:00:00Z"),
        )
        self.assertEqual(parsed.organization_id, "church-1")
        self.assertEqual(
            parsed.booking.location["chords"],
            {"latitude": 3.139, "longitude": 101.687},
        )
        self.assertIsNone(parsed.recurrence)

    def test_nested_booking_payload_is_rejected(self) -> None:
        request = _valid_request()
        booking_fields = {
            key: request.pop(key)
            for key in (
                "title",
                "recurrenceState",
                "host",
                "timeRange",
                "location",
                "description",
                "password",
            )
        }
        request["booking"] = booking_fields

        with self.assertRaisesRegex(
            BookingValidationError,
            "booking must not be nested",
        ):
            parse_request(
                request,
                now_millis=_millis("2026-08-01T00:00:00Z"),
            )

    def test_boolean_is_not_accepted_as_integer(self) -> None:
        request = _valid_request(timezoneOffsetMinutes=True)
        with self.assertRaisesRegex(
            BookingValidationError,
            "timezoneOffsetMinutes must be an integer",
        ):
            parse_request(
                request,
                now_millis=_millis("2026-08-01T00:00:00Z"),
            )

    def test_integer_valued_float_matches_javascript_validation(self) -> None:
        request = _valid_request(timezoneOffsetMinutes=480.0)
        parsed = parse_request(
            request,
            now_millis=_millis("2026-08-01T00:00:00Z"),
        )
        self.assertEqual(parsed.timezone_offset_minutes, 480)

    def test_callable_int64_wrappers_are_decoded(self) -> None:
        start = _millis("2026-08-02T02:00:00Z")
        end = _millis("2026-08-02T03:00:00Z")
        request = _valid_request(
            timeRange={
                "start": {
                    "@type": "type.googleapis.com/google.protobuf.Int64Value",
                    "value": str(start),
                },
                "end": {
                    "@type": "type.googleapis.com/google.protobuf.Int64Value",
                    "value": str(end),
                },
            }
        )

        parsed = parse_request(
            request,
            now_millis=_millis("2026-08-01T00:00:00Z"),
        )

        self.assertEqual(parsed.booking.start_millis, start)
        self.assertEqual(parsed.booking.end_millis, end)

    def test_daily_recurrence_builds_requested_occurrences(self) -> None:
        request = _valid_request(
            recurrence={
                "end_times": 3,
                "weekly_days": None,
                "type": 1,
                "repeat_interval": 1,
            }
        )
        request["recurrenceState"] = "daily"
        parsed = parse_request(
            request,
            now_millis=_millis("2026-08-01T00:00:00Z"),
        )
        candidates = build_candidate_ranges(parsed)
        self.assertEqual(len(candidates), 3)
        self.assertEqual(
            candidates[1].start_millis - candidates[0].start_millis,
            24 * 60 * 60 * 1000,
        )

    def test_past_booking_is_rejected(self) -> None:
        with self.assertRaisesRegex(
            BookingValidationError,
            "booking start time cannot be in the past",
        ):
            parse_request(
                _valid_request(),
                now_millis=_millis("2026-08-03T00:00:00Z"),
            )


if __name__ == "__main__":
    unittest.main()
