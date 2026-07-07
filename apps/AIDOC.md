# AIDOC.md — El Shaddai Coding Conventions (AI Reference)

> **Purpose:** This document captures the existing coding style, naming practices, and modular
> structure of the El Shaddai monorepo (both `apps/mobile` and `apps/web`, plus the shared
> `packages/*`). **Any AI-generated or future code MUST follow these conventions and must not
> deviate from them.** When in doubt, match the style of the nearest existing file in the same
> folder — do not introduce new patterns, libraries, or architectures.

---

## 1. Repository Layout (Melos Monorepo)

The repo root is `El_Shaddai/`, managed by **Melos** (`melos.yaml`, workspace name `elshaddai`).

```
El_Shaddai/
├── melos.yaml                # packages: apps/*, packages/*
├── pubspec.yaml              # root workspace pubspec (name: el_shaddai)
├── functions/                # Firebase Cloud Functions (backend)
├── apps/
│   ├── mobile/               # Flutter mobile app   (package name: mobile)
│   └── web/                  # Flutter web app      (package name: website  ← note!)
└── packages/                 # Shared internal packages (path dependencies)
    ├── api/                  # Zoom/HTTP layer (Dio), API models, interceptor
    ├── constants/            # API keys, URLs, Firebase collection names, theme
    ├── firebase/             # Firebase options + firebase instance providers
    ├── models/               # Domain models (freezed + json_serializable)
    ├── repositories/         # Firestore/Auth repositories + their providers
    └── util/                 # Failure, FutureEither, converters, extensions, custom pickers
```

Key facts:
- The **mobile app's Dart package is `mobile`** → imports look like `package:mobile/...`.
- The **web app's Dart package is `website`** → imports look like `package:website/...` (the folder is `web` but the package name is `website` — never mix these up).
- Apps consume shared packages via **path dependencies** in `pubspec.yaml`:
  ```yaml
  dependencies:
    constants:
      path: ../../packages/constants
    models:
      path: ../../packages/models
    util:
      path: ../../packages/util
    firebase:
      path: ../../packages/firebase
    repositories:
      path: ../../packages/repositories
    api:                      # mobile only
      path: ../../packages/api
  ```
- **Where code lives:**
  - Domain models, repositories, Firebase glue, constants, generic utilities → `packages/*` (shared by both apps).
  - Screens, feature controllers/providers/state, feature widgets → inside each app's `lib/`.
  - **Duplication between apps is accepted and intentional** (e.g. `GlassContainer`, `auth_controller.dart` exist in both apps and may drift). Do NOT "helpfully" extract app code into a shared package unless explicitly asked.

---

## 2. Tech Stack (do not substitute alternatives)

| Concern            | Library / Pattern used                                                                 |
|--------------------|----------------------------------------------------------------------------------------|
| Language/SDK       | Dart `^3.8.0`, Flutter, **Material 3** |
| State management   | **Riverpod 3** (`flutter_riverpod`, `riverpod_annotation` + `riverpod_generator` codegen). Nothing else — no BLoC, no GetX, no Provider package, no setState-based global state. |
| Immutable models   | **freezed 3** (`@freezed sealed class`) + **json_serializable** (`fromJson`/`toJson`) |
| Functional errors  | **fpdart** `Either<Failure, T>` via `FutureEither<T>` typedef from `package:util` |
| Routing            | **go_router** (v16). Mobile: typed routes via **go_router_builder**. Web: declarative `GoRouter` + `StatefulShellRoute.indexedStack`. |
| Backend            | Firebase (Auth, Firestore, Cloud Functions, Messaging/FCM on mobile, Crashlytics on mobile, Storage) |
| HTTP               | **dio** (in `packages/api`, for Zoom API), `http` where already present |
| Fonts              | `google_fonts` — **Inter** via shared `textTheme` in `packages/constants` |
| UI niceties        | `gap`, `auto_size_text`, `flutter_animate`, `shimmer`, `simple_gradient_text`, glass-morphism custom widgets, Syncfusion calendar/date pickers |
| Web-only UI        | `responsive_framework` (breakpoints/`ResponsiveScaledBox`), hover widgets |
| Mobile-only        | `webview_flutter` (Zoom OAuth), `image_picker`, `showcaseview` (onboarding tips), `flutter_local_notifications`, `permission_handler`, `share_plus` |
| Lints              | `flutter_lints` default rule set (`analysis_options.yaml` includes `package:flutter_lints/flutter.yaml`, no custom rules) |
| Formatting         | Standard `dart format` (Dart 3.8 tall style — trailing commas everywhere, chained `..copyWith(...)` wrapped) |

