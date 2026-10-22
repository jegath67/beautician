import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/responsive/responsive_layout.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';

class UserFooter extends StatelessWidget {
  const UserFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isMobile = Responsive.isMobile(context);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurfaceVariant,
        border: Border(
          top: BorderSide(
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
              vertical: AppSpacing.xxl,
            ),
            child: Column(
              children: [
                // Top columns
                if (isMobile)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBrandColumn(),
                      const SizedBox(height: AppSpacing.xl),
                      _buildLinksColumn(context),
                      const SizedBox(height: AppSpacing.xl),
                      _buildContactColumn(),
                      const SizedBox(height: AppSpacing.xl),
                      _buildHoursColumn(),
                    ],
                  )
                else
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: _buildBrandColumn()),
                      const SizedBox(width: AppSpacing.xl),
                      Expanded(flex: 2, child: _buildLinksColumn(context)),
                      const SizedBox(width: AppSpacing.xl),
                      Expanded(flex: 2, child: _buildHoursColumn()),
                      const SizedBox(width: AppSpacing.xl),
                      Expanded(flex: 3, child: _buildContactColumn()),
                    ],
                  ),

                const SizedBox(height: AppSpacing.xxl),
                Divider(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  height: 1,
                ),
                const SizedBox(height: AppSpacing.lg),

                // Bottom copyright row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '© ${DateTime.now().year} ${AppStrings.appName}. All rights reserved.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodySmall?.color?.withAlpha(160),
                      ),
                    ),
                    Text(
                      'Crafted with Passion & Precision',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.goldPrimary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBrandColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
            const SizedBox(width: AppSpacing.sm),
            const Text(
              AppStrings.appName,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 2.0,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        const Text(
          'Indulge in a haven of serenity and high elegance. Our master artisans create tailored beauty and wellness rituals designed to elevate your natural radiance.',
          style: TextStyle(fontSize: 13, height: 1.6),
        ),
      ],
    );
  }

  Widget _buildLinksColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'QUICK LINKS',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
            color: AppColors.goldPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _FooterLink(label: 'Home', onTap: () => context.go(AppRouter.home)),
        _FooterLink(label: 'Services Catalog', onTap: () => context.go(AppRouter.services)),
        _FooterLink(label: 'Transformations', onTap: () => context.go(AppRouter.gallery)),
        _FooterLink(label: 'Book Appointment', onTap: () => context.go(AppRouter.booking)),
        _FooterLink(label: 'About Aura', onTap: () => context.go(AppRouter.about)),
        _FooterLink(label: 'Contact Concierge', onTap: () => context.go(AppRouter.contact)),
      ],
    );
  }

  Widget _buildHoursColumn() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'HOURS OF LUXURY',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
            color: AppColors.goldPrimary,
          ),
        ),
        SizedBox(height: AppSpacing.md),
        Text('Mon - Fri: 09:00 AM - 08:00 PM', style: TextStyle(fontSize: 13, height: 1.6)),
        Text('Saturday: 09:00 AM - 09:00 PM', style: TextStyle(fontSize: 13, height: 1.6)),
        Text('Sunday: 10:00 AM - 06:00 PM', style: TextStyle(fontSize: 13, height: 1.6)),
        SizedBox(height: AppSpacing.sm),
        Text(
          '* Appointments recommended',
          style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: AppColors.goldPrimary),
        ),
      ],
    );
  }

  Widget _buildContactColumn() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SALON CONCIERGE',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
            color: AppColors.goldPrimary,
          ),
        ),
        SizedBox(height: AppSpacing.md),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.location_on_outlined, size: 16, color: AppColors.goldPrimary),
            SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Text(
                '42 Luxury Avenue, Suite 100, Mayfair District',
                style: TextStyle(fontSize: 13, height: 1.4),
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Icon(Icons.phone_outlined, size: 16, color: AppColors.goldPrimary),
            SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Text(
                '+1 (800) 892-AURA',
                style: TextStyle(fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Icon(Icons.email_outlined, size: 16, color: AppColors.goldPrimary),
            SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Text(
                'concierge@aurasalon.com',
                style: TextStyle(fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _FooterLink({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, height: 1.5),
          ),
        ),
      ),
    );
  }
}
