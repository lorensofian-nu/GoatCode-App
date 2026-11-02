# Sistema de diseño — GoatCode ("Cosmic Glass & Friendly Mascot")

## Fuentes visuales inspeccionadas

- **Wireframes analizados:**
  - `references/wireframes/01_bienvenida_dashboard.png` (Estructura de dashboard, orbes de luz, barra de progreso con gradiente púrpura/cian, card de racha).
  - `references/wireframes/02_catalogo_cursos.png` (Tarjetas de curso con borde luminoso, badges de estado "Próximamente").
  - `references/wireframes/03_teoria_y_pregunta_variables.png` (Jerarquía de lección: Contenedor de teoría, bloque de código monospace contrastado, opciones tipo botón píldora interactivo).
  - `references/wireframes/04_personalizar_cabra.png` (Podio circular con anillo de luz para la mascota, swatches de color circulares).
  - `references/wireframes/05_perfil_logros.png` (Medallas circulares con aureolas de luz y selector de tamaño tipográfico accesible).
  - `references/wireframes/06_vista_progreso_ranking.png` (Línea de tiempo ondulada de progreso con nodos conectores).
- **Referencias de personaje (`references/goat/`):**
  - Ilustraciones 2D estilo chibi/vector de alta calidez con paleta amigable (tonos crema `#F5D6A7`, marrón suave `#8D5B4C`, celeste y rojo vino).
- **Ajustes indispensables para público adulto:**
  - Los fondos ultra oscuros y textos con brillo neón puro pueden fatigar la vista si el contraste no es óptimo. El sistema de diseño garantiza un contraste estricto WCAG AA (mínimo 4.5:1, con promedio 8:1 para lectura prolongada) y ofrece un selector de tamaño de letra de tres niveles.

## Tokens de color

| Token | Valor Hex / RGBA | Evidencia / Justificación | Estado |
|---|---|---|:---:|
| `backgroundDark` | `#0C0A17` | Fondo profundo cósmico que da soporte a las tarjetas translúcidas. | PROPOSED |
| `surfaceGlass` | `rgba(26, 22, 44, 0.75)` | Tarjetas con efecto glassmorphic sutil y fondo legible. | PROPOSED |
| `surfaceBorder` | `rgba(168, 130, 255, 0.20)` | Borde de delimitación para garantizar contorno claro en pantallas de bajo contraste. | PROPOSED |
| `primaryNeon` | `#8A4FFF` | Púrpura principal brillante presente en botones y encabezados de los wireframes. | PROPOSED |
| `secondaryCyan` | `#00E5FF` | Cian neón para barras de progreso activo, halos de luz y enlaces. | PROPOSED |
| `streakFire` | `#FF7A00` | Naranja fuego para el contador y animación de rachas (estilo Duolingo). | PROPOSED |
| `successGreen` | `#00E676` | Verde esmeralda para respuestas correctas, lecciones completadas y checks. | PROPOSED |
| `warningAmber` | `#FFB300` | Ámbar cálido para sugerencias, pistas y estados pendientes. | PROPOSED |
| `heartYellow` | `#FFD21E` | Amarillo dorado brillante para el contador de vidas/corazones y energía vital. | PROPOSED |
| `errorSoft` | `#FF5252` | Rojo coral no agresivo para indicar respuestas incorrectas y sugerir reintento. | PROPOSED |
| `textPrimary` | `#F5F3FF` | Blanco cálido de alta luminancia (contraste > 12:1 contra fondo). | PROPOSED |
| `textSecondary` | `#B8B2D1` | Lavanda grisáceo para subtítulos, etiquetas y metadatos (contraste > 5:1). | PROPOSED |
| `codeBackground` | `#08060F` | Fondo sólido oscuro para bloques de código que maximiza la legibilidad de sintaxis. | PROPOSED |

## Tipografía y escala

- **Familia principal:** `Outfit` o `Plus Jakarta Sans` (Sans-serif moderno, geométrico, con gran altura de x para lectura descansada en adultos).
- **Familia para código:** `Fira Code` o `JetBrains Mono` con soporte de ligaduras y caracteres numéricos bien diferenciados (0 vs O, 1 vs l).

| Nivel tipográfico | Tamaño Normal (1.0x) | Tamaño Grande (1.25x) | Tamaño Extra Grande (1.5x) | Peso |
|---|---|---|---|---|
| `Display / H1` | 32 px | 38 px | 44 px | Bold (700) |
| `Heading 2` | 24 px | 28 px | 34 px | Semi-Bold (600) |
| `Heading 3 / Subtitle` | 18 px | 22 px | 26 px | Medium (500) |
| `Body Text` | 16 px | 20 px | 24 px | Regular (400) |
| `Caption / Label` | 13 px | 16 px | 19 px | Regular / Medium |
| `Code Snippet` | 15 px | 18 px | 21 px | Monospace (400/500) |