---

## 3. App Module Structure (feature-first)

Both apps use the same **feature-first** layout under `lib/`:

```
lib/
├── main.dart                       # entry point (see §9)
├── core/                           # cross-feature app code
│   ├── router/
│   │   ├── router.dart             # goRouterProvider + routes
│   │   └── no_internet_screen.dart
│   ├── user/
│   │   └── user_provider.dart
│   ├── utility/                    # small helpers (url_launcher.dart, etc.)
│   └── widgets/                    # app-wide reusable widgets
│       ├── glass_container.dart
│       ├── loader.dart
│       ├── snack_bar.dart
│       ├── confirm_dialog.dart
│       └── calendar_widget.dart
└── features/
    └── <feature_name>/             # e.g. auth, booking, calendar, home, post,
        │                           #      profile, settings, participant, user_management
        ├── controller/             # Riverpod controllers (business logic)
        │   └── <feature>_controller.dart (+ .g.dart)
        ├── provider/               # derived / repository-bridging providers
        │   └── <feature>_provider.dart (+ .g.dart)
        ├── state/                  # freezed state objects
        │   └── <feature>_state.dart (+ .freezed.dart, .g.dart)
        ├── presentations/          # screens, dialogs, large page components
        │   └── <feature>_screen.dart, <feature>_dialog.dart, *_component.dart
        └── widgets/  (or widget/)  # feature-scoped widgets
            └── <feature>_<thing>.dart
```

Rules:
- A new feature gets its own folder under `features/` with only the subfolders it needs (`controller/`, `provider/`, `state/`, `presentations/`, `widgets/`).
- Screen-level UI goes in `presentations/`; smaller reusable pieces go in the feature's `widgets/` (mobile mostly uses plural `widgets/`, some features and web use singular `widget/` — **match whatever the target feature already uses**; don't rename existing folders).
- App-level shared widgets go in `core/widgets/`; app-level helpers in `core/utility/`.

### Shared package structure

Every `packages/*` package follows the **barrel + src** pattern:

```
packages/<name>/
└── lib/
    ├── <name>.dart          # barrel file: only `export 'src/...';` lines
    └── src/
        └── ...              # actual implementation
```

- `packages/models`: one folder per model — `lib/src/models/<model_name>/<model_name>.dart` with its `.freezed.dart`/`.g.dart` parts next to it. Simple models (e.g. `location_data.dart`) may sit directly in `src/models/`.
- `packages/repositories`: one folder per domain — `lib/src/<domain>/<domain>_repository.dart`.
- Consumers always import the **barrel**: `package:models/models.dart`, `package:util/util.dart`, `package:constants/constants.dart`, `package:repositories/repositories.dart`, `package:api/api.dart`, `package:firebase/firebase.dart`. (Rare exception exists — mobile main.dart imports `package:firebase/src/firebase_options.dart` — but prefer barrels for new code.)

---

## 4. Naming Conventions

### Files & folders
| Thing | Convention | Examples |
|---|---|---|
| All Dart files | `snake_case.dart` | `booking_controller.dart` |
| Screens | `*_screen.dart` | `home_screen.dart`, `booking_list_screen.dart` |
| Dialogs | `*_dialog.dart` | `confirm_dialog.dart`, `add_post_dialog.dart`, `login_dialog.dart` |
| Page sections / composite widgets | `*_component.dart` | `booking_zoom_component.dart`, `recurrence_component.dart`, `monthly_calendar_component.dart` |
| Simple widgets | plain noun or `<feature>_<thing>.dart` | `loader.dart`, `glass_container.dart`, `booking_text_field.dart`, `login_button.dart` |
| Controllers | `*_controller.dart` | `auth_controller.dart`, `booking_controller.dart` |
| Providers | `*_provider.dart` | `booking_provider.dart`, `user_provider.dart` |
| State | `*_state.dart` | `booking_state.dart`, `participant_state.dart` |
| Repositories | `*_repository.dart` | `booking_repository.dart`, `auth_repository.dart` |
| Models | `*_model.dart` (folder-per-model in packages/models) | `booking_model/booking_model.dart` |
| Generated files | `*.g.dart`, `*.freezed.dart` — **never edit or hand-write these** | `router.g.dart`, `booking_state.freezed.dart` |

