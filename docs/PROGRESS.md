# Progress — gymapp-mobile

## 2026-10-18 — Auth completo, onboarding, perfil y planes

### Hecho
- **Pantallas de auth:** bienvenida (selector de idioma, CTA siempre visibles), login (link a recuperar contraseña), registro y "olvidé mi contraseña" (`POST /auth/password/forgot`; el reset se completa desde el link, que abre la web). Atrás del sistema = flecha atrás en todas.
- **Email sin verificar:** banner en el shell con "Reenviar" (`POST /auth/verify-email/resend`; `EMAIL_ALREADY_VERIFIED` → refresca) y "Ya lo confirmé" (re-fetch de `/users/me`); se puede ocultar por sesión de la app.
- **Sesión persistente / offline:** `SessionController` expone `Session(user, isOffline)`. Sin red al abrir, entra con el último usuario guardado en Drift y muestra un banner con "Reintentar".
- **Datos locales:** logout borra TODAS las tablas (`AppDatabase.wipe`) tras confirmar; si `UnsyncedChanges.count() > 0` el diálogo avisa que se pierden. Sesión expirada → solo se borran los tokens (los datos sobreviven al re-login del mismo usuario); si entra **otro** usuario, se borra todo antes.
- **Onboarding (5 pasos):** idioma + unidades, datos físicos (fecha de nacimiento, sexo, altura, peso — opcionales, en las unidades elegidas), nivel, objetivo, descanso por defecto. Guarda perfil + preferencias en un solo `PATCH /users/me` y el peso en `POST /body-metrics` (UUID de cliente; si falla no bloquea). El router obliga a completarlo mientras falten `level`/`goal`.
- **Perfil:** resumen de datos + "Editar perfil" (nombre, nacimiento, sexo, altura, nivel, objetivo), preferencias (unidades, tema, idioma, descanso) y cierre de sesión.
- **Planes:** `entitlementsProvider` (desde `/users/me`), `UpgradeCta` (feature / límite / desde un error `PLAN_FEATURE_REQUIRED` · `PLAN_LIMIT_REACHED` vía `UpgradeReason.fromError`), `PlanGate`, hoja de planes (`GET /plans`) e interfaz `PaymentProvider` (manual: lo asigna el admin). Uso real en Progreso (ventana de 90 días de Free) y Perfil.
- **Servidor dormido:** `SlowRequestMonitor` + interceptor; si una request tarda > 3 s aparece "Despertando el servidor…" arriba de toda la app hasta que termine.
- Helper `submissionOf()` para el patrón loading/error de formularios.

### Verificación
- `flutter analyze` ✅ sin issues.
- `flutter test` ✅ 68/68 (estable en corridas repetidas). Nuevos: entitlements (mapeo, desconocidos, `UpgradeReason`), monitor de requests lentas (rápida, lenta, error, varias), repositorio de auth (offline marcado, 401 conserva datos, otro usuario borra, logout borra), repositorio de perfil (PATCH parcial, fecha `YYYY-MM-DD`, UUID del peso), caso de uso de onboarding, guard (bienvenida/onboarding), widget: bienvenida, onboarding completo en imperial, validación de rango, banners offline/email, diálogo de logout, `UpgradeCta`/`PlanGate`/hoja de planes, olvidé contraseña, banner de servidor.
- **No ejecutado**: la app en emulador ni contra la API real.

### Decisiones y gotchas
- La API no tiene flag de onboarding: "pendiente" = `level` o `goal` nulos.
- `OnboardingDraft` observa solo el **id** del usuario: se reinicia si cambia la cuenta (o termina de cargar la sesión) pero no pisa respuestas por actualizaciones del mismo usuario. Con `ref.read` puro el draft quedaba vacío si se construía antes de que cargara la sesión (lo detectó un test).
- La bienvenida no entraba en un teléfono de 360×780: los botones quedaban bajo el fold. Ahora van fijos abajo. Los widget tests corren en tamaño teléfono (antes 800×600 apaisado ocultaba esto).
- Tests: un `ProviderScope` montado ignora overrides nuevos → `pumpLocalized` le da un `UniqueKey` por pump. `ensureVisible` necesita un `pump` antes del `tap`.
- En Riverpod 3, `.select` sobre un provider viene de `flutter_riverpod`; un archivo que solo importa `riverpod_annotation` no lo ve.
- Strings con recurso variable: "Sin límite de {resource}" en vez de "{resource} ilimitados" (género).
- `UnsyncedChanges` hoy suma 0: todavía no hay outbox de sync. Cada feature offline debe registrar su contador.

### Pendiente / próximo
- URL de producción real (Render) en `lib/core/config/app_config.dart`.
- Schemes de iOS para `--flavor` (en Mac) y prueba en simulador/dispositivo.
- Deep links (abrir verify/reset en la app en vez de la web).
- Sincronización offline (outbox en Drift + `/sync/push`/`/sync/pull`) registrando su contador en `UnsyncedChanges`, y registro de sesiones en vivo.

## 2026-10-18 — Base de la app (arquitectura, auth, navegación)

