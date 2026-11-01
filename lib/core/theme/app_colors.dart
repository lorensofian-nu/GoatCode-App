import 'package:flutter/material.dart';

/// Design tokens for GoatCode: "Cosmic Glass & Friendly Mascot"
class AppColors {
  AppColors._();

  // Cosmic Backgrounds
  static const Color backgroundDark = Color(0xFF0C0A17);
  static const Color backgroundCard = Color(0xFF141026);
  static const Color surfaceGlass = Color(0xF0151128); // 94% opacity for crisp text contrast
  static const Color surfaceGlassLight = Color(0xB8241E3D);

  // Borders & Dividers
  static const Color surfaceBorder = Color(0x33A882FF); // subtle violet border
  static const Color surfaceBorderHighContrast = Color(0x99A882FF);
  static const Color glassBorder = Color(0x26FFFFFF);

  // Neon & Brand Accents
  static const Color primaryNeon = Color(0xFF8A4FFF); // Violet glow
  static const Color primaryNeonLight = Color(0xFFA578FF);
  static const Color secondaryCyan = Color(
    0xFF00E5FF,
  ); // Neon cyan for active flow
  static const Color secondaryCyanGlow = Color(0x4D00E5FF);

  // Gamification & Status
  static const Color streakFire = Color(
    0xFFFF7A00,
  ); // Duolingo style streak fire
  static const Color streakFireGlow = Color(0x66FF7A00);
  static const Color heartYellow = Color(0xFFFFD21E); // Golden yellow for lives
  static const Color heartYellowGlow = Color(0x66FFD21E);
  static const Color successGreen = Color(0xFF00E676);
  static const Color warningAmber = Color(0xFFFFB300);
  static const Color errorSoft = Color(0xFFFF5252);

  // Text
  static const Color textPrimary = Color(0xFFF5F3FF); // 96% white warm
  static const Color textSecondary = Color(0xFFB8B2D1); // Soft lavender
  static const Color textMuted = Color(0xFF7E7799);

  // Code editor container
  static const Color codeBackground = Color(0xFF08060F);
  static const Color codeComment = Color(0xFF6B7280);
  static const Color codeKeyword = Color(0xFF8A4FFF);
  static const Color codeString = Color(0xFF00E5FF);
  static const Color codeNumber = Color(0xFFFF7A00);
}
