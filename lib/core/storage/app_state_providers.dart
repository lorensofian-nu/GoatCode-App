import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/app_typography.dart';
import 'local_storage_service.dart';

class UserProfileState {
  final String? username;
  final int xp;
  final int level;
  final int streak;
  final String mascotSkin;
  final List<String> completedLessons;
  final int lives;
  final int maxLives;
  final int secondsToNextLife;

  const UserProfileState({
    required this.username,
    required this.xp,
    required this.level,
    required this.streak,
    required this.mascotSkin,
    required this.completedLessons,
    this.lives = LocalStorageService.maxLives,
    this.maxLives = LocalStorageService.maxLives,
    this.secondsToNextLife = 0,
  });

  bool get isOnboarded => username != null && username!.isNotEmpty;
  bool get hasLives => lives > 0;

  String get formattedTimeUntilNextLife {
    final m = secondsToNextLife ~/ 60;
    final s = secondsToNextLife % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  UserProfileState copyWith({
    String? username,
    int? xp,
    int? level,
    int? streak,
    String? mascotSkin,
    List<String>? completedLessons,
    int? lives,
    int? maxLives,
    int? secondsToNextLife,
  }) {
    return UserProfileState(
      username: username ?? this.username,
      xp: xp ?? this.xp,
      level: level ?? this.level,
      streak: streak ?? this.streak,
      mascotSkin: mascotSkin ?? this.mascotSkin,
      completedLessons: completedLessons ?? this.completedLessons,
      lives: lives ?? this.lives,
      maxLives: maxLives ?? this.maxLives,
      secondsToNextLife: secondsToNextLife ?? this.secondsToNextLife,
    );
  }
}

class UserProfileNotifier extends Notifier<UserProfileState> {
  UserProfileState _buildState(LocalStorageService storage) {
    return UserProfileState(
      username: storage.getUsername(),
      xp: storage.getXP(),
      level: storage.getLevel(),
      streak: storage.getStreak(),
      mascotSkin: storage.getMascotSkin(),
      completedLessons: storage.getCompletedLessons(),
      lives: storage.getLives(),
      maxLives: LocalStorageService.maxLives,
      secondsToNextLife: storage.getSecondsToNextLife(),
    );
  }

  @override
  UserProfileState build() {
    final storage = ref.watch(localStorageServiceProvider);
    return _buildState(storage);
  }

  void refreshLives() {
    final storage = ref.read(localStorageServiceProvider);
    final currentLives = storage.getLives();
    final seconds = storage.getSecondsToNextLife();
    if (currentLives != state.lives || seconds != state.secondsToNextLife) {
      state = state.copyWith(
        lives: currentLives,
        secondsToNextLife: seconds,
      );
    }
  }

  Future<void> setUsername(String name) async {
    final storage = ref.read(localStorageServiceProvider);
    await storage.setUsername(name);
    state = state.copyWith(username: name.trim());
  }

  Future<void> updateMascotSkin(String skin) async {
    final storage = ref.read(localStorageServiceProvider);
    await storage.setMascotSkin(skin);
    state = state.copyWith(mascotSkin: skin);
  }

  Future<void> completeLesson(String lessonId) async {
    final storage = ref.read(localStorageServiceProvider);
    await storage.markLessonCompleted(lessonId);
    state = _buildState(storage);
  }

  Future<int> loseLife() async {
    final storage = ref.read(localStorageServiceProvider);
    final newLives = await storage.loseLife();
    final seconds = storage.getSecondsToNextLife();
    state = state.copyWith(
      lives: newLives,
      secondsToNextLife: seconds,
    );
    return newLives;
  }

  Future<void> refillLives() async {
    final storage = ref.read(localStorageServiceProvider);
    await storage.refillLives();
    state = state.copyWith(
      lives: LocalStorageService.maxLives,
      secondsToNextLife: 0,
    );
  }

  Future<void> reset() async {
    final storage = ref.read(localStorageServiceProvider);
    await storage.clearAll();
    state = const UserProfileState(
      username: null,
      xp: 0,
      level: 1,
      streak: 0,
      mascotSkin: 'idle',
      completedLessons: [],
      lives: LocalStorageService.maxLives,
      maxLives: LocalStorageService.maxLives,
      secondsToNextLife: 0,
    );
  }
}

final userProfileProvider =
    NotifierProvider<UserProfileNotifier, UserProfileState>(
      UserProfileNotifier.new,
    );

class AccessibilityState {
  final TextScaleLevel textScale;
  final bool highContrast;
  final bool soundEnabled;
  final bool glassEffectEnabled;

  const AccessibilityState({
    required this.textScale,
    required this.highContrast,
    required this.soundEnabled,
    this.glassEffectEnabled = true,
  });

  bool get isMatteMode => !glassEffectEnabled;

  AccessibilityState copyWith({
    TextScaleLevel? textScale,
    bool? highContrast,
    bool? soundEnabled,
    bool? glassEffectEnabled,
  }) {
    return AccessibilityState(
      textScale: textScale ?? this.textScale,
      highContrast: highContrast ?? this.highContrast,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      glassEffectEnabled: glassEffectEnabled ?? this.glassEffectEnabled,
    );
  }
}

class AccessibilityNotifier extends Notifier<AccessibilityState> {
  @override
  AccessibilityState build() {
    final storage = ref.watch(localStorageServiceProvider);
    return AccessibilityState(
      textScale: storage.getTextScale(),
      highContrast: storage.getHighContrast(),
      soundEnabled: storage.getSoundEnabled(),
      glassEffectEnabled: storage.getGlassEffectEnabled(),
    );
  }

  Future<void> setTextScale(TextScaleLevel level) async {
    final storage = ref.read(localStorageServiceProvider);
    await storage.setTextScale(level);
    state = state.copyWith(textScale: level);
  }

  Future<void> toggleHighContrast() async {
    final storage = ref.read(localStorageServiceProvider);
    final newVal = !state.highContrast;
    await storage.setHighContrast(newVal);
    state = state.copyWith(highContrast: newVal);
  }

  Future<void> toggleSound() async {
    final storage = ref.read(localStorageServiceProvider);
    final newVal = !state.soundEnabled;
    await storage.setSoundEnabled(newVal);
    state = state.copyWith(soundEnabled: newVal);
  }

  Future<void> toggleGlassEffect() async {
    final storage = ref.read(localStorageServiceProvider);
    final newVal = !state.glassEffectEnabled;
    await storage.setGlassEffectEnabled(newVal);
    state = state.copyWith(glassEffectEnabled: newVal);
  }
}

final accessibilityProvider =
    NotifierProvider<AccessibilityNotifier, AccessibilityState>(
      AccessibilityNotifier.new,
    );