### Identifiers
| Thing | Convention | Examples |
|---|---|---|
| Classes / enums / typedefs | `PascalCase` | `BookingController`, `GlassContainer`, `FutureEither` |
| Widget classes | Noun, no `Widget` suffix required | `HomeScreen`, `BookButton`, `HoverBorderContainer` |
| Route classes (mobile) | `<Name>Route` | `HomeRoute`, `BookingListRoute`, `NoInternetRoute` |
| Manual providers | `camelCase` + `Provider` suffix | `userProvider`, `goRouterProvider`, `authControllerProvider`, `firestoreProvider`, `currentOrgRepositoryProvider` |
| Generated providers | derived automatically: `@riverpod class BookingController` → `bookingControllerProvider`; `@riverpod Stream<T> fooBar(Ref ref)` → `fooBarProvider` | |
| Notifier classes | `<Thing>Notifier` or `<Thing>Controller` | `UserNotifier`, `AuthController` |
| Enums | PascalCase type, camelCase values; **enhanced enums with `displayName`** where user-facing | `UserRole.watchLeader(displayName: 'Watch Leader')`, `OrganizationsID.elShaddai`, `RecurrenceState.none/daily/weekly`, `BookingVenueComponent.location/zoom/hybrid` |
| Private fields | leading underscore | `_authRepository`, `_firestore`, `_bookingCollection`, `_connectivityTimer` |
| Booleans | `is*/has*` | `isUpdating`, `isRecurring`, `hasConnectivity`, `_disposed` |
| Controller mutators | `set<Field>(...)` one-liners using `copyWith` | `setTitle`, `setDescription`, `setWeb`, `setHostId` |
| Model instantiation helpers | `instantiate<Model>()` | `instantiateBookingModel`, `instantiateZoomMeetingModel` |
| Validation helpers | `is<Thing>Invalid(...)` that **throw String messages** | `isBookingDataInvalid`, `isTimeRangeInvalid` |
| Constants (constants package) | lowerCamelCase top-level `const` | `googleAPI`, `clientId`, `zoomLoginRoute`, `websiteLink`, `timeLabels` |
| Firestore field keys | static `fields` const holder class on the model | `UserModel.fields` → `_UserFields` with `final String name = 'name';` |
| Firestore collections | via `FirebaseConstants.<x>Collection` from `package:constants` | `FirebaseConstants.churchesCollection`, `FirebaseConstants.bookingsCollection`, `FirebaseConstants.usersCollection` |

---

## 5. State Management Patterns (Riverpod 3)

Both **codegen** and **manual** styles are in use. Follow these rules:

### 5a. Codegen style (`@riverpod`) — preferred for new feature controllers/providers
Files declare `part '<file>.g.dart';` and are regenerated with build_runner.

**Notifier controller holding freezed state** (the standard feature-controller shape):
```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'booking_controller.g.dart';

@riverpod
class BookingController extends _$BookingController {
  @override
  BookingState build() {
    return const BookingState();
  }

  void clearState() {
    state = const BookingState();
  }

  void setTitle(String title) => state = state.copyWith(title: title);
}
```

**Simple value notifier:**
```dart
@riverpod
class BookingListSearchQuery extends _$BookingListSearchQuery {
  @override
  String build() => '';

  void update(String query) => state = query;
}
```

**Derived/computed provider as a function:**
```dart
@riverpod
AsyncValue<List<BookingModel>> filteredBookingLists(Ref ref) {
  final bookingsAsync = ref.watch(getCurrentOrgBookingsStreamProvider);
  final searchQuery = ref.watch(bookingListSearchQueryProvider).toLowerCase();

  return bookingsAsync.whenData((bookings) {
    if (searchQuery.isEmpty) return bookings;
    return bookings.where((b) => b.title.toLowerCase().contains(searchQuery)).toList();
  });
}
```

