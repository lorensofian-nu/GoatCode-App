# Antigravity Flutter Learning Starter

Plantilla inicial de orquestación multiagente para construir una plataforma web responsiva de aprendizaje guiado de programación con Flutter.

> **Estado:** scaffold de configuración y arquitectura inicial. No es todavía una aplicación Flutter ejecutable: no se ha generado `pubspec.yaml`, `web/` ni código de producto porque faltan la descripción final del producto y los wireframes reales.

## Qué incluye

- `GEMINI.md`: reglas permanentes del workspace.
- `.agents/agents/`: agente líder y seis especialistas con frontmatter compatible con Antigravity.
- `.agents/skills/`: procedimientos reutilizables y focalizados.
- `MASTER_PROMPT.md`: prompt maestro con variables para la descripción de producto y rutas de wireframes.
- `docs/`: plantillas para requisitos, journeys, arquitectura, experiencia de aprendizaje, assets, QA, decisiones y backlog.
- `references/wireframes/`: lugar sugerido para copiar wireframes y referencias visuales.
- `lib/` y `test/`: estructura Flutter feature-first inicial, pendiente de materializar tras la fase de descubrimiento.
- `tools/asset_pipeline/`: especificación para un generador de assets privado con Gemini API.

## Inicio rápido

1. Descomprime el paquete y abre una terminal en la carpeta `antigravity-flutter-learning-starter`.
2. Copia tus wireframes a `references/wireframes/` o usa rutas absolutas a los archivos que ya tienes.
3. Abre Antigravity CLI desde la raíz del repositorio (`agy`).
4. En el administrador `/agents`, comprueba que aparece `project-lead` como agente personalizado. Si no aparece, revisa la sección de solución de problemas de la documentación oficial.
5. Abre `MASTER_PROMPT.md`, sustituye los campos `{{...}}` con tus datos y pega el prompt completo en la conversación del agente líder.
6. Deja que el líder haga descubrimiento, inspeccione las referencias, investigue opciones y redacte un plan. No debe implementar la plataforma hasta completar la especificación y obtener aprobación de las decisiones de arquitectura.

## Roles

| Agente | Responsabilidad |
|---|---|
| `project-lead` | Orquesta el trabajo, mantiene el plan, delega, integra y reporta. |
| `product-architect` | Descubrimiento, requisitos, alcance, journeys y aceptación. |
| `learning-designer` | Ruta de aprendizaje, lecciones, ejercicios, feedback y evaluación. |
| `flutter-architect` | Arquitectura Flutter Web, routing, estado, datos y escalabilidad. |
| `flutter-developer` | Implementación Flutter modular, accesible y responsiva. |
| `asset-artist` | Dirección visual y generación de assets con Gemini/Nano Banana. |
| `quality-auditor` | Auditoría independiente de código, UX, accesibilidad, seguridad y pruebas. |

Los perfiles están registrados como custom agents. El uso real de subagentes depende de que la versión/sesión de Antigravity exponga `invoke_subagent`; si no, el líder debe trabajar por fases y no afirmar que delegó en paralelo. `/teamwork` puede depender del plan y no es un requisito de esta plantilla.

## Decisiones de seguridad

- Nunca pongas `GEMINI_API_KEY` en Flutter Web, archivos Dart, `web/`, assets públicos o repositorios.
- La generación de imágenes se ejecuta en un proceso local o backend privado. La app Flutter solo consume assets ya generados y versionados.
- No guardes secretos en `docs/`, prompts, logs ni capturas.
- `.env.example` contiene nombres y valores ficticios; crea un `.env` local y mantenlo fuera de Git.

## Modelo de generación de imágenes

La documentación oficial de Gemini consultada para esta plantilla identifica `gemini-nano-banana-2.1` como modelo de generación de imágenes disponible en la API. El nombre y la disponibilidad pueden cambiar; el pipeline debe leer `GEMINI_IMAGE_MODEL` del entorno y verificar modelo, SDK, cuotas y coste antes de generar en lote.

## Próximo paso

Completar `MASTER_PROMPT.md` y entregar al agente líder la descripción del producto, las rutas de wireframes y las restricciones conocidas. El resultado esperado de esa primera ejecución es una propuesta de producto/arquitectura y una lista explícita de aprobaciones, no una implementación precipitada.
