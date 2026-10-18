# SaiyaGym — mobile (gymapp-mobile)

Flutter app (Android + iOS) for **live session logging, offline-first**.
Spec: [`docs/SPEC.md`](docs/SPEC.md) · Status: [`docs/PROGRESS.md`](docs/PROGRESS.md).

## Requirements

- Flutter **3.47.7** stable (Dart **3.13.5**) — `flutter --version`
- Android SDK (accept licenses: `flutter doctor --android-licenses`)
- iOS: a Mac with Xcode (see [iOS flavors](#ios-flavors))
- The API running locally (`saiyagym-backend`, `npm run start:dev`, port 3000)

## Run locally

```bash
flutter pub get
dart run build_runner build      # Riverpod / freezed / json / Drift codegen
flutter run --flavor dev         # Android emulator → http://10.0.2.2:3000/api/v1
```

| Flavor | App id | API |
|--------|--------|-----|
| `dev`  | `com.saiyagym.app.dev` ("SaiyaGym Dev") | Android emulator `10.0.2.2:3000`, iOS simulator `localhost:3000`. Cleartext HTTP allowed **only** in this flavor |
| `prod` | `com.saiyagym.app` | `https://CHANGE-ME.onrender.com/api/v1` — **set the real Render URL** in `lib/core/config/app_config.dart` |

Physical device against your dev API (same Wi-Fi):

```bash
flutter run --flavor dev --dart-define=API_BASE_URL=http://192.168.1.20:3000/api/v1
```

> The app only ever talks to the **API**. Never put a MongoDB connection
> string (or any server secret) in the app: anything in an APK/IPA is public.

## Commands

| What | Command |
|------|---------|
| Codegen (one-off / watch) | `dart run build_runner build` · `dart run build_runner watch` |
| Lint | `flutter analyze` (very_good_analysis) |
| Format | `dart format lib test` |
| Tests | `flutter test` · one file: `flutter test test/core/units/unit_formatter_test.dart` · by name: `flutter test --plain-name "single-flight"` |

Generated files (`*.g.dart`, `*.freezed.dart`) are committed so the project
compiles right after cloning; regenerate after changing annotated code.

## Architecture

Feature-first, three layers per feature:

```
lib/
  main.dart            # flavor → AppConfig, EasyLocalization, ProviderScope
  app/                 # root widget, go_router (guard + bottom-nav shell)
  core/                # cross-feature infrastructure (no feature imports)
    config/            # AppConfig per flavor
    network/           # Dio client, interceptors, ApiException
    storage/           # tokens in Keychain / Keystore
    database/          # Drift (SQLite) + versioned migrations
    i18n/ units/ theme/ widgets/
  features/<name>/
    domain/            # entities, repository ports, use cases (pure Dart)
    data/              # models (freezed + json), data sources, repository impls
    presentation/      # pages, widgets, Riverpod controllers
    <name>_providers.dart  # composition root of the feature (DI)
```

- **State/DI:** Riverpod 3 with code generation (`@riverpod`).
- **Navigation:** go_router. `authRedirect()` (pure, unit-tested) protects every
  route: restoring session → splash, signed out → login, signed in → tabs.
  Tabs: Hoy · Entrenar · Historial · Progreso · Perfil (`StatefulShellRoute`,
  each tab keeps its stack).
- **HTTP:** Dio. Interceptors, in order: `Accept-Language` → auth (Bearer +
  refresh) → error mapping. On 401 a **single-flight** refresh runs: concurrent
  requests wait for the same `/auth/refresh` (refresh tokens rotate; two
  parallel refreshes would trip `REFRESH_TOKEN_REUSED` and revoke the session),
  then retry. A rejected refresh ends the session; an unreachable API does
  **not** (offline ≠ logged out). Public endpoints pass
  `Options(extra: AuthInterceptor.publicEndpoint)`.
- **Errors:** everything leaving the data layer is an `ApiException` — branch on
  `code` (API codes like `PLAN_LIMIT_REACHED`, or client codes `NETWORK_ERROR`,
  `TIMEOUT`, `UNKNOWN_ERROR`). Display: `errors.<code>` from the app's i18n if
  defined, else the API's `message` (already localized), else a generic text.
- **Local DB:** Drift. Schema changes: bump `schemaVersion`, run
  `dart run drift_dev make-migrations` (exports `drift_schemas/`, generates
  step-by-step helpers and migration tests in `test/drift/`), add the step.
- **Offline session:** the last `/users/me` is cached in Drift; the app opens
  with it when the API is unreachable.

## i18n

`easy_localization`, files in `assets/i18n/{lang}.json` (`es` default and
fallback, `en`). **No hard-coded UI text**: always `context.tr('key')`.

Adding a language = add `assets/i18n/<code>.json` + one entry in
`AppLocales.languages` (`lib/core/i18n/app_locales.dart`) + the code in
`CFBundleLocalizations` (`ios/Runner/Info.plist`).

## Units

Data is stored and sent **only in kg and cm**. `UnitFormatter`
(`lib/core/units/`) converts for display following `preferences.units`
(`ref.unitFormatter(context)` in widgets) and converts user input back with
`weightToKg` / `lengthToCm` before saving.

## UI

Material 3, light/dark/system (from `preferences.theme`), brand seed
`#00C9B7`, bundled **Outfit** font (SIL OFL, works offline). Built for tired,
sweaty hands: 56 dp buttons, large text, padded touch targets.

## iOS flavors

Android flavors are wired in Gradle. On iOS the bundle id is set
(`com.saiyagym.app`) but the Xcode schemes are **not** created yet (done on a
Mac, can't be verified from Windows). Until then:

```bash
flutter run --dart-define=FLAVOR=dev     # or FLAVOR=prod
```

To add native schemes: in Xcode duplicate the `Debug`/`Release`/`Profile`
configurations as `Debug-dev`, `Release-prod`, …, create schemes `dev` and
`prod`, set `PRODUCT_BUNDLE_IDENTIFIER` (`.dev` suffix for dev) and the display
name per configuration. Then `flutter run --flavor dev` works on iOS too.
