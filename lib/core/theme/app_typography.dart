import 'package:flutter/material.dart';

import 'app_colors.dart';

enum TextScaleLevel {
  normal(1.0, 'Normal'),
  large(1.25, 'Grande'),
  extraLarge(1.5, 'Extra Grande');

  const TextScaleLevel(this.scaleFactor, this.label);
  final double scaleFactor;
  final String label;

  static TextScaleLevel fromString(String? value) {
    if (value == 'large') return TextScaleLevel.large;
    if (value == 'extraLarge') return TextScaleLevel.extraLarge;
    return TextScaleLevel.normal;
  }
}

class AppTypography {
  AppTypography._();

  static const String fontFamily = 'Outfit';

  static TextStyle display(double scale) => TextStyle(
    fontFamily: fontFamily,
    fontSize: 30 * scale,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static TextStyle headingLarge(double scale) => TextStyle(
    fontFamily: fontFamily,
    fontSize: 24 * scale,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.25,
  );

  static TextStyle headingMedium(double scale) => TextStyle(
    fontFamily: fontFamily,
    fontSize: 20 * scale,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static TextStyle headingSmall(double scale) => TextStyle(
    fontFamily: fontFamily,
    fontSize: 17 * scale,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.35,
  );

  static TextStyle body(double scale) => TextStyle(
    fontFamily: fontFamily,
    fontSize: 15 * scale,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.45,
  );

  static TextStyle bodyMuted(double scale) => TextStyle(
    fontFamily: fontFamily,
    fontSize: 14 * scale,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  static TextStyle caption(double scale) => TextStyle(
    fontFamily: fontFamily,
    fontSize: 12 * scale,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
    height: 1.3,
  );

  static TextStyle code(double scale) => TextStyle(
    fontFamily: 'monospace',
    fontSize: 14 * scale,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.4,
  );
}
