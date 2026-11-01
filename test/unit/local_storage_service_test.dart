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
      expect(storage.getSoundEnabled(), isTrue);
      expect(storage.getGlassEffectEnabled(), isTrue);

      await storage.setTextScale(TextScaleLevel.large);
      await storage.setHighContrast(true);
      await storage.setSoundEnabled(false);
      await storage.setGlassEffectEnabled(false);

      expect(storage.getTextScale(), TextScaleLevel.large);
      expect(storage.getHighContrast(), isTrue);
      expect(storage.getSoundEnabled(), isFalse);
      expect(storage.getGlassEffectEnabled(), isFalse);
    });
  });
}
