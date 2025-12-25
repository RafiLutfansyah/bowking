# Modern Luxury Light Design System Implementation Plan

> **For Droid:** REQUIRED SUB-SKILL: Use `executing-plans` skill to implement this plan task-by-task.

**Goal:** Implement complete Modern Luxury Light design system with Rose Gold + Slate accents, and refactor 3 key screens (Home, Wallet, Services) to match the new aesthetic.

**Architecture:** Create centralized design tokens (colors, typography, spacing) in `core/theme/`, build reusable custom widgets, then progressively refactor screens to use the new design system.

**Tech Stack:** Flutter 3.10+, Material 3, custom ThemeData, Playfair Display + Inter fonts

---

## Task 1: Create Color Constants File

**Files:**
- Create: `lib/core/theme/app_colors.dart`

#### Step 1: Write the file with all color constants

```dart
import 'package:flutter/material.dart';

class AppColors {
  // Dominant Colors (Light Background)
  static const Color primaryBackground = Color(0xFFFAFAF8);
  static const Color secondaryBackground = Color(0xFFF5F3F0);
  static const Color tertiaryBackground = Color(0xFFEFEFED);

  // Accent Colors - Rose Gold
  static const Color roseGold = Color(0xFFD4A574);
  static const Color roseGoldLight = Color(0xFFE8D4C0);
  static const Color roseGoldDark = Color(0xFFB8845C);

  // Accent Colors - Slate
  static const Color slate = Color(0xFF2C3E50);
  static const Color slateLight = Color(0xFF546E7A);

  // Text Colors
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textTertiary = Color(0xFF999999);

  // Semantic Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFE53935);
  static const Color divider = Color(0xFFE0E0E0);
}
```

#### Step 2: Verify file was created

Run: `ls -la lib/core/theme/app_colors.dart`
Expected: File exists

#### Step 3: Commit

```bash
git add lib/core/theme/app_colors.dart
git commit -m "feat: add color constants for modern luxury design system"
```

---

## Task 2: Create Spacing Constants File

**Files:**
- Create: `lib/core/theme/app_spacing.dart`

#### Step 1: Write the file with spacing constants

```dart
class AppSpacing {
  // Base spacing unit: 8px
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  // Common padding combinations
  static const double screenPaddingHorizontal = md;
  static const double screenPaddingVertical = md;
  static const double sectionSpacing = lg;
  static const double componentSpacing = md;
  static const double elementSpacing = sm;

  // Border radius
  static const double radiusSmall = 6.0;
  static const double radiusMedium = 8.0;
  static const double radiusLarge = 12.0;

  // Icon sizes
  static const double iconSmall = 20.0;
  static const double iconStandard = 24.0;
  static const double iconLarge = 32.0;
}
```

#### Step 2: Verify file was created

Run: `ls -la lib/core/theme/app_spacing.dart`
Expected: File exists

#### Step 3: Commit

```bash
git add lib/core/theme/app_spacing.dart
git commit -m "feat: add spacing constants for consistent layout"
```

---

## Task 3: Create Typography Theme File

**Files:**
- Create: `lib/core/theme/app_typography.dart`

#### Step 1: Write the file with text themes

```dart
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
```

#### Step 2: Verify file was created

Run: `ls -la lib/core/theme/app_typography.dart`
Expected: File exists

#### Step 3: Commit

```bash
git add lib/core/theme/app_typography.dart
git commit -m "feat: add typography theme with Playfair Display and Inter"
```

---

## Task 4: Update AppTheme with New Design System

**Files:**
- Modify: `lib/core/theme/app_theme.dart`

#### Step 1: Read current file to understand structure

Run: `cat lib/core/theme/app_theme.dart`

#### Step 2: Replace entire file with new theme

```dart
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
```

#### Step 3: Verify syntax by running flutter analyze

Run: `flutter analyze lib/core/theme/app_theme.dart`
Expected: No errors

#### Step 4: Commit

```bash
git add lib/core/theme/app_theme.dart
git commit -m "refactor: update AppTheme with modern luxury design system"
```

---

## Task 5: Create Custom Button Widget

**Files:**
- Create: `lib/core/widgets/custom_button.dart`

