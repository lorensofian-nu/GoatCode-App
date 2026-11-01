import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goat_code/core/storage/local_storage_service.dart';
import 'package:goat_code/features/dashboard/presentation/dashboard_screen.dart';
import 'package:goat_code/features/mascot/presentation/mascot_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets(
    'DashboardScreen displays sad goat and sad mood indicator when lives <= 2',
    (tester) async {
      tester.view.physicalSize = const Size(1280, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      // Pre-populate SharedPreferences with only 2 lives
      SharedPreferences.setMockInitialValues({
        'goat_user_name': 'Sofia',
        'goat_user_lives': 2,
      });
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
          child: const MaterialApp(home: Scaffold(body: DashboardScreen())),
        ),
      );
      await tester.pump();

      // Verify the mood chip displays 'Ánimo: Triste'
      expect(find.text('Ánimo: Triste'), findsOneWidget);

      // Verify speech bubble reflects sadness over lives
      expect(find.textContaining('Nos quedan solo 2 vidas'), findsOneWidget);

      // Verify the mascot image widget uses goat_sad.png
      final imageFinder = find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName ==
                'assets/mascot/goat_sad.png',
      );
      expect(imageFinder, findsOneWidget);
    },
  );

  testWidgets('DashboardScreen displays happy goat when lives are full (5)', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    SharedPreferences.setMockInitialValues({
      'goat_user_name': 'Sofia',
      'goat_user_lives': 5,
    });
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: const MaterialApp(home: Scaffold(body: DashboardScreen())),
      ),
    );
    await tester.pump();

    // Verify mood chip shows 'Ánimo: Feliz'
    expect(find.text('Ánimo: Feliz'), findsOneWidget);

    // Verify happy mascot image is used
    final imageFinder = find.byWidgetPredicate(
      (widget) =>
          widget is Image &&
          widget.image is AssetImage &&
          (widget.image as AssetImage).assetName ==
              'assets/mascot/goat_happy.png',
    );
    expect(imageFinder, findsOneWidget);
  });

  testWidgets(
    'MascotScreen displays mood explanation and handles sad state toggle',
    (tester) async {
      tester.view.physicalSize = const Size(1280, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      SharedPreferences.setMockInitialValues({
        'goat_user_name': 'Sofia',
        'goat_user_lives': 2,
      });
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
          child: const MaterialApp(home: Scaffold(body: MascotScreen())),
        ),
      );
      await tester.pump();

      // Verify mood banner is rendered
      expect(
        find.text('Estado de Ánimo: Triste por pérdida de vidas'),
        findsOneWidget,
      );
      expect(find.text('2/5 ❤️'), findsOneWidget);

      // Verify choice chips exist for toggling preview
      expect(find.text('Atuendo seleccionado'), findsOneWidget);
      expect(find.text('Gesto triste actual (2 vidas)'), findsOneWidget);

      // Tap on 'Gesto triste actual (2 vidas)'
      await tester.tap(find.text('Gesto triste actual (2 vidas)'));
      await tester.pump();

      expect(find.text('Gesto Triste (Por vidas bajas)'), findsOneWidget);
    },
  );
}
