import 'package:flutter/material.dart';
import '../constants/app_radius.dart';
import '../constants/app_sizes.dart';
import '../constants/app_spacing.dart';
import '../theme/app_colors.dart';

enum AppButtonVariant { primary, secondary, outline, text }
enum AppButtonSize { sm, md, lg }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final IconData? icon;
  final bool isTrailingIcon;
  final bool isLoading;
  final bool isFullWidth;
  final double? width;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.md,
    this.icon,
    this.isTrailingIcon = false,
    this.isLoading = false,
    this.isFullWidth = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final double height = switch (size) {
      AppButtonSize.sm => AppSizes.buttonHeightSm,
      AppButtonSize.md => AppSizes.buttonHeightMd,
      AppButtonSize.lg => AppSizes.buttonHeightLg,
    };

    final double fontSize = switch (size) {
      AppButtonSize.sm => 13.0,
      AppButtonSize.md => 15.0,
      AppButtonSize.lg => 16.0,
    };

    final double horizontalPadding = switch (size) {
      AppButtonSize.sm => AppSpacing.md,
      AppButtonSize.md => AppSpacing.lg,
      AppButtonSize.lg => AppSpacing.xl,
    };

    // Style according to variant
    Widget buttonContent = Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                variant == AppButtonVariant.primary
                    ? (isDark ? Colors.black87 : Colors.black)
                    : theme.colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
        ] else if (icon != null && !isTrailingIcon) ...[
          Icon(icon, size: 18),
          const SizedBox(width: AppSpacing.sm),
        ],
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        if (!isLoading && icon != null && isTrailingIcon) ...[
          const SizedBox(width: AppSpacing.sm),
          Icon(icon, size: 18),
        ],
      ],
    );

    Widget button;

    switch (variant) {
      case AppButtonVariant.primary:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.goldPrimary,
            foregroundColor: const Color(0xFF141311),
            disabledBackgroundColor: AppColors.goldPrimary.withAlpha(100),
            elevation: 0,
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            shape: RoundedRectangleBorder(borderRadius: AppRadius.borderSm),
          ),
          child: buttonContent,
        );
        break;

      case AppButtonVariant.secondary:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurfaceVariant,
            foregroundColor: theme.colorScheme.onSurface,
            elevation: 0,
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            shape: RoundedRectangleBorder(borderRadius: AppRadius.borderSm),
          ),
          child: buttonContent,
        );
        break;

      case AppButtonVariant.outline:
        button = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: theme.colorScheme.primary,
            side: BorderSide(
              color: AppColors.goldPrimary.withAlpha(160),
              width: 1.2,
            ),
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            shape: RoundedRectangleBorder(borderRadius: AppRadius.borderSm),
          ),
          child: buttonContent,
        );
        break;

      case AppButtonVariant.text:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: theme.colorScheme.primary,
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            shape: RoundedRectangleBorder(borderRadius: AppRadius.borderSm),
          ),
          child: buttonContent,
        );
        break;
    }

    return SizedBox(
      height: height,
      width: isFullWidth ? double.infinity : width,
      child: button,
    );
  }
}
