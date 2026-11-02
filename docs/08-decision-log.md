# Registro de decisiones de arquitectura (ADR Log) — GoatCode

Estados: `PROPOSED`, `APPROVED`, `REJECTED`, `DEFERRED`.

---

### ADR-001 — Gestión de estado de la aplicación
- **Estado:** APPROVED
- **Fecha:** 2026-10-31
- **Contexto:** La app necesita gestionar estado reactivo local: perfil del usuario, cálculo de rachas diarias, progreso de lecciones por módulo, personalización de la cabra y ajustes de accesibilidad (tamaño de fuente, contraste) de forma desacoplada de la UI.
- **Opciones consideradas:**
  1. `flutter_riverpod` (Seguridad en tiempo de compilación, sin `BuildContext`, fácil de testear).
  2. `flutter_bloc` / Cubit (Basado en eventos y streams, algo verborrágico para un MVP offline).
  3. `ChangeNotifier` + `Provider` (Sencillo y ligero, estándar de Flutter).
- **Recomendación:** **`flutter_riverpod`**. Permite modularizar la lógica de negocio por características (feature-first) y realizar pruebas unitarias inmediatas sin montar árboles de widgets.
- **Trade-offs:** Riverpod requiere familiaridad con sus `Ref` y `ConsumerWidget`, pero elimina por completo los problemas de paso de contextos y re-renders innecesarios.
- **Aprobación del usuario:** APROBADO por el usuario el 2026-10-31.

---

### ADR-002 — Estrategia de routing declarativo
- **Estado:** APPROVED
- **Fecha:** 2026-10-31
- **Contexto:** Flutter Web requiere soporte fluido para URLs legibles (`/dashboard`, `/catalog`, `/mascot`, `/lesson/:id`), botones atrás/adelante del navegador, preservación del estado del shell y redirección inicial (`/onboarding` si no hay nombre registrado).
- **Opciones consideradas:**
  1. `go_router` (Oficial de Google Flutter, declarativo, deep-links, sub-rutas y soporte web robusto).
  2. `Navigator 1.0` clásico (Imperativo, deficiente sincronización con la barra de direcciones de la web).
  3. `auto_route` (Requiere generación de código `build_runner`).
- **Recomendación:** **`go_router`**.
- **Trade-offs:** Ninguno relevante; es el estándar de la industria para Flutter Web.
- **Aprobación del usuario:** APROBADO por el usuario el 2026-10-31.

---

### ADR-003 — Persistencia local para versión 100% offline
- **Estado:** APPROVED
- **Fecha:** 2026-10-31
- **Contexto:** El requerimiento de negocio exige un funcionamiento 100% offline sin backend propio en el MVP. Se debe persistir el nombre, XP, racha, medallas y estado de completitud de cada lección entre visitas.
- **Opciones consideradas:**
  1. `shared_preferences` con serialización a JSON estructurado (Usa LocalStorage / IndexedDB en web; altamente probado y liviano).
  2. `hive_ce` / Hive (Base NoSQL binaria; rápida pero añade complejidad de adaptadores).
  3. `sqflite` para Web (Excesivo y requiere binarios Wasm adicionales).
- **Recomendación:** **`shared_preferences`** con serialización JSON en un `LocalStorageService`. Es instantáneo, no requiere compilación nativa ni scripts pesados en el navegador.
- **Trade-offs:** Limitado a volúmenes moderados de datos, lo cual es exactamente lo requerido para los perfiles y estadísticas locales del MVP.
- **Aprobación del usuario:** APROBADO por el usuario el 2026-10-31.

---

### ADR-004 — Identificación de usuario y privacidad
- **Estado:** APPROVED
- **Fecha:** 2026-10-31
- **Contexto:** Se requiere autenticación mínima sin email, contraseñas ni servidor de auth.
- **Opciones consideradas:**
  1. Captura de nombre o apodo en pantalla de onboarding y guardado en local storage.
  2. Autenticación con OAuth o Firebase.
- **Recomendación:** **Nombre de usuario local únicamente (100% offline)**.
- **Trade-offs:** Si el usuario borra los datos de su navegador, pierde el nombre y progreso. Se mitigará ofreciendo en el futuro una exportación de respaldo en archivo JSON.
- **Aprobación del usuario:** APROBADO por el usuario el 2026-10-31.

---

