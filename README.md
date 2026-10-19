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
| Format | `dart format lib test tool` |
| Tests | `flutter test` · one file: `flutter test test/core/units/unit_formatter_test.dart` · by name: `flutter test --plain-name "single-flight"` |
| Translations check | `dart run tool/check_i18n.dart` (same keys in every language, every key used in `lib/` exists; also a test) |
| Icon + splash | `dart run tool/generate_branding.dart` → `dart run flutter_launcher_icons` → `dart run flutter_native_splash:create` |

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

## Progress, measurements, photos and reminders

- **Stats** (`features/progress`): `/stats/exercise/:id`, `/stats/muscle-volume`
  and `/stats/powerlifting-total` with the device timezone (`tz`, from
  `localTimezoneProvider`). Every answer is kept in `app_meta` (`JsonCache`):
  when the API can't be reached the last one is shown with its date. The plan
  window (Free: 90 days) is applied by the API. Charts: `fl_chart`.
- **Body weight chart and personal records** are computed from local data
  (offline, includes unsynced entries); records reuse the PR port.
- **Body measurements**: quick weigh-in sheet + full form (offline, synced
  collection `body_metrics`), validated with the API's ranges (`BodyMeasure`).
- **Progress photos** (Premium, `features/progress_photos`): camera/gallery
  (`image_picker`) → framing guide → JPEG compression without EXIF
  (`flutter_image_compress`) → `PhotoUploadQueue` (file in app documents +
  entry in `app_meta`, registered in `UnsyncedChanges`). Each upload asks for a
  fresh `POST /media/upload-signature` (1 h TTL), posts the file to Cloudinary
  with a plain `Dio` (no JWT) and registers it with `POST /progress-photos`.
  Before/after comparison: `GET /progress-photos/compare`. iOS usage strings
  (`NSCameraUsageDescription`, `NSPhotoLibraryUsageDescription`) are in
  `Info.plist`.
- **Reminders** (`features/reminders`): weekly local notifications
  (`zonedSchedule` + `DateTimeComponents.dayOfWeekAndTime`, inexact) for
  training days/time and the weigh-in. Settings are per device (`app_meta`).
  The notification permission is asked only when a reminder is turned on (or
  the weekly weigh-in is accepted right after a weigh-in).

## Nutrition

`features/nutrition` (Today → Nutrition): calculator · meals · guides · foods,
under an always-visible "orientative, consult a professional" notice.

- **Calculator** runs on the device: `domain/nutrition_calculator.dart` is a
  port of the API's `nutrition-calculator.ts` (Mifflin-St Jeor × activity,
  macros per goal) — change both together; the tests mirror the API spec.
  Prefilled from the profile (sex, birth date, height) and the latest
  weigh-in; goal and activity are remembered on the device.
- **Meals, guides, foods**: the whole (small, localized) base is downloaded and
  cached in `app_meta` per language; filtering and the accent-insensitive food
  search run locally, so it all works offline with the "data from …" date.
  Free gets the API's sample of meals plus an `UpgradeCta` (`limitedByPlan`,
  `lockedCount`); the API decides what each plan sees.

## UX polish

- States: local lists go through `AsyncBody` (spinner → error + retry →
  content, no empty-state flash); API data through `CachedView` (+ offline
  date).
- Haptics: `confirmHaptic()` on key actions (save weight/measurements/routine,
  favorite, photo queued, reminder on); sets and rest use the live-workout
  `Haptics`.
- Accessibility: system text size respected up to 2× (`AppTheme.maxTextScale`);
  charts and photos have spoken labels; `test/accessibility_test.dart` runs
  Flutter's tap-target, label and contrast guidelines on the main screens in
  light and dark.

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

## Icon and splash

`assets/branding/` holds the source PNGs (a brand-teal dumbbell drawn by
`tool/generate_branding.dart`, a placeholder until there is a designed logo).
To change them, replace the PNGs (1024 px icon, 1024 px adaptive foreground
inside the 66 % safe zone, splash mark) and run:

```bash
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

Config lives in `pubspec.yaml`. Known bug of `flutter_launcher_icons`: it may
set `ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS = AppIcon` in
`ios/Runner.xcodeproj/project.pbxproj`; put it back to `YES`.

## Release builds

**Versioning**: `version: X.Y.Z+N` in `pubspec.yaml`. `X.Y.Z` is the store
version (bump it by hand, semver); CI sets the build number `N` from the run
number, so every upload is higher. A release is a git tag `vX.Y.Z` that must
match `pubspec.yaml`.

**Production API URL**: `--dart-define=API_BASE_URL=https://…/api/v1` (CI: the
`API_BASE_URL` repository variable). Tag builds fail without it.