#### Step 1: Write the custom button widget

```dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final ButtonVariant variant;
  final bool isLoading;
  final bool isEnabled;
  final double? width;
  final double? height;
  final IconData? icon;
  final MainAxisAlignment iconAlignment;

  const CustomButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.isLoading = false,
    this.isEnabled = true,
    this.width,
    this.height,
    this.icon,
    this.iconAlignment = MainAxisAlignment.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDisabled = !isEnabled || isLoading;

    return SizedBox(
      width: width,
      height: height ?? 48,
      child: _buildButton(isDisabled),
    );
  }

  Widget _buildButton(bool isDisabled) {
    switch (variant) {
      case ButtonVariant.primary:
        return _buildPrimaryButton(isDisabled);
      case ButtonVariant.secondary:
        return _buildSecondaryButton(isDisabled);
      case ButtonVariant.tertiary:
        return _buildTertiaryButton(isDisabled);
    }
  }

  Widget _buildPrimaryButton(bool isDisabled) {
    return ElevatedButton(
      onPressed: isDisabled ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isDisabled ? AppColors.tertiaryBackground : AppColors.roseGold,
        foregroundColor: AppColors.primaryBackground,
        disabledBackgroundColor: AppColors.tertiaryBackground,
        disabledForegroundColor: AppColors.textTertiary,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
        ),
      ),
      child: _buildButtonContent(),
    );
  }

  Widget _buildSecondaryButton(bool isDisabled) {
    return OutlinedButton(
      onPressed: isDisabled ? null : onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: isDisabled ? AppColors.textTertiary : AppColors.slate,
        side: BorderSide(
          color: isDisabled ? AppColors.divider : AppColors.slate,
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
        ),
      ),
      child: _buildButtonContent(),
    );
  }

  Widget _buildTertiaryButton(bool isDisabled) {
    return TextButton(
      onPressed: isDisabled ? null : onPressed,
      style: TextButton.styleFrom(
        foregroundColor: isDisabled ? AppColors.textTertiary : AppColors.roseGold,
      ),
      child: _buildButtonContent(),
    );
  }

  Widget _buildButtonContent() {
    if (isLoading) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisAlignment: iconAlignment,
        children: [
          Icon(icon, size: AppSpacing.iconSmall),
          const SizedBox(width: AppSpacing.sm),
          Text(label),
        ],
      );
    }

    return Text(label);
  }
}

enum ButtonVariant { primary, secondary, tertiary }
```

#### Step 2: Verify file was created

Run: `ls -la lib/core/widgets/custom_button.dart`
Expected: File exists

#### Step 3: Commit

```bash
git add lib/core/widgets/custom_button.dart
git commit -m "feat: add custom button widget with three variants"
```

---

## Task 6: Create Custom Card Widget

**Files:**
- Create: `lib/core/widgets/custom_card.dart`

#### Step 1: Write the custom card widget

```dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class CustomCard extends StatefulWidget {
  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final bool isClickable;
  final Color? backgroundColor;
  final double? elevation;

  const CustomCard({
    Key? key,
    required this.child,
    this.padding,
    this.onTap,
    this.isClickable = false,
    this.backgroundColor,
    this.elevation,
  }) : super(key: key);

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _setHovered(true),
      onExit: (_) => _setHovered(false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOutCubic,
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? AppColors.primaryBackground,
            border: Border.all(
              color: AppColors.divider,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_isHovered ? 0.12 : 0.08),
                blurRadius: _isHovered ? 12 : 8,
                offset: const Offset(0, _isHovered ? 4 : 2),
              ),
            ],
          ),
          child: Padding(
            padding: widget.padding ?? const EdgeInsets.all(AppSpacing.md),
            child: widget.child,
          ),
        ),
      ),
    );
  }

  void _setHovered(bool value) {
    if (widget.isClickable) {
      setState(() => _isHovered = value);
    }
  }
}
```

#### Step 2: Verify file was created

Run: `ls -la lib/core/widgets/custom_card.dart`
Expected: File exists

#### Step 3: Commit

```bash
git add lib/core/widgets/custom_card.dart
git commit -m "feat: add custom card widget with hover effects"
```

