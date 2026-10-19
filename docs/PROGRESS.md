# Progress — gymapp-mobile

## 2026-10-19 — Pantallas de uso diario

### Hecho
- **Hoy**: entreno del día del programa con "Empezar" (de la entrega anterior) + tarjeta "Esta semana": **racha semanal**, sesiones y volumen de la semana, y **último récord** (ejercicio, fecha y valor). Calculado en local con las mismas reglas que `/stats/summary` (semanas desde el `firstDayOfWeek` del usuario, fecha local del `startedAt`, la semana actual vacía no corta la racha).
- **Entrenar**: programas (estado; detalle con semanas → días → rutina; **activar/desactivar** con `POST /programs/:id/activate|deactivate`, requiere conexión; `PLAN_LIMIT_REACHED` → `UpgradeCta`), rutinas (tocar = empezar; lápiz = editar) y acceso a Ejercicios. Los programas se editan en la web.
- **Editor de rutinas** simplificado (offline, sincroniza): nombre, añadir ejercicio (catálogo local), reordenar arrastrando, quitar, series objetivo (tipo, reps mín–máx, peso en las unidades del usuario, descanso), añadir/quitar series, borrar rutina. Valida como la API (reps ≥ 1, mín ≤ máx, peso y %1RM excluyentes, descanso 0–1800). **Límite de rutinas del plan** comprobado antes de crear (la API lo vuelve a validar).
- **Ejercicios**: lista con buscador (sin tildes, palabras en cualquier orden) y filtros (músculo, equipo, favoritos, míos), favoritos con un toque; **tier list** S/A/B/C por objetivo (hipertrofia/powerlifting), por músculo y con fuente global o personal (vacío = global, como la API); **detalle** con tiers (y tier personal por objetivo), récords (cálculo local) e historial de series; **crear ejercicio personalizado** (`POST /exercises`, requiere conexión; se guarda en local al instante y el pull lo reemplaza; límite del plan → `UpgradeCta`).
- **Historial**: lista y **calendario** mensual (respeta el primer día de la semana; tocar un día filtra), **detalle de sesión** (totales, valoración, notas, series), **editar** sesiones pasadas (peso/reps/tipo/completada, añadir/quitar series, valoración, notas) y **borrar** con confirmación (borrado lógico → la API recalcula récords).
- Todo lee de Drift: funciona sin conexión salvo crear ejercicio y (des)activar programa, que la API exige por contrato (colecciones solo-pull).

### Verificación
- `flutter analyze` ✅ sin issues.
- `flutter test` ✅ 173/173, estable en 3 corridas. Nuevos: racha semanal y totales (casos borde de la API), último récord, filtros y tier list, edición de rutinas y validación, grilla del calendario, crear ejercicio / activar programa contra API simulada, catálogo vacío no oculta nada; widget: crear rutina offline (+ en cola), límite Free de rutinas, favoritos + filtro + tier list + detalle, historial (calendario, detalle, borrado), Hoy (racha y último récord).
- **No ejecutado**: contra la API real ni en dispositivo.

### Decisiones y gotchas
- **Bug evitado (lo destapó un test):** si `GET /exercises` respondía vacío, la descarga del catálogo ocultaba TODOS los ejercicios globales. Ahora una respuesta vacía nunca oculta nada (regresión cubierta).
- El ejercicio recién creado se guarda con versión 0: el documento crudo del próximo pull lo reemplaza sin conflicto. El programa activado se guarda con la respuesta (`ProgramDto`), así la pantalla no espera al sync.
- Nombres de ejercicio por id en un único `exerciseNamesProvider` (antes repetido en 4 pantallas).
- Tests: el catálogo y los filtros se recorren en Dart (~150 filas; búsqueda sin tildes más simple que en SQL). Chips en filas horizontales fuera de pantalla en 360 px → `ensureVisible` antes de tocar.

### Pendiente / próximo
- Progreso: gráficas por ejercicio, volumen semanal por músculo, total powerlifting (online vía `/stats/*`, con ventana del plan).
- Medidas corporales y fotos (Premium).
- Probar en dispositivo y contra la API real.

## 2026-10-18 — Entrenamiento en vivo

