# PLAN-web-user-management-screen

**Leverage rank: 5 of 5.** The web app already ships a complete user-management **controller and provider** (`apps/web/lib/features/user_management/controller|provider/`, `.g.dart` files committed) — but there is **no screen and no route**, so admins can only manage roles/deletions from a phone. This plan adds the missing web surface. It is also where the activity viewer (PLAN-admin-user-activity-tracking) will later plug in on web.
Soft dependency: **PLAN-secure-backend-functions-and-rules** should land first so the delete flow is server-enforced admin-only.

> Read `apps/AIDOC.md` first. The web app's package name is `website` (imports are `package:website/...`). Web routing is declarative `GoRouter` — do NOT introduce typed routes here.

---

## Goal

An admin logged into the web app gets a "User Management" entry in the top-left menu; it opens `/user-management` — a screen with role tabs, a search box, and per-user actions (change role, delete, view profile) — functionally equivalent to the mobile `UserManagementScreen`. Non-admins (including anyone typing the URL directly) see an unauthorized message instead.

## Context you need (verified facts)

- **Mobile reference implementation** (copy behavior, adapt UI): `apps/mobile/lib/features/user_management/presentations/user_management_screen.dart` — `DefaultTabController` over `UserRole.values`, search `TextField`, `usersByRoleProvider(role:, searchTerm:)` per tab, `_PopMenuButton` with "Role" (ToggleButtons dialog → `controller.changeUserRole(uid, role.name)`) and "Delete" (`ConfirmDialog` → `controller.deleteUserAccount(context, uid)`).
- **Web already has, ready to use (do not recreate):**
  - `UserManagementController` — `apps/web/lib/features/user_management/controller/user_management_controller.dart` (`changeUserRole`, `deleteUserAccount` incl. the `deleteUserAuth` cloud-function call).
  - `usersByRoleProvider` — `apps/web/lib/features/user_management/provider/user_management_provider.dart`.
  - `ConfirmDialog` — `apps/web/lib/core/widgets/confirm_dialog.dart`.
  - `showFailureSnackBar` / `showSuccessfulSnackBar` — `package:util` / `apps/web/lib/core/widgets/snack_bar.dart`.
  - Role helpers — `currentRole(ref)`, `UserRoleX.onlyAdmin`, `capitalize()` from `package:util`.
- **Web router**: `apps/web/lib/core/router/router.dart` — a single `StatefulShellRoute.indexedStack` whose branches are tabs `/` (0), `/booking` (1), `/list` (2), `/settings` (3), `/profile` (4).
- **Shell nav**: `apps/web/lib/features/home/presentations/shell_screen.dart` — `ScaffoldWithNavBar` (a `ConsumerWidget`), top-left `PopupMenuButton<String>` whose `onSelected` switch calls `navigationShell.goBranch(<index>)` with **hardcoded branch indices** (profile is `goBranch(4)`).
- **Profile navigation on web**: `context.go('/profile', extra: user)` / route `/profile/:uid` also accepts `extra` (`state.extra as UserModel?`).
- The mobile screen's `GlassListTile`/`GeneralDrawer` don't exist on web — use plain `ListTile`/`AppBar`.
- `models.dart` exports `UserModel`, `UserRole`; `UserModelFieldLabels` hide-import quirk from the mobile file is unnecessary on web (that name lives in mobile-only code; just import `package:models/models.dart` normally).

## Design decision (already made — implement exactly this)

Add `/user-management` as a **top-level sibling route of the shell**, NOT as a new `StatefulShellBranch`.
Reason: the shell's `onSelected` handler and profile buttons hardcode `goBranch(4)`; inserting a branch renumbers them and silently breaks profile navigation. A sibling `GoRoute` renders outside the shell (no bottom/persistent nav) with its own `AppBar` + back button, which is fine for an admin page.

## Files to touch

