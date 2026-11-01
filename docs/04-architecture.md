# Arquitectura técnica — GoatCode

## Estado

`APPROVED` — Decisiones de alto impacto formalmente aprobadas por el usuario el 2026-10-31.

## Contexto y restricciones

- **Cliente objetivo:** Flutter Web (optimizado para navegadores modernos).
- **Entorno de ejecución:** 100 % Offline en fase inicial. Sin backend remoto, sin base de datos en la nube y sin APIs externas llamadas en tiempo de ejecución del navegador.
- **Identificación:** Usuario local sin contraseña (solo nombre en almacenamiento local del navegador).
- **Assets:** Generación y normalización externa privada mediante script local con Gemini API / Nano Banana. Flutter Web consume únicamente ficheros estáticos ya aprobados y empaquetados en `assets/`.
- **Target Audience:** Adultos aprendiendo lógica desde cero (requiere separación clara entre modelos de lecciones pedagógicas y la interfaz gráfica).

## Diagrama de arquitectura lógica (Feature-First)

```text
┌────────────────────────────────────────────────────────────────────────┐
│                          FLUTTER WEB SHELL                             │
│       (Adaptive Layout: NavigationRail / BottomNavigationBar)          │
│                    (Theme, Responsive, Accessibility)                  │
└───────────────────────────────────┬────────────────────────────────────┘
                                    │
    ┌───────────────────────────────┼───────────────────────────────┐
    │                               │                               │
┌───▼─────────────────┐   ┌─────────▼───────────┐   ┌───────────────▼───────────┐
│     dashboard       │   │       lesson        │   │     profile & mascot      │
│  - User greeting    │   │  - Theory card      │   │  - XP & Streak counters   │
│  - Active course    │   │  - Code snippet     │   │  - Achievements badges    │
│  - Modules roadmap  │   │  - Quiz & Challenge │   │  - Accessibility settings │
│  - Streak indicator │   │  - Friendly feedback│   │  - Goat customization     │
└───┬─────────────────┘   └─────────┬───────────┘   └───────────────┬───────────┘
    │                               │                               │
    └───────────────────────────────┼───────────────────────────────┘
                                    │
┌───────────────────────────────────▼────────────────────────────────────┐
│                           CORE DOMAIN & DATA                           │
│  - LessonEngine (Evaluador pedagógico, reintentos, explicaciones)     │
│  - StreakService (Cálculo de días consecutivos y protección)           │
│  - UserProfileRepository (Nombre, XP, Nivel, Logros, Skin cabra)       │
│  - AccessibilityService (Escala tipográfica, contraste)               │
└───────────────────────────────────┬────────────────────────────────────┘
                                    │
┌───────────────────────────────────▼────────────────────────────────────┐
│                   OFFLINE LOCAL STORAGE (IndexedDB / Web)              │
│       - SharedPreferences / JSON Serialized Storage                    │
└────────────────────────────────────────────────────────────────────────┘

[Herramienta externa de desarrollo — Fuera del bundle web]
┌────────────────────────────────────────────────────────────────────────┐
│               TOOLS: PRIVATE GEMINI ASSET PIPELINE                     │
│  - Script local Node.js / Dart CLI                                     │
│  - Lee GEMINI_API_KEY desde .env local privado                         │
│  - Genera assets (Nano Banana / Gemini 2.0 Flash)                      │
│  - Guarda en assets/generated/ y actualiza docs/06-asset-manifest.csv  │
└────────────────────────────────────────────────────────────────────────┘
```

## Comparativa de alternativas y decisiones arquitectónicas (ADRs)

### ADR-001: Gestión de estado
- **Alternativa 1 — Flutter estándar (`ChangeNotifier` / `ValueNotifier` con Provider):** Muy bajo overhead, fácil de entender, pero puede volverse disperso si el estado de lecciones se complejiza.
- **Alternativa 2 — BLoC / Cubit:** Alta predictibilidad basada en eventos y streams, excelente para pruebas, pero genera boilerplate considerable para una aplicación offline de tamaño medio.
- **Alternativa 3 — Riverpod (`flutter_riverpod`):** Inyección de dependencias segura en tiempo de compilación, cero dependencia de `BuildContext` para la lógica de dominio, excelente soporte para testing unitario y desacoplamiento limpio del estado reactivo de accesibilidad, racha y lecciones.
- **Recomendación:** **`flutter_riverpod`**. Permite modularizar la lógica de negocio por características (feature-first) y realizar pruebas unitarias inmediatas sin montar árboles de widgets.
- **Estado:** `APPROVED` (Aprobado el 2026-10-31).

