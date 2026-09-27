import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/responsive/responsive_layout.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../presentation/providers/theme_provider.dart';
import 'user_footer.dart';
import 'user_header.dart';

class UserScaffold extends StatefulWidget {
  final Widget child;
  final String currentRoute;
  final bool showFooter;

  const UserScaffold({
    super.key,
    required this.child,
    required this.currentRoute,
    this.showFooter = true,
  });

  @override
  State<UserScaffold> createState() => _UserScaffoldState();
}

class _UserScaffoldState extends State<UserScaffold> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: theme.scaffoldBackgroundColor,
      endDrawer: !Responsive.isDesktop(context) && !Responsive.isWideDesktop(context)
          ? _buildMobileDrawer(context)
          : null,
      body: Column(
        children: [
          UserHeader(
            currentRoute: widget.currentRoute,
            onMenuPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  widget.child,
                  if (widget.showFooter) const UserFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: isMobile && widget.currentRoute != AppRouter.booking
          ? Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                border: Border(
                  top: BorderSide(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
              ),
              child: SafeArea(
                child: AppButton(
                  text: AppStrings.bookAppointment,
                  isFullWidth: true,
                  icon: Icons.calendar_today_outlined,
                  onPressed: () => context.go(AppRouter.booking),
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildMobileDrawer(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final themeProvider = context.watch<ThemeProvider>();

    return Drawer(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
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
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Divider(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, height: 1),
            const SizedBox(height: AppSpacing.md),
            _DrawerItem(
              icon: Icons.home_outlined,
              label: AppStrings.navHome,
              isActive: widget.currentRoute == AppRouter.home,
              onTap: () {
                Navigator.of(context).pop();
                context.go(AppRouter.home);
              },
            ),
            _DrawerItem(
              icon: Icons.spa_outlined,
              label: AppStrings.navServices,
              isActive: widget.currentRoute == AppRouter.services,
              onTap: () {
                Navigator.of(context).pop();
                context.go(AppRouter.services);
              },
            ),
            _DrawerItem(
              icon: Icons.photo_library_outlined,
              label: AppStrings.navGallery,
              isActive: widget.currentRoute == AppRouter.gallery,
              onTap: () {
                Navigator.of(context).pop();
                context.go(AppRouter.gallery);
              },
            ),
            _DrawerItem(
              icon: Icons.calendar_today_outlined,
              label: AppStrings.navBooking,
              isActive: widget.currentRoute == AppRouter.booking,
              onTap: () {
                Navigator.of(context).pop();
                context.go(AppRouter.booking);
              },
            ),
            _DrawerItem(
              icon: Icons.info_outline,
              label: AppStrings.navAbout,
              isActive: widget.currentRoute == AppRouter.about,
              onTap: () {
                Navigator.of(context).pop();
                context.go(AppRouter.about);
              },
            ),
            _DrawerItem(
              icon: Icons.contact_mail_outlined,
              label: AppStrings.navContact,
              isActive: widget.currentRoute == AppRouter.contact,
              onTap: () {
                Navigator.of(context).pop();
                context.go(AppRouter.contact);
              },
            ),
            const Spacer(),
            Divider(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, height: 1),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    themeProvider.isDarkMode ? 'Dark Mode' : 'Light Mode',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  IconButton(
                    icon: Icon(
                      themeProvider.isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                      color: AppColors.goldPrimary,
                    ),
                    onPressed: () => themeProvider.toggleTheme(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
              child: AppButton(
                text: 'Admin Portal',
                variant: AppButtonVariant.outline,
                isFullWidth: true,
                icon: Icons.lock_outline,
                onPressed: () {
                  Navigator.of(context).pop();
                  context.go(AppRouter.adminLogin);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 2),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderSm),
        tileColor: isActive ? AppColors.goldPrimary.withAlpha(20) : null,
        leading: Icon(
          icon,
          color: isActive ? AppColors.goldPrimary : null,
          size: 20,
        ),
        title: Text(
          label,
          style: TextStyle(
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            color: isActive ? AppColors.goldPrimary : null,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
