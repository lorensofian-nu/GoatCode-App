# Journeys y arquitectura de información — GoatCode

## Mapa de navegación propuesto

```text
App Shell (Responsive Navigation: NavigationRail en Desktop / BottomNavigationBar en Móvil)
  ├── 🏠 Dashboard (`/dashboard`)
  │     ├── Resumen de racha diaria & XP
  │     ├── Tarjeta de curso en progreso ("Lógica de Programación")
  │     ├── Carrusel de ruta de módulos (Introducción, Variables, Condicionales, Bucles)
  │     └── Acceso rápido a Mascota Cabra
  ├── 📚 Catálogo de Cursos (`/catalog`)
  │     ├── Curso Activo: "Lógica de Programación" -> [Entrar al curso]
  │     └── Próximamente: "Estructuras de Datos", "Modo Online Colaborativo"
  ├── 🗺️ Ruta de Progreso (`/roadmap`)
  │     └── Vista de hitos y lecciones completadas con reintento/repaso
  ├── 🐐 Mi Cabra (`/mascot`)
  │     └── Personalizador de mascota (colores, accesorios y guardar look)
  └── 👤 Perfil y Ajustes (`/profile`)
        ├── Estadísticas (Nivel, XP, Racha de días)
        ├── Medallero de logros desbloqueados
        └── Panel de Accesibilidad (Tamaño tipográfico A/A+/A++, Alto Contraste, Sonido)

Ruta modal / inmersiva:
  └── 📖 Visor de Lección (`/lesson/:lessonId`)
        ├── Barra de progreso de la lección
        ├── Panel de Teoría (Analogía sencilla explicada)
        ├── Panel de Ejemplo (Snippet de código legible)
        ├── Panel de Reto interactivo (Pregunta de opción o reto guiado)
        ├── Botón "Comprobar"
        └── Drawer/Modal inferior de Feedback (Explicación constructiva + Mascota cabra reaccionando)
```

## Journey principal: Descubrir, aprender y mantener el hábito diario

```text
[Inicio por primera vez] 
       │
       ▼
1. Pantalla de Bienvenida / Onboarding: "¿Cómo te llamas?" (Input accesible sin contraseñas).
       │
       ▼
2. Dashboard Principal: Saludo "¡Hola, [Nombre]! Bienvenido a GoatCode", racha en 0 días (icono de llama).
       │
       ▼
3. Clic en "Continuar curso: Lógica de Programación" o en el módulo actual ("Variables").
       │
       ▼
4. Pantalla de Lección inmersiva:
   a) Lee la Teoría ("Una variable es como una caja rotulada en un estante...").
   b) Observa el Ejemplo de código con tipografía clara y comentarios en español.
   c) Llega al Reto interactivo: "¿Qué valor contendrá la variable después de esta línea?".
       │
       ▼
5. Interacción del usuario: selecciona la opción "3" y pulsa "Comprobar respuesta".
       │
       ▼
6. Feedback Inmediato:
   - Si acierta: Banner verde cálido, explicación de por qué es correcto, la Cabra sonríe y salta de felicidad (+100 XP).
   - Si falla: Se descuenta 1 de sus 5 vidas (❤️). La cabra muestra expresión de aliento constructivo. Si le quedan vidas, puede pulsar "Intentar de nuevo". Si llega a 0 vidas, se presenta una pausa pedagógica con la cabra sorprendida y el contador de regeneración automática (1 cada 15 min), además de acceso a recarga de vidas.
       │
       ▼
7. Finalización de Lección:
   - Pantalla de celebración resumida.
   - Incremento de la racha diaria (+1 día en fuego) y cálculo del nuevo XP.
   - Botón claro: "Siguiente Lección" o "Volver al Dashboard".
```

## Journeys complementarios

### JRN-02: Adaptación de accesibilidad por un adulto mayor
1. El usuario siente que la tipografía por defecto es pequeña.
2. Navega al apartado **Perfil / Ajustes** desde la barra lateral o inferior.
3. En la sección "Accesibilidad", pulsa sobre el botón tipográfico `A+` (Grande) o `A++` (Extra Grande).
4. La interfaz recalcula dinámicamente el `fontSize` global en el tema de la aplicación sin desbordar los contenedores.
5. Si lo necesita, activa el switch "Alto contraste" para maximizar la visibilidad de los bordes y textos frente a los fondos oscuros.
6. La preferencia se almacena en memoria local y persiste entre recargas.

### JRN-03: Personalización de la Mascota Cabra
1. El usuario ingresa a la pestaña **Mi Cabra**.
2. Observa a su cabra en el podio central interactivo.
3. Modifica el color de pelaje o selecciona un estilo temático (ej. bufanda de estudiante o gafas).
4. Hace clic en "Guardar look".
5. Recibe una confirmación visual y al regresar al Dashboard o a las lecciones, su cabra refleja el nuevo aspecto seleccionado.

### JRN-04: Repaso de una lección superada
1. El usuario desea recordar cómo funcionaban los condicionales antes de pasar a bucles.
2. Abre la **Ruta de Progreso** (`/roadmap`) o el Dashboard.
3. Selecciona una lección ya completada (marcada con check verde).
4. La lección se abre en "Modo Repaso", permitiendo releer la teoría y el código sin alterar negativamente sus estadísticas de racha.

## Matriz de estados por pantalla

| Pantalla | Loading | Vacío | Error | Éxito / Contenido | Accesibilidad |
|---|---|---|---|---|---|
| **Dashboard** | Skeleton loader de cards y avatar | Estado inicial de bienvenida con racha 0 y botón destacado para primera lección | Mensaje amigable de fallo de almacenamiento local con botón "Reintentar" | Cards con progreso real, módulos con porcentaje y racha activa | Textos con `semanticsLabel`, escalado de fuentes hasta 1.5x, atajos de tabulador |
| **Catálogo** | Shimmer en tarjetas de cursos | No aplica (mínimo el curso de Lógica siempre presente) | Aviso visual si no carga el contenido estático | Tarjetas interactivas con estados "Disponible" y "Próximamente" | Contraste de badges superior a 4.5:1 |
| **Lección** | Indicador circular suave mientras parsea el contenido | Mensaje "Lección no encontrada" con botón seguro de volver al dashboard | Alerta de validación si no ha seleccionado ninguna respuesta al comprobar | Animación de acierto, explicación didáctica, avance de progreso | Opciones de respuesta como radio buttons accesibles con foco por teclado (Enter/Espacio) |
| **Mi Cabra** | Loader mientras decodifica el asset SVG/imagen | Cabra base por defecto cargada | Fallback a imagen de cabra estática estándar | Feedback "Look guardado con éxito" con sonido suave si está activado | Nombres legibles para cada color y opción de accesorio |
| **Perfil / Ajustes** | Shimmer en métricas | Sin logros desbloqueados: medallas en gris con texto "Completa tu primera lección para desbloquear" | Alerta si falla persistencia | Nivel, XP y medallas iluminadas con detalle emergente | Controles nativos accesibles (Sliders, SegmentedButtons, Switches) |

