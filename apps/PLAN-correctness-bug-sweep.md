# PLAN-correctness-bug-sweep

**Leverage rank: 4 of 5.** Seven small, surgical fixes for confirmed bugs found by reading the code — crashes, UI jank, corrupted data, and a wrong auth state. Cheap to do, and fix #4 protects the data quality of PLAN-admin-user-activity-tracking (do at least fix #4 before or together with that plan).

> Read `apps/AIDOC.md` first. Each fix is independent; apply them as one branch/commit series in the order below. Do not fix anything not listed — no drive-by refactors.

---

## Goal

Eliminate the following verified defects without changing any feature behavior beyond what each fix states.

## Fix 1 — Web Google sign-in always ends in error state

**File:** `apps/web/lib/features/auth/controller/auth_controller.dart`, method `signInWithGoogle` (~line 87–104).

**Defect:** after awaiting the sign-in result, the code unconditionally runs
`state = const AsyncValue.error('NO DATA', StackTrace.empty);`
*before* `userResult.fold(...)`. Every Google login on web — including successful ones — leaves `authControllerProvider` in an error state. Any widget watching it (loaders/buttons) sees a permanent error.

**Fix:** delete that line and set state inside the fold, mirroring the mobile app's `signInWithGoogle`:

```dart
      userResult.fold(
        (l) {
          showFailureSnackBar(context, l.message);
          state = AsyncValue.error(l.message, StackTrace.empty);
        },
        (userModel) {
          ref.read(userProvider.notifier).setUser(userModel);
          state = const AsyncValue.data(null);
        },
      );
```

Also change the method signature from `void signInWithGoogle(...) async` to `Future<void> signInWithGoogle(...) async` (matches mobile; callers are fire-and-forget onPressed handlers, nothing else changes).

## Fix 2 — `sleep()` blocks the UI thread on the mobile home screen

**File:** `apps/mobile/lib/features/home/presentations/home_screen.dart`.

**Defect:** inside `build` → `user.when(data: (data) { sleep(Duration(milliseconds: 500)); ... })` (~line 142). `dart:io`'s `sleep` synchronously freezes the raster/UI isolate for 500 ms on **every rebuild** of the home screen — visible jank, and it runs on each provider update.

**Fix:** delete the `sleep(Duration(milliseconds: 500));` line. Then check remaining usages of `dart:io` in the file — the import at line 1 exists only for `sleep`, so delete `import 'dart:io';` too. Do not replace with a delayed Future; the phone-number warning card needs no delay.

## Fix 3 — Null-assert crash path in booking details

**File:** `apps/mobile/lib/features/booking/presentations/booking_details_dialog.dart`, `_participantComponent` (~line 533).

**Defect:** `if (!user.value!.currentRole(ref).isObserver && ...)` — `user.value` is null while the profile is loading or after sign-out; the `!` throws and takes down the dialog.

**Fix:** remove the `!`: `user.value.currentRole(ref)` — the `currentRole` extension is declared on `UserModel?` (`packages/util/lib/src/user_extension.dart`) and returns `UserRole.observer` for null, which correctly hides the Join button for not-yet-loaded users.

## Fix 4 — `'default_user_id'` written into participant data

**Files:**
- `apps/mobile/lib/features/participant/participant_controller/participant_controller.dart`
- `apps/web/lib/features/participant/controller/participant_controller.dart`
(Both apps duplicate this controller — fix both, keeping them line-identical where they already are.)

**Defect 1:** `build(String bookingId)` seeds state with `userId: userId ?? 'default_user_id'`. If the user profile hasn't loaded when a booking dialog is opened, tapping Join writes a participant entry `{userId: 'default_user_id'}` into Firestore — garbage that also breaks `getAllParticipants`' user lookup and pollutes future activity/notification features.

**Defect 2:** guard order — `if (state.userId!.isNotEmpty && state.userId != null)` dereferences with `!` *before* the null check (dead null check; crash if ever null).

