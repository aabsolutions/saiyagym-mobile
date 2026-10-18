# Progress — gymapp-mobile

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
- Recuperar contraseña y verificación de email en la UI.
- Sincronización offline (`/sync/push`, `/sync/pull`, outbox en Drift) y registro de sesiones en vivo.
- Al cerrar sesión, borrar también las tablas sincronizadas del usuario (cuando existan).
