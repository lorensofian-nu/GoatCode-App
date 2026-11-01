# Requisitos del producto — GoatCode

## Visión

GoatCode es una plataforma web responsiva, 100% offline-first en su fase inicial, creada para que personas adultas aprendan lógica de programación desde cero, a su propio ritmo, con explicaciones claras basadas en analogías cotidianas, práctica inmediata interactiva (estilo SoloLearn), reforzamiento positivo diario mediante rachas (estilo Duolingo) y una mascota cabra empática que acompaña el proceso sin generar ansiedad ni presiones de tiempo.

## Usuarios y necesidades

| Usuario | Necesidad | Contexto | Resultado deseado |
|---|---|---|---|
| **Adulto principiante absoluto (18-50+)** | Aprender a programar sin sentirse juzgado ni abrumado por tecnicismos incomprensibles. | Ha intentado cursos tradicionales o videos densos y los ha abandonado por frustración o falta de práctica guiada. | Comprender conceptos lógicos paso a paso, practicar inmediatamente con feedback constructivo y ganar confianza. |
| **Adulto con requerimientos de accesibilidad visual o cognitiva** | Interfaces con texto claro, tamaño ajustable, alto contraste, sin temporizadores estresantes ni sobrecarga de estímulos. | Dificultad para leer texto pequeño en pantallas o necesidad de mayor tiempo de lectura y reflexión. | Poder ajustar el tamaño tipográfico, activar contraste optimizado y resolver actividades sin límites de tiempo regresivo. |
| **Usuario con conectividad limitada o sin interés en crear cuentas** | Acceso inmediato a la plataforma sin registro tedioso de correo/contraseña, funcionando offline. | Desea aprender de forma privada y sin fricciones técnicas desde su navegador. | Ingresar su nombre de usuario una sola vez y conservar todo su progreso localmente sin depender de internet. |

## Alcance MVP

| ID | Requisito | Prioridad | Criterio de aceptación | Dependencias |
|---|---|:---:|---|---|
| **REQ-001** | **Identificación de usuario local** | Alta | La app solicita el nombre del usuario al iniciar por primera vez y lo almacena localmente. En sesiones posteriores lo saluda por su nombre. Permite editar el nombre en ajustes. | Persistencia local |
| **REQ-002** | **Dashboard principal GoatCode** | Alta | Muestra saludo personalizado, racha actual (días consecutivos), avance global del curso "Lógica de Programación" y accesos directos a los módulos. | REQ-001, REQ-006 |
| **REQ-003** | **Catálogo modular de cursos** | Alta | Muestra el curso activo "Lógica de Programación" con botón habilitado "Entrar al curso", e items futuros ("Modo Online", cursos avanzados) claramente señalados como "Próximamente". | Ninguna |
| **REQ-004** | **Motor de lecciones guiadas (Teoría + Ejemplo + Práctica)** | Alta | Cada lección presenta: (1) Explicación teórica breve con analogía del mundo real, (2) Ejemplo de código resaltado y comentado, (3) Reto o pregunta interactiva inmediata (opción múltiple o rellenar hueco) sin temporizador. | Contenido estructurado |
| **REQ-005** | **Feedback explicativo y empático** | Alta | Al responder, el sistema muestra inmediatamente si es correcto o no, explicando *por qué* y ofreciendo pistas formativas. La mascota cabra reacciona visualmente (animada o con poses de alegría/aliento). Reintentos ilimitados. | REQ-004 |
| **REQ-006** | **Sistema de rachas diarias y XP** | Media | Se incrementa la racha diaria al completar al menos una lección en el día calendario. Se otorgan puntos de experiencia (XP) por lección completada. Los datos persisten offline. | REQ-004, Persistencia local |
| **REQ-007** | **Perfil, nivel y medallas de logros** | Media | Pantalla de perfil con avatar, nivel actual (calculado por XP), racha actual y rejilla de logros desbloqueables (ej. "Primer paso", "Racha de 3 días", "Maestro de Variables"). | REQ-006 |
| **REQ-008** | **Personalización de la Mascota Cabra** | Media | Permite al usuario seleccionar variaciones de color o estilo para su cabra acompañante y guardar su look en persistencia local. | REQ-001 |
| **REQ-009** | **Ajustes de accesibilidad para adultos** | Alta | Selector de tamaño de letra de interfaz (Normal, Grande, Extra Grande), interruptor de alto contraste, y control de efectos de sonido. Debe reflejarse de inmediato en toda la app. | Shell / Theme |
| **REQ-010** | **Diseño adaptativo responsivo** | Alta | La interfaz se adapta dinámicamente a anchos móviles (360-480px, menú inferior o drawer), tabletas (768-1024px) y escritorios (1280px+, barra lateral fija / NavigationRail). | Responsive framework |
| **REQ-011** | **Sistema de vidas y recarga temporal pasiva** | Alta | El usuario inicia con 5 vidas (corazones). Cada respuesta incorrecta en un reto resta 1 vida. Si llega a 0 vidas, se muestra aviso de reposo. Se recarga 1 vida cada 15 minutos de forma pasiva y automática. | Persistencia local, REQ-004 |

