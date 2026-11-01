import '../domain/lesson_models.dart';

class SampleLessons {
  SampleLessons._();

  static const List<Lesson> allLessons = [
    // ==================== MÓDULO 1: INTRODUCCIÓN A LA LÓGICA ====================
    Lesson(
      id: 'intro_01',
      moduleId: 'm1_intro',
      moduleTitle: 'Módulo 1: Introducción a la Lógica',
      title: '¿Qué es programar?',
      analogyTitle: 'La analogía de la receta de cocina',
      analogyText: 'Programar no requiere matemáticas complejas: es como redactar una receta de cocina paso a paso. La computadora es un asistente muy obediente que ejecuta al pie de la letra cada instrucción en el orden exacto en que la escribes.',
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
      explanationSuccess: '¡Exacto! En programación, la computadora no adivina intenciones: sigue estrictamente el orden secuencial.',
      explanationFailure: 'Recuerda: la computadora ejecuta los pasos en orden lineal. Si alteras el orden, el resultado falla.',
      hint: 'Piensa en qué pasa si te pones los zapatos antes de las medias.',
    ),
    Lesson(
      id: 'intro_02',
      moduleId: 'm1_intro',
      moduleTitle: 'Módulo 1: Introducción a la Lógica',
      title: 'El orden secuencial',
      analogyTitle: 'La rutina de la mañana',
      analogyText: 'En el mundo real, vestirte para salir tiene una secuencia lógica obligatoria. Un programa ejecuta sus líneas desde la primera hasta la última, una por una.',
      codeSnippet:
          'ponerseMedias();\nponerseZapatos();\nabrirPuerta();\nsalirDeCasa();',
      question: '¿Cuál instrucción se ejecutará en segundo lugar?',
      choices: [
        LessonChoice(id: 'c1', text: 'ponerseMedias()'),
        LessonChoice(id: 'c2', text: 'ponerseZapatos()'),
        LessonChoice(id: 'c3', text: 'salirDeCasa()'),
      ],
      correctChoiceIndex: 1,
      explanationSuccess: '¡Correcto! La computadora lee de arriba hacia abajo: primero se pone las medias y en segundo lugar los zapatos.',
      explanationFailure: 'Cuenta las líneas desde arriba: línea 1 es ponerseMedias(), línea 2 es ponerseZapatos().',
      hint: 'Observa la segunda línea del código.',
    ),

    // ==================== MÓDULO 2: VARIABLES Y DATOS ====================
    Lesson(
      id: 'variables_01',
      moduleId: 'm2_variables',
      moduleTitle: 'Módulo 2: Variables y Datos',
      title: '¿Qué es una Variable?',
      analogyTitle: 'La caja con etiqueta en el estante',
      analogyText: 'Una variable es como una caja rotulada en la memoria donde guardamos un dato para consultarlo o modificarlo más adelante mientras la aplicación funciona.',
      codeSnippet:
          'let vidas = 3;\n\n// Mostramos el valor inicial\nmostrar(vidas);',
      question:
          '¿Qué valor tendrá la variable "vidas" al final de este ejemplo?',
      choices: [
        LessonChoice(id: 'a', text: 'A) 3'),
        LessonChoice(id: 'b', text: 'B) 2'),
        LessonChoice(id: 'c', text: 'C) 0'),
      ],
      correctChoiceIndex: 0,
      explanationSuccess: '¡Muy bien! Guardamos el número 3 en la caja llamada "vidas", y como ninguna otra línea la alteró, conserva el 3.',
      explanationFailure: 'Revisa el código: asignamos el número 3 a "vidas" y no le restamos ningún valor.',
      hint: 'Mira la primera línea: let vidas = 3;',
    ),
    Lesson(
      id: 'variables_02',
      moduleId: 'm2_variables',
      moduleTitle: 'Módulo 2: Variables y Datos',
      title: 'Modificar una Variable',
      analogyTitle: 'Cambiando lo que hay en la caja',
      analogyText: 'El contenido de una variable no es permanente: podemos sacar el valor viejo y colocar uno nuevo en cualquier momento de la partida.',
      codeSnippet: 'let vidas = 3;\n\n// La cabra tropieza y pierde una vida\nvidas = vidas - 1;',
      question: '¿Cuántas vidas le quedan a la cabra tras esa línea de código?',
      choices: [
        LessonChoice(id: 'a', text: '3 vidas'),
        LessonChoice(id: 'b', text: '2 vidas'),
        LessonChoice(id: 'c', text: '0 vidas'),
      ],
      correctChoiceIndex: 1,
      explanationSuccess: '¡Perfecto! Tenías 3 vidas, le restaste 1 y ahora la caja "vidas" guarda el número 2.',
      explanationFailure: 'Hagamos la cuenta juntos: Tenías 3. La operación dice: vidas = 3 - 1. ¿Cuánto es 3 menos 1?',
      hint: 'Réstale 1 al número 3 inicial.',
    ),
    Lesson(
      id: 'variables_03',
      moduleId: 'm2_variables',
      moduleTitle: 'Módulo 2: Variables y Datos',
      title: 'Tipos de Datos Básicos',
      analogyTitle: 'Etiquetas de diferentes tipos',
      analogyText: 'No todos los datos son iguales: un nombre es Texto (entre comillas), una edad es un Número entero, y un interruptor es Booleano (verdadero o falso).',
      codeSnippet: 'let nombre = "Goat";   // Texto (String)\nlet nivel = 5;          // Número (Number)\nlet activo = true;      // Booleano (Boolean)',
      question: '¿Cuál de estas variables almacena un tipo de dato Texto?',
      choices: [
        LessonChoice(
          id: 'c1',
          text: 'nombre (porque está entre comillas "Goat")',
        ),
        LessonChoice(id: 'c2', text: 'nivel (porque vale 5)'),
        LessonChoice(id: 'c3', text: 'activo (porque es true)'),
      ],
      correctChoiceIndex: 0,
      explanationSuccess: '¡Excelente! Todo valor rodeado de comillas (como "Goat") es interpretado por la computadora como Texto.',
      explanationFailure: 'Fíjate en las comillas: los textos siempre se escriben entre comillas como "Goat".',
      hint: 'Los textos van envueltos en comillas dobles o simples.',
    ),

    // ==================== MÓDULO 3: CONDICIONALES Y DECISIONES ====================
    Lesson(
      id: 'conditionals_01',
      moduleId: 'm3_conditionals',
      moduleTitle: 'Módulo 3: Decisiones (Condicionales)',
      title: 'Tomando decisiones con "Si"',
      analogyTitle: 'El paraguas en día lluvioso',
      analogyText: 'En la vida cotidiana decidimos según condiciones: "Si está lloviendo, tomo el paraguas; si no, salgo con gafas de sol". En código usamos "if" para evaluar si una condición es verdadera.',
      codeSnippet: 'let llueve = true;\n\nif (llueve) {\n  llevarParaguas();\n} else {\n  llevarGafasDeSol();\n}',
      question:
          'Dado que "llueve" es verdadero (true), ¿cuál acción se ejecutará?',
      choices: [
        LessonChoice(id: 'c1', text: 'llevarParaguas()'),
        LessonChoice(id: 'c2', text: 'llevarGafasDeSol()'),
        LessonChoice(id: 'c3', text: 'Ambas acciones a la vez'),
      ],
      correctChoiceIndex: 0,
      explanationSuccess: '¡Gran deducción! Como "llueve" es verdadero, la computadora entra al primer bloque y ejecuta llevarParaguas().',
      explanationFailure: 'El bloque "else" (sino) solo se activa si la condición fuera falsa (false).',
      hint: 'Revisa la primera línea: let llueve = true;',
    ),
    Lesson(
      id: 'conditionals_02',
      moduleId: 'm3_conditionals',
      moduleTitle: 'Módulo 3: Decisiones (Condicionales)',
      title: 'La bifurcación con "Sino" (else)',
      analogyTitle: 'El semáforo de tránsito',
      analogyText: 'Cuando una condición no se cumple, el bloque "else" ofrece el camino alternativo garantizado.',
      codeSnippet: 'let semaforo = "rojo";\n\nif (semaforo == "verde") {\n  avanzar();\n} else {\n  frenar();\n}',
      question:
          'Con el semáforo en "rojo", ¿qué instrucción ejecutará el vehículo?',
      choices: [
        LessonChoice(id: 'c1', text: 'avanzar()'),
        LessonChoice(id: 'c2', text: 'frenar()'),
        LessonChoice(id: 'c3', text: 'El programa se apaga'),
      ],
      correctChoiceIndex: 1,
      explanationSuccess: '¡Exacto! "rojo" no es igual a "verde", por lo que la condición falla y salta directamente al bloque else: frenar().',
      explanationFailure: 'Compara: ¿Es "rojo" igual a "verde"? No, por lo tanto entra al camino alternativo (else).',
      hint: 'Si la condición del if es falsa, el programa ejecuta el else.',
    ),
    Lesson(
      id: 'conditionals_03',
      moduleId: 'm3_conditionals',
      moduleTitle: 'Módulo 3: Decisiones (Condicionales)',
      title: 'Comparadores numéricos (> y <)',
      analogyTitle: 'El control de equipaje en el aeropuerto',
      analogyText: 'Las computadoras son expertas comparando números con operadores como mayor que (>) o menor que (<).',
      codeSnippet: 'let pesoMaleta = 25;\nlet limitePermitido = 23;\n\nif (pesoMaleta > limitePermitido) {\n  cobrarSobrepeso();\n} else {\n  embarcarNormal();\n}',
      question: 'Si la maleta pesa 25 kg y el límite es 23 kg, ¿qué ocurrirá?',
      choices: [
        LessonChoice(id: 'c1', text: 'cobrarSobrepeso()'),
        LessonChoice(id: 'c2', text: 'embarcarNormal()'),
        LessonChoice(id: 'c3', text: 'La maleta se descarta'),
      ],
      correctChoiceIndex: 0,
      explanationSuccess: '¡Correcto! 25 es mayor que 23, por lo que la condición (25 > 23) es verdadera y se cobra sobrepeso.',
      explanationFailure: 'Comprueba los números: ¿Es 25 mayor que 23? Sí, por ende se cumple la condición.',
      hint: '¿Es 25 > 23 verdadero o falso?',
    ),

    // ==================== MÓDULO 4: BUCLES Y REPETICIONES ====================
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
      explanationSuccess: '¡Muy bien! Se lava el primer plato (queda 1), se lava el segundo (queda 0), y el bucle termina porque 0 ya no es mayor a 0.',
      explanationFailure: 'Empezamos con 2 platos sucios y en cada vuelta restamos 1. Al llegar a 0 platos, el bucle se detiene.',
      hint: 'Cuenta cuántas vueltas da hasta que platosSucios llegue a cero.',
    ),
    Lesson(
      id: 'loops_02',
      moduleId: 'm4_loops',
      moduleTitle: 'Módulo 4: Bucles (Repetición)',
      title: 'El bucle con contador (for)',
      analogyTitle: 'Las repeticiones en el gimnasio',
      analogyText: 'Cuando sabemos de antemano cuántas veces queremos repetir algo (ej. 3 series de saltos), el bucle "for" cuenta automáticamente por nosotros.',
      codeSnippet: 'for (let salto = 1; salto <= 3; salto = salto + 1) {\n  saltarCabra();\n}',
      question: '¿Cuántos saltos dará la cabra en total?',
      choices: [
        LessonChoice(id: 'c1', text: '1 salto'),
        LessonChoice(id: 'c2', text: '3 saltos (con salto = 1, 2 y 3)'),
        LessonChoice(id: 'c3', text: 'Infinitos saltos'),
      ],
      correctChoiceIndex: 1,
      explanationSuccess: '¡Excelente! El contador inicia en 1 y se incrementa en cada vuelta hasta llegar a 3, realizando exactamente 3 saltos.',
      explanationFailure: 'Revisa la condición: el bucle corre mientras salto <= 3. Da vueltas para 1, para 2 y para 3.',
      hint: 'Cuenta los números enteros del 1 al 3 inclusive.',
    ),
    Lesson(
      id: 'loops_03',
      moduleId: 'm4_loops',
      moduleTitle: 'Módulo 4: Bucles (Repetición)',
      title: 'Evitar el bucle infinito',
      analogyTitle: 'El carrusel sin botón de apagado',
      analogyText: 'Si un bucle nunca cambia su condición para volverse falsa, se ejecutará para siempre y congelará el programa. Siempre debemos asegurar una salida.',
      codeSnippet: 'let energia = 5;\n\nwhile (energia > 0) {\n  correr();\n  // ¡Olvidamos restar energia!\n}',
      question: 'Si "energia" nunca disminuye y se queda en 5, ¿qué le ocurrirá al programa?',
      choices: [
        LessonChoice(
          id: 'c1',
          text: 'Se detendrá tras 5 minutos automáticamente.',
        ),
        LessonChoice(
          id: 'c2',
          text: 'Entrará en un bucle infinito porque energia siempre será mayor a 0.',
        ),
        LessonChoice(id: 'c3', text: 'El programa aumentará la energía a 10.'),
      ],
      correctChoiceIndex: 1,
      explanationSuccess: '¡Exacto! Como energia sigue valiendo 5, la condición 5 > 0 nunca deja de ser verdadera, causando un bucle infinito.',
      explanationFailure: 'La computadora no sabe cansarse: si la condición nunca cambia a falso, sigue ejecutando el bucle sin parar.',
      hint: 'Si no hay resta, ¿alguna vez llegará energía a 0?',
    ),

