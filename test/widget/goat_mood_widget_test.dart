import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goat_code/core/storage/local_storage_service.dart';
import 'package:goat_code/core/widgets/lives_badge.dart';
import 'package:goat_code/features/dashboard/presentation/dashboard_screen.dart';
import 'package:goat_code/features/mascot/presentation/mascot_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets(
    'DashboardScreen displays sad goat and sad mood indicator when lives < 5',
    (tester) async {
      tester.view.physicalSize = const Size(1280, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      // Pre-populate SharedPreferences with 2 lives
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
      expect(imageFinder, findsWidgets);
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
    expect(imageFinder, findsWidgets);
  });

  testWidgets(
    'MascotScreen displays sad goat by default when lives < 5 and allows outfit preview',
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
      expect(find.text('Estado de Ánimo: Cabra Triste'), findsOneWidget);
      expect(find.text('2/5 ❤️'), findsOneWidget);

      // Verify podium defaults directly to sad goat
      expect(find.text('Estado: Cabra Triste'), findsOneWidget);
      expect(
        find.textContaining('Tu cabra está en estado Cabra Triste'),
        findsOneWidget,
      );

      // Verify choice chips exist for toggling preview
      expect(find.text('Estado actual: Triste (2 vidas)'), findsOneWidget);
      expect(find.text('Previsualizar atuendos'), findsOneWidget);

      // Verify sad goat image is used on podium
      final sadImages = find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName ==
                'assets/mascot/goat_sad.png',
      );
      expect(sadImages, findsWidgets);

      // Tap on 'Previsualizar atuendos' to switch to skin preview
      await tester.tap(find.text('Previsualizar atuendos'));
      await tester.pump();

      // Podium switches away from sad state to preview active skin
      expect(find.text('Estado: Cabra Triste'), findsNothing);
      expect(find.text('Cabra Natural'), findsNWidgets(2));
    },
  );

  testWidgets(
    'DashboardScreen compact (mobile) displays sad goat avatar and mood badge when lives < 5',
    (tester) async {
      tester.view.physicalSize = const Size(380, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      SharedPreferences.setMockInitialValues({
        'goat_user_name': 'Sofia',
        'goat_user_lives': 3,
      });
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
          child: const MaterialApp(home: Scaffold(body: DashboardScreen())),
        ),
      );
      await tester.pump();

      // Verify compact hero card and bottom card display 'Estado: Cabra Triste'
      expect(find.text('Estado: Cabra Triste'), findsNWidgets(2));
    },
  );

  testWidgets(
    'LivesBadge dialog displays 15-minute wait message and recovers life when 15 min pass',
    (tester) async {
      final now = DateTime.now().millisecondsSinceEpoch;
      SharedPreferences.setMockInitialValues({
        'goat_user_name': 'Sofia',
        'goat_user_lives': 4,
        'goat_last_life_loss_timestamp':
            now, // Just lost life, 15 min remaining
      });
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
          child: const MaterialApp(home: Scaffold(body: LivesBadge())),
        ),
      );
      await tester.pump();

      // Open dialog
      await tester.tap(find.byType(LivesBadge));
      await tester.pumpAndSettle();

      // Verify 15-minute wait text is present
      expect(
        find.textContaining(
          'Se tiene que esperar a que pasen los 15 minutos para poder recuperarla',
        ),
        findsOneWidget,
      );
      expect(
        find.textContaining('No se puede recuperar automáticamente'),
        findsWidgets,
      );

      // Close dialog
      await tester.tap(find.text('Entendido'));
      await tester.pumpAndSettle();

      // Now simulate 16 minutes have passed
      final sixteenMinAgo = DateTime.now()
          .subtract(const Duration(minutes: 16))
          .millisecondsSinceEpoch;
      await prefs.setInt('goat_last_life_loss_timestamp', sixteenMinAgo);

      // Open dialog again
      await tester.tap(find.byType(LivesBadge));
      await tester.pumpAndSettle();

      // Verify "¡15 minutos cumplidos!" is displayed and button to recover is available
      expect(find.text('¡15 minutos cumplidos!'), findsOneWidget);
      expect(find.text('Recuperar 1 vida (+1 ❤️)'), findsOneWidget);

      // Tap to recover life
      await tester.tap(find.text('Recuperar 1 vida (+1 ❤️)'));
      await tester.pumpAndSettle();

      // Lives is now full (5) and success message is displayed
      expect(find.text('¡Tus vidas están al máximo!'), findsOneWidget);
    },
  );

  testWidgets('LivesBadge displays goat icon and turns sad when lives < 5', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'goat_user_name': 'Sofia',
      'goat_user_lives': 4,
    });
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: const MaterialApp(home: Scaffold(body: LivesBadge())),
      ),
    );
    await tester.pump();

    // Verify goat sad image is present in badge
    final badgeGoat = find.byWidgetPredicate(
      (widget) =>
          widget is Image &&
          widget.image is AssetImage &&
          (widget.image as AssetImage).assetName ==
              'assets/mascot/goat_sad.png',
    );
    expect(badgeGoat, findsOneWidget);
  });
}
