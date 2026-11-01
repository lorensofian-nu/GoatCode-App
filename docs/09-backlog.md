# Backlog y milestones — GoatCode

## Milestones del proyecto

| ID | Milestone | Objetivo | Dependencias | Criterios de terminado | Estado |
|---|---|---|---|---|:---:|
| **M0** | **Descubrimiento y Auditoría de Referencias** | Analizar brief, inspeccionar wireframes e inventariar requerimientos | Brief + Wireframes | Documentos de requisitos, journeys, sistema visual y decisiones ADR listos | **DONE** |
| **M1** | **Aprobaciones de Arquitectura y Alcance** | Recibir confirmación formal del usuario en decisiones clave | M0 | ADRs aprobados por el usuario en `08-decision-log.md` | **DONE** |
| **M2** | **Bootstrap Flutter Web & Shell Adaptativo** | Crear app Flutter, configurar Router, diseño base y accesibilidad | M1 | `flutter create`, `go_router`, tokens de diseño aplicados, shell responsive funcional | **DONE** |
| **M3** | **Motor de Lecciones y Feedback Pedagógico** | Implementar visor de lecciones (Teoría + Código + Ejercicio) con feedback empático | M2 | Flujo de lección completo de extremo a extremo, feedback con cabra reactiva, sin temporizadores | **DONE** |
| **M4** | **Gamificación Offline & Mi Cabra** | Sistema de rachas diarias, XP, medallas y personalización de mascota | M3 | Persistencia en `shared_preferences`, cálculo de rachas, cambio de skins de cabra | **DONE** |
| **M5** | **Quality Gates, Auditoría y Build Web** | Pruebas unitarias/widget, verificación responsive en 4 viewports y build de producción | M4 | Suite de tests en verde, análisis sin errores, build web compilado exitosamente | **DONE** |

## Tareas desglosadas

| ID | Tarea | Responsable | Estimación | Dependencias | Estado |
|---|---|---|:---:|---|:---:|
| **TSK-001** | Inspección visual de wireframes y hoja de personajes de cabra | `project-lead` / `product-architect` | S | Ninguna | **DONE** |
| **TSK-002** | Especificación formal de requisitos y criterios de aceptación (`01-requirements.md`) | `product-architect` | M | TSK-001 | **DONE** |
| **TSK-003** | Mapeo de journeys y matriz de estados por pantalla (`02-user-journeys.md`) | `product-architect` | S | TSK-002 | **DONE** |
| **TSK-004** | Definición de tokens de diseño, colores cósmicos y escala accesible (`03-design-system.md`) | `asset-artist` | M | TSK-001 | **DONE** |
| **TSK-005** | Formulación de ADRs y arquitectura técnica feature-first (`04-architecture.md`) | `flutter-architect` | M | TSK-002 | **DONE** |
| **TSK-006** | Diseño del syllabus pedagógico "Lógica de Programación" (`05-learning-roadmap.md`) | `learning-designer` | M | TSK-001 | **DONE** |
| **TSK-007** | Inventario y priorización de assets en manifest (`06-asset-manifest.csv`) | `asset-artist` | S | TSK-001 | **DONE** |
| **TSK-008** | **Petición y resolución de Aprobaciones de Alto Impacto** | `project-lead` | S | M0 | **DONE** |
| **TSK-009** | Inicialización del proyecto Flutter (`flutter create`) y dependencias base | `flutter-developer` | S | M1 | **DONE** |
| **TSK-010** | Implementación del Shell Adaptativo (NavigationRail / BottomNavigationBar) | `flutter-developer` | M | TSK-009 | **DONE** |
| **TSK-011** | Implementación del Dashboard y Catálogo de cursos con estados visuales | `flutter-developer` | M | TSK-010 | **DONE** |
| **TSK-012** | Implementación del Visor de Lección interactivo y feedback constructivo | `flutter-developer` | L | TSK-010 | **DONE** |
| **TSK-013** | Implementación de persistencia de racha diaria, XP y medallas | `flutter-developer` | M | TSK-012 | **DONE** |
| **TSK-014** | Implementación de personalizador de cabra y panel de accesibilidad | `flutter-developer` | M | TSK-010 | **DONE** |
| **TSK-015** | Ejecución de suite de tests, auditoría responsive y build web final | `quality-auditor` | M | M4 | **DONE** |