**Family (parameterised) providers** use named required parameters:
```dart
@riverpod
Stream<BookingModel?> singleCurrentOrgBookingStream(
  Ref ref, {
  required String organizationId,
  required String bookingId,
}) { ... }
```

**Async controller with persistence** (`build` returns `Future<T>`/`Stream<T>`):
```dart
@riverpod
class OrganizationController extends _$OrganizationController {
  @override
  Future<OrganizationsID> build() async {
    final prefs = await SharedPreferences.getInstance();
    ...
  }

  Future<void> updateOrg(OrganizationsID orgId) async {
    ...
    state = AsyncData(orgId);
  }
}
```

### 5b. Manual style — used for auth/user and infrastructure providers
Do not convert these to codegen; extend them in-place in the same style:
```dart
final userProvider = NotifierProvider<UserNotifier, AsyncValue<UserModel?>>(
  () => UserNotifier(),
);

class UserNotifier extends Notifier<AsyncValue<UserModel?>> {
  @override
  AsyncValue<UserModel?> build() {
    return const AsyncValue.loading();
  }

  void setUser(UserModel user) {
    state = AsyncValue.data(user);
  }

  void clearUser() {
    state = const AsyncValue.data(null);
  }
}

final authControllerProvider = AsyncNotifierProvider<AuthController, void>(
  () => AuthController(),
);

final authStateChangeProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChange;
});
```
- Infrastructure singletons are plain `Provider`s (`firestoreProvider`, `authProvider`, `storageProvider` in `packages/firebase`).
- Repository providers use `Provider` / `Provider.family` declared **in the same file as the repository class**.

### 5c. Usage inside widgets
- `ref.watch(fooProvider)` for reactive reads in `build`.
- `ref.read(fooProvider.notifier).doThing()` for actions in callbacks.
- Render `AsyncValue` with `.when(data: ..., error: ..., loading: ...)`; loading is usually `const Loader()` (core widget) or `CircularProgressIndicator`; errors often `ErrorText(error: ...)` from `package:util` or an inline `Text('Error: $error')`.

### 5d. One-off local persistence singleton
`SettingsState` (mobile `features/settings/state/settings_state.dart`) is a **plain singleton** over `SharedPreferences` (`SettingsState.instance`, `init()`, getter/setter pairs with `debugPrint` + emoji logging). This is a deliberate exception — keep it a singleton; don't riverpod-ify it.

---

## 6. Models & State Objects (freezed)

All models and feature states are **freezed 3 sealed classes** with json support and custom converters:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:models/models.dart';
import 'package:util/util.dart';

part 'booking_state.freezed.dart';
part 'booking_state.g.dart';

@freezed
sealed class BookingState with _$BookingState {
  const BookingState._();                       // private ctor when helpers/getters needed
  @CustomDateTimeRangeConverter()               // converters annotate the factory
  @LocationDataConverter()
  const factory BookingState({
    CustomDateTimeRange? timeRange,
    String? bookingId,
    String? title,
    LocationData? location,
    @Default(RecurrenceState.none) RecurrenceState recurrenceState,
    @Default(2) int recurrenceFrequency,
  }) = _BookingState;

  factory BookingState.fromJson(Map<String, dynamic> json) =>
      _$BookingStateFromJson(json);
}
```

Conventions:
- `@freezed sealed class X with _$X` — always `sealed`.
- `const X._();` private constructor included when the class has custom methods/getters.
- Required domain fields use `required`; optional fields nullable; defaults via `@Default(...)`.
- Custom JSON converters live in `packages/util/lib/src/json_converters.dart` (`@TimestampConverter()`, `@CustomDateTimeRangeConverter()`, `@LocationDataConverter()`, `@RecurrenceConfigurationConverter()`).
- Always generate `fromJson` for models persisted to Firestore.
- Firestore documents deserialize with the doc id injected: `BookingModel.fromJson({...doc.data(), 'id': doc.id})`.
- Where Firestore field names are referenced as strings, prefer the model's `static const fields` holder (see `UserModel.fields`).
- Enums that need parsing from strings implement a static `fromName(String name)` returning nullable (see `RecurrenceState`).

---

## 7. Repository Pattern & Error Handling

Repositories live in `packages/repositories` (Firestore/Auth) and `packages/api` (HTTP/Zoom).

```dart
part 'booking_repository.g.dart';

