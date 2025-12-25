import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

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
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.isLoading = false,
    this.isEnabled = true,
    this.width,
    this.height,
    this.icon,
    this.iconAlignment = MainAxisAlignment.center,
  });

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