## Radios, elevación y efectos

- **Bordes redondeados:**
  - `radiusCard`: 20 px (tarjetas principales y paneles de lección).
  - `radiusButton`: 14 px (botones de acción y opciones de respuesta).
  - `radiusPill`: 999 px (chips de estado, contador de racha, badges).
- **Glow & Glass:**
  - `boxShadowGlow`: `BoxShadow(color: Color(0x338A4FFF), blurRadius: 16, spreadRadius: 0, offset: Offset(0, 4))`
  - `borderGlass`: `Border.all(color: Color(0x2EFFFFFF), width: 1.5)`

## Breakpoints responsivos

| Breakpoint | Rango en píxeles | Comportamiento del Shell y Layout |
|---|---|---|
| **Compact (Móvil)** | `< 600 px` | Barra de navegación inferior (`NavigationBar`), una sola columna con scroll vertical fluido, padding de 16 px, mascota en banner compacto. |
| **Medium (Tablet)** | `600 px - 1024 px` | Barra lateral colapsada (`NavigationRail` con iconos), rejilla de 2 columnas para módulos, padding de 24 px. |
| **Expanded (Desktop/Laptop)** | `> 1024 px` | Barra lateral expandida (`NavigationRail` con texto o menú fijo de 240px), ancho máximo de contenido centrado a 1200 px, 2 a 3 columnas para tarjetas y visualizador espacioso de lecciones. |

## Accesibilidad (WCAG 2.1 AA)

1. **Escalado tipográfico sin desbordamientos:** Los contenedores usan `Flexible`, `SingleChildScrollView` o auto-sizing para permitir que el texto crezca hasta 1.5x sin provocar errores de `RenderFlex overflowed`.
2. **Navegación por teclado y foco visible:** Todo elemento interactivo (botones de lección, opciones de respuesta, tabs de navegación) cuenta con indicador de foco resaltado con halo cian (`#00E5FF`).
3. **Semántica para lectores de pantalla:** Uso de widgets `Semantics` con descripciones en español en iconos de racha, logros y progreso.
4. **Respeto a reducción de movimiento:** Si el usuario tiene activado en su sistema operativo "reducir movimiento", las partículas y animaciones de brillo se detienen suavemente (`MediaQuery.disableAnimationsOf(context)`).

## Tokens de Motion UI y Animación (ADR-006)

| Token | Valor / Duración | Curva | Propósito |
|---|---|---|---|
| `durationMicro` | `150 ms` | `Curves.easeOutQuad` | Hover, selección inmediata, cambios de estado en botones y toggles. |
| `durationMedium` | `300 ms` | `Curves.easeOutCubic` | Expansión de acordeones, reveals de feedback, cambio de tarjetas. |
| `durationMacro` | `500 ms` | `Curves.easeOutCubic` | Entrada escalonada de listas y pantallas (*staggered entrance*). |
| `durationCelebrate`| `600 ms` | `Curves.elasticOut` | Insignias desbloqueadas, medallas y finalización con éxito de lección. |
| `durationBreathing`| `2400 ms` | `Curves.easeInOut` | Animación idle sutil y continua de la mascota GoatCode. |

## Componentes Visuales Clave

1. **`CodeSnippetBlock`:** Bloque de código con coloreado léxico (keywords, strings, números, comentarios), números de línea monospace, estilo terminal oscuro y botón de copiado con retroalimentación instantánea.
2. **`CosmicBackground`:** Fondo envolvente con orbes de luz radiales difusos (violeta `#8A4FFF` superior izquierdo y cian `#00E5FF` inferior derecho) que crean profundidad cósmica.
3. **`MascotSpeechBubble`:** Bocadillo de diálogo dinámico estilo cómic integrado junto a la mascota con consejos y pistas en español.
4. **`CosmicConfetti`:** Ráfaga de confeti y partículas cósmicas (estrellas y discos cian, púrpura, ámbar y esmeralda) renderizada en Canvas al acertar lecciones.
5. **`InteractiveMemoryVisualizer`:** Visualizador de memoria RAM interactivo con cajas de variables animadas paso a paso.
6. **`_SinuousConnectorPainter`:** Trazado de ruta ondulado con nodos luminosos intermedios en la hoja de ruta.

## Sistema Glassmorphism y Efecto Espejo Cósmico Calibrado (High-Contrast Frosted Mirror)

Para garantizar un contraste óptico superior (WCAG AAA) y máxima legibilidad de los textos y códigos, los valores del sistema de cristal esmerilado fueron afinados tras pruebas visuales:

1. **Desenfocado Óptico Calibrado (`BackdropFilter`):**
   - Tarjetas (`CosmicCard`): `ImageFilter.blur(sigmaX: 7, sigmaY: 7)` (óptica limpia sin sangrado difuso que nuble el texto).
   - Shell y Barras de Navegación (`AdaptiveScaffold`): `ImageFilter.blur(sigmaX: 8, sigmaY: 8)`.