| Action | File |
|---|---|
| Create | `apps/web/lib/features/user_management/presentations/user_management_screen.dart` |
| Edit | `apps/web/lib/core/router/router.dart` (add sibling route) |
| Edit | `apps/web/lib/features/home/presentations/shell_screen.dart` (admin-gated menu item) |

No codegen (web routes are not typed; no new annotations) — **build_runner not required**.

## Step-by-step implementation

### Step 1 — The screen

Create `apps/web/lib/features/user_management/presentations/user_management_screen.dart`. Port the mobile screen with these adaptations (everything else — tabs, search, popup menu, role dialog, delete confirm — port 1:1):

```dart
import 'package:constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:models/models.dart';
import 'package:util/util.dart';
import 'package:website/core/widgets/confirm_dialog.dart';
import 'package:website/core/widgets/loader.dart';
import 'package:website/features/auth/controller/auth_controller.dart';

import '../controller/user_management_controller.dart';
import '../provider/user_management_provider.dart';

class UserManagementScreen extends ConsumerStatefulWidget {
  const UserManagementScreen({super.key});

  @override
  ConsumerState createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends ConsumerState<UserManagementScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Guard: the URL is user-typable on web — never trust the menu gating.
    final currentUser = ref.watch(userProvider).value;
    if (!currentUser.currentRole(ref).onlyAdmin) {
      return Scaffold(
        appBar: AppBar(title: const Text('User Management')),
        body: const Center(
          child: Text('You are not authorized to view this page.'),
        ),
      );
    }

    final controller = ref.read(userManagementControllerProvider.notifier);

    return DefaultTabController(
      length: UserRole.values.length,
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () =>
                context.canPop() ? context.pop() : context.go('/'),
          ),
          title: const Text('User Management'),
          bottom: TabBar(
            isScrollable: true,
            tabs: UserRole.values.map((role) {
              return Tab(text: role.displayName);
            }).toList(),
          ),
        ),
        body: /* ... identical structure to the mobile file:
                 search TextField (onSubmitted: setState),
                 TabBarView over UserRole.values,
                 usersByRoleProvider(role: role, searchTerm: _searchController.text)
                   .when(data/error/loading),
                 ListView of ListTile(
                   onTap: () => context.push('/profile/${user.uid}', extra: user),
                   title/subtitle/trailing _PopMenuButton) ... */
      ),
    );
  }
}
```