final bookingRepositoryProvider = Provider.family<BookingRepository, String>((
  ref,
  organizationId,
) {
  return BookingRepository(
    firestore: ref.watch(firestoreProvider),
    organizationId: organizationId,
  );
});

class BookingRepository {
  final FirebaseFirestore _firestore;
  final String _organizationId;

  BookingRepository({
    required FirebaseFirestore firestore,
    required String organizationId,
  }) : _firestore = firestore,
       _organizationId = organizationId;

  CollectionReference get _bookingCollection => _firestore
      .collection(FirebaseConstants.churchesCollection)
      .doc(_organizationId)
      .collection(FirebaseConstants.bookingsCollection);

  FutureEither<void> deleteBooking({...}) async {
    try {
      ...
      return right(null);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
```

Rules:
- **Constructor injection** of Firebase instances via named required params, assigned to private fields in the initializer list.
- Private `get` accessors for collection references.
- Mutating methods return **`FutureEither<T>`** (`typedef FutureEither<T> = Future<Either<Failure, T>>` from `package:util`); success `right(value)`, failure `left(Failure(message))`. `Failure` is a simple `{ String message }` class.
- Read **streams** are exposed as `@riverpod Stream<...>` top-level functions in the same repository file.
- Batch writes for multi-doc operations (`_firestore.batch()` … `batch.commit()`).
- `FirebaseException` caught specifically before generic `catch (e)` where different handling is needed; some methods accept a `required Function(String) call` error callback for surfacing messages to the UI.

### Error-handling conventions across layers
1. **Repositories:** try/catch → `Either` (never throw across the boundary, except HTTP `ApiRepository` which throws `Exception`s).
2. **Controllers (AsyncNotifier):** set `state = const AsyncValue.loading();` first, then try/catch; unwrap `Either` with `.fold((l) { showFailureSnackBar(context, l.message); state = AsyncValue.error(...); }, (r) { ...; state = const AsyncValue.data(null); });` catch-all sets `state = AsyncValue.error(e, stackTrace);`.
3. **Validation methods throw plain `String` messages** (e.g. `throw 'Booking Failed! Fill in all the data.';`) which callers catch and pass to `showFailureSnackBar(context, e.toString())` or an `errorCall` callback.
4. **User-facing errors** always go through `showFailureSnackBar(context, text)` from `package:util` (red-accent floating SnackBar, 20 s, close icon).
5. Debug logging with `if (kDebugMode) { print(...); }` or `debugPrint(...)`; check `context.mounted` / a `_disposed` flag before using context/state after awaits.

---

## 8. Routing

### Mobile (`apps/mobile/lib/core/router/router.dart`) — typed routes (go_router_builder)
```dart
part 'router.g.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: navigatorKey,
    redirect: (BuildContext context, GoRouterState state) {
      final userData = ref.watch(authStateChangeProvider).value;
      final loggedIn = userData != null;
      ...                                   // auth redirect to LoginRoute
    },
    routes: $appRoutes,
    initialLocation: '/',
  );
});

