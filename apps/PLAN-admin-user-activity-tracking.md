# PLAN-admin-user-activity-tracking

**Leverage rank: 3 of 5.** The second explicitly requested feature: admins can inspect a user's activity — which bookings they joined/left, which booking details they viewed, and when they clicked into a Zoom meeting.
Prerequisites: **PLAN-secure-backend-functions-and-rules** (activity rules + indexes file already included there). Strongly recommended first: the participant fix in **PLAN-correctness-bug-sweep** (stops `'default_user_id'` garbage entering the very data this feature displays).

> Read `apps/AIDOC.md` first and follow its conventions (freezed sealed models, `FutureEither` only where UI needs errors, `@riverpod` codegen, barrel exports, feature-first folders). Do not refactor anything not listed here.

---

## Goal

1. An append-only `activity` collection records events: `bookingJoined`, `bookingLeft`, `bookingViewed`, `zoomJoinClicked` — each with uid, orgId, bookingId, booking title, and timestamp.
2. Both apps write these events at the existing interaction points, fire-and-forget (never blocking or breaking UI).
3. Mobile admin UI: from User Management, an admin opens a per-user activity timeline.

Why not just read the existing `participant` collection: `removeParticipant` **deletes the whole doc when the last person leaves** (`packages/repositories/lib/src/participant/participant_repository.dart`), so join history evaporates; and nothing anywhere records views. An append-only log is required.

## Context you need (verified facts)

- Collection name constants: `packages/constants/lib/src/firebase_constants.dart` (class `FirebaseConstants`).
- Model conventions: see `packages/models/lib/src/models/booking_model/booking_model.dart` — freezed `sealed`, `fromJson`, `@TimestampConverter()` for DateTimes (converter in `packages/util/lib/src/json_converters.dart`), folder-per-model, exported from `packages/models/lib/models.dart`.
- Repository conventions: see `packages/repositories/lib/src/participant/participant_repository.dart` — plain class + `Provider`, constructor-injected `firestore: ref.watch(firestoreProvider)`, exported from `packages/repositories/lib/repositories.dart`.
- Current user: `ref.read(userProvider).value` (`AsyncValue<UserModel?>` — may be loading/null!). Mobile: `apps/mobile/lib/features/auth/controller/auth_controller.dart`; web: `apps/web/lib/features/auth/controller/auth_controller.dart`.
- Current org: `ref.read(organizationControllerProvider)` → `AsyncValue<OrganizationsID>`; org id string is `.name` (e.g. `elShaddai`).
- Doc-id generation idiom used in this codebase: `FirebaseFirestore.instance.collection(...).doc().id`.
- **Join/leave call sites**:
  - Mobile: `joinButton(...)` in `apps/mobile/lib/features/booking/presentations/booking_details_dialog.dart` (~line 549) — calls `participationFunction.addParticipant()` / `.removeParticipant()`; the `booking` model is in scope in `_participantComponent`, which builds the button.
  - Web: join/leave button in `apps/web/lib/features/booking/widget/booking_details_widget.dart` (~line 728 onward, same add/remove pattern).
- **View call sites**: mobile `BookingDetailsDialog` is a `ConsumerStatefulWidget` (has `widget.bookingModel`); web's booking details widget in `booking_details_widget.dart` is also stateful (it references `widget.booking`).
- **Zoom click call sites**: mobile `_ZoomComponent.joinMeeting()` in the same dialog file (it holds a `ref` field of type `WidgetRef`); web `apps/web/lib/features/booking/widget/zoom_display_component.dart` (locate the tap handler that launches the meeting URL).
- **Admin UI host**: `apps/mobile/lib/features/user_management/presentations/user_management_screen.dart` — `_PopMenuButton` already shows "Role" and "Delete" `PopupMenuItem`s per user; User Management is reachable only for admins (gated in `general_drawer.dart`).
- Mobile routes are **typed** (`@TypedGoRoute` + mixin + `part 'router.g.dart'`) in `apps/mobile/lib/core/router/router.dart`; `ProfileRoute` shows how to pass a `UserModel` via `$extra`.
- Snackbars/loaders: `showFailureSnackBar` (package:util), `Loader` (`apps/mobile/lib/core/widgets/loader.dart`).