### ADR-002: Estrategia de routing y navegación
- **Alternativa 1 — Navigator 1.0 básico (`Navigator.push`):** Simple pero no soporta URLs declarativas en Flutter Web, ni refresco de pantalla sin perder la ruta actual.
- **Alternativa 2 — `go_router` (Recomendado oficial Flutter):** Soporte completo para URLs web limpias (`/dashboard`, `/catalog`, `/lesson/variables_01`), redirecciones automáticas (ej. si no ha ingresado su nombre, redirigir a `/onboarding`), historial de navegación del navegador (flechas atrás/adelante) y subrutas anidadas con shell responsive.
- **Recomendación:** **`go_router`**.
- **Estado:** `APPROVED` (Aprobado el 2026-10-31).

### ADR-003: Persistencia local offline (Web)
- **Alternativa 1 — `shared_preferences`:** Almacena pares clave-valor respaldados por `localStorage` / `IndexedDB` en Flutter Web. Muy estable, cero dependencias nativas complejas, ideal para perfiles, configuraciones, rachas y progreso estructurado en JSON.
- **Alternativa 2 — `hive_ce` / Hive:** Base de datos NoSQL rápida en disco/IndexedDB, pero añade complejidad de adaptadores y serialización binaria innecesaria para el volumen de datos de este MVP.
- **Alternativa 3 — SQLite (`sqflite_common_ffi_web`):** Excesivamente pesado para web; requiere cargar binarios WebAssembly adicionales.
- **Recomendación:** **`shared_preferences`** con serialización de entidades a JSON. Es ligero, ultraconfiable en web, instantáneo y sin fricciones de compilación.
- **Estado:** `APPROVED` (Aprobado el 2026-10-31).

### ADR-004: Autenticación y privacidad
- **Alternativa 1 — Sin autenticación / solo nombre de usuario local:** El usuario simplemente escribe su nombre o apodo al ingresar por primera vez. Se almacena localmente en el navegador. Cero recolección de datos personales, máxima privacidad, 100% offline.
- **Alternativa 2 — Auth gestionada (Firebase / Supabase):** Viola la restricción de 100% offline y añade dependencias de red y coste.
- **Recomendación:** **Solo nombre de usuario local (100% offline)** según lo estipulado en `MASTER_PROMPT.md`.
- **Estado:** `APPROVED` (Aprobado el 2026-10-31).

### ADR-005: Pipeline de assets visuales
- **Alternativa 1 — Llamada en runtime a Gemini desde Flutter Web:** Inaceptable. Expondría la `GEMINI_API_KEY` en el bundle de cliente JavaScript/Wasm de cualquier visitante.
- **Alternativa 2 — Pipeline local privado desacoplado:** Script privado (Node.js o Dart CLI) en `tools/asset_pipeline/` que invoca la API de Gemini usando la clave privada de `.env` local, normaliza el asset generado, lo versiona en `assets/generated/` y lo registra en `docs/06-asset-manifest.csv`. La app Flutter solo consume assets locales precompilados.
- **Recomendación:** **Pipeline local privado desacoplado**.
- **Estado:** `APPROVED` (Aprobado el 2026-10-31).


## Estructura física del código (`lib/`)

```text
lib/
├── app/
│   ├── app.dart                   # MaterialApp.router configurado con tema y accesibilidad
│   ├── router/
│   │   └── app_router.dart        # Configuración de go_router y guards de onboarding
│   └── theme/
│       ├── app_colors.dart        # Tokens cósmicos y colores de acento
│       ├── app_typography.dart    # Escala tipográfica adaptativa
│       └── app_theme.dart         # ThemeData con soporte de alto contraste y escalado
├── core/
│   ├── constants/                 # Claves de almacenamiento y assets
│   ├── responsive/
│   │   ├── responsive_layout.dart # Breakpoint detector (Compact, Medium, Expanded)
│   │   └── adaptive_scaffold.dart # Shell con NavigationRail / NavigationBar
│   └── storage/
│       └── local_storage_service.dart # Abstracción de persistencia local
├── features/
│   ├── onboarding/                # Pantalla inicial de bienvenida y captura de nombre
│   ├── dashboard/                 # Hub de inicio, racha actual, módulos
│   ├── catalog/                   # Catálogo de cursos disponibles y futuros
│   ├── roadmap/                   # Mapa visual de hitos y progreso
│   ├── lesson/                    # Motor de lección: teoría, código, práctica, feedback
│   │   ├── data/                  # Repositorio de lecciones estáticas (JSON / modelos)
│   │   ├── domain/                # Entidades: Lesson, TheorySection, Exercise, Choice
│   │   └── presentation/          # Widgets de lección, bloque de código y feedback modal
│   ├── mascot/                    # Personalización de la cabra y estados de ánimo
│   └── profile/                   # Estadísticas, medallas y controles de accesibilidad
└── main.dart                      # Punto de entrada de la aplicación
```

