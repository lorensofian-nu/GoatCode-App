# Estado del proyecto — GoatCode

- **Última actualización:** 2026-10-31
- **Milestone actual:** Post-MVP — Fases A, B y C Completadas
- **Estado general:** PRODUCCIÓN Y EXPANSIONES COMPLETADAS

## Hecho

1. Lectura e interpretación profunda del prompt maestro (`MASTER_PROMPT.md`) y reglas (`GEMINI.md`).
2. Inspección visual directa y exhaustiva de los 6 wireframes y las 9 referencias de personajes de cabra.
3. Especificación de requisitos (`docs/01-requirements.md`), journeys (`docs/02-user-journeys.md`) y sistema de diseño cósmico (`docs/03-design-system.md`).
4. Arquitectura y ADR-001 a ADR-005 formalmente aprobadas (`docs/08-decision-log.md`).
5. Bootstrap Flutter Web, shell adaptativo (`adaptive_scaffold.dart`) y persistencia local (`local_storage_service.dart`).
6. Suite de calidad: `flutter analyze` (0 lints), `flutter test` (9/9 pass) y build de producción en `build/web/`.
7. Servidor web local SPA en `tools/server.js` activo en `http://localhost:8080`.
8. **Opción A (Completada & Confirmada):**
   - Eliminación de fondos blancos de todos los assets de cabra con flood-fill y canal alfa transparente (`tools/remove_backgrounds.ps1`).
   - Disponibilidad de los 9 looks en el personalizador de cabra (`/mascot`).
9. **Opción B (Completada & Confirmada):**
   - Expansión pedagógica a 5 módulos completos con 12 lecciones interactivas secuenciales en `sample_lessons.dart`.
   - Sistema de desbloqueo progresivo y cálculo dinámico de avance.
10. **Opción C (Completada):**
    - Herramienta CLI privada y desacoplada en `tools/asset_pipeline/generate_asset.js`.
    - Presets de prompts en `tools/asset_pipeline/prompts/` (isla 3D, insignias de lógica/racha, cabra maga).
    - Soporte para API real de Gemini Imagen y modo offline `--mock`.
    - Registro y sincronización automática en `docs/06-asset-manifest.csv`.

## En curso

- Revisión y confirmación final de la Opción C con el usuario.

## Pendiente (Fases Futuras)

- Despliegue en la nube público (Firebase Hosting / GitHub Pages) si se desea publicar para usuarios externos.

## Bloqueos / Decisiones pendientes

- *Ninguno.*

## Próximo paso

Presentar el pipeline de assets de Gemini al usuario y recibir su confirmación final.


