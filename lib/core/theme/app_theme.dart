import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  AppTheme._();

  static ThemeData create({
    required TextScaleLevel textScale,
    required bool highContrast,
  }) {
    final scale = textScale.scaleFactor;
    final borderColor = highContrast
        ? AppColors.surfaceBorderHighContrast
        : AppColors.surfaceBorder;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      primaryColor: AppColors.primaryNeon,
      colorScheme: ColorScheme.dark(
        primary: AppColors.primaryNeon,
        onPrimary: Colors.white,
        secondary: AppColors.secondaryCyan,
        onSecondary: Colors.black,
        surface: highContrast
            ? const Color(0xFF161226)
            : AppColors.surfaceGlass,
        onSurface: AppColors.textPrimary,
        error: AppColors.errorSoft,
        onError: Colors.white,
      ),
      cardTheme: CardThemeData(
        color: highContrast ? const Color(0xFF19142C) : AppColors.surfaceGlass,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: borderColor, width: highContrast ? 2.0 : 1.2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryNeon,
          foregroundColor: Colors.white,
          minimumSize: Size(120, 48 * scale),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14 * scale),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: TextStyle(
            fontSize: 16 * scale,
            fontWeight: FontWeight.w600,
          ),
          elevation: 4,
          shadowColor: AppColors.primaryNeon.withValues(alpha: 0.4),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          minimumSize: Size(120, 48 * scale),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12 * scale),
          side: BorderSide(color: borderColor, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: TextStyle(
            fontSize: 15 * scale,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF141026),
        hintStyle: AppTypography.bodyMuted(scale),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16 * scale,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: borderColor, width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: borderColor, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.secondaryCyan,
            width: 2.0,
          ),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: const Color(0xFF0F0C1C),
        selectedIconTheme: const IconThemeData(
          color: AppColors.secondaryCyan,
          size: 28,
        ),
        unselectedIconTheme: const IconThemeData(
          color: AppColors.textMuted,
          size: 24,
        ),
        selectedLabelTextStyle: TextStyle(
          color: AppColors.secondaryCyan,
          fontWeight: FontWeight.w600,
          fontSize: 13 * scale,
        ),
        unselectedLabelTextStyle: TextStyle(
          color: AppColors.textMuted,
          fontWeight: FontWeight.w400,
          fontSize: 12 * scale,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xFF0F0C1C),
        indicatorColor: AppColors.primaryNeon.withValues(alpha: 0.3),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.secondaryCyan);
          }
          return const IconThemeData(color: AppColors.textMuted);
        }),
      ),
    );
  }
}
