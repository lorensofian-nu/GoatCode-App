# Contexto e insumos del proyecto — GoatCode

## Descripción recibida (verbatim de MASTER_PROMPT.md)

```text
Plataforma web de enseñanza de programación orientada a adultos (mayores de edad) que necesitan más tiempo para procesar conceptos. 

Características principales:
- Empieza con el curso de **Lógica de Programación**.
- Arquitectura modular que permita agregar más cursos en el futuro.
- Sistema de **rachas** estilo Duolingo.
- Experiencia similar a SoloLearn (lecciones cortas, práctica inmediata, progresión clara).
- Diferenciador: diseño pensado para ser amigable con todo público, especialmente personas que requieren ritmo más pausado y explicaciones claras.
- Modo online (sincronización, posibles funcionalidades sociales o de progreso en la nube) queda **fuera del alcance actual** (futuro).
- Versión inicial **100 % offline**.
- Autenticación mínima: solo solicitar nombre de usuario (sin email, contraseña ni backend de auth por ahora).

Objetivo: que el usuario adulto aprenda lógica de programación de forma guiada, sin presión de velocidad, con feedback claro y sensación de progreso constante.
```

## Referencias recibidas e inspeccionadas

Todas las referencias fueron inspeccionadas de manera visual y directa usando la herramienta `view_file`.

| Ruta | Tipo | Accesible | Observaciones |
|---|---|:---:|---|
| `references/wireframes/01_bienvenida_dashboard.png` | Wireframe / Mockup | Sí | **Dashboard principal de GoatCode**: Barra de navegación lateral izquierda (Home, Cursos, Cabra, Perfil, Configuración), encabezado con logo, buscador simulado, contador de racha (fuego), avatar. Tarjeta de bienvenida ("¡Bienvenido a GoatCode!"), barra de progreso del curso actual "Lógica de Programación" (15%), carrusel de ruta de aprendizaje ("Introducción 100%", "Variables 50%", "Bucles 0%"), card de "Ayuda IA" (orbe brillante) y mascota 3D central. |
| `references/wireframes/02_catalogo_cursos.png` | Wireframe / Mockup | Sí | **Catálogo de cursos (Panel 2)**: Ilustración de isla flotante 3D, tarjeta activa "Lógica de Programación" con botón "Entrar al curso", banner inferior promocional: "Próximamente: Modo Online Colaborativo" con cabras mascota. |
| `references/wireframes/03_teoria_y_pregunta_variables.png` | Wireframe / Mockup | Sí | **Pantalla de lección**: Título "¿Qué es una Variable?", sección de **Teoría** con analogía sencilla ("caja con nombre en la memoria"), sección de **Ejemplo** con snippet de código (`let vidas = 3; ...`), sección de **Pregunta** interactiva con opciones de respuesta de selección múltiple (A, B, C) en botones redondeados. |
| `references/wireframes/04_personalizar_cabra.png` | Wireframe / Mockup | Sí | **Personalización de mascota Cabra**: Vista central con la cabra sobre podio circular iluminado, selector de categorías a la izquierda (pelaje, accesorios, etc.), paleta de selección de color a la derecha, botón inferior iluminado "Guardar look". |
| `references/wireframes/05_perfil_logros.png` | Wireframe / Mockup | Sí | **Perfil, logros y accesibilidad**: Avatar de usuario, nivel actual ("Nivel 11"), barra de puntos XP (3799 XP), contador de racha (fuego). Rejilla de "Logros desbloqueados" con medallas numeradas e iluminadas. Panel crítico de **Configuración de Accesibilidad**: selector de tamaño de texto tipográfico (T, A2, As, etc.), switch de contraste y barra de efectos/sonido. |
| `references/wireframes/06_vista_progreso_ranking.png` | Wireframe / Mockup | Sí | **Vista de progreso y ruta de hitos**: Línea de tiempo horizontal con nodos de progreso, tarjetas de módulos/hitos completados e insignias desbloqueadas. |
| `references/goat/` (9 imágenes JPEG) | Hoja de referencia de personaje | Sí | Conjunto consistente de la mascota cabra en 2D vector / chibi con diferentes expresiones y atuendos: (1) cabrita bebé con chupete y gorro de dormir; (2) cabra pedagoga/explicando con gafas, bufanda roja y camiseta "THE GOATS"; (3) tímida/sonrojada; (4) llorando (fallo/intento); (5) celebrando feliz (éxito); (6) decidida/enfocada; (7) asombrada/boca abierta; (8) sonrisa atenta neutra; y versión neutra con bufanda y camiseta de rock. |

## Resumen interpretado

- **Problema:** Los adultos que desean ingresar a la programación a menudo se sienten abrumados por herramientas con jerga excesiva, interfaces densas, ritmos acelerados pensados para jóvenes y curvas de aprendizaje agresivas que generan frustración y deserción.
- **Usuarios principales:** Adultos (mayores de edad, incluyendo adultos mayores o personas en reconversión laboral) principiantes absolutos sin experiencia previa en código, que necesitan procesar conceptos a su propio ritmo, con explicaciones claras, fuentes legibles y refuerzo positivo sin penalizaciones por tiempo.
- **Propuesta de valor:** "GoatCode" — una experiencia web responsiva, cálida y guiada, con una mascota empática (la cabra), explicaciones basadas en analogías cotidianas, práctica interactiva inmediata (estilo SoloLearn), hábito diario basado en rachas sin presión (estilo Duolingo) y funcionamiento 100% offline local sin necesidad de crear contraseñas o registros pesados.
- **Resultado esperado:** El estudiante comprende los fundamentos de la lógica de programación (variables, tipos de datos, condicionales, bucles, funciones) y desarrolla confianza mediante la resolución autónoma de retos interactivos.
- **Plataformas:** Flutter Web adaptativo para pantallas móviles (360px - 480px), tabletas (768px - 1024px) y escritorios (1280px+).