    // ==================== MÓDULO 5: FUNCIONES Y REUTILIZACIÓN ====================
    Lesson(
      id: 'functions_01',
      moduleId: 'm5_functions',
      moduleTitle: 'Módulo 5: Funciones y Modularidad',
      title: '¿Qué es una Función?',
      analogyTitle: 'El botón de la cafetera automática',
      analogyText: 'Una función es un bloque de código con nombre que empaqueta varias instrucciones. En lugar de escribir los 10 pasos para hacer café cada vez, simplemente presionas el botón "hacerCafe()".',
      codeSnippet: 'function prepararDesayuno() {\n  tostarPan();\n  servirJugo();\n}\n\n// Podemos usarla todas las mañanas:\nprepararDesayuno();\nprepararDesayuno();',
      question:
          '¿Cuál es la principal ventaja de empaquetar código en una función?',
      choices: [
        LessonChoice(
          id: 'c1',
          text: 'Reutilizar el mismo bloque de código sin tener que reescribirlo cada vez.',
        ),
        LessonChoice(
          id: 'c2',
          text: 'Hace que el código sea más difícil de entender.',
        ),
        LessonChoice(
          id: 'c3',
          text: 'Las funciones solo pueden ejecutarse una sola vez.',
        ),
      ],
      correctChoiceIndex: 0,
      explanationSuccess: '¡Brillante! Las funciones nos permiten ahorrar tiempo, evitar duplicar líneas y mantener el código limpio y modular.',
      explanationFailure: 'La regla de oro de un programador es "no te repitas". Una función permite escribir el trabajo una vez y usarlo cien veces.',
      hint: 'Piensa en qué beneficio tiene guardar un contacto en el celular en lugar de marcar los 10 dígitos cada vez.',
    ),
    Lesson(
      id: 'functions_02',
      moduleId: 'm5_functions',
      moduleTitle: 'Módulo 5: Funciones y Modularidad',
      title: 'Parámetros y Retorno',
      analogyTitle: 'La licuadora: ingredientes y resultado',
      analogyText: 'Las funciones pueden recibir datos de entrada (parámetros) y devolver un resultado procesado (retorno). Es como meter frutas a la licuadora y obtener un jugo fresco.',
      codeSnippet: 'function calcularTotal(precio, cantidad) {\n  return precio * cantidad;\n}\n\nlet total = calcularTotal(10, 3);',
      question: 'Si pasamos precio = 10 y cantidad = 3, ¿qué valor devolverá la función y guardará en "total"?',
      choices: [
        LessonChoice(id: 'c1', text: '13 (sumó los números)'),
        LessonChoice(id: 'c2', text: '30 (multiplicó 10 * 3)'),
        LessonChoice(id: 'c3', text: '10 (solo devolvió el precio)'),
      ],
      correctChoiceIndex: 1,
      explanationSuccess: '¡Extraordinario! La función multiplicó el precio (10) por la cantidad (3) y retornó 30. ¡Has dominado los fundamentos de la lógica de programación!',
      explanationFailure: 'Fíjate en la operación dentro de la función: return precio * cantidad. El asterisco (*) significa multiplicación: 10 por 3.',
      hint: 'Multiplica 10 por 3.',
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
    final m1Lessons = allLessons
        .where((l) => l.moduleId == 'm1_intro')
        .toList();
    final m2Lessons = allLessons
        .where((l) => l.moduleId == 'm2_variables')
        .toList();
    final m3Lessons = allLessons
        .where((l) => l.moduleId == 'm3_conditionals')
        .toList();
    final m4Lessons = allLessons
        .where((l) => l.moduleId == 'm4_loops')
        .toList();
    final m5Lessons = allLessons
        .where((l) => l.moduleId == 'm5_functions')
        .toList();

    final hasCompletedM1 = completedLessonIds.any(
      (id) => id.startsWith('intro_'),
    );
    final hasCompletedM2 = completedLessonIds.any(
      (id) => id.startsWith('variables_'),
    );
    final hasCompletedM3 = completedLessonIds.any(
      (id) => id.startsWith('conditionals_'),
    );
    final hasCompletedM4 = completedLessonIds.any(
      (id) => id.startsWith('loops_'),
    );

    return [
      CourseModule(
        id: 'm1_intro',
        title: 'Módulo 1: Introducción a la Lógica',
        description: 'Descubre qué es un algoritmo y por qué el orden secuencial de cada paso es vital.',
        lessons: m1Lessons,
        isUnlocked: true,
      ),
      CourseModule(
        id: 'm2_variables',
        title: 'Módulo 2: Variables y Datos',
        description: 'Aprende a almacenar, nombrar y transformar textos, números y booleanos en la memoria.',
        lessons: m2Lessons,
        isUnlocked: true,
      ),
      CourseModule(
        id: 'm3_conditionals',
        title: 'Módulo 3: Decisiones (Condicionales)',
        description: 'Enseña a tu programa a tomar caminos lógicos inteligentes con si/sino y comparadores.',
        lessons: m3Lessons,
        isUnlocked: hasCompletedM1 || hasCompletedM2,
      ),
      CourseModule(
        id: 'm4_loops',
        title: 'Módulo 4: Bucles y Repeticiones',
        description: 'Automatiza tareas repetitivas con los bucles mientras (while) y con contador (for).',
        lessons: m4Lessons,
        isUnlocked: hasCompletedM3,
      ),
      CourseModule(
        id: 'm5_functions',
        title: 'Módulo 5: Funciones y Modularidad',
        description: 'Empaqueta tus instrucciones en bloques reutilizables con parámetros y resultados.',
        lessons: m5Lessons,
        isUnlocked: hasCompletedM4,
      ),
    ];
  }
}