Port `_PopMenuButton` and `_showChangeRoleDialog` from the mobile file verbatim, with only these substitutions:
- `import 'package:website/...'` instead of `package:mobile/...`.
- Profile navigation: `context.push('/profile/${user.uid}', extra: user);` instead of `ProfileRoute(user).push(context);`.
- Keep the "cannot delete an admin" guard and the `ConfirmDialog` delete flow exactly as on mobile (the web controller has the same `deleteUserAccount`).
- Web has `Loader` at `apps/web/lib/core/widgets/loader.dart` — verify its class name by opening the file before importing (mobile's is `Loader`; if web's differs, use web's).

### Step 2 — Route

In `apps/web/lib/core/router/router.dart`, inside the `GoRouter(routes: [ ... ])` list, add **after** (sibling to) the `StatefulShellRoute.indexedStack(...)` entry:

```dart
      GoRoute(
        path: '/user-management',
        builder: (context, state) => const UserManagementScreen(),
      ),
```

Import: `package:website/features/user_management/presentations/user_management_screen.dart`.

### Step 3 — Menu entry (admin-gated)

In `apps/web/lib/features/home/presentations/shell_screen.dart`:

1. In the `PopupMenuButton`'s `itemBuilder` list, after the `/settings` item, add:
   ```dart
   if (ref.watch(userProvider).value.currentRole(ref) == UserRole.admin)
     PopupMenuItem<String>(
       value: '/user-management',
       child: ListTile(
         leading: Icon(
           Icons.supervisor_account,
           color: currentLocation == '/user-management'
               ? Theme.of(context).colorScheme.primary
               : null,
         ),
         title: Text(
           'User Management',
           style: TextStyle(
             color: currentLocation == '/user-management'
                 ? Theme.of(context).colorScheme.primary
                 : null,
           ),
         ),
       ),
     ),
   ```
   Imports needed: `package:models/models.dart` (for `UserRole`) and `package:util/util.dart` (for the `currentRole` extension) — check which are already imported first.
2. In the `onSelected` switch, add:
   ```dart
   case '/user-management':
     context.push('/user-management');
     break;
   ```
   **Use `context.push`, NOT `navigationShell.goBranch`** — this route lives outside the shell.

## Edge cases a weaker model would miss

1. **Do not add a `StatefulShellBranch`.** Branch indices are hardcoded (`goBranch(4)` for profile in two places in `shell_screen.dart`); a new branch shifts them and breaks profile navigation with no compile error.
2. **Gate inside the screen, not just the menu.** Web URLs are typable; a non-admin (or logged-out visitor) can navigate to `/user-management` directly. The in-screen role check is the actual UI guard; Firestore rules + the admin-gated cloud function (security plan) are the real enforcement. `currentRole(ref)` on a null user returns `UserRole.observer`, so logged-out is handled by the same check.
3. **`currentRole(ref)` takes a `WidgetRef`** — inside `ConsumerState`/`ConsumerWidget` you have one; don't try to call it with `Ref`.
4. **`usersByRoleProvider` streams ALL users and filters client-side** (see `usersByRoleForOrg` in `packages/repositories/.../user_management_repository.dart`). Fine at this app's scale; do not "optimize" with server-side role queries (roles live in a per-org map — there's no flat role field to query).
5. **The role stored per org**: `changeUserRole` writes `roles.<currentOrg>` only. The tabs reflect the **currently selected org** (`organizationControllerProvider`). If the admin switches org in web settings, the same user may appear under a different tab — expected, mirror of mobile.
6. **Search only re-filters on submit** (`onSubmitted: setState`) on mobile — keep that behavior for parity (don't switch to `onChanged` and cause a rebuild per keystroke over the full user list).
7. **`deleteUserAccount` self-delete branch** reauthenticates and signs out — an admin deleting *themselves* from this screen will be logged out mid-session. That's existing controller behavior; don't block it, but don't "improve" it either.
8. **After the security plan**, delete of another user requires the caller to be admin server-side; if this screen is tested with a non-admin account before rules land, deletes would *succeed* — another reason to land the security plan first.
9. **Responsive frame**: the web app wraps everything in `ResponsiveScaledBox` via `MaterialApp.router`'s builder — the new screen gets it automatically; don't add your own MaxWidth wrappers.

## Acceptance criteria

1. `flutter analyze` in `apps/web` is clean; `flutter build web` succeeds.
2. Logged in as **admin**: the top-left popup menu shows "User Management"; clicking it opens `/user-management` (URL bar shows the path) with role tabs (Admin / Watchman / Watch Leader / Intercessor / Observer), a search field, and the user list for the current org.
3. Changing a user's role via ⋮ → Role → pick a role: the change persists (Firestore `users/{uid}.roles.<org>` updates; the user moves tabs after the stream refreshes).
4. Search: type a name fragment, press Enter → list filters (case-insensitive contains, same as mobile).
5. Clicking a user row navigates to their profile (`/profile/<uid>`), back button returns.
6. Delete: ⋮ → Delete on a **test** non-admin user → ConfirmDialog → user doc and their hosted bookings disappear from Firestore, auth account removed (Firebase console → Authentication), success snackbar shown. Deleting an admin is blocked with the "cannot delete an admin" snackbar.
7. Logged in as **non-admin**: no menu entry; typing `/user-management` in the URL shows "You are not authorized to view this page." Logged out: same.
8. Existing tabs still work: Home/Calendar/List/Settings/Profile all navigate correctly after the change (regression for the goBranch indices).
