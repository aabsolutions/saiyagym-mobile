# Progress — gymapp-mobile

## 2026-10-24 — Biblioteca e instrucciones de ejecución

### Hecho
- **Navegación**: Hoy · Entrenar · **Biblioteca** · Progreso · Perfil. Biblioteca tiene pestañas primarias Ejercicios | Nutrición y cada sección conserva sus pestañas secundarias (`TabBar.secondary`): Lista | Tier list y Calculadora · Comidas · Guías · Alimentos. El atajo de Nutrición en Hoy abre `/library?section=nutrition`.
- **Historial** pasa a Progreso (`/progress/history/...`), como primera tarjeta.
- `ExercisesPage`/`NutritionPage` → `ExercisesView`/`NutritionView` (sin AppBar propio; el de la Biblioteca manda).
- **Detalle de ejercicio**: sección "Cómo hacerlo" con la descripción y los pasos numerados, debajo de la guía. `Exercise.description`/`instructions` + `steps` (un paso por línea, sin numeración escrita a mano).
- **Catálogo offline con textos**: la descarga pide `withText=true`; `catalog.version` en `app_meta` hace que una copia de la versión anterior (sin textos) se baje de nuevo al momento, sin esperar 24 h.

### Verificación
- `dart analyze` ✅ · `check_i18n` ✅ · `flutter test` 299/299 ✅ (nuevos: textos y versión del catálogo; Biblioteca → detalle con pasos → Nutrición; tests de navegación actualizados).

### Decisiones y gotchas
- Pestañas primarias + secundarias en vez de 6 destinos abajo (Material: máximo 5).
- El `TabBarView` de la Biblioteca no se desliza (`NeverScrollableScrollPhysics`): el gesto es de las pestañas internas.
- Un test de navegación que no encuentra la pestaña puede quedar colgado 10 min: correr la suite con `timeout`.

## 2026-10-23 — Guías de ejecución de ejercicios

### Hecho
- **Feature `guides`** (`domain` puro · `data` · `presentation` + `guides_providers.dart`):
  - `GuidesApi`: `GET /guides` cacheado por idioma en `app_meta` (`JsonCache`, los textos vienen localizados) y `POST /guides/resolve` (solo online).
  - `GuidesController` (keep-alive): arranca con la última respuesta guardada (offline) y `refresh()` se llama después de cada sync que llegó a la API (`SyncCoordinator`, `lastSyncedAt`), porque los desbloqueos dependen de las rutinas que tiene el servidor. Las llamadas se agrupan (una en curso + a lo sumo una más). En cada refresh: purga (si un logout borró la marca) → `retain` de lo desbloqueado → descarga previa de las guías de los ejercicios de las rutinas activas (Premium no baja el catálogo entero).
  - `GuideFiles`: copias en `exercise_guides/<guideId>.<ext>` bajadas con el cliente sin JWT; una sola descarga por archivo aunque la pidan dos widgets; `.part` hasta completar; marca `guides.files` en `app_meta` para reconocer archivos huérfanos tras un logout (una sesión expirada los conserva).
  - Sesión sin rutina (`routineId == null`): `sessionGuidesProvider` pide `resolve` con los ejercicios en el orden de la sesión y lo suma a lo guardado; sin red usa solo lo guardado.
- **UI**:
  - Catálogo: "Con guía" en el subtítulo de la lista; en el detalle, sección "Guía de ejecución" con carrusel (GIF animado nativo, puntos, texto) o la tarjeta de bloqueo con "Ver planes".
  - Sesión en vivo: botón en la tarjeta del ejercicio (▶ o candado), que abre la hoja con la guía: 1 toque.
  - Hoja de planes: "Guías de ejecución de N ejercicios por rutina" / "de todos los ejercicios" (`entitlements.guidesPerRoutine`, solo para mostrar).
- `RoutinesRepository.active()` (lectura única, sin `watch().first`).
- i18n es/en: `guides.*`, `plans.sheet.guidesAll` / `guidesPerRoutine`.

### Verificación
- `dart analyze` ✅ · `dart run tool/check_i18n.dart` ✅ · `flutter test` ✅ (nuevos: dominio, API + archivos, controller, widgets de guía y 2 casos en `live_workout_flow_test`).
- **No ejecutado**: build ni dispositivo real (la animación de un GIF real y la descarga desde Cloudinary quedan por probar a mano).