**Fix (apply to both files):**
1. First read that app's `ParticipantState` (`.../participant/state/participant_state.dart`) to confirm `userId` is a nullable `String?` — it is used with `!` today. Keep the state shape unchanged.
2. In `build`, drop the placeholder: `userId: userId` (pass the nullable through; if the freezed field is non-nullable `String`, use `userId ?? ''` instead — check the state file first).
3. In `addParticipant` AND `removeParticipant`, replace the outer condition with an early guard:
   ```dart
   final userId = state.userId;
   if (userId == null || userId.isEmpty) {
     throw 'User not loaded yet. Please wait a moment and try again.';
   }
   ```
   then use the local `userId` (no `!`) in the calls below. Keep the thrown-String convention — callers already catch and route through `showFailureSnackBar`.
4. `build` watches `ref.watch(userProvider).value?.uid`, so once the profile loads, the provider rebuilds with a real uid automatically. Do NOT cache the controller across the null→value transition by other means.

**Cleanup (one-time, MANUAL, optional):** in the Firebase console, search the `participant` collection for entries with `userId == 'default_user_id'` and delete those array entries. Code must tolerate them regardless (the reminder function and `getAllParticipants` skip unknown uids).

## Fix 5 — `whereIn` crashes with >30 participants

**File:** `packages/repositories/lib/src/participant/participant_repository.dart`, `getAllParticipants` (~lines 97–118).

**Defect:** `where(FieldPath.documentId, whereIn: userIds)` — Firestore rejects `whereIn` lists longer than 30 with an exception, so a popular booking (31+ intercessors) makes the participants section permanently error.

**Fix:** chunk the lookup:

```dart
  Stream<List<UserModel>> getAllParticipants(String bookingId) {
    return _participant.doc(bookingId).snapshots().asyncMap((snapshot) async {
      if (!snapshot.exists) return [];

      final data = snapshot.data() as Map<String, dynamic>;
      final List participantsData = data['participantsId'] ?? [];

      if (participantsData.isEmpty) return [];

      final userIds = participantsData
          .map((p) => p['userId'])
          .whereType<String>()
          .toSet()
          .toList();

      // Firestore whereIn accepts at most 30 values — fetch in chunks.
      final List<UserModel> users = [];
      for (var i = 0; i < userIds.length; i += 30) {
        final chunk = userIds.sublist(
          i,
          i + 30 > userIds.length ? userIds.length : i + 30,
        );
        final userSnapshots = await _firestore
            .collection(FirebaseConstants.usersCollection)
            .where(FieldPath.documentId, whereIn: chunk)
            .get();
        users.addAll(
          userSnapshots.docs.map((doc) => UserModel.fromJson(doc.data())),
        );
      }
      return users;
    });
  }
```

