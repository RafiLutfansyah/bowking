import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Color Scheme
      colorScheme: ColorScheme.light(
        primary: AppColors.roseGold,
        onPrimary: AppColors.primaryBackground,
        secondary: AppColors.slate,
        onSecondary: AppColors.primaryBackground,
        surface: AppColors.primaryBackground,
        onSurface: AppColors.textPrimary,
        error: AppColors.error,
        onError: AppColors.primaryBackground,
      ),
      
      // Scaffold Background
      scaffoldBackgroundColor: AppColors.primaryBackground,
      
      // Text Theme
      textTheme: AppTypography.textTheme,
      
      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primaryBackground,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTypography.textTheme.displayMedium,
        iconTheme: const IconThemeData(
          color: AppColors.slate,
          size: AppSpacing.iconStandard,
        ),
        surfaceTintColor: Colors.transparent,
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.primaryBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          side: const BorderSide(
            color: AppColors.divider,
            width: 1,
          ),
        ),
        margin: EdgeInsets.zero,
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.roseGold,
          foregroundColor: AppColors.primaryBackground,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
          ),
          elevation: 0,
          textStyle: AppTypography.textTheme.labelLarge,
        ),
      ),
      
      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.slate,
          side: const BorderSide(
            color: AppColors.slate,
            width: 1,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
          ),
          textStyle: AppTypography.textTheme.labelLarge,
        ),
      ),
      
      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.roseGold,
          textStyle: AppTypography.textTheme.labelLarge,
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.secondaryBackground,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
          borderSide: const BorderSide(
            color: AppColors.divider,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
          borderSide: const BorderSide(
            color: AppColors.divider,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
          borderSide: const BorderSide(
            color: AppColors.roseGold,
            width: 2,
          ),
        ),
        hintStyle: AppTypography.textTheme.bodyMedium?.copyWith(
          color: AppColors.textTertiary,
        ),
        labelStyle: AppTypography.textTheme.labelMedium,
      ),
      
      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.roseGoldLight,
        labelStyle: AppTypography.textTheme.labelMedium?.copyWith(
          color: AppColors.roseGoldDark,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
        ),
      ),
      
      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: AppSpacing.lg,
      ),
      
      // Icon Theme
      iconTheme: const IconThemeData(
        color: AppColors.slate,
        size: AppSpacing.iconStandard,
      ),
    );
  }
}
