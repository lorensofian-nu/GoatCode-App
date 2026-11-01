import 'package:flutter/foundation.dart';

import 'sound_service_platform.dart'
    if (dart.library.js_interop) 'sound_service_web.dart';

/// Lightweight synthetic audio feedback service.
/// Plays pure synthetic Web Audio oscillator tones with 0 latency,
/// 0 bytes network download, and complete offline capability.
class SoundService {
  SoundService._();

  /// Plays a sweet rising cosmic arpeggio on correct exercise completion.
  static void playSuccess({required bool soundEnabled}) {
    if (!soundEnabled || !kIsWeb) return;
    playPlatformSound('success');
  }

  /// Plays a gentle, damped low-frequency tone on error feedback.
  static void playError({required bool soundEnabled}) {
    if (!soundEnabled || !kIsWeb) return;
    playPlatformSound('error');
  }

  /// Plays a solar shimmer arpeggio when celebrating streaks or levels.
  static void playStreak({required bool soundEnabled}) {
    if (!soundEnabled || !kIsWeb) return;
    playPlatformSound('streak');
  }
}
