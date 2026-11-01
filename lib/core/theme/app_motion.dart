import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Tokens and reusable animation helpers for GoatCode Motion UI (ADR-006).
class AppMotion {
  AppMotion._();

  /// Allows forcing animations in test mode if specifically desired.
  static bool forceEnableInTests = false;

  /// Detects whether code is running inside Flutter's WidgetTester / test harness.
  static bool get isTestEnvironment {
    if (forceEnableInTests) return false;
    final binding = WidgetsBinding.instance;
    return binding.runtimeType.toString().contains('Test');
  }

  // Durations
  static const Duration durationMicro = Duration(milliseconds: 150);
  static const Duration durationMedium = Duration(milliseconds: 300);
  static const Duration durationMacro = Duration(milliseconds: 500);
  static const Duration durationCelebrate = Duration(milliseconds: 650);
  static const Duration durationBreathing = Duration(milliseconds: 2400);
  static const Duration durationPulsing = Duration(milliseconds: 1600);

  // Curves
  static const Curve curveEnter = Curves.easeOutCubic;
  static const Curve curveExit = Curves.easeInCubic;
  static const Curve curveStandard = Curves.easeInOut;
  static const Curve curveBounce = Curves.elasticOut;
  static const Curve curveSpring = Curves.easeOutBack;
}

/// Extension helpers on [Widget] for standard GoatCode animations using `flutter_animate`.
extension AppMotionWidgetExtensions on Widget {
  /// Staggered entrance animation: fade and slide up with an index-based delay.
  Widget animateEntrance({
    int index = 0,
    Duration delayBase = const Duration(milliseconds: 60),
    Duration duration = AppMotion.durationMedium,
  }) {
    if (AppMotion.isTestEnvironment) return this;
    return animate(delay: delayBase * index)
        .fadeIn(duration: duration, curve: AppMotion.curveEnter)
        .slideY(
          begin: 0.12,
          end: 0.0,
          duration: duration,
          curve: AppMotion.curveEnter,
        );
  }

  /// Gentle breathing idle loop for mascot characters and prominent illustrations.
  Widget animateBreathing({bool active = true}) {
    if (!active || AppMotion.isTestEnvironment) return this;
    return animate(onPlay: (controller) => controller.repeat(reverse: true))
        .scaleXY(
          begin: 1.0,
          end: 1.035,
          duration: AppMotion.durationBreathing,
          curve: Curves.easeInOutSine,
        );
  }

  /// Pulsing glow effect for fire/streak, medals or active states.
  Widget animatePulsing({bool active = true}) {
    if (!active || AppMotion.isTestEnvironment) return this;
    return animate(onPlay: (controller) => controller.repeat(reverse: true))
        .scaleXY(
          begin: 1.0,
          end: 1.08,
          duration: AppMotion.durationPulsing,
          curve: Curves.easeInOutSine,
        );
  }

  /// Celebration pop for correct answers, unlocked achievements or completed modules.
  Widget animateCelebrate({Duration delay = Duration.zero}) {
    if (AppMotion.isTestEnvironment) return this;
    return animate(delay: delay)
        .scale(
          begin: const Offset(0.7, 0.7),
          end: const Offset(1.0, 1.0),
          duration: AppMotion.durationCelebrate,
          curve: AppMotion.curveBounce,
        )
        .fadeIn(duration: const Duration(milliseconds: 200));
  }

  /// Horizontal shake animation for incorrect responses or invalid form inputs.
  Widget animateShake() {
    if (AppMotion.isTestEnvironment) return this;
    return animate()
        .shakeX(
          amount: 6,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
  }

  /// Slide-in reveal for explanations, alerts, hints and feedback banners.
  Widget animateRevealDown({Duration? duration}) {
    if (AppMotion.isTestEnvironment) return this;
    return animate()
        .fadeIn(
          duration: duration ?? AppMotion.durationMedium,
          curve: AppMotion.curveEnter,
        )
        .slideY(
          begin: -0.15,
          end: 0.0,
          duration: duration ?? AppMotion.durationMedium,
          curve: AppMotion.curveEnter,
        );
  }
}