@TypedGoRoute<HomeRoute>(
  path: '/',
  routes: <TypedGoRoute<GoRouteData>>[
    TypedGoRoute<BookingRoute>(path: 'booking'),
    ...
  ],
)
class HomeRoute extends GoRouteData with _$HomeRoute {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const HomeScreen();
}
```
- Every screen gets a `<Name>Route extends GoRouteData with _$<Name>Route`.
- Child paths are kebab-case (`'contact-us'`, `'booking-list'`, `'intercessors-feed'`, `'user-management'`).
- Extra objects passed via `$extra` field; navigate with `const BookingRoute().go(context)` style.

### Web (`apps/web/lib/core/router/router.dart`) — declarative shell
- Single `goRouterProvider` returning `GoRouter` with `StatefulShellRoute.indexedStack`; one `StatefulShellBranch` per nav tab (`/`, `/booking`, `/list`, `/settings`, `/profile`), wrapped by `ScaffoldWithNavBar(navigationShell: ...)` from `shell_screen.dart`.
- Dialog-like pages are sub-routes using `CustomTransitionPage` with `FadeTransition`, `opaque: false`, `barrierDismissible: true`, `barrierColor: Colors.black54`, 200–300 ms durations.
- Path params read via `state.pathParameters['id']!`; extras via `state.extra as BookingModel?`.
- **Route order matters** — literal paths (`create`) must be declared before parameterised ones (`:id`); keep the banner comments that document this.

---

## 9. App Entry Point (`main.dart`) shape

Both apps follow the same boot sequence — preserve it when touching startup code:
1. `void main() async` → `WidgetsFlutterBinding.ensureInitialized();`
2. Platform setup (mobile: `SystemChrome.setEnabledSystemUIMode`, `SettingsState.instance.init()`).
3. `await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);`
4. Connectivity gate: a top-level `final ValueNotifier<bool> hasConnectivity = ValueNotifier(true);` checked via `Backend.checkInternetAccess()` (mobile) / `Backend.checkFirebaseAvailability()` (web), then `runApp(ValueListenableBuilder(...))` switching between `ProviderScope(child: App)` and a no-internet screen.
5. Public root widget (`MobileApp` / `WebApp`, a `StatelessWidget`) wraps a private `_My<X>App extends ConsumerStatefulWidget` whose state mixes in `WidgetsBindingObserver` for lifecycle-based connectivity rechecks (with `Timer`s cancelled in `dispose`).
6. `MaterialApp.router(routerConfig: ref.watch(goRouterProvider), ...)` with:
   ```dart
   theme: ThemeData(
     appBarTheme: const AppBarTheme(titleSpacing: 0),
     textTheme: textTheme,                    // from package:constants
     useMaterial3: true,
     colorScheme: MaterialTheme.darkScheme(), // dark scheme for BOTH theme & darkTheme
   ),
   ```
   `title: 'El Shaddai'`, `debugShowCheckedModeBanner: false`.
7. Web only: the `builder:` wraps children in `ResponsiveBreakpoints.builder` (MOBILE ≤450, TABLET ≤800, DESKTOP ≤1920, '4K' above) → `MaxWidthBox(maxWidth: 3000)` → `ResponsiveScaledBox` → `BouncingScrollWrapper`.
8. Mobile only: FCM background handler registered top-level (`_firebaseMessagingBackgroundHandler`), portrait-only orientation, `ShowCaseWidget` wrapper.

---

## 10. Widget & UI Conventions

- **Widget class shape** (fields-first, const constructor with `super.key`, named required params):
  ```dart
  class BookingTextField extends StatelessWidget {
    final String label;
    final TextEditingController? controller;
    final int maxLines;

    const BookingTextField({
      super.key,
      required this.label,
      required this.controller,
      this.maxLines = 1,
    });

    @override
    Widget build(BuildContext context) { ... }
  }
  ```
  (Some files put fields after the constructor — both orders exist; match the file you're editing. New files: fields first.)
- Use `ConsumerWidget` / `ConsumerStatefulWidget` whenever the widget touches providers; plain `StatelessWidget`/`StatefulWidget` for pure UI. StatefulWidget state classes are `_<Name>State`; `createState() => _<Name>State();`.
- **Theme access:** `context.colors.<role>` (extension `ThemeExtension on BuildContext` in `package:constants` — `context.colors.primary`, `context.colors.surface`, `context.colors.onSurface`, `context.colors.secondary`, `context.colors.outlineVariant`).
- **Opacity:** use the custom `.withOpac(0.3)` extension (from `package:constants`) — NOT `.withOpacity(...)`.
- Text styling via the shared Inter `textTheme` or inline `TextStyle(fontSize: ..., fontWeight: FontWeight.bold, color: context.colors...)`.
- Signature look: glass-morphism — reuse `GlassContainer` (blur + translucent fill + subtle border), `GradientText` (`simple_gradient_text`) with `context.colors.primary/secondary` gradients, `flutter_animate` (`Animate`, `effects: [...]`, `2000.ms`) for pulsing/emphasis, `Gap(x)` or `SizedBox(height: x)` spacers (both in use).
- Forms: `TextFormField` with `OutlineInputBorder(borderRadius: BorderRadius.circular(10))`, `autovalidateMode: AutovalidateMode.onUserInteraction`, validators returning a `validationMessage` string param.
- Dialogs: reuse `ConfirmDialog` (core widget) for confirm/cancel flows; `showDialog` + `AlertDialog` with `TextButton` actions for multi-choice (destructive option styled `TextStyle(color: Colors.red)`); close with `context.pop()` (go_router) or `Navigator.pop(context)` — both appear.
- Loading states: `Loader()` core widget or `CircularProgressIndicator`; shimmer for skeletons.
- Buttons: `ElevatedButton` with `Padding` child; icon+label via `ElevatedButton.icon`.
- Web hover affordances: `HoverBorderContainer` (MouseRegion + AnimatedContainer border).
- Async UI in `onPressed`: wrap in try/catch, surface failures through `errorCall`/`showFailureSnackBar`, check `context.mounted` after awaits.

---

## 11. Comment & Code Style

- **Comment style is chatty and didactic — preserve it.** Numbered step comments (`// 1. ...`, `// Step 1: ...`, `// A. ...`), section banners (`// ------------- // 1. CREATE & EDIT ROUTES ... // -------------`), and **emoji markers**: `✅` (done/correct), `🔹` (section/refactor note), `🧭` (navigation/reference), `❌`/`⏰`/`💾`/`📖`/`🔧`/`📊` in log strings, `///` doc comments occasionally with emoji (`/// 🔹 **Smart Compress & Resize Image**`).
- **Commented-out legacy code blocks are retained in-place** throughout the repo. Do not delete them when editing nearby code, and it's acceptable to comment-out rather than delete when replacing logic.
- Strings: single quotes preferred; double quotes appear occasionally (esp. when the string contains apostrophes) — never mass-convert.
- `const` aggressively where possible (`const SizedBox(...)`, `const Duration(...)`, const constructors).
- Formatting: run `dart format` (Dart 3.8) — trailing commas, 80-col wrapping, cascaded `..` for Dio interceptors etc. Never hand-format against the formatter.
- Imports: `dart:` first, then `package:` (roughly alphabetical), then relative imports last. Both absolute (`package:mobile/...`, `package:website/...`) and relative (`../../...`) app-internal imports are used — even mixed within one file. Prefer the dominant style of the file being edited; use `show` combinators sparingly (`import '...confirm_dialog.dart' show ConfirmDialog;` exists).
- Top-level mutable globals are allowed sparingly for app-wide signals (`hasConnectivity`, `navigatorKey`).
- Extensions used freely for helpers: `extension BackendConnectivity on Backend`, `ThemeExtension on BuildContext`, `ColorUtils on Color`, user extensions in `packages/util/src/user_extension.dart`.

