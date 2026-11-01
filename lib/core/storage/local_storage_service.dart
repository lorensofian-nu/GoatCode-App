import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/app_typography.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'SharedPreferences must be initialized before runApp',
  );
});

final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LocalStorageService(prefs);
});

class LocalStorageService {
  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  static const _keyUsername = 'goat_user_name';
  static const _keyXp = 'goat_user_xp';
  static const _keyStreak = 'goat_user_streak';
  static const _keyLastActiveDate = 'goat_last_active_date';
  static const _keyCompletedLessons = 'goat_completed_lessons';
  static const _keyMascotSkin = 'goat_mascot_skin';
  static const _keyTextScale = 'goat_pref_text_scale';
  static const _keyHighContrast = 'goat_pref_high_contrast';
  static const _keySoundEnabled = 'goat_pref_sound_enabled';

  // Username
  String? getUsername() => _prefs.getString(_keyUsername);
  Future<bool> setUsername(String name) =>
      _prefs.setString(_keyUsername, name.trim());

  // XP & Level
  int getXP() => _prefs.getInt(_keyXp) ?? 0;
  Future<bool> addXP(int points) async {
    final current = getXP();
    return _prefs.setInt(_keyXp, current + points);
  }

  int getLevel() {
    final xp = getXP();
    return (xp ~/ 250) + 1;
  }

  // Streak tracking (Duolingo style)
  int getStreak() => _prefs.getInt(_keyStreak) ?? 0;
  String? getLastActiveDate() => _prefs.getString(_keyLastActiveDate);

  Future<int> recordActivityToday() async {
    final now = DateTime.now();
    final todayStr =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    final lastActive = getLastActiveDate();
    int currentStreak = getStreak();

    if (lastActive == todayStr) {
      return currentStreak;
    }

    if (lastActive != null) {
      final lastDate = DateTime.tryParse(lastActive);
      if (lastDate != null) {
        final difference = now
            .difference(DateTime(lastDate.year, lastDate.month, lastDate.day))
            .inDays;
        if (difference == 1) {
          currentStreak += 1;
        } else if (difference > 1) {
          currentStreak = 1;
        }
      } else {
        currentStreak = 1;
      }
    } else {
      currentStreak = 1;
    }

    await _prefs.setInt(_keyStreak, currentStreak);
    await _prefs.setString(_keyLastActiveDate, todayStr);
    return currentStreak;
  }

  // Completed Lessons
  List<String> getCompletedLessons() =>
      _prefs.getStringList(_keyCompletedLessons) ?? [];
  bool isLessonCompleted(String lessonId) =>
      getCompletedLessons().contains(lessonId);

  Future<bool> markLessonCompleted(String lessonId) async {
    final list = List<String>.from(getCompletedLessons());
    if (!list.contains(lessonId)) {
      list.add(lessonId);
      await _prefs.setStringList(_keyCompletedLessons, list);
      await addXP(100);
      await recordActivityToday();
      return true;
    }
    return false;
  }

  // Mascot Customization
  String getMascotSkin() => _prefs.getString(_keyMascotSkin) ?? 'idle';
  Future<bool> setMascotSkin(String skin) =>
      _prefs.setString(_keyMascotSkin, skin);

  // Accessibility
  TextScaleLevel getTextScale() {
    final val = _prefs.getString(_keyTextScale);
    return TextScaleLevel.fromString(val);
  }

  Future<bool> setTextScale(TextScaleLevel level) =>
      _prefs.setString(_keyTextScale, level.name);

  bool getHighContrast() => _prefs.getBool(_keyHighContrast) ?? false;
  Future<bool> setHighContrast(bool value) =>
      _prefs.setBool(_keyHighContrast, value);

  bool getSoundEnabled() => _prefs.getBool(_keySoundEnabled) ?? true;
  Future<bool> setSoundEnabled(bool value) =>
      _prefs.setBool(_keySoundEnabled, value);

  Future<bool> clearAll() => _prefs.clear();
}
