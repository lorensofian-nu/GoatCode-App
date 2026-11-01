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
4. **Respeto a reducción de movimiento:** Si el usuario tiene activado en su sistema operativo "reducir movimiento", las partículas y animaciones de brillo se detienen suavemente.