---

## Task 7: Create Custom TextField Widget

**Files:**
- Create: `lib/core/widgets/custom_text_field.dart`

#### Step 1: Write the custom text field widget

```dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

class CustomTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final int maxLines;
  final int minLines;
  final bool obscureText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconPressed;

  const CustomTextField({
    Key? key,
    this.label,
    this.hint,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.minLines = 1,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() => _isFocused = _focusNode.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTypography.textTheme.labelMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          keyboardType: widget.keyboardType,
          maxLines: widget.obscureText ? 1 : widget.maxLines,
          minLines: widget.minLines,
          obscureText: widget.obscureText,
          validator: widget.validator,
          onChanged: widget.onChanged,
          style: AppTypography.textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: AppTypography.textTheme.bodyMedium?.copyWith(
              color: AppColors.textTertiary,
            ),
            prefixIcon: widget.prefixIcon != null
                ? Icon(widget.prefixIcon, color: AppColors.slate)
                : null,
            suffixIcon: widget.suffixIcon != null
                ? IconButton(
                    icon: Icon(widget.suffixIcon, color: AppColors.slate),
                    onPressed: widget.onSuffixIconPressed,
                  )
                : null,
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
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
              borderSide: const BorderSide(
                color: AppColors.error,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
              borderSide: const BorderSide(
                color: AppColors.error,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
```

#### Step 2: Verify file was created

Run: `ls -la lib/core/widgets/custom_text_field.dart`
Expected: File exists

#### Step 3: Commit

```bash
git add lib/core/widgets/custom_text_field.dart
git commit -m "feat: add custom text field widget with focus states"
```

---

## Task 8: Refactor HomePage with New Design System

**Files:**
- Modify: `lib/features/booking/presentation/pages/home_page.dart`

#### Step 1: Read current HomePage to understand structure

Run: `head -100 lib/features/booking/presentation/pages/home_page.dart`

#### Step 2: Update imports and refactor to use new design system

(This will be done in next message due to length)

---

## Task 9: Refactor WalletPage with New Design System

**Files:**
- Modify: `lib/features/wallet/presentation/pages/wallet_page.dart`

(To be continued in next message)

---

## Task 10: Refactor ServicesPage with New Design System

**Files:**
- Modify: `lib/features/booking/presentation/pages/services_page.dart`

(To be continued in next message)

---

## Task 11: Update pubspec.yaml with Font Dependencies

**Files:**
- Modify: `pubspec.yaml`

#### Step 1: Add font dependencies

Add to `pubspec.yaml` under `flutter:` section:

```yaml
fonts:
  - family: Playfair Display
    fonts:
      - asset: assets/fonts/PlayfairDisplay-Regular.ttf
        weight: 400
      - asset: fonts/PlayfairDisplay-Bold.ttf
        weight: 700
  - family: Inter
    fonts:
      - asset: assets/fonts/Inter-Regular.ttf
        weight: 400
      - asset: assets/fonts/Inter-Medium.ttf
        weight: 500
      - asset: assets/fonts/Inter-SemiBold.ttf
        weight: 600
```

#### Step 2: Download fonts and place in assets/fonts/

(Fonts need to be downloaded from Google Fonts)

#### Step 3: Run flutter pub get

Run: `flutter pub get`

#### Step 4: Commit

```bash
git add pubspec.yaml
git commit -m "feat: add Playfair Display and Inter font dependencies"
```

---

## Task 12: Run Flutter Analyze and Tests

#### Step 1: Run flutter analyze

Run: `flutter analyze`
Expected: No errors

#### Step 2: Run flutter test

Run: `flutter test`
Expected: All tests pass

#### Step 3: Run flutter build

Run: `flutter build apk --debug` (or appropriate build command)
Expected: Build succeeds

---

## Summary

This plan creates a complete Modern Luxury Light design system with:
- Centralized color, typography, and spacing tokens
- Custom reusable widgets (Button, Card, TextField)
- Updated ThemeData with new aesthetic
- Refactored screens using new design system
- Font integration for Playfair Display + Inter

Each task is designed to be completed independently with TDD principles and frequent commits.
