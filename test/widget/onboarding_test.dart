import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:goat_code/core/storage/local_storage_service.dart';
import 'package:goat_code/features/onboarding/presentation/onboarding_screen.dart';

void main() {
  testWidgets(
    'OnboardingScreen displays welcoming message and validates input',
    (tester) async {
      tester.view.physicalSize = const Size(1280, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
          child: const MaterialApp(home: OnboardingScreen()),
        ),
      );

      expect(find.text('¡Bienvenido a GoatCode!'), findsOneWidget);
      expect(find.text('¿Cómo te gustaría que te llamemos?'), findsOneWidget);

      // Tap submit with empty field
      final button = find.text('Comenzar mi aprendizaje');
      expect(button, findsOneWidget);
      await tester.ensureVisible(button);
      await tester.tap(button);
      await tester.pump();

      // Verify error text
      expect(
        find.text('Por favor escribe tu nombre o apodo para saludarte.'),
        findsOneWidget,
      );

      // Enter name
      await tester.enterText(find.byType(TextField), 'Elena');
      await tester.pump();
      expect(find.text('Elena'), findsOneWidget);
    },
  );
}
