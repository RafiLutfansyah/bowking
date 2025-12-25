import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTypography {
  static const String displayFont = 'Playfair Display';
  static const String bodyFont = 'Inter';

  static TextTheme get textTheme {
    return TextTheme(
      // Display styles (Playfair Display)
      displayLarge: TextStyle(
        fontFamily: displayFont,
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        color: AppColors.textPrimary,
        height: 1.2,
      ),
      displayMedium: TextStyle(
        fontFamily: displayFont,
        fontSize: 24,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        color: AppColors.textPrimary,
        height: 1.2,
      ),
      displaySmall: TextStyle(
        fontFamily: bodyFont,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: AppColors.textPrimary,
        height: 1.4,
      ),
      // Headline styles
      headlineMedium: TextStyle(
        fontFamily: bodyFont,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: AppColors.textPrimary,
        height: 1.4,
      ),
      // Title styles
      titleLarge: TextStyle(
        fontFamily: bodyFont,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: AppColors.textPrimary,
        height: 1.5,
      ),
      titleMedium: TextStyle(
        fontFamily: bodyFont,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: AppColors.textPrimary,
        height: 1.5,
      ),
      // Body styles
      bodyLarge: TextStyle(
        fontFamily: bodyFont,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: AppColors.textPrimary,
        height: 1.6,
      ),
      bodyMedium: TextStyle(
        fontFamily: bodyFont,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: AppColors.textPrimary,
        height: 1.6,
      ),
      bodySmall: TextStyle(
        fontFamily: bodyFont,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: AppColors.textSecondary,
        height: 1.5,
      ),
      // Label styles
      labelLarge: TextStyle(
        fontFamily: bodyFont,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: AppColors.textPrimary,
        height: 1.4,
      ),
      labelMedium: TextStyle(
        fontFamily: bodyFont,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: AppColors.textSecondary,
        height: 1.4,
      ),
      labelSmall: TextStyle(
        fontFamily: bodyFont,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: AppColors.textTertiary,
        height: 1.3,
      ),
    );
  }
}
