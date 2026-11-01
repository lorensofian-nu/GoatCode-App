import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Representa el estado de ánimo emocional y el gesto de la cabra mascota (GoatCode).
///
/// Regla de diseño:
/// El estado de ánimo y el gesto de la cabra dependen directamente de las vidas disponibles en el momento:
/// - 5 vidas (vidas al máximo): [GoatMood.happy] (Óptimo, motivada, alegre con 'goat_happy.png' o atuendo)
/// - Menos de 5 vidas (ha perdido vidas: 1 a 4 vidas): [GoatMood.sad] (Gesto triste empático con 'goat_sad.png')
/// - 0 vidas: [GoatMood.critical] (Sin vidas disponibles, gesto triste / afligido con 'goat_sad.png')
enum GoatMood {
  /// 5 vidas (100%): Llena de energía y feliz.
  happy,

  /// 1 a 4 vidas: Ha perdido vidas. El gesto visual cambia a triste.
  sad,

  /// 0 vidas: Sin vidas. Gesto triste / afligido.
  critical,
}

extension GoatMoodExtension on GoatMood {
  /// Determina el estado de ánimo a partir de las vidas disponibles en el momento.
  /// Regla:
  /// - 0 vidas: Crítico (sin vidas)
  /// - Menos de maxLives (< 5 vidas): Triste (ha perdido vidas -> icono y gesto triste)
  /// - maxLives (5 vidas): Feliz (vidas intactas)
  static GoatMood fromLives(int lives, [int maxLives = 5]) {
    if (lives <= 0) return GoatMood.critical;
    if (lives < maxLives) return GoatMood.sad;
    return GoatMood.happy;
  }

  /// Indica si el usuario ha perdido vidas (< maxLives).
  bool get isConsiderableLifeLoss =>
      this == GoatMood.sad || this == GoatMood.critical;

  /// Indica si el gesto visual y el icono de la cabra deben mostrarse tristes.
  bool get showsSadGesture => isConsiderableLifeLoss;

  /// Nombre legible en español para la interfaz de usuario.
  String get displayName {
    switch (this) {
      case GoatMood.happy:
        return 'Feliz y motivada';
      case GoatMood.sad:
        return 'Triste por pérdida de vidas';
      case GoatMood.critical:
        return 'Afligida (sin vidas)';
    }
  }

  /// Etiqueta corta de estado.
  String get shortLabel {
    switch (this) {
      case GoatMood.happy:
        return 'Feliz';
      case GoatMood.sad:
        return 'Triste';
      case GoatMood.critical:
        return 'Sin vidas';
    }
  }

  /// Devuelve la ruta del asset de imagen correspondiente al gesto y estado de ánimo.
  ///
  /// REGLA:
  /// Al perder vidas (< 5 vidas disponibles), el icono y gesto de la cabra cambia a triste
  /// ('assets/mascot/goat_sad.png'), priorizando el gesto emocional de empatía.
  /// Con vidas al máximo (5 vidas), se respeta la apariencia alegre o atuendo elegido.
  String getMascotAsset({String? userSkin}) {
    if (showsSadGesture) {
      return 'assets/mascot/goat_sad.png';
    }

    final skin = userSkin ?? 'idle';
    switch (skin) {
      case 'teacher':
        return 'assets/mascot/goat_teacher.png';
      case 'rocker':
        return 'assets/mascot/goat_rocker.png';
      case 'baby':
        return 'assets/mascot/goat_baby.png';
      case 'happy':
        return 'assets/mascot/goat_happy.png';
      case 'shy':
        return 'assets/mascot/goat_shy.png';
      case 'grumpy':
        return 'assets/mascot/goat_grumpy.png';
      case 'shocked':
        return 'assets/mascot/goat_shocked.png';
      case 'sad':
        return 'assets/mascot/goat_sad.png';
      case 'idle':
      default:
        return 'assets/mascot/goat_happy.png';
    }
  }

  /// Mensaje de diálogo pedagógico adaptado al estado de ánimo y cantidad de vidas.
  String getSpeechMessage({int streak = 0, int lives = 5, int maxLives = 5}) {
    switch (this) {
      case GoatMood.critical:
        return '¡Nos quedamos sin vidas! Me duele verte así... No te desanimes: descansa un momento o repasa tus notas mientras se recargan.';
      case GoatMood.sad:
        if (lives == 1) {
          return '¡Cuidado! Solo nos queda 1 vida... Mi corazón late con nervios. ¡Respira hondo y lee con mucha calma antes de responder!';
        }
        if (lives == 4) {
          return '¡Oh no! Perdimos una vida (te quedan 4/$maxLives)... Me pone triste tropezar, pero el error nos enseña. ¡Vamos con calma en la siguiente!';
        }
        return '¡Oh no! Nos quedan solo $lives vidas... Me pone triste verte tropezar, pero tropezar también es aprender. ¡Tú puedes!';
      case GoatMood.happy:
        if (streak > 0) {
          return '¡Llevas $streak días seguidos con tus $lives vidas intactas! Tu disciplina y mente lógica son imparables.';
        }
        return '¡Hola! Aprender a programar es como armar un rompecabezas. Con nuestras $lives vidas al máximo, ¡vamos a resolverlo!';
    }
  }

  /// Color semántico asociado al estado de ánimo.
  Color get color {
    switch (this) {
      case GoatMood.happy:
        return AppColors.successGreen;
      case GoatMood.sad:
        return AppColors.heartYellow;
      case GoatMood.critical:
        return AppColors.errorSoft;
    }
  }

  /// Icono representativo del estado de ánimo.
  IconData get icon {
    switch (this) {
      case GoatMood.happy:
        return Icons.sentiment_very_satisfied_rounded;
      case GoatMood.sad:
        return Icons.sentiment_dissatisfied_rounded;
      case GoatMood.critical:
        return Icons.heart_broken_rounded;
    }
  }
}