---

## 12. Code Generation Workflow

Generated files: `*.g.dart` (riverpod_generator, json_serializable, go_router_builder) and `*.freezed.dart` (freezed). They are **committed to the repo**.

- Declare parts at the top of source files:
  ```dart
  part 'booking_controller.g.dart';        // riverpod / json / router codegen
  part 'booking_state.freezed.dart';       // freezed
  part 'booking_state.g.dart';
  ```
- Regenerate after adding/renaming any `@riverpod`, `@freezed`, `@TypedGoRoute`, or json-annotated declaration:
  ```
  # per package/app
  dart run build_runner build --delete-conflicting-outputs
  # or across the workspace
  melos run build_runner
  ```
- **Never manually edit or author `.g.dart` / `.freezed.dart` files.**

---

## 13. Mobile vs Web — differences to respect

| Aspect | Mobile (`apps/mobile`, pkg `mobile`) | Web (`apps/web`, pkg `website`) |
|---|---|---|
| Routing | Typed `@TypedGoRoute` classes + `router.g.dart`, auth `redirect` to `LoginRoute` | Declarative `GoRouter` + `StatefulShellRoute.indexedStack` tabs + `ScaffoldWithNavBar` shell |
| Login | Full `login_screen.dart` | `login_dialog.dart` overlay |
| Responsiveness | Portrait-only phone UI | `responsive_framework` breakpoints + scaled box; hover states |
| Notifications | FCM + `flutter_local_notifications` + fcmToken sync on the user doc | none |
| Zoom OAuth | In-app `webview_flutter` + PKCE (`lib/api/pkce_utils.dart`, `zoom_auth_controller`) | (relies on shared `api` package patterns) |
| Onboarding | `showcaseview` tips (`features/tip/`) | none |
| Extra widgets | — | `animated_background.dart`, `footer_widget.dart`, `rainbow_text.dart`, `glass_button.dart`, `hover_container.dart` |
| Feature set | + `post/`, `calendar/`, `notifications/`, `tip/` features | + booking detail/daily dialogs, custom calendar widgets under `features/booking/presentations/` |