### Android

1. Create the upload keystore once (keep it and its passwords safe — Play
   needs the same key for every update):
   `keytool -genkey -v -keystore android/app/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload`
2. Copy `android/key.properties.example` to `android/key.properties`
   (git-ignored, like `*.jks`) and fill it in.
3. Build:

```bash
flutter build appbundle --release --flavor prod \
  --dart-define=API_BASE_URL=https://<render-service>.onrender.com/api/v1 \
  --obfuscate --split-debug-info=build/symbols
```

Without a keystore the release is signed with the **debug** key (Gradle warns):
fine for `flutter run --release`, never for the store. Keep `build/symbols` of
each release to symbolize crash stack traces.

### iOS (on a Mac)

1. Xcode → Runner → Signing & Capabilities: your **Team**, bundle id
   `com.saiyagym.app` (register it in App Store Connect).
2. Optional native flavors: see [iOS flavors](#ios-flavors) (until then
   `--dart-define=FLAVOR=prod`).
3. `flutter build ipa --release --dart-define=FLAVOR=prod --dart-define=API_BASE_URL=… --obfuscate --split-debug-info=build/symbols`
   and upload with Transporter / Xcode Organizer.

Before the first upload: privacy texts in `Info.plist` (camera, photo library)
are set; fill App Store privacy details (account data, photos, health-adjacent
fitness data) and the Play data-safety form accordingly.

### CI (GitHub Actions)

`.github/workflows/ci.yml`:

- **checks** (every push / PR): generated code up to date, `dart format`,
  `flutter analyze`, translations check, `flutter test`.
- **android** (main and `v*` tags): signed APK + AAB (prod, obfuscated) as
  artifacts. Secrets: `ANDROID_KEYSTORE_BASE64` (`base64 -w0 upload-keystore.jks`),
  `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS`, `ANDROID_KEY_PASSWORD`;
  variable `API_BASE_URL`. Tags fail without them.
- **ios** (main and tags): `flutter build ios --no-codesign` on macOS — proves it
  compiles; signing/upload needs the Apple certificates (manual or fastlane).

## In-app purchases with RevenueCat (future)

Today an admin assigns plans (`user.subscription.provider = 'manual'`) and the
upgrade sheet says so. The model is already shaped for stores: **access always
comes from `GET /users/me` → `plan.entitlements`**, resolved by the API from
`user.subscription { planId, status, currentPeriodEnd, provider }`. Adding
RevenueCat changes how the subscription gets there, not how the app reads it.

1. **Stores + RevenueCat**: create the subscription products in App Store
   Connect and Google Play, add them to a RevenueCat project and group them
   in an *entitlement* whose identifier equals the plan's `code` (`premium`).
   Map by plan **code**, never by plan id (ids differ per environment).
2. **API** (`saiyagym-backend`): implement `RevenueCatPaymentProvider`
   (`src/modules/billing/payment-provider.interface.ts`, `id: 'revenuecat'`):
   a webhook endpoint that verifies the authorization header, is idempotent
   (store processed event ids) and turns `INITIAL_PURCHASE`, `RENEWAL`,
   `CANCELLATION`, `EXPIRATION`, … into `user.subscription` with
   `provider: 'revenuecat'`. Entitlements, guards and limits don't change.
3. **App**:
   - Add `purchases_flutter`; after sign-in `Purchases.configure(...)` with the
     platform's public SDK key and `appUserID = user.id` (so webhooks name our
     user); `Purchases.logOut()` on logout.
   - Put it behind an interface in `features/plans` (e.g. `BillingService`:
     `offers()`, `purchase(offer)`, `restore()`, `manageUrl()`) with a fake for
     tests, like the device services.
   - `UpgradeSheet`: show the offers and a "restore purchases" button
     (required by Apple) instead of the "an admin assigns plans" text.
   - After a purchase **don't unlock from `CustomerInfo`**: call
     `refreshUser()` until `/users/me` reports the new plan (the webhook may
     take a few seconds) — `entitlementsProvider` and every `PlanGate` /
     `UpgradeCta` update by themselves.
   - Manage/cancel: link to the store's subscription page.
4. **Rules**: digital subscriptions sold in the app must use the stores'
   billing (no links to web payments in the iOS app). Web keeps Stripe; a user
   subscribed on one platform is Premium everywhere because the API decides.
5. **Test** with sandbox / license-tester accounts and RevenueCat's webhook
   test events before going live.