## Inventario de pantallas y flujos

| Pantalla / flujo | Evidencia de wireframe | Propósito | Interacciones | Estados |
|---|---|---|---|---|
| **Onboarding / Registro Simple** | Brief + Wireframe 01/05 | Capturar nombre de usuario y dar la bienvenida | Input de texto para nombre, botón "Comenzar" | Vacío, escribiendo, validado |
| **Dashboard Principal** | Wireframe 01 (`01_bienvenida_dashboard.png`) | Hub central del estudiante, resumen de racha, avance del curso activo | Navegar a lección actual, ver módulos, cambiar sección | Cargando, estado normal, racha activa/inactiva |
| **Catálogo de Cursos** | Wireframe 02 (`02_catalogo_cursos.png`) | Mostrar cursos disponibles y teaser de futuros | Tarjeta de curso activo ("Lógica"), botón "Entrar", tarjeta deshabilitada ("Próximamente") | Disponible, bloqueado/próximamente |
| **Visor de Lección / Ejercicio** | Wireframe 03 (`03_teoria_y_pregunta_variables.png`) | Enseñar un concepto (Teoría + Ejemplo de código) y evaluar con práctica inmediata | Selección de opción, botón de comprobar, solicitar pista, continuar | Sin responder, seleccionada, éxito (feedback verde + cabra feliz), error (feedback explicativo + cabra de aliento) |
| **Personalización de Mascota** | Wireframe 04 (`04_personalizar_cabra.png`) | Fomentar la conexión emocional y recompensa del estudiante | Seleccionar color/skin, seleccionar accesorio, "Guardar look" | Vista previa en tiempo real, guardado exitoso con persistencia local |
| **Perfil y Logros / Ajustes** | Wireframe 05 (`05_perfil_logros.png`) | Ver progreso, medallas desbloqueadas y ajustar accesibilidad | Cambio de tamaño de letra (A/A+/A++), toggle alto contraste, ajuste de sonido | Estado de logros (bloqueado/desbloqueado con tooltip explicativo) |
| **Ruta de Progreso (Roadmap)** | Wireframe 06 (`06_vista_progreso_ranking.png`) | Ver el camino de aprendizaje y lecciones completadas | Clic en nodo de módulo para retomar o repasar | Bloqueado, en progreso, completado |

## Hechos confirmados

1. **Tecnología:** Flutter Web exclusivamente.
2. **Ambiente:** Versión inicial 100 % offline. No hay backend propio, base de datos en la nube ni llamadas externas en runtime de cliente.
3. **Autenticación:** Identificación mínima local (solo solicitar nombre de usuario en local storage). Sin contraseñas ni emails.
4. **Contenido inicial:** Curso enfocado en **Lógica de Programación** (Variables, Tipos de datos, Condicionales, Bucles, Funciones básicas).
5. **Diferenciador:** Diseñado especialmente para adultos que procesan conceptos paso a paso (tipografía legible, contraste ajustable, sin temporizadores de presión, analogías del mundo real).
6. **Mascota y gamificación:** Mascota cabra "GoatCode" con estados expresivos y recompensas por racha diaria y logros.
7. **Pipeline de assets:** Generación y estandarización privada de assets mediante Gemini API / Nano Banana en entorno seguro local, sirviendo a Flutter Web solo archivos estáticos procesados.

## Suposiciones y preguntas abiertas

| Elemento | Tipo | Impacto | Cómo resolver |
|---|---|---|---|
| Idioma del código de ejemplo | Suposición | Medio | El wireframe 03 muestra sintaxis estilo JavaScript/Dart (`let vidas = 3;`). Para lógica general usaremos pseudocódigo limpio o JavaScript/Dart básico y legible. |
| Persistencia local | Decisión técnica | Alto | Dado que es 100% offline en web, se recomienda `shared_preferences` o `hive_ce` para persistir estado, racha y lecciones en IndexedDB/LocalStorage. |
| Estilo visual definitivo: ¿Glow/Dark Neumorphism o Dark Modern Clean? | Decisión estética | Alto | Los wireframes muestran un estilo "Cyber Dark Glassmorphic" con tonos púrpuras, azules y neón. Se propondrá un sistema compatible con accesibilidad real (WCAG AA). |

## Fuentes consultadas

| Fuente | URL | Fecha de consulta | Dato utilizado |
|---|---|---|---|
| Flutter SDK Local | `C:\Tools\SDKs\flutter` | 2026-10-31 | Flutter 3.47.9 / Dart 3.13.7 verificado en entorno de trabajo |
| Gemini API Docs (Image Generation) | https://ai.google.dev/gemini-api/docs/image-generation | 2026-10-31 | Especificación de prompts y pipeline seguro offline para assets |
| Material 3 & Accessibility | https://docs.flutter.dev/ui/design/material | 2026-10-31 | Guías de accesibilidad, escalado de fuentes y contrastes en Flutter |

