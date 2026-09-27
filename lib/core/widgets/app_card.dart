import 'package:flutter/material.dart';
import '../constants/app_radius.dart';
import '../constants/app_spacing.dart';
import '../theme/app_colors.dart';

class AppCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final bool enableHover;
  final Color? backgroundColor;
  final Border? border;
  final BorderRadius? borderRadius;
  final double? width;
  final double? height;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.onTap,
    this.enableHover = true,
    this.backgroundColor,
    this.border,
    this.borderRadius,
    this.width,
    this.height,
  });

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final defaultBg = isDark ? AppColors.darkCard : AppColors.lightCard;
    final defaultBorderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final r = widget.borderRadius ?? AppRadius.borderMd;

    final cardBorder = widget.border ??
        Border.all(
          color: _isHovered && widget.onTap != null
              ? AppColors.goldPrimary.withAlpha(180)
              : defaultBorderColor,
          width: 1.0,
        );

    Widget content = Container(
      width: widget.width,
      height: widget.height,
      padding: widget.padding,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? defaultBg,
        borderRadius: r,
        border: cardBorder,
        boxShadow: _isHovered && widget.onTap != null
            ? [
                BoxShadow(
                  color: AppColors.goldPrimary.withAlpha(isDark ? 30 : 25),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withAlpha(isDark ? 30 : 10),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: widget.child,
    );

    if (widget.onTap != null) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: widget.enableHover ? (_) => setState(() => _isHovered = true) : null,
        onExit: widget.enableHover ? (_) => setState(() => _isHovered = false) : null,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            transform: _isHovered && widget.enableHover
                ? Matrix4.translationValues(0.0, -3.0, 0.0)
                : Matrix4.identity(),
            child: content,
          ),
        ),
      );
    }

    return content;
  }
}
