import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goat_code/app/app.dart';
import 'package:goat_code/core/storage/local_storage_service.dart';

void main() {
  testWidgets(
    'GoatCodeApp smoke test: loads without crash into onboarding or dashboard',
    (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
          child: const GoatCodeApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Since username is empty, it redirects to onboarding
      expect(find.text('¡Bienvenido a GoatCode!'), findsOneWidget);
    },
  );
}
