# Quality gates — GoatCode

## Antes de desarrollar (Gate M0 -> M1)
- [x] Requisitos y alcance MVP revisados y documentados (`01-requirements.md`).
- [x] Wireframes (6 pantallas) y hoja de mascota (9 imágenes) inspeccionados visualmente.
- [x] Arquitectura propuesta y decisiones de alto impacto estructuradas en ADRs (`04-architecture.md`, `08-decision-log.md`).
- [x] Tokens del sistema de diseño y accesibilidad definidos (`03-design-system.md`).
- [x] Datos, privacidad y modelo 100% offline evaluados.
- [x] Estrategia de assets desacoplada (Gemini API Nano Banana privada) formulada.
- [x] Aprobación explícita del usuario para decisiones ADR de alto impacto (Puerta M1 - Confirmado el 2026-10-31).

## Por funcionalidad (Milestones M2 - M4)
- [x] Criterios de aceptación cubiertos por historia/tarea (Onboarding, Dashboard, Catálogo, Lección interactiva, Personalizador de Cabra, Perfil/Ajustes).
- [x] Manejo de estados: Loading, Empty, Error, Success y Validación resueltos.
- [x] Lógica de dominio y evaluación desacoplada de la interfaz gráfica (`LessonModels`, `LocalStorageService`, `UserProfileNotifier`).
- [x] Tests unitarios y de widgets agregados y ejecutados (9 de 9 pasando).
- [x] Accesibilidad comprobada: foco visible, semántica, escalado tipográfico hasta 1.5x y modo alto contraste.
- [x] Adaptación responsive comprobada en móvil (360px), tablet (768px) y desktop (1280px).

## Antes de cada release/entrega (Milestone M5)
- [x] `dart format lib test` ejecutado con éxito (24 archivos formateados).
- [x] `flutter analyze` ejecutado con 0 errores y 0 warnings (No issues found).
- [x] `flutter test` ejecutado con 100% de tests pasando (9 tests OK).
- [x] `flutter build web --release` compilado exitosamente (`build/web` listo).
- [x] Revisión independiente de calidad por `quality-auditor`.
- [x] Cero defectos bloqueantes abiertos.
- [x] Documentación, manifest y decision log completamente sincronizados.

## Registro de ejecución de calidad

| Fecha | Comando / Comprobación | Resultado real | Evidencia | Responsable |
|---|---|---|---|---|
| 2026-10-31 | Inspección visual de wireframes (`view_file`) | 6 wireframes y 9 referencias analizadas | `references/wireframes/`, `references/goat/` | `project-lead` |
| 2026-10-31 | Verificación de Flutter SDK en sistema | Flutter 3.47.9 / Dart 3.13.7 verificado | `flutter --version` (Exit Code 0) | `project-lead` |
| 2026-10-31 | `dart format lib test` | 24 archivos formateados idiomáticamente | Exit code 0 | `flutter-developer` |
| 2026-10-31 | `flutter analyze` | No issues found! (0 warnings, 0 lints) | Exit code 0 | `quality-auditor` |
| 2026-10-31 | `flutter test` | 9/9 tests unitarios y de widgets pasando | `test/unit/`, `test/widget/` (Exit code 0) | `quality-auditor` |
| 2026-10-31 | `flutter build web --release` | Compilación release exitosa en `build/web` | `build/web` (Exit code 0) | `flutter-developer` |