2. **Borde Especular Biselado Sutil (`_SpecularBorderPainter`):**
   - Borde con gradiente lineal a 135° de 1.0 px: arista superior con luz blanca atenuada (`rgba(255, 255, 255, 0.22)`) fundiéndose suavemente hacia `0.02` en la base. En hover, se intensifica a `0.45` de reflectancia con 1.3 px.
3. **Fondo de Obsidiana Cristalina de Alto Contraste:**
   - Base sólida y oscura al 93%-96% de opacidad (`Color(0xF0151128)` y `Color(0xF70C091A)`), con solo un sutil toque de 4% de luz blanca en el vértice extremo superior (stop 0.12), asegurando que el 88% del área de texto tenga un fondo oscuro uniforme y perfecto.
4. **Destello Diagonal Suave en Hover (`_LightSheenPainter`):**
   - Franja especular rápida con reflectancia pico amortiguada al 7% (`alpha: 0.07`), permitiendo que el texto permanezca 100% nítido y legible durante la animación de hover.
5. **Sombras Cáusticas Refinadas:**
   - Sombra dual: oclusión ambiental de 8-14 px de radio y halo neón amortiguado (alfa 0.06 reposo / 0.18 hover) para evitar halos invasivos.
7. **`ReadingProgressBar`:** Barra de progreso horizontal fija en el AppBar de las lecciones con degradado neón (violeta a cian) y halo luminoso en la cabeza del avance, indicando la lectura de la teoría.
8. **`MascotStreakAura`:** Halo cáustico adaptativo de la mascota según la racha acumulada:
   - *Racha 0–2 días:* Tier 1 "Aura Cósmica" (Violeta Neón `#8A4FFF` + Cian `#00E5FF`).
   - *Racha 3–6 días:* Tier 2 "Aura de Fuego" (Fuego Ámbar `#FF7A00` + Destello Solar `#FFB300`).
   - *Racha 7+ días:* Tier 3 "Aura Solar Mítica" (Oro Radiante `#FFD700` + Destellos Estelares).
9. **`SoundService` (Audio Sintético Web):**
   - Síntesis en tiempo real con Web Audio API (osciladores senoidales/triangulares), con 0 bytes de descarga, 100% offline y latencia 0 ms.
   - Sonido de acierto (arpegio cósmico ascendente C5-E5-G5), error (tono amortiguado 220Hz a 140Hz) y racha solar (arpegio brillante D5-A5-D6).
   - Interruptor de silenciado directo en la barra superior (`AdaptiveScaffold`) y en Ajustes (`ProfileScreen`).
10. **Interruptor de Modo "Cristal Cósmico" vs. "Obsidiana Mate" (Ultra-Legible):**
    - Alternador disponible en la barra superior (`AdaptiveScaffold`) y en Ajustes de Accesibilidad (`ProfileScreen`).
    - En modo Obsidiana Mate (`glassEffectEnabled == false`), `CosmicCard` y las barras de navegación omiten `BackdropFilter` y gradientes de luz, empleando fondos sólidos `#141026` y bordes limpios, eliminando el 100% de reflejos para estudio bajo luz solar o fatiga visual.
11. **Micro-Sombras de Contraste Tipográfico (`TextShadow` de Protección):**
    - Todos los tokens de `AppTypography` incorporan `contrastShadow` y `subtleContrastShadow` (sombras de oclusión negra con offset y desenfoque óptico), logrando separación perfecta entre cada letra y cualquier elemento o halo de fondo.
12. **Sistema de Estado de Ánimo Dinámico de la Mascota según Vidas (`GoatMood`):**
    - *Regla Emocional Reactiva:* El gesto visual y los diálogos pedagógicos de la cabra dependen en tiempo real del saldo de vidas disponibles:
      - **4 a 5 vidas (80% - 100%):** Estado `GoatMood.happy`. Gesto sonriente / atuendo personalizado del usuario. Diálogo motivador con racha y energía.
      - **3 vidas (60%):** Estado `GoatMood.attentive`. Gesto neutral o concentrado (`goat_idle.png` o atuendo activo). Diálogo de precaución reflexiva.
      - **1 a 2 vidas (20% - 40%):** Estado `GoatMood.sad` (*bajada considerable de vidas*). El gesto visual cambia obligatoriamente a triste (`assets/mascot/goat_sad.png`), priorizando la empatía pedagógica sobre la personalización cosmética.
      - **0 vidas (0%):** Estado `GoatMood.critical`. Gesto triste/afligido (`assets/mascot/goat_sad.png`) con mensaje de descanso y aliento para la recarga.
    - Se refleja transversalmente en Dashboard, Shell de Navegación (`AdaptiveScaffold`), Tarjeta de Personalización (`MascotScreen`), Modal de Vidas (`LivesBadge`) y lecciones (`LessonScreen`).