### Decisiones y gotchas
- **Deadlock encontrado por los tests**: `future.whenComplete(() => _inFlight.remove(key))` devuelve el future removido (que es el mismo), y `whenComplete` se queda esperándose a sí mismo para siempre. Ahora se limpia en un `finally` con `removeWhere`.
- La clave de los providers por archivo es un record `({id, url})` (igualdad por valor) en vez de `==` a mano: el dominio es Dart puro y no usa `meta`/`@immutable`.
- El dispositivo nunca calcula desbloqueos: muestra lo que manda la API. `merge` de la respuesta de `resolve` solo puede SUMAR desbloqueos.
- Lo que deja de estar desbloqueado se borra en el siguiente refresh (cambio del admin o de plan). Lo bajado antes de un downgrade no se puede revocar del todo porque las URLs son públicas; es un compromiso aceptado.

## 2026-10-22 — Sonidos en recordatorios y limpieza de sonidos (cambio `reminder-sounds-cleanup`)

### Hecho
- **Sonido propio para recordatorios de entreno y de pesaje** (Ajustes → Recordatorios): una fila "Sonido" bajo cada recordatorio activo, con el mismo selector que el descanso (`SoundSelector(purpose)`); cada propósito edita solo su preferencia (`trainingReminderSoundId` / `weighInSoundId`).
- **Canales por sonido en Android**: `reminder_training_<assetKey>` / `reminder_weighin_<assetKey>` (`UriAndroidNotificationSound`). Cae al canal `reminders` si no hay sonido, ya no está instalado, falla la creación del canal o Android < 10. iOS: `DarwinNotificationDetails(sound: iosFileName)`. Tras cada aplicación se borran los canales huérfanos por prefijo.
- **Reaplicar sin `BuildContext`**: al guardar se cachean los textos (`app_meta` `reminders.texts`); `RemindersController.reapply()` (serializado) los reutiliza. Disparadores: guardar ajustes, cambio de sonido (tras la descarga) y arranque (el primer valor de los sonidos efectivos se compara contra "nada aplicado" ⇒ cubre un downgrade con la app cerrada). Sin textos cacheados solo se podan canales.
- Al iniciar sesión: se sueltan los sonidos que ningún propósito usa y se descargan (best effort) los de los recordatorios (dispositivo nuevo).
- `usableSound` pasó a `sounds/data` (lo comparten descanso y recordatorios).

### Decisiones y gotchas
- El disparador por cambio de sonido vive en `SyncCoordinator` (siempre observado), no en un `ref.listen` dentro de `RemindersController`: Riverpod 3 pausa los listeners de un provider que nadie escucha (el controller solo se lee) y el reapply no se disparaba.
- Los recordatorios siguen siendo locales al dispositivo; una sesión expirada los conserva.

## 2026-10-19 — Nutrición, pulido y preparación de release

### Hecho
- **Nutrición** (Hoy → Nutrición): calculadora · comidas · guías · alimentos, con el **aviso "orientativo, consulta con un profesional" siempre visible** encima de las pestañas.
  - **Calculadora en el dispositivo**: port de `nutrition-calculator.ts` de la API (Mifflin-St Jeor × actividad, macros por objetivo, nunca por debajo del metabolismo basal); tests espejo del spec del backend. Prellenada con el perfil (sexo, edad, altura) y el último pesaje; objetivo y actividad se recuerdan. Validación con los límites de la API (18–100 años, 120–230 cm, 35–250 kg) en las unidades del usuario.
  - **Comidas por objetivo y tipo**: Free ve la muestra de la API + "N sugerencias más con Premium" + `UpgradeCta`; la API decide (`limitedByPlan`, `lockedCount`).
  - **Guías** por objetivo y **buscador de alimentos** (sin tildes, por categoría, macros por 100 g).
  - **Caché local**: la base completa (≈80 alimentos, 30 comidas, 10 guías) se descarga y se guarda por idioma; sin red se ve la última copia con su fecha.
- **Pulido**
  - Estados: `AsyncBody` (carga → error + reintentar → contenido, sin parpadeo del estado vacío) en historial, entrenar, ejercicios, récords y medidas; `CachedView` (con fecha offline) compartido por progreso y nutrición.
  - Haptics en acciones clave (guardar peso/medidas/rutina, favorito, foto en cola, recordatorio activado), siempre sin bloquear la UI.
  - Accesibilidad: tamaño de texto del sistema respetado hasta 2×; gráficas con descripción hablada (resumen en lugar del lienzo); fotos con etiqueta; guía de encuadre excluida del lector.
  - **Script de i18n** `tool/check_i18n.dart`: mismas claves en es/en, mismos placeholders, y toda clave usada en `lib/` existe (literal o prefijo de las interpoladas). También corre como test.