### ADR-005 — Pipeline seguro de assets con Gemini API / Nano Banana
- **Estado:** APPROVED
- **Fecha:** 2026-10-31
- **Contexto:** El producto utiliza Gemini API / Nano Banana para generar ilustraciones (escenarios, medallas, orbes). Flutter Web nunca debe contener la `GEMINI_API_KEY`.
- **Opciones consideradas:**
  1. Pipeline local privado (`tools/asset_pipeline/`) en Node.js o Dart CLI que lee `.env` ignorado, genera assets, los valida y los escribe en `assets/generated/`.
  2. Embeber la clave en la app web de cliente (INACEPTABLE por seguridad).
- **Recomendación:** **Pipeline local privado desacoplado**.
- **Trade-offs:** La generación ocurre durante el desarrollo / preparación de assets y no en tiempo real ante el usuario final, lo cual además ahorra costos y garantiza que no haya latencias ni consumo no autorizado de cuotas.
- **Aprobación del usuario:** APROBADO por el usuario el 2026-10-31.

---

### ADR-006 — Adopción de flutter_animate para Motion UI declarativo
- **Estado:** APPROVED
- **Fecha:** 2026-10-31
- **Contexto:** La experiencia de aprendizaje requiere microinteracciones (retroalimentación de aciertos y errores en ejercicios, efectos hover en tarjetas cósmicas, respiración/animación de la mascota y transiciones escalonadas de lecciones). Se requería elegir entre animaciones nativas con `AnimationController` imperativo o la librería declarativa `flutter_animate`.
- **Opciones consideradas:**
  1. `flutter_animate` (Sintaxis declarativa encadenable, soporte nativo de accesibilidad `disableAnimations`, reduce sustancialmente el boilerplate, optimizado para Flutter Web).
  2. Animaciones nativas de Flutter (`AnimationController`, `AnimatedBuilder`, `TweenAnimationBuilder` manuales).
- **Recomendación:** **`flutter_animate`**.
- **Trade-offs:** Introduce una dependencia directa (~15KB compilada en web), pero reduce drásticamente el código repetitivo de Tickers y Controllers, evitando memory leaks por controllers no liberados y facilitando la creación de secuencias coordinadas.
- **Aprobación del usuario:** APROBADO por el usuario el 2026-10-31 (Opción A).

---

### ADR-007 — Sistema de Glassmorphism Óptico y Espejo Cósmico (Frosted Mirror Glass)
- **Estado:** APPROVED
- **Fecha:** 2026-10-31
- **Contexto:** Se solicitó elevar la inmersión visual implementando un efecto de glassmorphism de fondo entre el contenido y el fondo con características de espejo (óptica de refracción, borde biselado especular, gradiente frontal de superficie, barrido diagonal de luz en hover, barras de navegación esmeriladas fijas y sombras cáusticas duales neón).
- **Opciones consideradas:**
  1. `BackdropFilter` nativo con `ImageFilter.blur` combinado con `CustomPainter` para biseles y destellos, y `LinearGradient` de atenuación especular.
  2. Uso de imágenes rasterizadas prediseñadas semitransparentes como fondos.
  3. Paquetes de terceros de glassmorphism no mantenidos (`glassmorphism`, `glass_kit`).
- **Recomendación:** **`BackdropFilter` nativo con `CustomPainter` propio**. Proporciona renderizado directo por hardware (CanvasKit/Skia/Wasm), sin dependencias obsoletas, respetando los tokens de accesibilidad y optimizado para widget tests (`AppMotion.isTestEnvironment`).
- **Trade-offs:** `BackdropFilter` requiere composición gráfica GPU; se mitiga limitando el sigma de desenfoque a 12-16px y usando `ClipRRect`/`ClipRect` contenidos.
- **Aprobación del usuario:** APROBADO por el usuario el 2026-10-31.

---

### ADR-008 — Mecánica de 5 vidas y recarga temporal pasiva
- **Estado:** APPROVED
- **Fecha:** 2026-10-31
- **Contexto:** El usuario solicitó explícitamente un sistema de 5 vidas que se pierden con respuestas incorrectas en los ejercicios y se recargan con el paso del tiempo.
- **Opciones consideradas:**
  1. Contador de 5 vidas con recarga pasiva calculada por marcas de tiempo en `LocalStorageService` (1 vida cada 15 min), sin bloqueos abusivos e integración con `userProfileProvider` y `LivesBadge`.
  2. Temporizadores estrictos de servidor que bloquean al usuario y requieren compras de vidas (rechazado por ser punitivo y requerir backend).
