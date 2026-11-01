import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goat_code/core/storage/app_state_providers.dart';
import 'package:goat_code/core/storage/local_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('GoatMood domain logic and rules', () {
    test('5 and 4 lives result in GoatMood.happy with non-sad gesture', () {
      final mood5 = GoatMoodExtension.fromLives(5);
      expect(mood5, GoatMood.happy);
      expect(mood5.showsSadGesture, isFalse);
      expect(mood5.isConsiderableLifeLoss, isFalse);
      expect(mood5.getMascotAsset(), 'assets/mascot/goat_happy.png');

      final mood4 = GoatMoodExtension.fromLives(4);
      expect(mood4, GoatMood.happy);
      expect(mood4.showsSadGesture, isFalse);
    });

    test('3 lives result in GoatMood.attentive with neutral gesture', () {
      final mood3 = GoatMoodExtension.fromLives(3);
      expect(mood3, GoatMood.attentive);
      expect(mood3.showsSadGesture, isFalse);
      expect(mood3.isConsiderableLifeLoss, isFalse);
      expect(mood3.getMascotAsset(), 'assets/mascot/goat_idle.png');
    });

    test('2 and 1 lives (considerable loss) result in GoatMood.sad and goat_sad.png', () {
      final mood2 = GoatMoodExtension.fromLives(2);
      expect(mood2, GoatMood.sad);
      expect(mood2.showsSadGesture, isTrue);
      expect(mood2.isConsiderableLifeLoss, isTrue);
      expect(mood2.getMascotAsset(), 'assets/mascot/goat_sad.png');

      final mood1 = GoatMoodExtension.fromLives(1);
      expect(mood1, GoatMood.sad);
      expect(mood1.showsSadGesture, isTrue);
      expect(mood1.isConsiderableLifeLoss, isTrue);
      expect(mood1.getMascotAsset(), 'assets/mascot/goat_sad.png');
    });

    test('0 lives result in GoatMood.critical with sad gesture', () {
      final mood0 = GoatMoodExtension.fromLives(0);
      expect(mood0, GoatMood.critical);
      expect(mood0.showsSadGesture, isTrue);
      expect(mood0.isConsiderableLifeLoss, isTrue);
      expect(mood0.getMascotAsset(), 'assets/mascot/goat_sad.png');
    });

    test('Considerable life loss (<= 2 lives) overrides cosmetic skins to goat_sad.png', () {
      final moodLow = GoatMoodExtension.fromLives(2);
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

      // But with healthy lives (>= 3), cosmetic skins are preserved
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
      final moodSad = GoatMoodExtension.fromLives(2);
      final sadMsg = moodSad.getSpeechMessage(lives: 2);
      expect(sadMsg.contains('2 vidas'), isTrue);
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

        // Lose 1st life (4 lives): still happy
        await container.read(userProfileProvider.notifier).loseLife();
        expect(container.read(userProfileProvider).lives, 4);
        expect(container.read(userProfileProvider).goatMood, GoatMood.happy);

        // Lose 2nd life (3 lives): attentive
        await container.read(userProfileProvider.notifier).loseLife();
        expect(container.read(userProfileProvider).lives, 3);
        expect(
          container.read(userProfileProvider).goatMood,
          GoatMood.attentive,
        );
        expect(
          container.read(userProfileProvider).currentMascotAsset,
          'assets/mascot/goat_idle.png',
        );

        // Lose 3rd life (2 lives) -> Considerable drop! Mood changes to sad
        await container.read(userProfileProvider.notifier).loseLife();
        final state2 = container.read(userProfileProvider);
        expect(state2.lives, 2);
        expect(state2.goatMood, GoatMood.sad);
        expect(state2.goatMood.showsSadGesture, isTrue);
        expect(state2.currentMascotAsset, 'assets/mascot/goat_sad.png');

        // Lose 4th life (1 life) -> Still sad
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
