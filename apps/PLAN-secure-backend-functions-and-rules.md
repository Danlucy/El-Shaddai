# PLAN-secure-backend-functions-and-rules

**Leverage rank: 1 of 5 — DO THIS FIRST.**
Effort: ~half a day. Closes a hole where **any logged-in user can permanently delete any other user's account**, and creates the Firestore rules/indexes scaffolding that the notification and activity plans build on.

> Read `apps/AIDOC.md` first and follow its conventions. Do not refactor anything not listed here.

---

## Goal

1. `deleteUserAuth` cloud function must only work for **admins** (or a user deleting themselves).
2. `backfillEmailsToFirestore` must only work for admins.
3. Add `firestore.rules` and `firestore.indexes.json` to the repo, wired into `firebase.json`, and deploy them.
4. Stop tracking the release keystore; remove leaked secrets from comments; document key rotation.

## Context you need (verified facts — do not re-derive)

- Functions live in `El_Shaddai/functions/src/index.ts` (TypeScript, Node 22, `firebase-functions` v6, `firebase-admin` v12). `functions/main.py` is dead commented-out code — ignore it.
- Firebase project id: `el-shadd`. Deploy commands run from the repo root `El_Shaddai/`.
- User docs: top-level `users/{uid}` with a `roles` field that is a **map of orgId → role-name string**, e.g. `{ "elShaddai": "admin", "flamingFire": "observer" }`. Role strings are the Dart enum names: `admin`, `watchman`, `watchLeader`, `intercessor`, `observer` (see `packages/models/lib/src/models/user_model/user_model.dart`).
- Org ids are the enum names in `packages/repositories/lib/src/provider/organization_provider/organization_controller.dart`: `elShaddai`, `flamingFire`.
- Bookings: `churches/{orgId}/bookings/{bookingId}`. The client also runs a **collection-group query** on `bookings` (`collectionGroup('bookings').where('userId'==...)` in `packages/repositories/lib/src/user_management/user_management_repository.dart` `deleteUserAccount`) — rules must permit collection-group reads.
- Participants: **top-level collection named `participant` (singular)** — see `FirebaseConstants.participantsCollection` in `packages/constants/lib/src/firebase_constants.dart`. Docs keyed by bookingId, whole-array rewrites are performed by any joiner, so writes can't be restricted per-entry.
- The **web app has no auth redirect** — logged-out visitors can browse `/booking` and `/booking/:id`. Bookings, participant docs, `feed`, `about`, and `configuration` must therefore remain **publicly readable** or the public website breaks. `users` reads will become auth-only (see Edge cases for the visible consequence).
- Other collections in use: `feed`, `about`, `configuration` (see `firebase_constants.dart`).
- Committed secrets found: `packages/constants/lib/src/constants.dart` (Zoom `clientId`/`clientSecret` as consts, MORE secrets in the comment block lines ~25–33), and the Android release keystore `apps/mobile/android/app/my-release-key.jks`.

## Files to touch

| Action | File |
|---|---|
| Edit | `functions/src/index.ts` |
| Create | `firestore.rules` (repo root, next to `firebase.json`) |
| Create | `firestore.indexes.json` (repo root) |
| Edit | `firebase.json` (add firestore section) |
| Edit | `.gitignore` (repo root — create if missing) |
| Edit | `packages/constants/lib/src/constants.dart` (delete leaked-secret comment block only) |

## Step-by-step implementation

### Step 1 — Add an admin guard to the cloud functions

Edit `functions/src/index.ts`. Add this helper above the exports (keep the existing `admin.initializeApp()` and `db`):

```ts
/**
 * Returns true if the given uid has the 'admin' role in ANY organization.
 * Roles live on users/{uid}.roles as a map of orgId -> role string.
 */
async function isAdminUser(uid: string): Promise<boolean> {
  const snap = await db.collection("users").doc(uid).get();
  if (!snap.exists) return false;
  const roles = (snap.data()?.roles ?? {}) as Record<string, string>;
  return Object.values(roles).includes("admin");
}
```

In `deleteUserAuth`, after the existing `request.auth` and `targetUid` checks, insert:

```ts
  const callerUid = request.auth.uid;
  const isSelfDelete = callerUid === targetUid;
  if (!isSelfDelete && !(await isAdminUser(callerUid))) {
    throw new HttpsError(
      "permission-denied",
      "Only admins can delete other users."
    );
  }
```