- **Recomendación:** **Opción 1: Recarga temporal pasiva local**. El cómputo por diferencia de tiempo (`DateTime.now() - lastTimestamp`) garantiza que el tiempo transcurrido restaura vidas incluso si el navegador se cierra o el dispositivo se suspende. Se incluye modal accesible con desglose de corazones, tiempo exacto restante en formato MM:SS y opción de reposo amigable.
- **Trade-offs:** La recarga está sujeta a la hora del reloj del dispositivo en este MVP 100% offline, pero garantiza que la experiencia del usuario sea fluida, respetuosa y educativa.
- **Aprobación del usuario:** Solicitado y aprobado explícitamente por el usuario el 2026-10-31.

---

### ADR-009 — Regla de estado de ánimo dinámico y gesto triste de la mascota según vidas disponibles
- **Estado:** APPROVED
- **Fecha:** 2026-11-01
- **Contexto:** El usuario solicitó la siguiente regla explícita: "al bajar una cantidad considerable de vidas, el gesto de la cabra cambia a triste... Regla de que el estado de ánimo de la cabra dependerá de las vidas disponibles en el momento."
- **Opciones consideradas:**
  1. Modelo de dominio unificado `GoatMood` (`happy`, `sad`, `critical`), derivado reactivamente de `lives / maxLives`. Cuando las vidas bajan de 5 (< 5 vidas), el gesto de la cabra conmuta obligatoriamente a triste (`assets/mascot/goat_sad.png`), adaptando transversalmente el avatar de navegación (`AdaptiveScaffold`), la tarjeta principal de Dashboard, los bocadillos de diálogo pedagógicos (`MascotSpeechBubble`), la pantalla de personalización (`MascotScreen`) y el diálogo de vidas (`LivesBadge`).
  2. Cambio aislado únicamente en la pantalla de lección al errar una respuesta (insuficiente porque no cumplía la regla sistémica de que el estado de ánimo dependa de las vidas disponibles en el momento).
- **Recomendación:** **Opción 1: Modelo reactivo transversal `GoatMood`**. Asegura coherencia y empatía pedagógica. Si el usuario pierde vidas en cualquier reto y vuelve al Dashboard o navega por la app, la cabra empatiza visualmente con un gesto triste y diálogos comprensivos sin ser condescendiente ni punitiva.
- **Trade-offs:** El gesto triste prioriza la empatía sobre atuendos cosméticos (`userSkin`) mientras se hayan perdido vidas (< 5). En `MascotScreen` se muestra triste por defecto en el podio.
- **Aprobación del usuario:** Solicitado por el usuario el 2026-11-01.

---

### ADR-010 — Estado estricto "Cabra Triste" y espera obligatoria de 15 minutos sin recuperación automática
- **Estado:** APPROVED
- **Fecha:** 2026-11-01
- **Contexto:** El usuario especificó: *"quiero que al perder vidas la cabra cambie de estado a cabra triste adicional que las vidas se tiene que esperar a que pasen los 15 minutos, para poder recuperarla no se puede recuperar automáticamente"*.
- **Decisión:**
  1. **Estado "Cabra Triste":** Ante cualquier vida perdida (vidas < 5), el estado del perfil y de la cabra se nombra explícitamente "Cabra Triste" con icono y gesto triste (`assets/mascot/goat_sad.png`), visible por defecto en el podio de `MascotScreen`, el hero banner y tarjetas del `DashboardScreen`, la barra de navegación y el `LivesBadge`.
  2. **Espera obligatoria de 15 minutos:** No se permite recuperación automática en segundo plano ni atajos de recarga instantánea. El temporizador de 15 minutos (900s) es un requisito estricto y observable.
  3. **Acción explícita de recuperación tras 15 minutos:** Durante los 15 minutos, el botón de recuperación permanece bloqueado mostrando el tiempo restante exacto (`MM:SS`) y explicando que no se puede recuperar automáticamente. Solo al cumplirse los 15 minutos (`canRecoverLife == true`), se activa el botón *"¡15 minutos cumplidos! Recuperar 1 vida (+1 ❤️)"*, permitiendo al estudiante recuperar una vida a la vez e iniciando el siguiente bloque de 15 minutos si aún quedan vidas por recuperar.
- **Trade-offs:** Elimina atajos de recarga inmediata en favor del respeto pedagógico por los ritmos de descanso y concentración.
- **Aprobación del usuario:** Solicitado por el usuario el 2026-11-01.

