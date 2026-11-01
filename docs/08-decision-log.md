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

