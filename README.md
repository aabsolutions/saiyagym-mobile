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
  with it when the API is unreachable (`Session.isOffline`, banner + retry).
- **Local data ownership:** logout wipes every table (`AppDatabase.wipe`),
  confirming harder when `UnsyncedChanges.count() > 0`. An expired session
  only drops the tokens — data survives a re-login of the same user; a
  *different* user signing in wipes it first. Offline features must register
  their outbox counter in `UnsyncedChanges`.
- **Onboarding:** required while `profile.level` or `profile.goal` is null
  (the router enforces it). Password reset and email verification links open
  the **web** app; the mobile app requests the email and re-fetches
  `/users/me`.
- **Plans:** `entitlementsProvider` (from `/users/me`) hides/explains UI;
  `UpgradeCta` / `PlanGate` / `UpgradeReason.fromError(apiError)` for blocked
  features or limits. The API always decides. Store purchases plug into
  `PaymentProvider` (manual for now).
- **Cold starts:** `SlowRequestMonitor` shows "waking up the server" when a
  request takes > 3 s (Render free plan).

## Offline-first sync

Repositories (`features/*/data`) **always read from Drift** and write through
`SyncWriter`: local row + `sync_queue` entry in one transaction. Nothing in the
UI waits for the network.

- **Tables:** `exercises`, `user_exercise_prefs`, `routines`, `programs`,
  `workouts`, `body_metrics` (typed columns for queries + the full doc as JSON in
  `data`) and `sync_queue` (op, collection, doc id, payload, attempts, error,
  next attempt). One queue entry per document: re-editing replaces the payload
  and keeps its position.
- **`SyncService.sync()`** (single-flight): push due entries in batches of 100 to
  `POST /sync/push`, then `GET /sync/pull?since=<serverTime>`, then refresh the
  exercise catalog if stale. The cursor is saved in the same transaction as the
  pulled docs.
- **Conflicts:** last write wins on `updatedAt` (client clock, UTC, millisecond
  precision, strictly increasing per doc). A pulled doc newer than the local one
  replaces it and drops its queued change; an older one is ignored (ours gets
  pushed). Deletions are logical (`deletedAt`).
- **Push whitelist:** `push_codecs.dart`. Pulled docs carry server-computed fields
  (`volumeKg`, …) that the API rejects on push (`forbidNonWhitelisted`).
- **Errors:** connectivity → offline, no attempt counted. 5xx / `CONFLICT` /
  `TOO_MANY_REQUESTS` → exponential backoff (30 s · 2ⁿ, max 1 h, ±20 % jitter).
  Anything else (validation, plan limits, …) → `failed`, shown in the sync sheet
  with retry / discard (discard drops the change and re-pulls the server copy).
- **Triggers** (`app/sync/sync_coordinator.dart`): sign-in / app open, app
  resumed or paused, network back (`connectivity_plus`), language change
  (catalog), every local edit (debounced 2 s), a finished workout, pull-to-refresh
  (History, Train) and **periodic background work** (`workmanager`, every 30 min
  with network, Android).
- **Background isolate never refreshes tokens**: refresh tokens rotate, so two
  isolates refreshing at once would trip `REFRESH_TOKEN_REUSED` and revoke the
  session. With an expired access token the background run just skips; the app
  syncs on resume/pause.
- **Exercise catalog:** pull only returns custom exercises; the global catalog is
  downloaded from `GET /exercises` (all pages) when missing, older than 24 h or
  in another UI language. Removed exercises are hidden, not deleted (old workouts
  still show their names).
- **Indicator:** `SyncStatusButton` in every tab's app bar — synced, pending (n),
  syncing, offline, error — opening the sync sheet.
- Logout counts unsynced changes through `UnsyncedChanges` (the queue registers
  there) before wiping local data.

### iOS background sync (pending, needs a Mac)

Android needs no setup. On iOS `WorkmanagerBackgroundSync` is skipped until:
add `BGTaskSchedulerPermittedIdentifiers` (`saiyagym.sync`) and
`UIBackgroundModes` (`fetch`, `processing`) to `Info.plist`, register the task in
`AppDelegate.swift` (see the `workmanager_apple` docs) and remove the platform
check in `background_sync.dart`.

## Live workout

`features/live_workout`: the session lives in the `workouts` table
(`finishedAt: null`) and every edit is written immediately (chained writes);
UI-only state (targets, rest timer) is stored in `app_meta` (`live.meta`), never
inside the synced document. On app open a running session is offered to resume.

- Starting points: today's program day (`TodayPlanService`: API, or computed
  locally with `program_schedule.dart` when offline), any routine, or empty.
- Pure logic, unit-tested: `workout_editing.dart` (prefill, supersets, finish
  keeps completed sets), `plate_calculator.dart`,
  `records/domain/personal_records.dart` (port of the API's PR calculation —
  keep both in sync) and `program_schedule.dart` (port of the API's calendar).
- Rest timer: end time persisted + a local notification scheduled at that time
  (`RestAlarm`); haptics in foreground. Device services (`RestAlarm`,
  `ScreenAwake`, `Haptics`) are interfaces with fakes for tests.
- PRs are detected locally on finish and confirmed after sync via
  `GET /exercises/:id/records`.

Android needs core library desugaring and the notification receivers (already
in `build.gradle.kts` / `AndroidManifest.xml`); exact alarms use
`SCHEDULE_EXACT_ALARM` (asked at session start, inexact fallback).

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