When implementing a feature "for both apps": implement it **twice** (once per app) following each app's local patterns, sharing only models/repository/util logic through `packages/*`.

---

## 14. Firestore Data Conventions

- Hierarchy: `churches/<organizationId>/bookings/<bookingId>` etc. — collection names always through `FirebaseConstants`.
- Multi-tenancy: the active organization comes from `organizationControllerProvider` (enum `OrganizationsID`, persisted in SharedPreferences under `'currentOrg'`); repositories are `Provider.family` keyed by `organizationId`; apps bridge with a `currentOrgRepositoryProvider` that `.when(...)`s over the org async value.
- Recurring bookings: series share a `groupId`; each occurrence is its own doc; Zoom occurrence ids stored as `occurrenceId`; deletes offer "This Only" vs "Entire Series" (batch delete by `groupId`).
- Upserts use `docRef.set(model.toJson(), SetOptions(merge: true))`; new ids from `_collection.doc().id`.
- Timestamps stored via `@TimestampConverter()`; `createdAt: DateTime.now()` set at write time.

---

## 15. Checklist for Adding a New Feature (either app)

1. Create `lib/features/<feature>/` with the needed subfolders (`controller/`, `provider/`, `state/`, `presentations/`, `widgets/`).
2. State: freezed sealed class `<Feature>State` in `state/<feature>_state.dart` (with `fromJson` if persisted).
3. Controller: `@riverpod class <Feature>Controller extends _$<Feature>Controller` in `controller/<feature>_controller.dart`, `build()` returning the state, `set<Field>` mutators via `copyWith`, validation methods that throw String messages.
4. Data access: repository in `packages/repositories/lib/src/<domain>/<domain>_repository.dart` returning `FutureEither`, exposed via `Provider`/`Provider.family` + `@riverpod Stream` functions in the same file; export from `repositories.dart` barrel.
5. Models: `packages/models/lib/src/models/<model>/<model>.dart` freezed + json; export from `models.dart` barrel.
6. Screens in `presentations/` (`<feature>_screen.dart`), registered in the app's router following that app's routing style (typed route class on mobile; GoRoute/branch on web).
7. Reuse core widgets (`GlassContainer`, `Loader`, `ConfirmDialog`, `showFailureSnackBar`, `BookingTextField`-style fields) and `context.colors` theming.
8. Run `dart run build_runner build --delete-conflicting-outputs` in every package/app you touched.
9. Keep lints clean under `flutter_lints`; format with `dart format`.

## 16. Hard "Do NOT" list

- Do NOT introduce other state-management, routing, DI, or model libraries.
- Do NOT edit `.g.dart` / `.freezed.dart` files by hand.
- Do NOT rename existing files or singular/plural folder names unless explicitly asked.
- Do NOT extract app-local UI/controllers into shared packages on your own initiative.
- Do NOT replace `.withOpac()` with `.withOpacity()`, or `context.colors` with `Theme.of(context).colorScheme`.
- Do NOT switch the web app to typed routes or the mobile app to declarative routes.
- Do NOT convert the manual auth/user providers to codegen, or `SettingsState` to Riverpod.
- Do NOT delete existing commented-out code blocks while editing unrelated lines.
- Do NOT change theming away from Material 3 dark (`MaterialTheme.darkScheme()`) / Inter `textTheme`.
- Do NOT bypass `FutureEither`/`Failure` in repositories or `showFailureSnackBar` for user-facing errors.
