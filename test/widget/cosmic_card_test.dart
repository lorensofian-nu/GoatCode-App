import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goat_code/core/theme/app_motion.dart';
import 'package:goat_code/core/widgets/cosmic_card.dart';

void main() {
  group('Motion UI and CosmicCard tests', () {
    test('AppMotion tokens have valid durations and curves', () {
      expect(AppMotion.durationMicro.inMilliseconds, equals(150));
      expect(AppMotion.durationMedium.inMilliseconds, equals(300));
      expect(AppMotion.durationMacro.inMilliseconds, equals(500));
      expect(AppMotion.durationCelebrate.inMilliseconds, equals(650));
      expect(AppMotion.durationBreathing.inMilliseconds, equals(2400));
      expect(AppMotion.durationPulsing.inMilliseconds, equals(1600));

      expect(AppMotion.curveEnter, equals(Curves.easeOutCubic));
      expect(AppMotion.curveBounce, equals(Curves.elasticOut));
    });

    testWidgets('CosmicCard renders child and triggers onTap callback', (
      tester,
    ) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CosmicCard(
              onTap: () => tapped = true,
              child: const Text('Cosmic Content'),
            ),
          ),
        ),
      );

      expect(find.text('Cosmic Content'), findsOneWidget);

      await tester.tap(find.text('Cosmic Content'));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('CosmicCard renders in Matte Obsidian mode without BackdropFilter', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CosmicCard(
              enableGlassEffect: false,
              child: Text('Matte Obsidian Content'),
            ),
          ),
        ),
      );

      expect(find.text('Matte Obsidian Content'), findsOneWidget);
      expect(find.byType(BackdropFilter), findsNothing);
    });

    testWidgets('CosmicCard renders in Frosted Glass mode with BackdropFilter', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CosmicCard(
              enableGlassEffect: true,
              child: Text('Frosted Glass Content'),
            ),
          ),
        ),
      );

      expect(find.text('Frosted Glass Content'), findsOneWidget);
      expect(find.byType(BackdropFilter), findsOneWidget);
    });
  });
}
