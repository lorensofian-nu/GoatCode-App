import '../domain/lesson_models.dart';

class SampleLessons {
  SampleLessons._();

  static const List<Lesson> allLessons = [
    Lesson(
      id: 'intro_01',
      moduleId: 'm1_intro',
      moduleTitle: 'Módulo 1: Introducción a la Lógica',
      title: '¿Qué es programar?',
      analogyTitle: 'La analogía de la receta',
      analogyText: 'Programar no es magia ni matemáticas complejas: es como escribir una receta de cocina paso a paso. La computadora es un cocinero muy obediente que ejecuta exactamente las instrucciones en el orden en que las escribes.',
      codeSnippet: '// Paso 1: Hervir agua\n// Paso 2: Agregar café\n// Paso 3: Servir en la taza\nprepararCafe();',
      question: 'Si cambiamos el orden y servimos en la taza antes de hervir el agua, ¿qué ocurrirá?',
      choices: [
        LessonChoice(
          id: 'c1',
          text: 'El café no saldrá bien porque el orden de los pasos importa.',
        ),
        LessonChoice(
          id: 'c2',
          text:
              'La computadora adivina lo que querías hacer y lo arregla sola.',
        ),
        LessonChoice(id: 'c3', text: 'No importa el orden en un programa.'),
      ],
      correctChoiceIndex: 0,
      explanationSuccess: '¡Exacto! En programación, el orden secuencial de cada instrucción es fundamental para obtener el resultado correcto.',
      explanationFailure: 'Recuerda: la computadora ejecuta los pasos en orden estricto. Si cambias el orden, el resultado no será el esperado.',
      hint: 'Piensa en qué pasa si te pones los zapatos antes que las medias.',
    ),
    Lesson(
      id: 'variables_01',
      moduleId: 'm2_variables',
      moduleTitle: 'Módulo 2: Variables y Datos',
      title: '¿Qué es una Variable?',
      analogyTitle: 'La analogía de la caja con etiqueta',
      analogyText: 'Una variable es como una caja con nombre en la memoria de la computadora donde guardamos un dato para usarlo o cambiarlo más adelante mientras corre el programa.',
      codeSnippet:
          'let vidas = 3;\n\n// Mostramos el valor inicial\nmostrar(vidas);',
      question:
          '¿Qué valor tendrá la variable "vidas" al final de este ejemplo?',
      choices: [
        LessonChoice(id: 'a', text: 'A) 3'),
        LessonChoice(id: 'b', text: 'B) 2'),
        LessonChoice(id: 'c', text: 'C) 1'),
      ],
      correctChoiceIndex: 0,
      explanationSuccess: '¡Correcto! Guardamos el número 3 dentro de la caja llamada "vidas", y como nadie lo modificó, conserva el valor 3.',
      explanationFailure: 'Revisa el código: asignamos el número 3 a la variable "vidas" y no le restamos ningún valor.',
      hint: 'Mira la primera línea: let vidas = 3;',
    ),
    Lesson(
      id: 'variables_02',
      moduleId: 'm2_variables',
      moduleTitle: 'Módulo 2: Variables y Datos',
      title: 'Modificar una Variable',
      analogyTitle: 'Cambiando lo que hay en la caja',
      analogyText: 'El contenido de una variable no es fijo: podemos sacar el valor viejo y colocar uno nuevo en cualquier momento del juego o programa.',
      codeSnippet: 'let vidas = 3;\n\n// La cabra tropieza y pierde una vida\nvidas = vidas - 1;',
      question: '¿Cuántas vidas le quedan a la cabra tras esa línea de código?',
      choices: [
        LessonChoice(id: 'a', text: '3 vidas'),
        LessonChoice(id: 'b', text: '2 vidas'),
        LessonChoice(id: 'c', text: '0 vidas'),
      ],
      correctChoiceIndex: 1,
      explanationSuccess: '¡Perfecto! Tenías 3 vidas, le restaste 1, y ahora la caja "vidas" contiene el número 2.',
      explanationFailure: 'Hagamos la cuenta juntos: Tenías 3. La operación dice: vidas = 3 - 1. ¿Cuánto es 3 menos 1?',
      hint: 'Réstale 1 al número 3.',
    ),
    Lesson(
      id: 'conditionals_01',
      moduleId: 'm3_conditionals',
      moduleTitle: 'Módulo 3: Decisiones (Condicionales)',
      title: 'Tomando decisiones con "Si"',
      analogyTitle: 'El paraguas en día lluvioso',
      analogyText: 'En la vida cotidiana tomamos decisiones todo el tiempo: "Si está lloviendo, tomo el paraguas; si no, salgo con gafas de sol". En programación usamos la palabra "if" para evaluar si algo es verdadero o falso.',
      codeSnippet: 'let llueve = true;\n\nif (llueve) {\n  llevarParaguas();\n} else {\n  llevarGafasDeSol();\n}',
      question:
          'Dado que "llueve" es verdadero (true), ¿cuál acción se ejecutará?',
      choices: [
        LessonChoice(id: 'c1', text: 'llevarParaguas()'),
        LessonChoice(id: 'c2', text: 'llevarGafasDeSol()'),
        LessonChoice(id: 'c3', text: 'Ambas al mismo tiempo'),
      ],
      correctChoiceIndex: 0,
      explanationSuccess: '¡Excelente deducción! Como la condición "llueve" era verdadera, la computadora entró al primer bloque y ejecutó llevarParaguas().',
      explanationFailure: 'Observa que el bloque "else" (si no) solo se ejecuta cuando la condición es falsa (false).',
      hint: 'Verifica el valor de let llueve = true;',
    ),
    Lesson(
      id: 'loops_01',
      moduleId: 'm4_loops',
      moduleTitle: 'Módulo 4: Bucles (Repetición)',
      title: 'El bucle "Mientras" (while)',
      analogyTitle: 'Lavar platos mientras queden platos',
      analogyText: 'Un bucle permite repetir una acción automáticamente sin escribirla cien veces. Le decimos a la computadora: "Mientras queden platos por lavar, sigue lavando".',
      codeSnippet: 'let platosSucios = 2;\n\nwhile (platosSucios > 0) {\n  lavarPlato();\n  platosSucios = platosSucios - 1;\n}',
      question: '¿Cuántas veces se ejecutará la acción lavarPlato() antes de terminar?',
      choices: [
        LessonChoice(id: 'c1', text: '2 veces'),
        LessonChoice(id: 'c2', text: '100 veces'),
        LessonChoice(id: 'c3', text: 'Ninguna vez'),
      ],
      correctChoiceIndex: 0,
      explanationSuccess: '¡Muy bien! Se lava el primer plato (quedando 1), luego se lava el segundo (quedando 0), y el bucle termina porque ya no es mayor a 0.',
      explanationFailure: 'Empezamos con 2 platos sucios y en cada vuelta restamos 1. Al llegar a 0 platos, el bucle se detiene.',
      hint: 'Cuenta cuántas vueltas da hasta que platosSucios llegue a cero.',
    ),
  ];

