import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../presentation/providers/auth_provider.dart';

class AdminSidebar extends StatelessWidget {
  final String currentRoute;
  final bool isCollapsed;
  final VoidCallback? onToggleCollapse;

  const AdminSidebar({
    super.key,
    required this.currentRoute,
    this.isCollapsed = false,
    this.onToggleCollapse,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authProvider = context.read<AuthProvider>();

    final double width = isCollapsed
        ? AppSizes.adminSidebarCollapsedWidth
        : AppSizes.adminSidebarWidth;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: width,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        border: Border(
          right: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Sidebar Top Brand
          Container(
            height: AppSizes.topNavHeight,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.goldPrimary, width: 1.5),
                  ),
                  child: const Center(
                    child: Text(
                      'A',
                      style: TextStyle(
                        color: AppColors.goldPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                if (!isCollapsed) ...[
                  const SizedBox(width: AppSpacing.sm),
                  const Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AURA & CO.',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'ADMIN CONSOLE',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                            color: AppColors.goldPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Navigation Items Scrollable List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              children: [
                _AdminSidebarItem(
                  icon: Icons.dashboard_outlined,
                  activeIcon: Icons.dashboard,
                  title: 'Dashboard',
                  route: AppRouter.adminDashboard,
                  isActive: currentRoute == AppRouter.adminDashboard,
                  isCollapsed: isCollapsed,
                ),
                _AdminSidebarItem(
                  icon: Icons.calendar_today_outlined,
                  activeIcon: Icons.calendar_today,
                  title: 'Bookings',
                  route: AppRouter.adminBookings,
                  isActive: currentRoute == AppRouter.adminBookings,
                  isCollapsed: isCollapsed,
                ),
                _AdminSidebarItem(
                  icon: Icons.spa_outlined,
                  activeIcon: Icons.spa,
                  title: 'Services CMS',
                  route: AppRouter.adminServices,
                  isActive: currentRoute == AppRouter.adminServices,
                  isCollapsed: isCollapsed,
                ),
                _AdminSidebarItem(
                  icon: Icons.people_outline,
                  activeIcon: Icons.people,
                  title: 'Beauticians',
                  route: AppRouter.adminBeauticians,
                  isActive: currentRoute == AppRouter.adminBeauticians,
                  isCollapsed: isCollapsed,
                ),
                _AdminSidebarItem(
                  icon: Icons.photo_library_outlined,
                  activeIcon: Icons.photo_library,
                  title: 'Gallery Studio',
                  route: AppRouter.adminGallery,
                  isActive: currentRoute == AppRouter.adminGallery,
                  isCollapsed: isCollapsed,
                ),
                _AdminSidebarItem(
                  icon: Icons.rate_review_outlined,
                  activeIcon: Icons.rate_review,
                  title: 'Client Reviews',
                  route: AppRouter.adminReviews,
                  isActive: currentRoute == AppRouter.adminReviews,
                  isCollapsed: isCollapsed,
                ),
                _AdminSidebarItem(
                  icon: Icons.contact_mail_outlined,
                  activeIcon: Icons.contact_mail,
                  title: 'Enquiries CRM',
                  route: AppRouter.adminEnquiries,
                  isActive: currentRoute == AppRouter.adminEnquiries,
                  isCollapsed: isCollapsed,
                ),
                _AdminSidebarItem(
                  icon: Icons.view_carousel_outlined,
                  activeIcon: Icons.view_carousel,
                  title: 'Hero Slides',
                  route: AppRouter.adminHero,
                  isActive: currentRoute == AppRouter.adminHero,
                  isCollapsed: isCollapsed,
                ),
                _AdminSidebarItem(
                  icon: Icons.article_outlined,
                  activeIcon: Icons.article,
                  title: 'About Content',
                  route: AppRouter.adminAbout,
                  isActive: currentRoute == AppRouter.adminAbout,
                  isCollapsed: isCollapsed,
                ),
                _AdminSidebarItem(
                  icon: Icons.contact_phone_outlined,
                  activeIcon: Icons.contact_phone,
                  title: 'Contact Info',
                  route: AppRouter.adminContact,
                  isActive: currentRoute == AppRouter.adminContact,
                  isCollapsed: isCollapsed,
                ),
                _AdminSidebarItem(
                  icon: Icons.tune_outlined,
                  activeIcon: Icons.tune,
                  title: 'Branding Settings',
                  route: AppRouter.adminSettings,
                  isActive: currentRoute == AppRouter.adminSettings,
                  isCollapsed: isCollapsed,
                ),
                _AdminSidebarItem(
                  icon: Icons.history_outlined,
                  activeIcon: Icons.history,
                  title: 'Audit Logs',
                  route: AppRouter.adminAuditLogs,
                  isActive: currentRoute == AppRouter.adminAuditLogs,
                  isCollapsed: isCollapsed,
                ),
              ],
            ),
          ),

          // Bottom actions (Logout & View Site)
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                _AdminSidebarItem(
                  icon: Icons.public_outlined,
                  activeIcon: Icons.public,
                  title: 'Public Site',
                  route: AppRouter.home,
                  isActive: false,
                  isCollapsed: isCollapsed,
                ),
                ListTile(
                  dense: true,
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.borderSm),
                  leading: const Icon(Icons.logout, size: 20, color: AppColors.error),
                  title: isCollapsed
                      ? null
                      : const Text(
                          'Log Out',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                  onTap: () async {
                    await authProvider.logout();
                    if (context.mounted) {
                      context.go(AppRouter.home);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminSidebarItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String title;
  final String route;
  final bool isActive;
  final bool isCollapsed;

  const _AdminSidebarItem({
    required this.icon,
    required this.activeIcon,
    required this.title,
    required this.route,
    required this.isActive,
    required this.isCollapsed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
      child: Tooltip(
        message: isCollapsed ? title : '',
        child: ListTile(
          dense: true,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.borderSm),
          tileColor: isActive ? AppColors.goldPrimary.withAlpha(25) : null,
          leading: Icon(
            isActive ? activeIcon : icon,
            size: 20,
            color: isActive ? AppColors.goldPrimary : null,
          ),
          title: isCollapsed
              ? null
              : Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    color: isActive ? AppColors.goldPrimary : null,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
          onTap: () => context.go(route),
        ),
      ),
    );
  }
}
