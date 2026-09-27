import 'package:flutter/material.dart';
import '../constants/app_radius.dart';
import '../constants/app_spacing.dart';
import '../theme/app_colors.dart';
import 'app_button.dart';

class AppDialog extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? content;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool isDestructive;
  final bool isLoading;
  final double maxWidth;

  const AppDialog({
    super.key,
    required this.title,
    this.subtitle,
    this.content,
    this.confirmText,
    this.cancelText = 'Cancel',
    this.onConfirm,
    this.onCancel,
    this.isDestructive = false,
    this.isLoading = false,
    this.maxWidth = 480.0,
  });

  static Future<bool?> showConfirmation({
    required BuildContext context,
    required String title,
    String? subtitle,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDestructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AppDialog(
        title: title,
        subtitle: subtitle,
        confirmText: confirmText,
        cancelText: cancelText,
        isDestructive: isDestructive,
        onConfirm: () => Navigator.of(ctx).pop(true),
        onCancel: () => Navigator.of(ctx).pop(false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.borderLg,
        side: BorderSide(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      insetPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xl,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: onCancel ?? () => Navigator.of(context).pop(),
                    splashRadius: 20,
                  ),
                ],
              ),
              if (subtitle != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  subtitle!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodyMedium?.color?.withAlpha(180),
                  ),
                ),
              ],
              if (content != null) ...[
                const SizedBox(height: AppSpacing.lg),
                content!,
              ],
              const SizedBox(height: AppSpacing.xl),
              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (cancelText != null)
                    AppButton(
                      text: cancelText!,
                      variant: AppButtonVariant.text,
                      onPressed: onCancel ?? () => Navigator.of(context).pop(),
                    ),
                  if (confirmText != null) ...[
                    const SizedBox(width: AppSpacing.md),
                    AppButton(
                      text: confirmText!,
                      variant: isDestructive ? AppButtonVariant.secondary : AppButtonVariant.primary,
                      isLoading: isLoading,
                      onPressed: onConfirm,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
