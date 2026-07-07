# PLAN-booking-reminder-push-notifications

**Leverage rank: 2 of 5.** The explicitly requested flagship feature: a Firebase server pushes "your prayer watch starts soon" notifications to user devices ~30 minutes before a booking begins.
Prerequisite: none strictly, but do **PLAN-secure-backend-functions-and-rules** first (it creates `firestore.indexes.json` and the deploy wiring this plan appends to).

> Read `apps/AIDOC.md` first and follow its conventions. Do not refactor anything not listed here.

---

## Goal

A scheduled Cloud Function runs every 5 minutes, finds bookings starting within the next 30 minutes across **all organizations**, and sends one FCM push to the **host and every joined participant** who has a device token and hasn't opted out. The mobile app displays these pushes in foreground, background, and terminated states. Users can opt out via the existing (currently commented-out) Settings toggle.

## Context you need (verified facts — do not re-derive)

- **Backend**: `functions/src/index.ts` (TypeScript, `firebase-functions` v6 → v2 API, `firebase-admin` v12, Node 22). Two `onCall` functions exist; there are no scheduled functions yet.
- **Booking docs** live at `churches/{orgId}/bookings/{bookingId}`. Field `timeRange` is a map `{start, end}` whose values are **native Firestore Timestamps** (the Dart `CustomDateTimeRangeConverter` in `packages/util/lib/src/customs/custom_date_time_range.dart` writes raw `DateTime`s, which the Firestore SDK stores as Timestamps). **However**, its `fromJson` has a legacy branch — some old documents may hold ISO **strings** instead of Timestamps. Timestamp range queries silently skip those docs.
- Booking fields you will use: `title` (string), `userId` (host uid), `id` (string, == doc id), `timeRange.start`. Recurring series are **materialized as individual docs** (one doc per occurrence, sharing `groupId`), so no recurrence expansion is needed server-side.
- **Participants** live in the **top-level collection named `participant` (singular!)** — `FirebaseConstants.participantsCollection = 'participant'` in `packages/constants/lib/src/firebase_constants.dart`. Doc id = bookingId. Shape: `{ participantsId: [ { userId: "<uid>", timestamp: "<iso string>" }, ... ] }`. The doc may not exist (nobody joined).
- **User docs** `users/{uid}`: mobile already syncs the FCM device token to field `fcmToken` (see `_initAndUpdateFCMToken` in `apps/mobile/lib/features/auth/controller/auth_controller.dart`). One token per user — last logged-in device wins. **Web users have no `fcmToken`** (web never sets it); they simply won't receive pushes.
- **Mobile client**: `firebase_messaging`, `flutter_local_notifications`, `permission_handler`, `timezone` are already in `apps/mobile/pubspec.yaml` — **no pubspec changes needed**. `main.dart` already registers `_firebaseMessagingBackgroundHandler` and an `onMessage` listener that only `debugPrint`s. `NotificationsController` (`apps/mobile/lib/features/notifications/controller/notifications_controller.dart`) is a plain singleton whose `initialize()` is **never called anywhere**, and it ends with an unimplemented comment "Schedule a notification 30 minutes before booking".
- **Settings**: `SettingsState` (`apps/mobile/lib/features/settings/state/settings_state.dart`) is a SharedPreferences singleton — **local-only**, the server can't see it. The Settings screen (`apps/mobile/lib/features/settings/presentations/settings_screen.dart`) has the "Push Notifications" `GlassListTile` **commented out** at lines ~85–106.
- `ProfileController.updateUserField(String fieldName, dynamic newValue)` (`apps/mobile/lib/features/profile/controller/profile_controller.dart`) writes arbitrary fields to the current user's doc with `SetOptions(merge: true)` — reuse it to sync the opt-out flag. The provider is a family: `profileControllerProvider(null)` targets the current user.
- **AndroidManifest** (`apps/mobile/android/app/src/main/AndroidManifest.xml`) declares only `INTERNET`. It is **missing `POST_NOTIFICATIONS`**, so on Android 13+ no permission dialog can ever appear and no notification can ever show. There is also a stray `!` character after `</activity>` (line ~30).

## Design decisions (already made — implement exactly this)