  static Lesson? getLessonById(String id) {
    try {
      return allLessons.firstWhere((l) => l.id == id);
    } catch (_) {
      return null;
    }
  }

  static List<CourseModule> getModules(List<String> completedLessonIds) {
    return [
      CourseModule(
        id: 'm1_intro',
        title: 'Introducción a la Lógica',
        description: 'Aprende qué es un algoritmo y por qué el orden secuencial importa.',
        lessons: allLessons.where((l) => l.moduleId == 'm1_intro').toList(),
        isUnlocked: true,
      ),
      CourseModule(
        id: 'm2_variables',
        title: 'Variables y Datos',
        description: 'Aprende a guardar números y textos en la memoria de la computadora.',
        lessons: allLessons.where((l) => l.moduleId == 'm2_variables').toList(),
        isUnlocked: true,
      ),
      CourseModule(
        id: 'm3_conditionals',
        title: 'Condicionales y Decisiones',
        description: 'Enseña a tu programa a tomar decisiones basadas en preguntas lógicas.',
        lessons: allLessons
            .where((l) => l.moduleId == 'm3_conditionals')
            .toList(),
        isUnlocked: completedLessonIds.any((id) => id.startsWith('variables')),
      ),
      CourseModule(
        id: 'm4_loops',
        title: 'Bucles y Repeticiones',
        description:
            'Automatiza tareas repetitivas sin cansarte con el bucle mientras.',
        lessons: allLessons.where((l) => l.moduleId == 'm4_loops').toList(),
        isUnlocked: completedLessonIds.contains('conditionals_01'),
      ),
    ];
  }
}
