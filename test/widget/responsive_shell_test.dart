import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:goat_code/core/responsive/adaptive_scaffold.dart';
import 'package:goat_code/core/storage/local_storage_service.dart';

void main() {
  testWidgets(
    'AdaptiveScaffold renders NavigationBar on compact mobile and NavigationRail on desktop',
    (tester) async {
      SharedPreferences.setMockInitialValues({'goat_user_name': 'Carlos'});
      final prefs = await SharedPreferences.getInstance();

      // 1. Test Mobile Compact Viewport (360 x 700)
      tester.view.physicalSize = const Size(360, 700);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
          child: const MaterialApp(
            home: AdaptiveScaffold(
              currentRoute: '/dashboard',
              body: Text('Contenido Principal'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Expect Bottom NavigationBar present in mobile
      expect(find.byType(NavigationBar), findsOneWidget);

      // 2. Test Desktop Viewport (1280 x 900)
      tester.view.physicalSize = const Size(1280, 900);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
          child: const MaterialApp(
            home: AdaptiveScaffold(
              currentRoute: '/dashboard',
              body: Text('Contenido Principal'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // In desktop, BottomNavigationBar is absent and Sidebar container is present
      expect(find.byType(NavigationBar), findsNothing);
      expect(find.text('100% Offline Activo'), findsOneWidget);
      expect(find.text('Perfil & Ajustes'), findsOneWidget);

      tester.view.resetPhysicalSize();
    },
  );
}