- **Ícono y splash**: ícono propio (mancuerna blanca sobre el teal de marca, generado por `tool/generate_branding.dart`), ícono adaptativo de Android, splash nativo (Android 12+ incluido) con `flutter_launcher_icons` y `flutter_native_splash`.
- **Release**: firma de Android por `android/key.properties` (ignorado; hay `.example`) o variables `ANDROID_KEYSTORE_*` en CI, con fallback a la clave debug avisado por Gradle; versionado (`X.Y.Z` a mano, build number de CI, tag `vX.Y.Z` = pubspec); pasos de iOS (team, bundle id, `flutter build ipa`, privacidad).
- **GitHub Actions** (`.github/workflows/ci.yml`): código generado al día, formato, analyze, i18n, tests; APK + AAB prod ofuscados como artefactos (main y tags); compilación iOS sin firma en macOS.
- **README**: nutrición, pulido, ícono/splash, release, CI y **cómo integrar RevenueCat** sin cambiar el modelo de entitlements.

### Verificación
- `flutter analyze` ✅ · `dart format --set-exit-if-changed` ✅ · `dart run tool/check_i18n.dart` ✅.
- `flutter test` ✅ 217/217, estable en 3 corridas. Nuevos: calculadora (espejo del spec de la API), script de i18n (detecta faltantes, sobrantes, placeholders y claves desconocidas), pantallas de nutrición (prellenado + validación, muestra Free + CTA, copia offline con fecha + búsqueda sin tildes, error sin copia), **guías de accesibilidad de Flutter** (tap targets Android/iOS, etiquetas, contraste) en las 5 pestañas + nutrición, en claro y oscuro.
- **No ejecutado**: `flutter build` (regla del proyecto: no compilar localmente; lo hace CI), el workflow en GitHub (no hay remote), dispositivo real.

### Decisiones y gotchas
- **Calculadora local en vez de `POST /nutrition/calculator`**: funciona sin red y responde al instante; misma fórmula que la API (port + tests espejo, como los récords).
- La base de nutrición es chica: se baja entera y se filtra en el dispositivo (búsqueda sin tildes reutilizando `core/text/search.dart`, extraído de ejercicios).
- **Haptics nunca con `await`**: el canal de plataforma puede tardar (o no responder en tests) y la hoja no se cerraba — lo detectó un test.
- `flutter_launcher_icons` cambia `ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS` a `AppIcon` en el pbxproj (bug conocido): revertido a `YES`; anotado en el README.
- No se reutilizó el logo de `plantilla-app` (es otra marca); el ícono actual es provisional hasta tener un logo diseñado.
- La TabBar de nutrición es desplazable: con texto grande las 4 pestañas no entran en 360 px.

### Pendiente / próximo
- **URL real de la API** (Render) como variable `API_BASE_URL` del repo / `--dart-define`.
- Crear el keystore de subida y cargar los secretos en GitHub; subir el repo a GitHub para que corra CI.
- iOS en un Mac: team y firma, schemes de flavors, `flutter build ipa`, prueba en dispositivo.
- ~~Logo diseñado~~ Hecho: ícono y colores desde `../icono-app` (`tool/sync_branding.dart`; azul = primario, amarillo = acento).
- `default-flavor: dev` en el pubspec **después** de crear los schemes de iOS (hoy rompería el build de iOS e inyectaría appFlavor=dev).
- Plugins que aún aplican Kotlin Gradle Plugin (`flutter_image_compress_common`, `workmanager_android`): revisar versiones nuevas antes de actualizar Flutter.
- Probar en dispositivo: cámara, Cloudinary, notificaciones, haptics, lector de pantalla.
- Compras in-app (RevenueCat) cuando haya pasarela: seguir la guía del README.

## 2026-10-19 — Progreso, medidas, fotos y recordatorios

### Hecho
- **Progreso** (`fl_chart`): evolución por ejercicio (peso máximo / 1RM estimado, selector con los ejercicios entrenados), volumen semanal por músculo (series o volumen, últimas 12 semanas), total de powerlifting (1RM estimado o peso máximo, mejor total y última marca por levantamiento) y peso corporal. Datos de `/stats/*` con el `tz` del dispositivo; **caché local** en `app_meta`: sin red (o con la API dormida) se muestra la última versión con "Sin conexión · datos del …". Free: aviso de la ventana de 90 días + `UpgradeCta` (la API aplica la ventana).
- **Récords personales** por ejercicio (peso máximo, 1RM estimado, volumen por sesión y reps por peso), calculados en local con el port de la API.
- **Medidas corporales**: registro rápido de peso (hoja con el último peso como pista) y formulario completo (fecha, peso, % graso, 7 perímetros, notas) con los rangos de la API; lista con editar/borrar. Offline (colección sincronizada).
- **Fotos de progreso (Premium)**: vistas frontal/lateral/espalda; guía de encuadre (silueta + línea central, consejos antes de abrir la cámara y superpuesta en la vista previa); cámara o galería; compresión a JPEG ≤ 1280 px sin EXIF; **cola de subida** offline (archivo local + entrada en `app_meta`, cuenta en `UnsyncedChanges` → el logout avisa); firma pedida en el momento de subir, subida directa a Cloudinary y registro en la API; fallos permanentes con reintentar/descartar; borrar con pulsación larga; **comparador antes/después** con deslizador.
- **Recordatorios locales**: entreno por días + hora y pesaje semanal (día + hora), en Perfil → Recordatorios. Notificaciones semanales en la zona horaria del dispositivo. **Permiso en el momento oportuno**: solo al activar un recordatorio, o al aceptar el recordatorio de pesaje que se ofrece (una vez) justo después de pesarse.

