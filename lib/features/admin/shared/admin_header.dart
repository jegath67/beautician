import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/responsive/responsive_layout.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../presentation/providers/auth_provider.dart';
import '../../../../presentation/providers/theme_provider.dart';

class AdminHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onMenuPressed;
  final List<Widget>? actions;

  const AdminHeader({
    super.key,
    required this.title,
    this.onMenuPressed,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(AppSizes.topNavHeight);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDesktop = Responsive.isDesktop(context) || Responsive.isWideDesktop(context);
    final themeProvider = context.watch<ThemeProvider>();
    final authProvider = context.watch<AuthProvider>();

    return Container(
      height: AppSizes.topNavHeight,
      padding: EdgeInsets.symmetric(horizontal: Responsive.horizontalPadding(context)),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          if (!isDesktop) ...[
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: onMenuPressed,
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          ...?actions,
          const SizedBox(width: AppSpacing.sm),

          // Theme Toggle
          IconButton(
            tooltip: themeProvider.isDarkMode ? 'Light Mode' : 'Dark Mode',
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              size: 20,
              color: AppColors.goldPrimary,
            ),
            onPressed: () => themeProvider.toggleTheme(),
          ),
          const SizedBox(width: AppSpacing.sm),

          // Admin User Profile Avatar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurfaceVariant,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: AppColors.goldPrimary.withAlpha(50),
                  child: Text(
                    authProvider.currentUser?.name.substring(0, 1).toUpperCase() ?? 'A',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.goldPrimary,
                    ),
                  ),
                ),
                if (isDesktop) ...[
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    authProvider.currentUser?.name ?? 'Administrator',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