(Self-delete must stay allowed: the mobile/web `UserManagementController.deleteUserAccount` "SCENARIO 1" path deletes the caller's own auth account client-side, but keep the function safe anyway.)

In `backfillEmailsToFirestore`, at the top of the handler insert:

```ts
  if (!request.auth || !(await isAdminUser(request.auth.uid))) {
    throw new HttpsError("permission-denied", "Admins only.");
  }
```

### Step 2 — Create `firestore.rules` at the repo root

Create `El_Shaddai/firestore.rules` with exactly this content:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    function isSignedIn() {
      return request.auth != null;
    }

    function callerDoc() {
      return get(/databases/$(database)/documents/users/$(request.auth.uid));
    }

    function isAdmin() {
      return isSignedIn()
        && callerDoc().data.roles.values().hasAny(['admin']);
    }

    // ---------- users ----------
    // Read requires sign-in (docs contain emails/phone numbers).
    // A user may write their own doc but may NOT touch their roles map;
    // admins may write anything (role changes, deletions).
    match /users/{userId} {
      allow read: if isSignedIn();
      allow create: if isSignedIn() && request.auth.uid == userId;
      allow update: if isAdmin()
        || (isSignedIn()
            && request.auth.uid == userId
            && !request.resource.data.diff(resource.data)
                 .affectedKeys().hasAny(['roles']));
      allow delete: if isAdmin()
        || (isSignedIn() && request.auth.uid == userId);
    }

    // ---------- bookings (org-scoped, also queried via collectionGroup) ----------
    // Public read: the web app shows the calendar to logged-out visitors.
    // Create: any signed-in user, but only as themselves.
    // Update/delete: the host or an admin. (App also lets 'watchman' edit;
    // watchman check kept server-side simple: host-or-admin. See Edge cases.)
    match /{path=**}/bookings/{bookingId} {
      allow read: if true;
      allow create: if isSignedIn()
        && request.resource.data.userId == request.auth.uid;
      allow update: if isSignedIn()
        && (resource.data.userId == request.auth.uid || isAdmin());
      allow delete: if isSignedIn()
        && (resource.data.userId == request.auth.uid || isAdmin());
    }

    // ---------- participant (top-level, doc per bookingId) ----------
    // Whole-array rewrites are how the app removes entries, so writes can't
    // be per-entry restricted. Public read (web shows intercessor names count
    // to visitors); any signed-in user may write.
    match /participant/{bookingId} {
      allow read: if true;
      allow write: if isSignedIn();
    }

    // ---------- activity (append-only audit log; used by PLAN-admin-user-activity) ----------
    match /activity/{activityId} {
      allow read: if isAdmin();
      allow create: if isSignedIn()
        && request.resource.data.uid == request.auth.uid;
      allow update, delete: if false;
    }

    // ---------- public content ----------
    match /feed/{docId} {
      allow read: if true;
      allow write: if isSignedIn();
    }
    match /about/{docId} {
      allow read: if true;
      allow write: if isAdmin();
    }
    match /configuration/{docId} {
      allow read: if true;
      allow write: if isAdmin();
    }

    // healthCheck collection is probed by the web connectivity check
    // (apps/web/lib/main.dart checkFirebaseAvailability). It reads with
    // limit(1); an empty allow-read keeps that working.
    match /healthCheck/{docId} {
      allow read: if true;
      allow write: if false;
    }

    // Everything else: deny.
    match /{document=**} {
      allow read, write: if false;
    }
  }
}
```

### Step 3 — Create `firestore.indexes.json` at the repo root

```json
{
  "indexes": [],
  "fieldOverrides": []
}
```

(Plans 1 and 2 append entries to this file; creating it empty now wires the deploy pipeline.)

### Step 4 — Wire both into `firebase.json`

In `El_Shaddai/firebase.json`, add this top-level key (sibling of `"hosting"` and `"functions"`):

```json
  "firestore": {
    "rules": "firestore.rules",
    "indexes": "firestore.indexes.json"
  },
```

### Step 5 — Keystore and leaked secrets

1. Append to the repo-root `.gitignore` (create the file if it does not exist):
   ```
   # Signing keys — never commit
   *.jks
   *.keystore
   key.properties
   ```
2. Untrack the committed keystore (file stays on disk):
   `git rm --cached apps/mobile/android/app/my-release-key.jks`
3. In `packages/constants/lib/src/constants.dart`, **delete the comment block** at the bottom of the file that contains Zoom account IDs/secrets/tokens (the lines starting `// LM8ljM6-...` down to the commented `// const clientSecret = ...`). Do NOT delete the live `clientId`/`clientSecret` consts — the mobile Zoom flow still uses them (moving them server-side is out of scope).

