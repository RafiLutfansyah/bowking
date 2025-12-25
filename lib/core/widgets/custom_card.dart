import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class CustomCard extends StatefulWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final VoidCallback? onTap;
  final bool isClickable;
  final Color? backgroundColor;
  final double? elevation;

  const CustomCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.isClickable = false,
    this.backgroundColor,
    this.elevation,
  });

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
        child: Container(
          margin: widget.margin,
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
                  color: Colors.black.withValues(
                    alpha: _isHovered ? 0.12 : 0.08,
                  ),
                  blurRadius: _isHovered ? 12 : 8,
                  offset: Offset(0, _isHovered ? 4 : 2),
                ),
              ],
            ),
            child: Padding(
              padding: widget.padding ?? const EdgeInsets.all(AppSpacing.md),
              child: widget.child,
            ),
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