## Fuera de alcance inicial (Fase futura)

- Backend propio o base de datos centralizada en la nube.
- Autenticación con email, contraseñas, Google Auth o recuperación de cuentas.
- Sincronización multi-dispositivo en la nube.
- Modo colaborativo multijugador o chat en tiempo real ("Modo Online").
- Asistente de IA generativa en vivo en tiempo de ejecución del navegador (el widget "Ayuda IA" de los wireframes operará con respuestas fijas de ayuda pedagógica / FAQ offline).
- Sistema de pagos, suscripciones premium o pasarelas de cobro.

## Requisitos no funcionales

- **Responsividad:** Soporte probado en 360px (móvil compacto), 768px (tablet) y 1280px+ (desktop).
- **Accesibilidad:** Cumplimiento con pautas WCAG 2.1 nivel AA: contraste mínimo de texto 4.5:1, áreas de toque mínimas de 48x48dp, soporte para navegación por teclado y escalado de fuentes sin desbordamiento de contenedores.
- **Rendimiento:** Carga inicial rápida en Flutter Web (CanvasKit/Skwasm optimizado), assets comprimidos (SVG / WebP), transiciones suaves a 60 fps.
- **Seguridad:** Cero exposición de API keys o credenciales privadas en el bundle web. Almacenamiento local aislado en el navegador del usuario.
- **Mantenibilidad:** Separación clara en arquitectura modular feature-first (presentación, dominio, datos), lecciones desacopladas en modelos de datos tipados (no hardcodeadas en widgets gigantes).

## Reglas de negocio

1. **Racha diaria:** Se cuenta 1 racha por día calendario en el que el usuario complete al menos una actividad. Si transcurre un día completo sin actividad, la racha se reinicia a 1 (o se ofrece un escudo de racha amigable para evitar frustración en adultos).
2. **Sistema de vidas (5 vidas):** El usuario cuenta con un máximo de 5 vidas representadas visualmente en la barra superior. Cada fallo en un reto interactivo resta 1 vida. Las vidas se regeneran pasivamente (1 vida cada 15 minutos) incluso con la app cerrada. Al quedarse sin vidas, el sistema ofrece una pausa pedagógica formativa o recarga instantánea para continuar aprendiendo sin bloqueos prolongados.
3. **Cálculo de niveles:** Cada lección superada otorga 100 XP. Cada nivel requiere `Nivel * 250 XP`.
4. **Desbloqueo progresivo:** Las unidades del curso se desbloquean en secuencia pedagógica lógica (Variables -> Condicionales -> Bucles), pero se permite repasar lecciones ya completadas en cualquier momento.

## Suposiciones, riesgos y preguntas

| ID | Descripción | Tipo | Estado | Mitigación |
|---|---|---|---|---|
| **RSK-001** | La estética glassmorphic con neón oscuro del wireframe puede reducir la legibilidad en usuarios adultos con problemas de visión. | Riesgo UX | Mitigado por diseño | Se implementará un tema oscuro accesible con ratios de contraste WCAG AA rigurosos y un modo de alto contraste con fuentes robustas. |
| **RSK-002** | Pérdida de progreso si el usuario borra la caché del navegador en modo offline puro. | Riesgo de datos | Aceptado para MVP | Se advertirá al usuario en ajustes y se considerará una función simple de exportar/importar progreso en formato JSON local. |
| **RSK-003** | El usuario adulto puede frustrarse con sintaxis críptica de lenguajes complejos como C++ o Java. | Riesgo pedagógico | Mitigado por syllabus | Se usará pseudocódigo estructurado e intuitivo en español y Dart/JS elemental altamente legible. |

