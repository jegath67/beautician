import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/responsive/responsive_layout.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../presentation/providers/theme_provider.dart';

class UserHeader extends StatelessWidget implements PreferredSizeWidget {
  final String currentRoute;
  final VoidCallback? onMenuPressed;

  const UserHeader({
    super.key,
    required this.currentRoute,
    this.onMenuPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(AppSizes.topNavHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isDesktop = Responsive.isDesktop(context) || Responsive.isWideDesktop(context);
    final themeProvider = context.watch<ThemeProvider>();

    return Container(
      height: AppSizes.topNavHeight,
      decoration: BoxDecoration(
        color: (isDark ? AppColors.darkBackground : AppColors.lightBackground).withAlpha(240),
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 1,
          ),
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppSizes.maxContentWidth),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.horizontalPadding(context),
            ),
            child: Row(
              children: [
                // Brand Logo
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => context.go(AppRouter.home),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.goldPrimary, width: 1.5),
                            gradient: RadialGradient(
                              colors: [
                                AppColors.goldPrimary.withAlpha(40),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'A',
                              style: TextStyle(
                                color: AppColors.goldPrimary,
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                                fontFamily: 'Playfair Display',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              AppStrings.appName,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 2.0,
                              ),
                            ),
                            Text(
                              'SALON & SPA',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 2.5,
                                color: AppColors.goldPrimary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                // Desktop Navigation Items
                if (isDesktop) ...[
                  Flexible(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _NavItem(
                            title: AppStrings.navHome,
                            route: AppRouter.home,
                            isActive: currentRoute == AppRouter.home,
                          ),
                          _NavItem(
                            title: AppStrings.navServices,
                            route: AppRouter.services,
                            isActive: currentRoute == AppRouter.services,
                          ),
                          _NavItem(
                            title: AppStrings.navGallery,
                            route: AppRouter.gallery,
                            isActive: currentRoute == AppRouter.gallery,
                          ),
                          _NavItem(
                            title: AppStrings.navAbout,
                            route: AppRouter.about,
                            isActive: currentRoute == AppRouter.about,
                          ),
                          _NavItem(
                            title: AppStrings.navContact,
                            route: AppRouter.contact,
                            isActive: currentRoute == AppRouter.contact,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                ],

                // Theme Toggle
                IconButton(
                  tooltip: themeProvider.isDarkMode ? 'Switch to Light Theme' : 'Switch to Dark Theme',
                  icon: Icon(
                    themeProvider.isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                    color: AppColors.goldPrimary,
                    size: 20,
                  ),
                  onPressed: () => themeProvider.toggleTheme(),
                ),

                // Admin Portal Link
                IconButton(
                  tooltip: 'Admin Portal',
                  icon: const Icon(Icons.admin_panel_settings_outlined, size: 20),
                  onPressed: () => context.go(AppRouter.adminLogin),
                ),

                if (isDesktop) ...[
                  const SizedBox(width: AppSpacing.sm),
                  AppButton(
                    text: AppStrings.bookAppointment,
                    size: AppButtonSize.sm,
                    icon: Icons.calendar_today_outlined,
                    onPressed: () => context.go(AppRouter.booking),
                  ),
                ] else ...[
                  const SizedBox(width: AppSpacing.xs),
                  IconButton(
                    icon: const Icon(Icons.menu, size: 24),
                    onPressed: onMenuPressed,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  final String title;
  final String route;
  final bool isActive;

  const _NavItem({
    required this.title,
    required this.route,
    required this.isActive,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => context.go(widget.route),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: widget.isActive ? FontWeight.w700 : FontWeight.w500,
                  letterSpacing: 0.5,
                  color: widget.isActive || _isHovered
                      ? AppColors.goldPrimary
                      : theme.textTheme.bodyMedium?.color?.withAlpha(200),
                ),
              ),
              const SizedBox(height: 4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 2,
                width: widget.isActive ? 24 : (_isHovered ? 16 : 0),
                decoration: BoxDecoration(
                  color: AppColors.goldPrimary,
                  borderRadius: AppRadius.borderFull,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
