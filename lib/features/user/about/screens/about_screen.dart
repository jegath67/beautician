import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/responsive/responsive_layout.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../presentation/providers/content_provider.dart';
import '../../shared/user_scaffold.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isDesktop = Responsive.isDesktop(context) || Responsive.isWideDesktop(context);
    final contentProvider = context.watch<ContentProvider>();
    final about = contentProvider.aboutContent;

    return UserScaffold(
      currentRoute: AppRouter.about,
      child: Column(
        children: [
          // Header Banner
          Container(
            padding: const EdgeInsets.symmetric(vertical: 60),
            color: isDark ? AppColors.darkSurface : AppColors.lightSurfaceVariant,
            child: ResponsiveContainer(
              child: AppSectionHeader(
                eyebrow: 'Our Heritage',
                title: about?.title ?? 'The Aura & Co. Philosophy',
                subtitle: about?.subtitle ??
                    'Where timeless luxury converges with tailored aesthetic excellence and sustainable botanical care.',
                isCentered: true,
              ),
            ),
          ),

          // Story & Founder Section
          ResponsiveContainer(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.horizontalPadding(context),
              vertical: AppSpacing.xxxl,
            ),
            child: Column(
              children: [
                if (isDesktop)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: AppRadius.borderLg,
                          child: Image.network(
                            about?.founderImageUrl ??
                                'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=800&q=80',
                            height: 440,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(height: 440, color: AppColors.goldMuted),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xxl),
                      Expanded(
                        child: _buildStoryContent(context, about?.story, about?.founderName, about?.founderRole),
                      ),
                    ],
                  )
                else
                  Column(
                    children: [
                      ClipRRect(
                        borderRadius: AppRadius.borderLg,
                        child: Image.network(
                          about?.founderImageUrl ??
                              'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=800&q=80',
                          height: 320,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(height: 320, color: AppColors.goldMuted),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      _buildStoryContent(context, about?.story, about?.founderName, about?.founderRole),
                    ],
                  ),

                const SizedBox(height: AppSpacing.xxxl),

                // Core Pillars / Values
                const AppSectionHeader(
                  eyebrow: 'Our Commitments',
                  title: 'The Pillars of Our Craft',
                  subtitle: 'Every ritual at Aura & Co. is guided by principles of uncompromising quality and mindful beauty.',
                  isCentered: true,
                ),
                const SizedBox(height: AppSpacing.xl),

                LayoutBuilder(
                  builder: (context, constraints) {
                    final cols = Responsive.gridColumns(context, mobile: 1, tablet: 2, desktop: 3);
                    final values = about?.values.isNotEmpty == true
                        ? about!.values
                        : [
                            'Clean Botanical Formulations without parabens or harsh chemicals',
                            'Master Artisan Expertise with European and Parisian certifications',
                            'Sanctuary of Complete Privacy with dedicated VIP treatment suites',
                          ];

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: cols,
                        crossAxisSpacing: AppSpacing.lg,
                        mainAxisSpacing: AppSpacing.lg,
                        childAspectRatio: 1.5,
                      ),
                      itemCount: values.length,
                      itemBuilder: (context, index) {
                        return AppCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.goldPrimary.withAlpha(30),
                                ),
                                child: Center(
                                  child: Text(
                                    '0${index + 1}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.goldPrimary,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppSpacing.md),
                              Text(
                                values[index],
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, height: 1.4),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryContent(BuildContext context, String? story, String? founderName, String? founderRole) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'A Legacy of Aesthetic Refinement',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, letterSpacing: -0.5),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          story ??
              'Founded with a profound reverence for natural beauty, Aura & Co. was conceived as an architectural oasis where high salon technique meets mindful tranquility. We curate the globe\'s most precious botanical serums and combine them with artisan mastery.',
          style: const TextStyle(fontSize: 15, height: 1.7),
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            Container(
              width: 3,
              height: 48,
              color: AppColors.goldPrimary,
            ),
            const SizedBox(width: AppSpacing.md),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  founderName ?? 'Madame Vivienne Laurent',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                Text(
                  founderRole ?? 'Master Creative Director & Founder',
                  style: const TextStyle(fontSize: 13, color: AppColors.goldPrimary),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        AppButton(
          text: 'Experience Aura Rituals',
          onPressed: () => context.go(AppRouter.booking),
        ),
      ],
    );
  }
}