### Hecho
- **Inicio** desde: el día del programa activo (Hoy; online con `GET /programs/active/today?date=<local>` → pesos objetivo con progresión; offline calculado en local con un port de `program-schedule.ts` y los pesos estáticos de la rutina, avisado en la UI), cualquier rutina (Entrenar) o entreno vacío. Una sesión a la vez.
- **Tarjeta por ejercicio**: filas con tipo (badge: número / C / D / F, menú para cambiarlo), "Anterior" (peso × reps de la última vez, de la historia local), peso y reps **prellenados** (objetivo; si no, lo anterior) y check de completado (**1 toque**). Borrar serie deslizando; añadir serie (copia la anterior); notas; sustituir; quitar; superserie con el siguiente (siempre contigua); reordenar (hoja con drag).
- **Teclado numérico propio** (teclas de 56 dp, ±2,5 kg / ±5 lb / ±1 rep, "Sig." peso → reps → siguiente serie); cada tecla persiste.
- **Descanso**: arranca al completar (descanso del objetivo de la rutina, o el del usuario; en superseries solo tras el último ejercicio del grupo), +15 / −15 / Saltar. Se guarda la hora de fin (sobrevive a cierres) y se programa una **notificación local exacta** (`flutter_local_notifications`, `SCHEDULE_EXACT_ALARM` pedido al iniciar sesión; si se niega, inexacta) + vibración háptica en primer plano.
- **Cabecera**: cronómetro de sesión y volumen/series acumulados (solo series de trabajo completadas). **Calculadora de discos** (barra y discos configurables en Perfil → Entrenamiento, por unidad: gimnasios en kg o lb).
- **Persistencia instantánea**: cada cambio va a Drift (el workout en `workouts` con `finishedAt: null` + metadatos de UI —objetivos, descanso— en `app_meta`). Escrituras encadenadas en orden. Al abrir la app con una sesión en curso se ofrece **reanudar o descartar**; una barra "Sesión en curso · mm:ss" vuelve a la pantalla.
- **Pantalla encendida** opcional (`wakelock_plus`), por defecto activa.
- **Finalizar**: resumen (duración, volumen, series), valoración 1-5 y notas; se guardan solo las series completadas; encola sync (`FinishWorkoutUseCase`). **PRs** calculados en local con un port exacto de `personal-records.calc.ts` y mostrados con animación de celebración; tras sincronizar se **confirman** con `GET /exercises/:id/records` (dueño del récord = esta sesión). Offline quedan "pendientes de confirmar". No se puede guardar una sesión sin series completadas.
- **Descartar** con confirmación (borrado lógico: si ya se había sincronizado en curso, el borrado también viaja).

### Verificación
- `flutter analyze` ✅ sin issues.
- `flutter test` ✅ 144/144, estable en 3 corridas. Nuevos: PRs (mismos casos que el spec del backend), calendario de programas (mismos casos que el spec del backend), calculadora de discos, edición del workout (prellenado, superseries contiguas, solo lo completado, volumen sin calentamientos), controller (inicio, **sobrevive a un kill** con otra instancia sobre la misma base, descanso caducado, descanso/superserie, finalizar + PRs + cola, descartar, una sesión a la vez) y **flujo de widget**: iniciar rutina → teclado ±2,5 → completar series (descanso + alarma programada) → terminar con valoración → resumen con 3 récords; reanudar al reabrir; descartar con confirmación.
- **No ejecutado**: en dispositivo (notificación real con la app en segundo plano, vibración, wakelock), contra la API real, iOS.

### Decisiones y gotchas
- Los metadatos de la sesión NO van en el JSON del workout: un pull de nuestra propia escritura lo reemplaza y se perderían. Van en `app_meta`.
- El workout en curso se sincroniza (con debounce) como cualquier otro: la web puede verlo en curso y un descarte se propaga.
- Al finalizar se descartan las series prellenadas no marcadas (no se hicieron) y los ejercicios que quedan vacíos.
- Lecturas puntuales con `get()`, nunca `watch().first`: el stream arma y desarma el seguimiento de cambios y, bajo el reloj fake de los widget tests, no terminaba (lo detectó el test de flujo).
- `SyncService.sync()` arranca en un microtask: el resumen lo llama desde `initState` y su primera actualización de estado caía en pleno build. Dos llamadas antes de que la corrida arranque comparten esa corrida (no había leído la cola); una llamada **durante** la corrida agenda exactamente una pasada más.
- `ref` no se puede usar en `dispose()`: el `ScreenAwake` se guarda en `initState`.
- Widget tests de la pantalla en vivo: el cronómetro hace tick cada segundo → `pump` por pasos, nunca `pumpAndSettle`.
- Android: core library desugaring + receivers de `flutter_local_notifications`. No se usa `USE_EXACT_ALARM` (Play lo restringe a apps de alarma/calendario).

### Pendiente / próximo
- Probar en dispositivo: notificación de descanso con la app en segundo plano/cerrada, permisos de Android 13/14, wakelock.
- iOS: verificar notificaciones (en Mac).
- Crear/editar rutinas en el móvil (hoy se crean en la web); ejercicios personalizados.
- Estadísticas y récords en Progreso.

## 2026-10-18 — Offline-first: base local + sincronización