Note the added `.whereType<String>().toSet()` — also silently drops malformed entries and duplicates (defends against Fix 4's historical garbage).

## Fix 6 — `ErrorText` shows a SnackBar during build

**File:** `packages/util/lib/src/failure.dart` (~lines 35–46).

**Defect:** `ErrorText.build` calls `showFailureSnackBar(context, error)` synchronously during build — mutating `ScaffoldMessenger` mid-build can throw "setState() or markNeedsBuild() called during build" and re-fires the snackbar on every rebuild.

**Fix:** convert to a `StatefulWidget` that fires once, after the first frame:

```dart
class ErrorText extends StatefulWidget {
  const ErrorText({super.key, required this.error});
  final String error;

  @override
  State<ErrorText> createState() => _ErrorTextState();
}

class _ErrorTextState extends State<ErrorText> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        showFailureSnackBar(context, widget.error);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        widget.error,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
```

Keep `Failure` and `showFailureSnackBar` in the file untouched. `ErrorText` is used with named parameter `error:` everywhere, so the signature is unchanged.

## Fix 7 — Dead code in `BookingController`

**File:** `apps/mobile/lib/features/booking/controller/booking_controller.dart`.

**Defect A:** `void setOccurenceId(Map<String, dynamic>? occurenceId) => occurrenceIds;` (~line 169) is a no-op (evaluates the field, assigns nothing). Verified unused: the only occurrence-id consumer (`booking_book_button.dart`) uses its own local variable.
**Fix A:** delete the method AND the `Map<String, dynamic>? occurrenceIds;` field (~line 46). Grep `occurrenceIds` and `setOccurenceId` under `apps/mobile/lib` afterward to confirm zero references remain (the `booking_book_button.dart` local variable of the same name stays — it is a different, local symbol).

**Defect B:** `isTimeRangeInvalid` (~line 366) calls `ref.watch(getCurrentOrgBookingsStreamProvider)` inside a plain method — controller methods must use `ref.read` (watch outside `build` creates stray subscriptions; Riverpod 3 discourages/asserts on it).
**Fix B:** change that single `ref.watch(` to `ref.read(`.

No codegen is affected by any fix in this plan (no annotations change) — **build_runner not required**.

## Edge cases a weaker model would miss

1. **Fix 1:** do NOT remove the `state = const AsyncValue.loading();` at the top of `signInWithGoogle` — only the misplaced error assignment. And don't touch `_signInWithGoogleWeb`; it's correct.
2. **Fix 2:** `sleep` comes from `dart:io`, which does not exist on web — but this file is mobile-only, so the import removal is about hygiene, not platform. Confirm nothing else in the file uses `dart:io` before deleting the import (as of this writing, nothing does).
3. **Fix 3:** do not "defend" with `user.value?.currentRole(...) ?? something` — the extension is *already* null-receiver-safe; the bang was the only problem.
4. **Fix 4:** the two controllers are near-identical but live in different paths (`participant_controller/` on mobile vs `controller/` on web) and import their own app's `auth_controller.dart`. Keep each app's imports app-local (`package:mobile/...` vs `package:website/...`).
5. **Fix 4:** do not change `ParticipantState`'s freezed definition — that would require build_runner and touches serialized state; the guard belongs in the controller.
6. **Fix 5:** `FieldPath.documentId` with `whereIn` compares against the **document id**, and `UserModel.fromJson(doc.data())` relies on the doc body containing `uid` — unchanged behavior; don't switch to `where('uid', whereIn: ...)` (works, but changes index usage and is unnecessary).
7. **Fix 5:** keep it a `Stream` via `asyncMap` — the participants panel live-updates when someone joins; don't convert to a one-shot Future.
8. **Fix 6:** `ErrorText` lives in a **shared package** used by both apps; changing its constructor signature would be a breaking cross-app change. The fix above keeps the exact public API.
9. **General:** these files contain intentionally retained commented-out code blocks; per AIDOC §11 leave them alone.

## Acceptance criteria

1. `flutter analyze` in `apps/mobile`, `apps/web`, `packages/util`, `packages/repositories` — no new warnings/errors (pre-existing infos may remain).
2. **Web login:** run `flutter run -d chrome` in `apps/web`, sign in with Google → after the popup completes, no error snackbar appears and the account UI (avatar in the top bar) is shown. Watching `authControllerProvider` in DevTools shows `AsyncData`, not `AsyncError`.
3. **Home jank:** on mobile, the home screen renders instantly after login (no half-second freeze per rebuild; verify by toggling org in Settings and returning — previously each rebuild froze).
4. **Participant guard:** on mobile with airplane-mode-then-online (profile not yet loaded), opening a booking and tapping Join shows the "User not loaded yet..." snackbar and writes **nothing** to `participant/{bookingId}`; after the profile loads, Join writes the real uid.
5. **Chunking:** temporarily seed a test booking's participant doc with 35 fake `{userId: <real-looking-id>, timestamp: <iso>}` entries (console) → the details dialog's participants list renders (unknown uids simply don't resolve) instead of erroring.
6. **ErrorText:** force an error state (e.g. temporarily throw inside a watched provider used by a screen that renders `ErrorText`) → exactly one snackbar, no "called during build" exception in the console.
7. Booking create/edit/delete still work end-to-end on mobile (regression check for Fix 7): create a single booking, edit its time, delete it.