### Step 6 — Build, deploy, verify

```bash
npm --prefix functions run lint
npm --prefix functions run build
firebase deploy --only functions,firestore:rules,firestore:indexes
```

If `firebase deploy` asks to delete functions you don't recognize, answer **No**.

## Edge cases a weaker model would miss

1. **Do not require auth to read bookings/participant/feed/about/configuration/healthCheck.** The web app intentionally serves logged-out visitors; auth-only reads there would blank the public calendar and break the web connectivity probe (`healthCheck` read in `apps/web/lib/main.dart`).
2. **Bookings rules must use `match /{path=**}/bookings/{id}`**, not `match /churches/{org}/bookings/{id}` — the admin delete flow uses a `collectionGroup('bookings')` query, and collection-group queries only pass rules when the match path uses the recursive wildcard.
3. **The roles map values are strings, not booleans** — `roles.values().hasAny(['admin'])` is the correct rules expression. There is no `isAdmin` field anywhere.
4. **Self-delete must remain allowed** in `deleteUserAuth` (`callerUid === targetUid`), or the "delete my own account" flow breaks.
5. **`users` update rule must block self-service role escalation** — that's the `diff().affectedKeys().hasAny(['roles'])` clause. Without it any user could write `roles: {elShaddai: 'admin'}` onto their own doc and become admin.
6. **The app also allows `watchman`/`watchLeader` to edit/delete others' bookings client-side** (see `isWatchmanOrHigher` usage in `apps/mobile/lib/features/booking/presentations/booking_details_dialog.dart`). The rules above allow only host-or-admin, so a watchman editing someone else's booking will now get `permission-denied`. If that matters to the owner, extend the booking update/delete condition with: `|| callerDoc().data.roles.get(path[1], 'observer') in ['admin','watchman','watchLeader']` — but note `path[1]` indexing of the org segment only works if you split the bookings match back into the explicit `churches/{orgId}` form and duplicate a `{path=**}` read-only match for the collectionGroup case. Simplest accepted behavior: watchmen ask an admin. **State this in the commit message.**
7. **Known limitation (do not try to fix here):** booking docs contain the Zoom join URL and password, and they are publicly readable. That is the pre-existing behavior; hiding them requires a data-model change (separate private subdocument), out of scope.
8. **Git history still contains the keystore and secrets** after Step 5. Removing from history (`git filter-repo`) rewrites commits and is a manual owner decision. The real mitigations are: rotate the Zoom client secret in the Zoom Marketplace dashboard, and restrict the Google API keys by app signature/domain in the Google Cloud console. List these as MANUAL follow-ups; do not attempt them from code.
9. **Firestore rules `get()` calls cost a read per evaluation** (`isAdmin()`); that is acceptable at this app's scale — do not "optimize" with custom claims unless asked.

## Acceptance criteria

1. `npm --prefix functions run build` exits 0; deploy succeeds.
2. Signed in as a **non-admin** (role `observer`/`intercessor` in both orgs), calling `deleteUserAuth` with another user's uid returns `permission-denied` (verify from the mobile app's admin delete flow using a non-admin account, or with `firebase functions:shell`).
3. Signed in as an **admin**, deleting a non-admin user still works end-to-end from the mobile User Management screen (Firestore doc gone AND auth user gone — check Firebase console → Authentication).
4. Rules deployed: in Firebase console → Firestore → Rules, the published rules match `firestore.rules`.
5. Logged-out web visitor: open the deployed site's `/booking` — calendar still renders bookings (public read works).
6. Logged-in non-admin: profile edits still save (own-doc update works); attempting to read another flow is unchanged.
7. Non-admin cannot change their own role: in the app there is no UI for it, so verify in Firebase console → Rules playground: simulate `update` on `users/<their-uid>` changing `roles`, authenticated as that uid → **Denied**.
8. `git status` no longer lists `my-release-key.jks` as tracked; `.gitignore` contains the `*.jks` entry.
9. Mobile app still builds and signs in (`flutter analyze` in `apps/mobile` reports no new errors; run the app, log in, open a booking).