### Hecho
- **Drift v2** (migración versionada v1→v2 con `make-migrations`, schemas en `drift_schemas/`): tablas `exercises`, `user_exercise_prefs`, `routines`, `programs`, `workouts`, `body_metrics` (columnas tipadas para filtrar/ordenar + el documento completo en JSON) y `sync_queue` (operación, colección, id, payload, intentos, estado, error, próximo intento).
- **Repositorios** (ejercicios + prefs, rutinas, programas, workouts, medidas): leen SIEMPRE de local; escriben local + encolan en una sola transacción (`SyncWriter`). Una entrada de cola por documento (la última edición reemplaza el payload y conserva el orden). `FinishWorkoutUseCase` pide sync al terminar.
- **SyncService**: push por lotes de 100 → pull desde el último `serverTime` → catálogo si está vencido. Single-flight (una llamada concurrente agenda una pasada más). Last-write-wins por `updatedAt` (UTC, ms, estrictamente creciente por doc aunque el reloj retroceda); borrado lógico con `deletedAt`. Codecs de push con whitelist por colección (el pull trae campos calculados que el push rechaza). Prefs adoptan el id que devuelve el servidor (clave natural = ejercicio).
- **Errores y reintentos**: sin conexión → offline sin gastar intentos; 5xx/CONFLICT/429 → backoff exponencial (30 s·2ⁿ, tope 1 h, ±20 %); el resto → `failed`, visible en la hoja de sync con "Reintentar" / "Descartar" (descarta y vuelve a bajar la versión del servidor). Re-editar un cambio rechazado le da otra oportunidad.
- **Disparadores** (`SyncCoordinator`): inicio de sesión/apertura, volver a primer plano, pasar a segundo plano, recuperar conexión (`connectivity_plus`; si la sesión abrió offline también refresca el perfil), cambio de idioma, cada edición local (debounce 2 s), workout terminado, pull-to-refresh (Historial, Entrenar) y periódico en segundo plano (`workmanager`, 30 min con red, Android).
- **Catálogo offline**: descarga completa de `GET /exercises` (todas las páginas) si falta, tiene > 24 h o está en otro idioma; los que desaparecen se ocultan (no se borran: el historial necesita sus nombres).
- **Indicador global**: `SyncStatusButton` en el AppBar de todas las tabs (sincronizado / pendiente n / sincronizando / sin conexión / error) + hoja de detalle. Historial y Entrenar listan datos locales.
- Logout cuenta los cambios sin sincronizar a través de `UnsyncedChanges` (la cola se registra ahí).
- Fechas de dominio con converters UTC (`…Z` siempre).

### Verificación
- `flutter analyze` ✅ sin issues.
- `flutter test` ✅ 99/99, estable en 3 corridas. Nuevos: `SyncService` con API simulada (push con whitelist, edición múltiple → un cambio, delete lógico, reloj que retrocede, id de prefs, pull de todas las colecciones + cursor, borrado remoto, adoptar la propia escritura, conflictos local-más-nuevo / servidor-más-nuevo / `ignored_older`, backoff exponencial + tope, offline sin intentos, rechazo permanente + re-edición, reintentar, descartar, single-flight, catálogo paginado + vencimiento + idioma), codecs de push, `SyncCoordinator` (login, logout, conectividad, idioma), migración v1→v2 (esquema + datos de `app_meta`).
- **No ejecutado**: contra la API real, en dispositivo, ni la tarea de `workmanager` real (iOS sin configurar).

### Decisiones y gotchas
- **Background nunca refresca tokens** (`buildApiClient(refreshTokens: false)`): los refresh tokens rotan y dos isolates refrescando a la vez dispararían `REFRESH_TOKEN_REUSED` → sesión revocada. Si el access token venció, la corrida de fondo se saltea; por eso también se sincroniza al pasar a segundo plano.
- Mongo guarda milisegundos: las versiones locales se truncan a ms, si no nuestra propia escritura, al volver en el pull, parecería más vieja que la local.
- `sync_queue` conserva la posición al re-encolar: una rutina creada antes que el workout que la usa llega antes al servidor.
- `riverpod_generator` corre antes que `drift_dev`: un provider no puede exponer tipos generados por Drift (`InvalidTypeException`). La UI usa `FailedChange` (core) en vez de filas de la cola — mejor separación de todos modos.
- `requestSync` nunca sincroniza en el mismo frame (microtask): los disparadores vienen de listeners durante builds y Riverpod prohíbe actualizar estado ahí.
- Tests: Drift cierra streams cancelados con un timer de 0 ms → en widget tests `DatabaseConnection(..., closeStreamsSynchronously: true)`. `pumpLocalized` monta infraestructura falsa (`testInfraOverrides`). En una cascada, `..x = (a) => [...]..y = …` asigna `y` a la lista: paréntesis.
- Entidades de dominio con `fromJson/toJson` (freezed): el formato del sync ES la forma del dominio; lo que se puede enviar lo decide el codec de la capa de sync, no la entidad.

### Pendiente / próximo
- Configurar `workmanager` en iOS (Info.plist + AppDelegate, en Mac).
- Probar contra la API real (Render) y en dispositivo; medir el tamaño del pull completo inicial.
- Registro de sesiones en vivo (≤ 2 toques por serie) usando `WorkoutsRepository` + `FinishWorkoutUseCase`.
- URL de producción real; schemes de iOS.

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
