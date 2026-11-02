import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goat_code/core/storage/app_state_providers.dart';
import 'package:goat_code/core/storage/local_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('GoatMood domain logic and rules', () {
    test('5 lives (max) result in GoatMood.happy with non-sad gesture', () {
      final mood5 = GoatMoodExtension.fromLives(5);
      expect(mood5, GoatMood.happy);
      expect(mood5.showsSadGesture, isFalse);
      expect(mood5.isConsiderableLifeLoss, isFalse);
      expect(mood5.getMascotAsset(), 'assets/mascot/goat_happy.png');
    });

    test('Losing lives (4, 3, 2, 1 lives) results in GoatMood.sad and goat_sad.png', () {
      for (final lives in [4, 3, 2, 1]) {
        final mood = GoatMoodExtension.fromLives(lives);
        expect(
          mood,
          GoatMood.sad,
          reason: 'Lives $lives should result in GoatMood.sad',
        );
        expect(mood.showsSadGesture, isTrue);
        expect(mood.isConsiderableLifeLoss, isTrue);
        expect(mood.getMascotAsset(), 'assets/mascot/goat_sad.png');
      }
    });

    test('0 lives result in GoatMood.critical with sad gesture', () {
      final mood0 = GoatMoodExtension.fromLives(0);
      expect(mood0, GoatMood.critical);
      expect(mood0.showsSadGesture, isTrue);
      expect(mood0.isConsiderableLifeLoss, isTrue);
      expect(mood0.getMascotAsset(), 'assets/mascot/goat_sad.png');
    });

    test('Losing lives overrides cosmetic skins to goat_sad.png', () {
      final moodLow = GoatMoodExtension.fromLives(4);
      expect(
        moodLow.getMascotAsset(userSkin: 'teacher'),
        'assets/mascot/goat_sad.png',
      );
      expect(
        moodLow.getMascotAsset(userSkin: 'rocker'),
        'assets/mascot/goat_sad.png',
      );
      expect(
        moodLow.getMascotAsset(userSkin: 'baby'),
        'assets/mascot/goat_sad.png',
      );

      // But with full lives (5), cosmetic skins are preserved
      final moodHealthy = GoatMoodExtension.fromLives(5);
      expect(
        moodHealthy.getMascotAsset(userSkin: 'teacher'),
        'assets/mascot/goat_teacher.png',
      );
      expect(
        moodHealthy.getMascotAsset(userSkin: 'rocker'),
        'assets/mascot/goat_rocker.png',
      );
      expect(
        moodHealthy.getMascotAsset(userSkin: 'baby'),
        'assets/mascot/goat_baby.png',
      );
    });

    test('Contextual speech messages reflect available lives and mood', () {
      final moodSad = GoatMoodExtension.fromLives(4);
      final sadMsg = moodSad.getSpeechMessage(lives: 4);
      expect(sadMsg.contains('4/5'), isTrue);
      expect(sadMsg.toLowerCase().contains('triste'), isTrue);

      final moodCritical = GoatMoodExtension.fromLives(0);
      final critMsg = moodCritical.getSpeechMessage(lives: 0);
      expect(critMsg.contains('sin vidas'), isTrue);

      final moodHappy = GoatMoodExtension.fromLives(5);
      final happyMsg = moodHappy.getSpeechMessage(lives: 5);
      expect(happyMsg.contains('5 vidas'), isTrue);
    });
  });

  group('UserProfileNotifier & GoatMood integration', () {
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
    });

    test(
      'Goat mood and mascot asset update reactively as lives decrement',
      () async {
        final container = ProviderContainer(
          overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        );
        addTearDown(container.dispose);

        // Initially 5 lives: happy
        expect(container.read(userProfileProvider).lives, 5);
        expect(container.read(userProfileProvider).goatMood, GoatMood.happy);
        expect(
          container.read(userProfileProvider).currentMascotAsset,
          'assets/mascot/goat_happy.png',
        );

        // Lose 1st life (4 lives): icon turns SAD immediately
        await container.read(userProfileProvider.notifier).loseLife();
        expect(container.read(userProfileProvider).lives, 4);
        expect(container.read(userProfileProvider).goatMood, GoatMood.sad);
        expect(
          container.read(userProfileProvider).currentMascotAsset,
          'assets/mascot/goat_sad.png',
        );

        // Lose 2nd life (3 lives): still sad
        await container.read(userProfileProvider.notifier).loseLife();
        expect(container.read(userProfileProvider).lives, 3);
        expect(container.read(userProfileProvider).goatMood, GoatMood.sad);
        expect(
          container.read(userProfileProvider).currentMascotAsset,
          'assets/mascot/goat_sad.png',
        );

        // Lose 3rd life (2 lives): still sad
        await container.read(userProfileProvider.notifier).loseLife();
        final state2 = container.read(userProfileProvider);
        expect(state2.lives, 2);
        expect(state2.goatMood, GoatMood.sad);
        expect(state2.goatMood.showsSadGesture, isTrue);
        expect(state2.currentMascotAsset, 'assets/mascot/goat_sad.png');

        // Lose 4th life (1 life): still sad
        await container.read(userProfileProvider.notifier).loseLife();
        final state1 = container.read(userProfileProvider);
        expect(state1.lives, 1);
        expect(state1.goatMood, GoatMood.sad);
        expect(state1.currentMascotAsset, 'assets/mascot/goat_sad.png');

        // Refill lives back to 5 -> Mood recovers to happy immediately
        await container.read(userProfileProvider.notifier).refillLives();
        final stateRefilled = container.read(userProfileProvider);
        expect(stateRefilled.lives, 5);
        expect(stateRefilled.goatMood, GoatMood.happy);
        expect(stateRefilled.goatMood.showsSadGesture, isFalse);
        expect(
          stateRefilled.currentMascotAsset,
          'assets/mascot/goat_happy.png',
        );
      },
    );
  });
}