## Files to touch

| Action | File |
|---|---|
| Edit | `packages/constants/lib/src/firebase_constants.dart` (add `activityCollection`) |
| Create | `packages/models/lib/src/models/activity_model/activity_model.dart` |
| Edit | `packages/models/lib/models.dart` (export) |
| Create | `packages/repositories/lib/src/activity/activity_repository.dart` |
| Edit | `packages/repositories/lib/repositories.dart` (export) |
| Create | `apps/mobile/lib/core/utility/activity_logger.dart` |
| Create | `apps/web/lib/core/utility/activity_logger.dart` (duplicate per AIDOC §1 — do NOT share) |
| Edit | `apps/mobile/lib/features/booking/presentations/booking_details_dialog.dart` (view + join/leave + zoom hooks) |
| Edit | `apps/web/lib/features/booking/widget/booking_details_widget.dart` (view + join/leave hooks) |
| Edit | `apps/web/lib/features/booking/widget/zoom_display_component.dart` (zoom hook) |
| Create | `apps/mobile/lib/features/user_management/presentations/user_activity_screen.dart` |
| Edit | `apps/mobile/lib/features/user_management/presentations/user_management_screen.dart` (menu item) |
| Edit | `apps/mobile/lib/core/router/router.dart` (typed route) |
| Edit | `firestore.indexes.json` (composite index) |
| Edit | `firestore.rules` (only if the security plan hasn't added the `activity` block yet — it should have) |

## Step-by-step implementation

### Step 1 — Constant

In `FirebaseConstants` add:
```dart
  static const activityCollection = 'activity';
```

### Step 2 — Model (`packages/models`)

`packages/models/lib/src/models/activity_model/activity_model.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:util/util.dart';

part 'activity_model.freezed.dart';
part 'activity_model.g.dart';

enum ActivityType {
  bookingJoined(displayName: 'Joined Booking'),
  bookingLeft(displayName: 'Left Booking'),
  bookingViewed(displayName: 'Viewed Booking'),
  zoomJoinClicked(displayName: 'Joined Zoom Meeting');

  const ActivityType({required this.displayName});
  final String displayName;
}

@freezed
sealed class ActivityModel with _$ActivityModel {
  const factory ActivityModel({
    required String id,
    required String uid,
    required ActivityType type,
    @TimestampConverter() required DateTime timestamp,
    String? orgId,
    String? bookingId,
    String? bookingTitle,
  }) = _ActivityModel;

  factory ActivityModel.fromJson(Map<String, dynamic> json) =>
      _$ActivityModelFromJson(json);
}
```

Add `export 'src/models/activity_model/activity_model.dart';` to `packages/models/lib/models.dart`.

### Step 3 — Repository (`packages/repositories`)

`packages/repositories/lib/src/activity/activity_repository.dart`:

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:constants/constants.dart';
import 'package:firebase/firebase.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:models/models.dart';

final activityRepositoryProvider = Provider((ref) {
  return ActivityRepository(firestore: ref.watch(firestoreProvider));
});

class ActivityRepository {
  final FirebaseFirestore _firestore;

  ActivityRepository({required FirebaseFirestore firestore})
    : _firestore = firestore;

  CollectionReference get _activity =>
      _firestore.collection(FirebaseConstants.activityCollection);

  /// Fire-and-forget append. Never throws to the caller — activity logging
  /// must never break a user-facing flow.
  Future<void> logActivity(ActivityModel activity) async {
    try {
      await _activity.doc(activity.id).set(activity.toJson());
    } catch (e) {
      if (kDebugMode) {
        print('Failed to log activity: $e');
      }
    }
  }

  /// Newest-first activity for one user. Requires the composite index
  /// (uid ASC, timestamp DESC) — see firestore.indexes.json.
  Stream<List<ActivityModel>> getUserActivityStream(
    String uid, {
    int limit = 100,
  }) {
    return _activity
        .where('uid', isEqualTo: uid)
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => ActivityModel.fromJson({
                  ...doc.data() as Map<String, dynamic>,
                  'id': doc.id,
                }),
              )
              .toList(),
        );
  }
}
```

Add `export 'src/activity/activity_repository.dart';` to `packages/repositories/lib/repositories.dart`.

### Step 4 — Codegen

From the repo root: `melos run build_runner` (or run `dart run build_runner build --delete-conflicting-outputs` inside `packages/models` — repositories has no new annotations, models does). Commit the generated `activity_model.freezed.dart` / `activity_model.g.dart`.

### Step 5 — Logger helper (one per app, duplicated intentionally)

`apps/mobile/lib/core/utility/activity_logger.dart` (web copy identical except the import style if any app-local import is needed — there isn't; copy the file verbatim):

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:constants/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';

/// Session-scoped dedupe so reopening the same booking dialog repeatedly
/// doesn't spam 'bookingViewed' rows. Cleared on app restart by design.
final Set<String> _sessionLoggedKeys = <String>{};

/// Fire-and-forget activity logging. Safe to call from initState/onTap.
/// Silently does nothing when the user is not loaded yet — NEVER writes a
/// placeholder uid.
void logUserActivity(
  WidgetRef ref,
  ActivityType type, {
  BookingModel? booking,
}) {
  final user = ref.read(userProvider).value;
  if (user == null) return;

  if (type == ActivityType.bookingViewed && booking != null) {
    final key = '${type.name}:${booking.id}';
    if (_sessionLoggedKeys.contains(key)) return;
    _sessionLoggedKeys.add(key);
  }

  final orgId = ref.read(organizationControllerProvider).value?.name;

  final activity = ActivityModel(
    id: FirebaseFirestore.instance
        .collection(FirebaseConstants.activityCollection)
        .doc()
        .id,
    uid: user.uid,
    type: type,
    timestamp: DateTime.now(),
    orgId: orgId,
    bookingId: booking?.id,
    bookingTitle: booking?.title,
  );

  // Intentionally not awaited.
  ref.read(activityRepositoryProvider).logActivity(activity);
}
```

