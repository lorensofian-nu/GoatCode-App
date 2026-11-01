import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:goat_code/core/storage/local_storage_service.dart';
import 'package:goat_code/core/theme/app_typography.dart';

void main() {
  late SharedPreferences prefs;
  late LocalStorageService storage;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    storage = LocalStorageService(prefs);
  });

  group('LocalStorageService', () {
    test('username can be saved and retrieved', () async {
      expect(storage.getUsername(), isNull);
      await storage.setUsername('Carlos');
      expect(storage.getUsername(), 'Carlos');
    });

    test('XP and level calculation', () async {
      expect(storage.getXP(), 0);
      expect(storage.getLevel(), 1);

      await storage.addXP(200);
      expect(storage.getXP(), 200);
      expect(storage.getLevel(), 1);

      await storage.addXP(100);
      expect(storage.getXP(), 300);
      expect(storage.getLevel(), 2);
    });

    test('lesson completion adds XP and updates completed list', () async {
      expect(storage.isLessonCompleted('variables_01'), isFalse);
      final completed = await storage.markLessonCompleted('variables_01');
      expect(completed, isTrue);
      expect(storage.isLessonCompleted('variables_01'), isTrue);
      expect(storage.getXP(), 100);

      // Re-completing same lesson should not duplicate XP
      final completedAgain = await storage.markLessonCompleted('variables_01');
      expect(completedAgain, isFalse);
      expect(storage.getXP(), 100);
    });

    test('mascot skin customization', () async {
      expect(storage.getMascotSkin(), 'idle');
      await storage.setMascotSkin('teacher');
      expect(storage.getMascotSkin(), 'teacher');
    });

    test('accessibility settings persist', () async {
      expect(storage.getTextScale(), TextScaleLevel.normal);
      expect(storage.getHighContrast(), isFalse);

      await storage.setTextScale(TextScaleLevel.large);
      await storage.setHighContrast(true);

      expect(storage.getTextScale(), TextScaleLevel.large);
      expect(storage.getHighContrast(), isTrue);
    });

    test('initial lives is 5 and seconds to next life is 0', () {
      expect(storage.getLives(), 5);
      expect(storage.getSecondsToNextLife(), 0);
    });

    test('losing lives decrements and sets regeneration timer', () async {
      expect(storage.getLives(), 5);
      final remaining = await storage.loseLife();
      expect(remaining, 4);
      expect(storage.getLives(), 4);
      expect(storage.getSecondsToNextLife(), greaterThan(0));
      expect(storage.getSecondsToNextLife(), lessThanOrEqualTo(15 * 60));

      await storage.loseLife(); // 3
      await storage.loseLife(); // 2
      await storage.loseLife(); // 1
      final lastRemaining = await storage.loseLife(); // 0
      expect(lastRemaining, 0);
      expect(storage.getLives(), 0);

      // Lives cannot drop below 0
      final underflow = await storage.loseLife();
      expect(underflow, 0);
      expect(storage.getLives(), 0);
    });

    test('refillLives resets lives to max 5', () async {
      await storage.loseLife();
      await storage.loseLife();
      expect(storage.getLives(), 3);

      await storage.refillLives();
      expect(storage.getLives(), 5);
      expect(storage.getSecondsToNextLife(), 0);
    });

    test('time-based regeneration restores lives correctly', () async {
      await storage.loseLife(); // 4 lives
      expect(storage.getLives(), 4);

      // Simulate that 16 minutes have passed since last life was lost
      final sixteenMinutesAgo = DateTime.now()
          .subtract(const Duration(minutes: 16))
          .millisecondsSinceEpoch;
      await prefs.setInt('goat_last_life_loss_timestamp', sixteenMinutesAgo);

      // getLives should compute passive regeneration and return 5
      expect(storage.getLives(), 5);
      expect(storage.getSecondsToNextLife(), 0);
    });
  });
}
