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

### ADR-006 — Mecánica de 5 vidas y recarga temporal pasiva
- **Estado:** APPROVED
- **Fecha:** 2026-10-31
- **Contexto:** El usuario solicitó explícitamente un sistema de 5 vidas que se pierden con respuestas incorrectas en los ejercicios y se recargan con el paso del tiempo.
- **Opciones consideradas:**
  1. Contador de 5 vidas con recarga pasiva calculada por marcas de tiempo en `LocalStorageService` (1 vida cada 15 min), sin bloqueos abusivos e integración con `userProfileProvider` y `LivesBadge`.
  2. Temporizadores estrictos de servidor que bloquean al usuario y requieren compras de vidas (rechazado por ser punitivo y requerir backend).
- **Recomendación:** **Opción 1: Recarga temporal pasiva local**. El cómputo por diferencia de tiempo (`DateTime.now() - lastTimestamp`) garantiza que el tiempo transcurrido restaura vidas incluso si el navegador se cierra o el dispositivo se suspende. Se incluye modal accesible con desglose de corazones, tiempo exacto restante en formato MM:SS y opción de reposo amigable.
- **Trade-offs:** La recarga está sujeta a la hora del reloj del dispositivo en este MVP 100% offline, pero garantiza que la experiencia del usuario sea fluida, respetuosa y educativa.
- **Aprobación del usuario:** Solicitado y aprobado explícitamente por el usuario el 2026-10-31.