### Hecho
- Proyecto Flutter **3.47.7 / Dart 3.13.5** (Android + iOS), paquete `saiyagym_mobile`, app id `com.saiyagym.app`.
- Dependencias en su última versión compatible (verificadas en pub.dev): flutter_riverpod 3.4.3 + riverpod_generator 4.0.9, go_router 18.1.0, dio 5.11.1, freezed 4.0.3 + json_serializable 6.14.1, drift 2.35.2 + drift_flutter 0.3.1, flutter_secure_storage 11.2.0, easy_localization 3.0.8, very_good_analysis 11.0.0, mocktail 1.0.5.
- Arquitectura por features (`domain` / `data` / `presentation` + composition root por feature); `core/` sin dependencias a features (la expiración de sesión se publica con `SessionEvents`).
- **Red (Dio):** base URL por flavor, `Accept-Language` con el idioma de la UI, Bearer, refresh **single-flight** en 401 con reintento de las requests encoladas, mapeo de errores a `ApiException(code, message, statusCode, details)`. Refresh rechazado → fin de sesión; API inalcanzable → la sesión sigue (offline ≠ logout).
- **Auth:** login, registro (envía el idioma de la UI), restaurar sesión al arrancar (tokens + `GET /users/me`, con fallback al usuario cacheado en Drift si no hay red), logout (revoca el refresh token si hay red; siempre limpia lo local).
- **Router:** go_router con guard puro `authRedirect()` (splash / login / tabs) y `StatefulShellRoute` con 5 tabs: Hoy, Entrenar, Historial, Progreso, Perfil (las 4 primeras son placeholders).
- **Perfil:** unidades (kg/lb), tema (sistema/claro/oscuro) e idioma, persistidos con `PATCH /users/me`; el idioma de la cuenta se aplica al iniciar sesión.
- **Drift:** `AppDatabase` v1 (tabla `app_meta` clave/valor), schema exportado en `drift_schemas/` con `make-migrations`.
- **i18n:** `assets/i18n/{es,en}.json` (es por defecto), lista única `AppLocales.languages`; ningún texto fijo en widgets.
- **Flavors:** dev/prod nativos en Android (`.dev` suffix, nombre por flavor, HTTP plano solo en dev); en iOS por `--dart-define=FLAVOR`.
- **Tema M3** claro/oscuro desde el seed `#00C9B7`, fuente Outfit embebida (OFL), botones de 56 dp y texto grande. De `plantilla-app/` se tomó solo la identidad visual (paleta, fuente, estilo de inputs/cards), no su código (GetX/screenutil/sqflite).
- **Unidades:** `UnitFormatter` (kg↔lb, cm↔in, separador decimal según locale); se persiste siempre kg/cm.
- README con cómo arrancar, arquitectura y convenciones.

### Verificación
- `flutter analyze` ✅ (very_good_analysis, sin issues).
- `flutter test` ✅ 33/33, estables en corridas repetidas:
  - unit: `UnitFormatter`, `ApiException.fromDio`, cadena real de interceptores con adapters fake (3 401 concurrentes → 1 solo refresh; refresh rechazado → limpia tokens y expira 1 vez; refresh inalcanzable → conserva sesión; endpoints públicos no refrescan), `AppDatabase` en memoria, `AuthRepositoryImpl` (online, offline con caché, 401, logout offline), `authRedirect`, `AppConfig`.
  - widget: shell con 5 tabs y cambio de tab, redirección a login sin sesión, validación del login y error traducido sin red.
- **No ejecutado**: la app en emulador/dispositivo ni contra la API real; build de iOS (requiere Mac).

### Decisiones y gotchas
- `build_runner` queda en 2.16.2: 2.17.1 choca con una restricción transitiva de los generadores.
- `sqlite3_flutter_libs` está EOL: drift_flutter + sqlite3 3.x traen SQLite nativo vía build hooks (los tests de Drift corren en la VM sin instalar nada).
- `riverpod_lint` 3 es un `analysis_server_plugin`: se configura en `analysis_options.yaml` (`plugins: riverpod_lint: 3.1.9`), no es dev dependency.
- Se desactivó `unnecessary_type_name_in_constructor`: la sintaxis `const new(...)` de Dart 3.13 aún no la entienden freezed/riverpod/json_serializable; se mantiene el estilo clásico. Sí se usan parámetros nombrados privados (`required this._x`).
- Dio 5.11 agregó `DioExceptionType.transformTimeout` (lo detectó el switch exhaustivo).
- Tests de widget con easy_localization: el loader por defecto hace IO async real con `rootBundle` y compite con el reloj fake (pasa el primer test de cada archivo, fallan los siguientes). Se usa un loader de test que lee los mismos JSON con IO síncrono. **No** usar `SynchronousFuture` ahí: easy_localization lo pasa por `Future.wait`, que completa con lista vacía.
- Timeouts de Dio: 15 s connect / 60 s receive por el cold start del plan free de Render.
- `/auth/logout` es `@Public()` en la API: se llama sin Bearer.

### Pendiente / próximo
- URL de producción real (Render) en `lib/core/config/app_config.dart` (hoy placeholder `CHANGE-ME`).
- Schemes de iOS para `--flavor` (en Mac) y prueba en simulador/dispositivo.
- ~~Recuperar contraseña y verificación de email en la UI.~~ Hecho (ver arriba).
- Sincronización offline (`/sync/push`, `/sync/pull`, outbox en Drift) y registro de sesiones en vivo.
- ~~Al cerrar sesión, borrar también las tablas sincronizadas del usuario.~~ Hecho: `AppDatabase.wipe` cubre todas las tablas.
