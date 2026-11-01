# Diseño de la experiencia de aprendizaje — Lógica de Programación

## Principios pedagógicos para adultos

1. **Analogías del mundo real antes de la sintaxis:** Un adulto comprende más rápido si relacionamos un concepto abstracto con algo tangible (ej. una variable es una caja etiquetada; una función es una receta con nombre).
2. **Microaprendizaje progresivo (Estilo SoloLearn):** Explicaciones de máximo 2 a 3 párrafos, seguidas inmediatamente de un ejemplo de código breve y una pregunta interactiva para fijar la atención.
3. **Sin ansiedad ni cronómetros:** No existen temporizadores regresivos ni penalizaciones por lentitud. El adulto puede releer cuantas veces requiera.
4. **Feedback formativo en lugar de punitivo:** Si se equivoca, no se pierden "vidas" que bloqueen el estudio. El sistema explica *por qué* la opción elegida no era la esperada y permite reintentar de inmediato con la ayuda de la cabra.
5. **Hábito diario y refuerzo positivo (Estilo Duolingo):** Cada lección superada suma racha diaria y XP, reforzando la sensación de progreso continuo y maestría observable.

## Mapa de competencias y syllabus del curso "Lógica de Programación"

| Módulo | Unidad | Concepto clave | Analogía intuitiva | Reto interactivo de práctica |
|---|---|---|---|---|
| **M1: Introducción** | 1.1 ¿Qué es un programa? | Algoritmo y secuencias | Una receta de cocina paso a paso | Ordenar 3 pasos lógicos para preparar un café |
| | 1.2 El orden importa | Ejecución secuencial | Seguir un mapa de navegación | Predecir qué instrucción se ejecuta primero |
| **M2: Variables y Datos** | 2.1 ¿Qué es una variable? (Wireframe 03) | Espacio en memoria con nombre | Una caja rotulada en un estante (`vidas = 3`) | ¿Qué valor tiene la caja 'vidas' al final? |
| | 2.2 Tipos de datos | Texto, Números y Booleanos | Etiquetas en frascos (número de teléfono vs mensaje vs interruptor ON/OFF) | Identificar si `"Hola"` es Texto o Número |
| | 2.3 Modificar variables | Reasignación de valores | Cambiar el contenido de la caja (`puntos = puntos + 10`) | Calcular el resultado tras sumar puntos |
| **M3: Decisiones (Condicionales)** | 3.1 El camino lógico | Condición booleana | "Si llueve, llevo paraguas; si no, salgo ligero" | ¿Qué ocurre si `temperatura > 30`? |
| | 3.2 La estructura `Si ... Sino` | `if ... else` | Un semáforo vehicular | Elegir el bloque de código que frena el auto en rojo |
| | 3.3 Comparadores | `>`, `<`, `==`, `!=` | Balanza de platos | ¿Es `5 > 10` Verdadero o Falso? |
| **M4: Repetición (Bucles)** | 4.1 Automatizar repeticiones | Bucle / Loop | Dar 5 saltos sin cansarse de escribir el código 5 veces | Predecir cuántas veces se imprime un mensaje |
| | 4.2 El bucle Mientras | `while (condición)` | Fregar platos mientras queden platos sucios | Identificar la condición de parada para no quedar atrapado |
| **M5: Funciones y Reutilización** | 5.1 Empaquetar instrucciones | Funciones / Métodos | El botón "Encender" de una máquina | Identificar la ventaja de agrupar código en una función |
| | 5.2 Parámetros y resultados | Entrada y salida | Una licuadora: ingresas fruta, obtienes jugo | ¿Qué devuelve `sumar(2, 3)`? |

## Estructura de cada lección (Modelo de datos estructurado)

Cada lección en GoatCode se define como un objeto estructurado inmutable, totalmente desacoplado de los widgets de presentación:

```dart
class Lesson {
  final String id;
  final String moduleId;
  final String title;
  final String analogyText;
  final String codeSnippet;
  final String questionText;
  final List<LessonChoice> choices;
  final int correctChoiceIndex;
  final String explanationSuccess;
  final String explanationFailure;
  final String hint;
  final int xpReward;
}
```

## Evaluación y progreso

- **Criterio de completado:** Una lección se considera completada únicamente cuando el estudiante responde correctamente la pregunta interactiva.
- **Cálculo de progreso modular:** Porcentaje de lecciones aprobadas sobre el total del módulo (ej. 1 de 2 lecciones = 50%, 2 de 2 = 100%).
- **Recompensas al completar:**
  - +100 XP por lección nueva.
  - Actualización de racha (+1 si es la primera lección del día calendario).
  - Verificación de logros desbloqueados (ej. Logro "Mente Lógica" tras el Módulo 1).
  - Estado de celebración con la Mascota Cabra en pose alegre (`references/goat/(5)`).