**Import note for each app:** `userProvider` comes from that app's own `features/auth/controller/auth_controller.dart` — add that import in each copy (mobile: `package:mobile/...`, web: `package:website/...`).

### Step 6 — Hooks

Mobile — `apps/mobile/lib/features/booking/presentations/booking_details_dialog.dart`:
1. `initState` of `_BookingDetailsDialogState` (add the override; class currently has none):
   ```dart
   @override
   void initState() {
     super.initState();
     WidgetsBinding.instance.addPostFrameCallback((_) {
       logUserActivity(ref, ActivityType.bookingViewed,
           booking: widget.bookingModel);
     });
   }
   ```
   (post-frame: `ref.read` of providers is safe in initState, but the org controller may not be warm on first frame; post-frame costs nothing and avoids ordering surprises.)
2. In `joinButton(...)` after `await participationFunction.addParticipant();` add `logUserActivity(ref, ActivityType.bookingJoined, booking: booking);` — the button is built from `_participantComponent`, which has `booking` in scope; pass `booking` into `joinButton` as an extra parameter (it currently receives `user, isJoined, participationFunction, context`). Mirror for `removeParticipant()` → `ActivityType.bookingLeft`.
3. In `_ZoomComponent.joinMeeting()` (the class already holds `ref` and `booking` as fields) add, before `launchURL(...)`:
   `logUserActivity(ref, ActivityType.zoomJoinClicked, booking: booking);`

