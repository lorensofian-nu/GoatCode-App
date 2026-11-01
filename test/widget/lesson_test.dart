import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:goat_code/core/storage/local_storage_service.dart';
import 'package:goat_code/features/lesson/presentation/lesson_screen.dart';

void main() {
  testWidgets('LessonScreen renders theory, code, and evaluates answer', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: const MaterialApp(home: LessonScreen(lessonId: 'variables_01')),
      ),
    );

    // Verify Theory and Example
    expect(find.text('TEORÍA'), findsOneWidget);
    expect(find.text('EJEMPLO'), findsOneWidget);
    expect(find.text('¿Qué es una Variable?'), findsOneWidget);
    expect(
      find.text(
        '¿Qué valor tendrá la variable "vidas" al final de este ejemplo?',
      ),
      findsOneWidget,
    );

    // Select option A) 3
    final optionA = find.text('A) 3');
    expect(optionA, findsOneWidget);
    await tester.ensureVisible(optionA);
    await tester.tap(optionA);
    await tester.pump();

    // Tap Check answer button
    final checkButton = find.text('Comprobar respuesta');
    expect(checkButton, findsOneWidget);
    await tester.ensureVisible(checkButton);
    await tester.tap(checkButton);
    await tester.pump();

    // Verify feedback
    expect(find.text('¡Respuesta Correcta! (+100 XP)'), findsOneWidget);
  });

  testWidgets('LessonScreen handles incorrect answer and decrements life', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: const MaterialApp(home: LessonScreen(lessonId: 'variables_01')),
      ),
    );

    // Select incorrect option B) 5
    final optionB = find.text('B) 5');
    expect(optionB, findsOneWidget);
    await tester.ensureVisible(optionB);
    await tester.tap(optionB);
    await tester.pump();

    // Tap Check answer button
    final checkButton = find.text('Comprobar respuesta');
    await tester.ensureVisible(checkButton);
    await tester.tap(checkButton);
    await tester.pump();

    // Verify feedback shows life loss and remaining lives
    expect(find.text('Casi lo logras... (-1 Vida ❤️)'), findsOneWidget);
    expect(find.text('Te quedan 4 vidas.'), findsOneWidget);
    expect(find.text('Intentar de nuevo'), findsOneWidget);
  });
}
