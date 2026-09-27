import 'package:flutter/material.dart';
import '../constants/app_spacing.dart';
import '../theme/app_colors.dart';

class AppSectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? eyebrow;
  final Widget? trailing;
  final bool isCentered;

  const AppSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.eyebrow,
    this.trailing,
    this.isCentered = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget headerText = Column(
      crossAxisAlignment: isCentered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (eyebrow != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.goldPrimary.withAlpha(25),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: AppColors.goldPrimary.withAlpha(70),
                width: 1,
              ),
            ),
            child: Text(
              eyebrow!.toUpperCase(),
              style: const TextStyle(
                color: AppColors.goldPrimary,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 2.0,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        Text(
          title,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
          textAlign: isCentered ? TextAlign.center : TextAlign.start,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: AppSpacing.sm),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Text(
              subtitle!,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withAlpha(180),
                height: 1.5,
              ),
              textAlign: isCentered ? TextAlign.center : TextAlign.start,
            ),
          ),
        ],
      ],
    );

    if (trailing != null && !isCentered) {
      return Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.lg),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(child: headerText),
            const SizedBox(width: AppSpacing.md),
            trailing!,
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: isCentered ? Center(child: headerText) : headerText,
    );
  }
}