Web — `apps/web/lib/features/booking/widget/booking_details_widget.dart`:
1. Same three hooks: `initState` of the top-level stateful widget's State (uses `widget.booking`), and the join/leave button handler (~line 728) after each successful `addParticipant()` / `removeParticipant()`.
2. `apps/web/lib/features/booking/widget/zoom_display_component.dart`: find the tap handler that launches the zoom URL (`url_launch.dart` helper) and add the `zoomJoinClicked` log call. If the component doesn't have a `WidgetRef` (plain `StatelessWidget`), convert it to `ConsumerWidget` per AIDOC §10 — do NOT thread a `WidgetRef` through constructor params in new code.

### Step 7 — Admin activity screen (mobile)

Create `apps/mobile/lib/features/user_management/presentations/user_activity_screen.dart`:

```dart
import 'package:constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mobile/core/widgets/glass_container.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';

class UserActivityScreen extends ConsumerWidget {
  const UserActivityScreen({super.key, required this.userModel});

  final UserModel? userModel;

  IconData _iconFor(ActivityType type) {
    switch (type) {
      case ActivityType.bookingJoined:
        return Icons.group_add;
      case ActivityType.bookingLeft:
        return Icons.group_remove;
      case ActivityType.bookingViewed:
        return Icons.visibility;
      case ActivityType.zoomJoinClicked:
        return Icons.videocam;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = userModel;
    if (user == null) {
      return const Scaffold(body: Center(child: Text('No user selected')));
    }

    final activityStream =
        ref.watch(activityRepositoryProvider).getUserActivityStream(user.uid);

    return Scaffold(
      appBar: AppBar(title: Text('${user.lastName ?? user.name} — Activity')),
      body: StreamBuilder<List<ActivityModel>>(
        stream: activityStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final activities = snapshot.data ?? [];
          if (activities.isEmpty) {
            return const Center(child: Text('No activity recorded yet.'));
          }
          return ListView.builder(
            itemCount: activities.length,
            itemBuilder: (context, index) {
              final activity = activities[index];
              return ListTile(
                leading: Icon(
                  _iconFor(activity.type),
                  color: context.colors.primary,
                ),
                title: Text(
                  activity.bookingTitle == null
                      ? activity.type.displayName
                      : '${activity.type.displayName}: ${activity.bookingTitle}',
                ),
                subtitle: Text(
                  DateFormat('d MMM y, h:mm a').format(activity.timestamp),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
```

**Note:** `intl` is not currently a direct dependency of `apps/mobile` — check `apps/mobile/pubspec.yaml`; if absent, add `intl: ^0.20.2` under dependencies (web already has it) and run `flutter pub get`.

### Step 8 — Route + menu entry (mobile)

1. `apps/mobile/lib/core/router/router.dart`:
   - Add `TypedGoRoute<UserActivityRoute>(path: 'user-activity')` to the `routes:` list inside the `@TypedGoRoute<HomeRoute>` annotation.
   - Add the route class (model it exactly on `ProfileRoute`, which also passes a `UserModel?` via `$extra`):
     ```dart
     class UserActivityRoute extends GoRouteData with _$UserActivityRoute {
       const UserActivityRoute(this.$extra);
       final UserModel? $extra;
       @override
       Widget build(BuildContext context, GoRouterState state) =>
           UserActivityScreen(userModel: $extra);
     }
     ```
   - Import the new screen. Run codegen again (Step 4 command) to regenerate `router.g.dart`.
2. `user_management_screen.dart` → `_PopMenuButton.itemBuilder`: add a third `PopupMenuItem` ABOVE "Delete":
   ```dart
   PopupMenuItem(
     child: const Row(
       children: [
         Icon(Icons.history, size: 20),
         Gap(5),
         Text('Activity '),
       ],
     ),
     onTap: () {
       UserActivityRoute(user).push(context);
     },
   ),
   ```

### Step 9 — Composite index + rules

1. `firestore.indexes.json` — add to the `"indexes"` array:
   ```json
   {
     "collectionGroup": "activity",
     "queryScope": "COLLECTION",
     "fields": [
       { "fieldPath": "uid", "order": "ASCENDING" },
       { "fieldPath": "timestamp", "order": "DESCENDING" }
     ]
   }
   ```
