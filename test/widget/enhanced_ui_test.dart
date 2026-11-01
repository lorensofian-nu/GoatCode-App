import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goat_code/core/audio/sound_service.dart';
import 'package:goat_code/core/widgets/code_snippet_block.dart';
import 'package:goat_code/core/widgets/cosmic_background.dart';
import 'package:goat_code/core/widgets/mascot_speech_bubble.dart';
import 'package:goat_code/core/widgets/mascot_streak_aura.dart';
import 'package:goat_code/core/theme/app_typography.dart';
import 'package:goat_code/features/lesson/presentation/widgets/interactive_memory_visualizer.dart';
import 'package:goat_code/features/lesson/presentation/widgets/reading_progress_bar.dart';

void main() {
  group('Enhanced UI widgets tests', () {
    testWidgets('CodeSnippetBlock renders syntax-highlighted code with line numbers', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CodeSnippetBlock(
              code: 'var x = 10;\nprint(x);',
              title: 'Snippet Test',
            ),
          ),
        ),
      );

      expect(find.text('Snippet Test'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('Copiar'), findsOneWidget);
    });

    testWidgets('MascotSpeechBubble renders title and message', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MascotSpeechBubble(
              title: 'Consejo',
              text: 'Aprende paso a paso.',
            ),
          ),
        ),
      );

      expect(find.text('Consejo'), findsOneWidget);
      expect(find.text('Aprende paso a paso.'), findsOneWidget);
    });

    testWidgets('InteractiveMemoryVisualizer renders steps and advances', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: InteractiveMemoryVisualizer(
                code: 'var vidas = 3;\nvidas = vidas - 1;\nprint(vidas);',
                lessonId: 'variables_01',
              ),
            ),
          ),
        ),
      );

      expect(find.text('Simulación en Vivo • Paso a Paso'), findsOneWidget);
      expect(find.text('Paso 1 de 3'), findsOneWidget);
      expect(find.text('Siguiente paso'), findsOneWidget);

      await tester.tap(find.text('Siguiente paso'));
      await tester.pump();

      expect(find.text('Paso 2 de 3'), findsOneWidget);
    });

    testWidgets('CosmicBackground renders child content cleanly', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CosmicBackground(
              child: Text('Cosmic Starship'),
            ),
          ),
        ),
      );

      expect(find.text('Cosmic Starship'), findsOneWidget);
    });

    testWidgets('ReadingProgressBar renders with correct semantics and bounds', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ReadingProgressBar(progress: 0.5),
          ),
        ),
      );

      expect(
        find.bySemanticsLabel('Progreso de lectura de la lección: 50%'),
        findsOneWidget,
      );
    });

    testWidgets('MascotStreakAura renders appropriate tier badges based on streak days', (
      tester,
    ) async {
      // Test Tier 1: Cosmic
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MascotStreakAura(
              streak: 1,
              child: Icon(Icons.pets),
            ),
          ),
        ),
      );
      expect(find.text('1 d • Aura Cósmica'), findsOneWidget);

      // Test Tier 2: Fire
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MascotStreakAura(
              streak: 5,
              child: Icon(Icons.pets),
            ),
          ),
        ),
      );
      expect(find.text('5 d • Aura de Fuego'), findsOneWidget);

      // Test Tier 3: Solar
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MascotStreakAura(
              streak: 10,
              child: Icon(Icons.pets),
            ),
          ),
        ),
      );
      expect(find.text('10 d • Aura Solar'), findsOneWidget);
    });

    test('SoundService executes methods without throwing exceptions', () {
      expect(
        () => SoundService.playSuccess(soundEnabled: true),
        returnsNormally,
      );
      expect(
        () => SoundService.playError(soundEnabled: true),
        returnsNormally,
      );
      expect(
        () => SoundService.playStreak(soundEnabled: false),
        returnsNormally,
      );
    });

    test('AppTypography has protective contrast text shadows', () {
      expect(AppTypography.contrastShadow, isNotEmpty);
      expect(AppTypography.subtleContrastShadow, isNotEmpty);

      final heading = AppTypography.headingLarge(1.0);
      expect(heading.shadows, isNotNull);
      expect(heading.shadows!.length, greaterThanOrEqualTo(1));

      final body = AppTypography.body(1.0);
      expect(body.shadows, isNotNull);
      expect(body.shadows!.length, greaterThanOrEqualTo(1));
    });
  });
}