### Verificación
- `flutter analyze` ✅ sin issues.
- `flutter test` ✅ 199/199, estable en 2 corridas. Nuevos: caché de stats (tz, fallback offline con fecha, sin copia → error, métricas separadas), modelo de volumen por músculo, récords por ejercicio, `nextWeekly` (incluye el cambio de hora del 25-oct), ids de notificaciones, controlador de recordatorios (permiso solo al activar; denegado = sin cambios), cola de fotos (offline → en cola; firma → Cloudinary SIN JWT → registro; el reintento solo registra si ya subió; rechazo permanente; descartar), coordinador (sube fotos al iniciar sesión y al volver la red; cancela recordatorios solo si el logout borró sus ajustes); widget: stats offline con fecha, pesaje rápido + oferta de recordatorio, validación del formulario, récords, recordatorios con permiso denegado/concedido, fotos Free → CTA Premium, foto offline en cola.
- **No ejecutado**: en dispositivo (cámara, compresión, notificaciones reales) ni contra la API / Cloudinary reales.

### Decisiones y gotchas
- **Peso corporal y récords desde Drift**, no desde `/body-metrics/series` ni la API de récords: funcionan offline e incluyen lo no sincronizado; mismas reglas que la API (port).
- **La firma de Cloudinary dura 1 h**: nunca se guarda; cada subida pide una nueva. Si Cloudinary aceptó pero el registro falló, se guarda el `public_id` y el reintento solo registra (no sube dos veces).
- **Cloudinary con un `Dio` aparte** (`uploadClientProvider`): el JWT nunca sale hacia terceros.
- Recordatorios: `inexactAllowWhileIdle` (sin permiso de alarma exacta; unos minutos tarde da igual). El logout borra sus ajustes → se cancelan las notificaciones; una **sesión expirada** conserva ajustes y recordatorios (por eso no se cancela en cualquier "signed out").
- iOS: `DarwinInitializationSettings` con `request*Permission: false`, para que inicializar no pida permiso.
- Tests: en 360 px un título largo + un toggle no entran en una fila (overflow detectado por test); `scrollUntilVisible` hace settle y las otras pestañas siguen montadas (IndexedStack) → helper propio que arrastra la lista de la página. IO de archivos en widget tests: síncrona.

### Pendiente / próximo
- Probar en dispositivo: cámara/galería, compresión, subida real a Cloudinary, notificaciones (Android 13+ / iOS).
- Los textos de las notificaciones se fijan al guardar: si cambia el idioma, se actualizan al volver a guardar los recordatorios.
- Duplicado posible si el registro de una foto llega al servidor pero se pierde la respuesta (la API no recibe id de cliente).

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

## 2026-10-22 — Sonidos personalizados del descanso (rest-alarm-sounds)

### Hecho
- Feature `sounds/`: catalogo `GET /sounds` (cache `app_meta` por idioma), `SoundCache` (descarga con el cliente Dio plano, sin JWT; un solo sonido instalado; registro en `app_meta` `sounds.installed`), selector en Perfil + hoja con vista previa; los premium se ven bloqueados y tocar uno muestra `UpgradeCta` sin enviar PATCH.
- `PreferencesUpdate.restSoundId` + `resetRestSound` (`null` ya significa "sin cambios"); `PlanFeature.premiumSounds`.
- `RestAlarm.prepare({channelName, sound})`: canal Android `rest_timer_<assetKey>` con `UriAndroidNotificationSound`, borra canales `rest_timer_*` viejos, vuelve al canal `rest_timer` si falta el archivo / uri / offline; iOS usa `DarwinNotificationDetails(sound: <assetKey>.wav)`.
- Nativo: `MainActivity.kt` (MethodChannel `saiyagym/alarm_sound`: install en MediaStore `Notifications/SaiyaGym` API 29+, exists, remove, preview) y `AppDelegate.swift` (preview con AVAudioPlayer).

### Pendiente de verificar en dispositivo (M1, spike)
- Entrega por MediaStore en un Android real y en OEMs (Xiaomi/Samsung); tamano real del wav `af_22050` para iOS; sonido de la notificacion con la app cerrada. Ver checklist en el apply-progress de SDD.
- No se ejecuto build, tests ni analyze en esta tanda.
