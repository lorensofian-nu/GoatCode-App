import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goat_code/core/storage/app_state_providers.dart';
import 'package:goat_code/core/storage/local_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  test('UserProfileProvider initializes with 5 lives and max lives', () {
    final container = ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: Consumer(
        builder: (context, ref, child) {
          final state = ref.watch(userProfileProvider);
          expect(state.lives, 5);
          expect(state.maxLives, 5);
          expect(state.hasLives, isTrue);
          expect(state.secondsToNextLife, 0);
          expect(state.formattedTimeUntilNextLife, '00:00');
          return const SizedBox.shrink();
        },
      ),
    );

    expect(container, isNotNull);
  });

  test('losing lives through notifier updates state and formatted countdown',
      () async {
    final container = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    );
    addTearDown(container.dispose);

    final initial = container.read(userProfileProvider);
    expect(initial.lives, 5);

    final remaining =
        await container.read(userProfileProvider.notifier).loseLife();
    expect(remaining, 4);

    final updated = container.read(userProfileProvider);
    expect(updated.lives, 4);
    expect(updated.secondsToNextLife, greaterThan(0));

    await container.read(userProfileProvider.notifier).refillLives();
    final refilled = container.read(userProfileProvider);
    expect(refilled.lives, 5);
    expect(refilled.secondsToNextLife, 0);
  });
}