2. `firestore.rules` — verify the `activity` block from the security plan exists (create own-uid only, read admin-only, no update/delete). If that plan hasn't run yet, add the block exactly as written there.
3. Deploy: `firebase deploy --only firestore:rules,firestore:indexes`. Index build takes a few minutes; the admin screen errors with `FAILED_PRECONDITION` until it finishes.

## Edge cases a weaker model would miss

1. **Never write a placeholder uid.** `userProvider` is an `AsyncValue` that is `loading` at startup — the logger returns silently when `.value == null`. Do not copy the `'default_user_id'` fallback pattern from `participant_controller.dart` (that's a bug, fixed in PLAN-correctness-bug-sweep).
2. **Logging must be fire-and-forget.** No `await` at call sites, all exceptions swallowed inside the repository. A Firestore outage must not break the Join button.
3. **The composite index is mandatory** — `where(uid ==) + orderBy(timestamp desc)` cannot run on automatic single-field indexes. Without Step 9 the admin screen shows a `FAILED_PRECONDITION` error containing an index-creation URL.
4. **`bookingViewed` dedupe is per-session by design** — a `Set` in the helper file. Don't persist it; don't log on every rebuild (that's why the hook is in `initState`, never in `build`).
5. **The `activity` log's rules make it admin-read-only** — the per-user screen works for admins because the drawer already hides User Management from non-admins, but the rules are the real guard. Non-admins opening the route directly get a Firestore permission error → surfaced by the StreamBuilder error branch (acceptable).
6. **`removeParticipant` deletes the participant doc when empty** — this is exactly why activity is a separate append-only collection. Do not "optimize" by deriving history from `participant`.
7. **Device-clock timestamps**: `DateTime.now()` matches the codebase's existing `createdAt` convention. `FieldValue.serverTimestamp()` would fight the freezed/`TimestampConverter` round-trip (`null` on latency-compensated snapshots). Accept minor clock skew.
8. **Unbounded growth**: optionally set a Firestore TTL policy on `activity.timestamp` (Firebase console → Firestore → TTL) to auto-expire rows after e.g. 180 days. MANUAL console step; note it, don't attempt from code.
9. **Web `zoom_display_component.dart` may be a plain StatelessWidget** — convert to `ConsumerWidget` (change `build(BuildContext context)` to `build(BuildContext context, WidgetRef ref)`); don't add a `ref` constructor field.
10. **Melos codegen ordering**: models must be regenerated before apps compile. If an app's analyzer still shows `ActivityModel` undefined after codegen, run `flutter pub get` in that app (path deps refresh).

## Acceptance criteria

1. `melos run build_runner` completes; `flutter analyze` is clean in `packages/models`, `packages/repositories`, `apps/mobile`, `apps/web`.
2. On mobile, logged in as any non-observer user: open a booking's details → a doc appears in `activity` with `type: 'bookingViewed'`, correct `uid`, `bookingId`, `bookingTitle`, `orgId`, and a Timestamp. Reopening the same booking in the same session does NOT add a second `bookingViewed` row.
3. Tapping Join adds a `bookingJoined` row; Leave adds `bookingLeft`; tapping the Zoom avatar adds `zoomJoinClicked`. Same behaviors on web (view/join/leave/zoom).
4. Logged in as admin on mobile: User Management → ⋮ on any user → "Activity" opens a timeline listing that user's events newest-first with icons, type + booking title, and formatted date (`d MMM y, h:mm a`).
5. A user with no activity shows "No activity recorded yet." — not an error.
6. While logged OUT (or before the profile loads), opening the web booking details page writes **no** activity docs (verify: no rows with missing/placeholder uid appear in the collection).
7. With rules deployed, a non-admin querying `activity` (e.g. temporarily hitting the route) gets permission-denied rather than data.
8. Join/Leave still work when Firestore writes to `activity` are forced to fail (e.g. temporarily deny `activity` create in rules): buttons behave normally, no visible error.