- **Cadence/window**: cron every 5 minutes; select bookings with `timeRange.start` in `(now, now + 30min]`. With the dedupe flag this sends exactly once, ~25–30 min before start. This matches the intended "30 minutes before booking".
- **Dedupe**: after sending, write `reminderSent: true` onto the booking doc (merge). Filter `reminderSent == true` **in code, not in the query** (Firestore `==`/`!=` filters don't match docs where the field is missing, and every existing doc is missing it).
- **Recipients**: host (`booking.userId`) ∪ participants' userIds. De-duplicate uids.
- **Opt-out**: new optional boolean `notificationsEnabled` on `users/{uid}`. **Missing ⇒ send** (opt-out model — hosts/participants explicitly involved themselves with the booking). The Settings toggle writes this field.
- **Message body**: timezone-free, e.g. `"Morning Watch" starts in 25 minutes` (compute minutes server-side). Never format wall-clock times on the server — users span timezones and the server runs in UTC.
- **Notification type**: send a `notification` payload (system-rendered when app is backgrounded/terminated) plus `data: {bookingId, orgId}`. Foreground display is done client-side via `flutter_local_notifications`.

## Files to touch

| Action | File |
|---|---|
| Edit | `functions/src/index.ts` (add scheduled function + helper) |
| Edit | `firestore.indexes.json` (repo root — add collection-group field override) |
| Edit | `apps/mobile/android/app/src/main/AndroidManifest.xml` |
| Edit | `apps/mobile/lib/features/notifications/controller/notifications_controller.dart` |
| Edit | `apps/mobile/lib/main.dart` |
| Edit | `apps/mobile/lib/features/settings/presentations/settings_screen.dart` |

## Step-by-step implementation

### Step 1 — Firestore index for the collection-group range query

`collectionGroup("bookings").where("timeRange.start", ...)` requires the field to be indexed at **collection-group scope** (default single-field indexes are collection-scope only; without this the function throws `FAILED_PRECONDITION`). In `firestore.indexes.json` (created by the security plan; if it doesn't exist, create it with this full content), set:

```json
{
  "indexes": [],
  "fieldOverrides": [
    {
      "collectionGroup": "bookings",
      "fieldPath": "timeRange.start",
      "indexes": [
        { "order": "ASCENDING", "queryScope": "COLLECTION" },
        { "order": "DESCENDING", "queryScope": "COLLECTION" },
        { "arrayConfig": "CONTAINS", "queryScope": "COLLECTION" },
        { "order": "ASCENDING", "queryScope": "COLLECTION_GROUP" }
      ]
    }
  ]
}
```

(The first three entries recreate the defaults a field override would otherwise drop; the last is the one we need.)

### Step 2 — The scheduled function

Append to `functions/src/index.ts` (keep existing imports/exports; add the new import at the top with the others):

```ts
import { onSchedule } from "firebase-functions/v2/scheduler";
import { logger } from "firebase-functions";

const REMINDER_WINDOW_MINUTES = 30;

export const sendBookingReminders = onSchedule("every 5 minutes", async () => {
  const now = admin.firestore.Timestamp.now();
  const windowEnd = admin.firestore.Timestamp.fromMillis(
    now.toMillis() + REMINDER_WINDOW_MINUTES * 60 * 1000
  );

  // NOTE: matches only docs where timeRange.start is a native Timestamp.
  // Legacy docs storing ISO strings are silently excluded by Firestore's
  // type ordering — see the backfill note in the plan.
  const snapshot = await db
    .collectionGroup("bookings")
    .where("timeRange.start", ">", now)
    .where("timeRange.start", "<=", windowEnd)
    .get();

  for (const doc of snapshot.docs) {
    const booking = doc.data();
    if (booking.reminderSent === true) continue;

    const bookingId = doc.id;
    // Path: churches/{orgId}/bookings/{bookingId}
    const orgId = doc.ref.parent.parent?.id ?? "unknown";

    // ---- Collect recipient uids: host + joined participants ----
    const uids = new Set<string>();
    if (typeof booking.userId === "string" && booking.userId.length > 0) {
      uids.add(booking.userId);
    }
    // Top-level collection is named 'participant' (singular).
    const participantSnap = await db
      .collection("participant")
      .doc(bookingId)
      .get();
    if (participantSnap.exists) {
      const entries = (participantSnap.data()?.participantsId ?? []) as Array<{
        userId?: string;
      }>;
      for (const entry of entries) {
        if (typeof entry?.userId === "string" && entry.userId.length > 0) {
          uids.add(entry.userId);
        }
      }
    }
    // Defensive: a historical client bug wrote the literal placeholder
    // 'default_user_id' into participant arrays. Never notify it.
    uids.delete("default_user_id");

    if (uids.size === 0) {
      await doc.ref.set({ reminderSent: true }, { merge: true });
      continue;
    }

    // ---- Resolve fcm tokens, honoring the notificationsEnabled opt-out ----
    const userRefs = [...uids].map((uid) => db.collection("users").doc(uid));
    const userSnaps = await db.getAll(...userRefs);
    const tokens: string[] = [];
    const tokenOwners = new Map<string, string>(); // token -> uid (for cleanup)
    for (const userSnap of userSnaps) {
      if (!userSnap.exists) continue;
      const data = userSnap.data()!;
      if (data.notificationsEnabled === false) continue; // missing => send
      const token = data.fcmToken;
      if (typeof token === "string" && token.length > 0) {
        tokens.push(token);
        tokenOwners.set(token, userSnap.id);
      }
    }

    if (tokens.length > 0) {
      const startMillis = (booking.timeRange.start as admin.firestore.Timestamp)
        .toMillis();
      const minutesLeft = Math.max(
        1,
        Math.round((startMillis - Date.now()) / 60000)
      );
      const title = "Prayer Watch Reminder";
      const body =
        `"${booking.title ?? "Prayer Watch"}" starts in ${minutesLeft} ` +
        `minute${minutesLeft === 1 ? "" : "s"}.`;

      // sendEachForMulticast accepts max 500 tokens per call.
      for (let i = 0; i < tokens.length; i += 500) {
        const chunk = tokens.slice(i, i + 500);
        const response = await admin.messaging().sendEachForMulticast({
          tokens: chunk,
          notification: { title, body },
          data: { bookingId, orgId },
          android: { priority: "high" },
        });
        // Remove dead tokens so future runs stop retrying them.
        await Promise.all(
          response.responses.map(async (result, index) => {
            const code = result.error?.code;
            if (
              code === "messaging/registration-token-not-registered" ||
              code === "messaging/invalid-registration-token"
            ) {
              const uid = tokenOwners.get(chunk[index]);
              if (uid) {
                await db.collection("users").doc(uid).update({
                  fcmToken: admin.firestore.FieldValue.delete(),
                });
              }
            }
          })
        );
        logger.info(
          `Booking ${bookingId}: sent ${response.successCount}/${chunk.length}`
        );
      }
    }

    // Mark sent even on partial failure — never spam retries.
    await doc.ref.set({ reminderSent: true }, { merge: true });
  }
});
```

### Step 3 — AndroidManifest

In `apps/mobile/android/app/src/main/AndroidManifest.xml`:
1. Add below the INTERNET permission:
   ```xml
   <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
   ```
2. Delete the stray `!` character that sits immediately after `</activity>` (around line 30).

### Step 4 — `NotificationsController`: channel + foreground display

In `apps/mobile/lib/features/notifications/controller/notifications_controller.dart` (keep the singleton pattern and existing methods):

1. Add channel constants inside the class:
   ```dart
   static const String _channelId = 'booking_reminders';
   static const String _channelName = 'Booking Reminders';
   static const String _channelDescription =
       'Reminders before a prayer watch starts';
   ```
2. At the end of `initialize()` (before `_initialized = true;`), create the Android channel:
   ```dart
   await _flutterLocalNotificationsPlugin
       .resolvePlatformSpecificImplementation<
         AndroidFlutterLocalNotificationsPlugin>()
       ?.createNotificationChannel(
         const AndroidNotificationChannel(
           _channelId,
           _channelName,
           description: _channelDescription,
           importance: Importance.high,
         ),
       );
   ```
3. Replace the dangling comment `/// Schedule a notification 30 minutes before booking` with a display method used for foreground FCM messages:
   ```dart
   /// Shows a notification immediately (used for foreground FCM messages).
   Future<void> showNotification({
     required String title,
     required String body,
   }) async {
     if (!_initialized) await initialize();
     await _flutterLocalNotificationsPlugin.show(
       DateTime.now().millisecondsSinceEpoch ~/ 1000, // unique-enough id
       title,
       body,
       const NotificationDetails(
         android: AndroidNotificationDetails(
           _channelId,
           _channelName,
           channelDescription: _channelDescription,
           importance: Importance.high,
           priority: Priority.high,
         ),
         iOS: DarwinNotificationDetails(),
       ),
     );
   }
   ```

### Step 5 — `main.dart` wiring

In `apps/mobile/lib/main.dart`:
1. In `main()`, after `Firebase.initializeApp(...)` add:
   ```dart
   await NotificationsController.instance.initialize();
   await FirebaseMessaging.instance.requestPermission();
   ```
   (`requestPermission()` shows the iOS APNs dialog and, with the manifest entry from Step 3, the Android 13+ system dialog. On declined permission it resolves without throwing — do not wrap in UI error handling.)
   Add the import: `package:mobile/features/notifications/controller/notifications_controller.dart`.
2. In `_MyAppState.initState`, replace the body of the existing `FirebaseMessaging.onMessage.listen` callback (currently only `debugPrint`s) with:
   ```dart
   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
     final notification = message.notification;
     if (notification != null) {
       NotificationsController.instance.showNotification(
         title: notification.title ?? 'El Shaddai',
         body: notification.body ?? '',
       );
     }
   });
   ```
3. Leave `_firebaseMessagingBackgroundHandler` as is (background/terminated pushes are rendered by the OS because we send a `notification` payload).

### Step 6 — Settings toggle (opt-out sync)

In `apps/mobile/lib/features/settings/presentations/settings_screen.dart`:
1. Un-comment the "Push Notifications" `GlassListTile` block (lines ~85–106) as the **first child** of the settings `Column`.
2. In `initState` (add one if missing), call `_loadSettings();` so the toggle reflects the stored value.
3. Change the toggle's `onToggleChanged` so that in **both** branches, after updating `SettingsState`, it also syncs the server flag:
   ```dart
   ref
       .read(profileControllerProvider(null).notifier)
       .updateUserField('notificationsEnabled', granted); // or false branch: false
   ```
   Add the import `package:mobile/features/profile/controller/profile_controller.dart`.
   Concretely: on-toggle-on use the `granted` boolean returned by `NotificationsController.instance.requestPermission()`; on-toggle-off write `false`.

### Step 7 — Build, deploy, regenerate nothing

No Dart codegen is touched (no new `@riverpod`/`@freezed` declarations), so **build_runner is not needed**.

```bash
npm --prefix functions run build
firebase deploy --only functions,firestore:indexes
cd apps/mobile && flutter analyze
```

## Edge cases a weaker model would miss

1. **The participants collection is named `participant` (singular).** Using `participants` silently notifies only hosts.
2. **`reminderSent` must be filtered in code**, not with `.where('reminderSent','==',false)` — existing docs don't have the field and Firestore equality filters never match missing fields; you would notify nothing.
3. **Collection-group index** (Step 1) is mandatory; without it the function fails with `FAILED_PRECONDITION` and, because it's scheduled, fails invisibly unless you read the logs (`firebase functions:log`).
4. **Legacy string dates**: old bookings whose `timeRange.start` is an ISO string are invisible to the Timestamp range query — they just never get reminders. Acceptable; every booking written by the current app stores Timestamps. Do not crash on them; the query already excludes them.
5. **`'default_user_id'` ghost participant**: a client bug (fixed separately in PLAN-correctness-bug-sweep) could write this placeholder uid into participant arrays. The function must skip it (`uids.delete("default_user_id")`).
6. **One token per user, last device wins** — `fcmToken` is a single string. A user logged in on two phones gets the push only on the most recent one. Known limitation; do not redesign.
7. **Web users have no token** — `users/{uid}` docs created purely via web have no `fcmToken`; the loop must tolerate missing fields (it does).
8. **Opt-out default is "send"**: `notificationsEnabled == false` is the only skip condition. `null`/missing means send. Do not invert this.
9. **Never spam on partial failure**: `reminderSent: true` is written even if some sends fail — a retry storm every 5 minutes is worse than one missed reminder.
10. **Timezone trap**: the server runs in UTC; never render wall-clock times ("starts at 9:00") server-side. The "starts in N minutes" phrasing is timezone-free by construction.
11. **Android 13+ shows nothing without BOTH** the manifest `POST_NOTIFICATIONS` entry **and** a runtime grant. Older Android (< 13) needs neither. If a test device shows no notification, check `Settings → Apps → El Shaddai → Notifications` first.
12. **Foreground pushes on Android never display by default** — that's why Step 5.2 routes them through `flutter_local_notifications`. Don't "fix" this by sending data-only messages; background delivery of data-only messages is throttled/unreliable on iOS.
13. **iOS delivery requires an APNs key** uploaded in Firebase console → Project settings → Cloud Messaging, plus the Push Notifications capability in Xcode. These are MANUAL owner steps; Android acceptance below does not depend on them.
14. **`getAll(...refs)` requires at least one ref** — the `uids.size === 0` early-continue guards that.

## Acceptance criteria

Test on a **physical Android device** (emulators without Google Play services don't receive FCM).

1. `npm --prefix functions run build` exits 0; `firebase deploy --only functions,firestore:indexes` succeeds; `sendBookingReminders` appears in Firebase console → Functions with a 5-minute schedule.
2. Fresh install of the mobile app on Android 13+: the system notification-permission dialog appears once after login flow reaches the home screen.
3. Create a booking starting **20 minutes from now**; join it with a second account on the test device (or be the host). Within ≤5 minutes a push arrives: title "Prayer Watch Reminder", body `"<title>" starts in N minutes.` Verify it arrives in all three app states: foreground (heads-up via local notification), background, and terminated.
4. The booking doc in Firestore now has `reminderSent: true`, and no second push arrives on subsequent 5-minute runs.
5. Toggle Settings → Push Notifications **off**: `users/{uid}.notificationsEnabled == false` appears in Firestore; create another booking 20 min out with that user joined → no push for them (check `firebase functions:log`: token skipped or 0 recipients).
6. A booking with no participants and a host whose doc has no `fcmToken` logs no errors and still gets `reminderSent: true`.
7. `flutter analyze` in `apps/mobile` reports no new issues; the app builds and runs.
8. `firebase functions:log --only sendBookingReminders` shows `sent X/Y` lines and no unhandled exceptions across at least 3 consecutive runs.
