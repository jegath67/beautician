import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/responsive/responsive_layout.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../presentation/providers/beauticians_provider.dart';
import '../../../../presentation/providers/content_provider.dart';
import '../../../../presentation/providers/reviews_provider.dart';
import '../../../../presentation/providers/services_provider.dart';
import '../../shared/user_scaffold.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const UserScaffold(
      currentRoute: AppRouter.home,
      child: Column(
        children: [
          _HeroSliderSection(),
          _StatsHighlightBar(),
          _FeaturedServicesSection(),
          _ArtisansSection(),
          _ReviewsSection(),
          _CtaBannerSection(),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// 1. HERO SLIDER SECTION
// -------------------------------------------------------------
class _HeroSliderSection extends StatefulWidget {
  const _HeroSliderSection();

  @override
  State<_HeroSliderSection> createState() => _HeroSliderSectionState();
}

class _HeroSliderSectionState extends State<_HeroSliderSection> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context) || Responsive.isWideDesktop(context);
    final height = isDesktop ? 620.0 : 480.0;
    final contentProvider = context.watch<ContentProvider>();
    final slides = contentProvider.heroSlides;

    if (slides.isEmpty) {
      return SizedBox(
        height: height,
        child: const AppLoader(message: 'Loading luxury experiences...'),
      );
    }

    return SizedBox(
      height: height,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemCount: slides.length,
            itemBuilder: (context, index) {
              final slide = slides[index];
              return Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    slide.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: AppColors.darkSurface),
                  ),
                  // Luxury dark gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withAlpha(90),
                          Colors.black.withAlpha(200),
                        ],
                      ),
                    ),
                  ),
                  // Hero Content
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: AppSizes.maxContentWidth),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Responsive.horizontalPadding(context),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.goldPrimary.withAlpha(40),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppColors.goldPrimary,
                                  width: 1.2,
                                ),
                              ),
                              child: Text(
                                slide.subtitle.toUpperCase(),
                                style: const TextStyle(
                                  color: AppColors.goldPrimary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 2.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Text(
                              slide.title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: isDesktop ? 48 : 32,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: -0.5,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 620),
                              child: Text(
                                'Immerse in bespoke treatments crafted with rare botanicals, European techniques, and intuitive artisan touch.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: isDesktop ? 16 : 14,
                                  color: Colors.white.withAlpha(210),
                                  height: 1.6,
                                ),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xl),
                            Wrap(
                              spacing: AppSpacing.md,
                              runSpacing: AppSpacing.sm,
                              alignment: WrapAlignment.center,
                              children: [
                                AppButton(
                                  text: slide.ctaText.isNotEmpty ? slide.ctaText : AppStrings.bookAppointment,
                                  size: AppButtonSize.lg,
                                  icon: Icons.calendar_today_outlined,
                                  onPressed: () => context.go(slide.ctaLink.isNotEmpty ? slide.ctaLink : AppRouter.booking),
                                ),
                                AppButton(
                                  text: AppStrings.viewServices,
                                  variant: AppButtonVariant.outline,
                                  size: AppButtonSize.lg,
                                  onPressed: () => context.go(AppRouter.services),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // Slide indicator dots
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                slides.length,
                (index) => GestureDetector(
                  onTap: () => _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentIndex == index ? 28 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentIndex == index ? AppColors.goldPrimary : Colors.white.withAlpha(100),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// 2. STATS & HIGHLIGHTS BAR
// -------------------------------------------------------------
class _StatsHighlightBar extends StatelessWidget {
  const _StatsHighlightBar();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurfaceVariant,
        border: Border.symmetric(
          horizontal: BorderSide(
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
              vertical: AppSpacing.xl,
            ),
            child: const Responsive(
              mobile: Column(
                children: [
                  _StatItem(number: '12+', label: 'Master Stylists & Artisans'),
                  SizedBox(height: AppSpacing.lg),
                  _StatItem(number: '35+', label: 'Signature Rituals & Services'),
                  SizedBox(height: AppSpacing.lg),
                  _StatItem(number: '4.9★', label: 'Average Client Rating'),
                  SizedBox(height: AppSpacing.lg),
                  _StatItem(number: '10,000+', label: 'Transformations Completed'),
                ],
              ),
              desktop: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _StatItem(number: '12+', label: 'Master Stylists & Artisans'),
                  _StatItem(number: '35+', label: 'Signature Rituals & Services'),
                  _StatItem(number: '4.9★', label: 'Average Client Rating'),
                  _StatItem(number: '10,000+', label: 'Transformations Completed'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String number;
  final String label;

  const _StatItem({required this.number, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          number,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: AppColors.goldPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}

// -------------------------------------------------------------
// 3. FEATURED SERVICES SECTION
// -------------------------------------------------------------
class _FeaturedServicesSection extends StatelessWidget {
  const _FeaturedServicesSection();

  @override
  Widget build(BuildContext context) {
    final servicesProvider = context.watch<ServicesProvider>();
    final featuredServices = servicesProvider.featuredServices;

    return ResponsiveContainer(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.horizontalPadding(context),
        vertical: AppSpacing.xxxl,
      ),
      child: Column(
        children: [
          AppSectionHeader(
            eyebrow: 'Our Signature Menu',
            title: 'Indulgent Rituals & Treatments',
            subtitle:
                'Carefully composed treatments blending high-performance botanical products with bespoke aesthetic craftsmanship.',
            isCentered: true,
          ),
          const SizedBox(height: AppSpacing.xl),
          if (featuredServices.isEmpty)
            const AppLoader(message: 'Loading featured services...')
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final columns = Responsive.gridColumns(context, mobile: 1, tablet: 2, desktop: 3);
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: AppSpacing.lg,
                    mainAxisSpacing: AppSpacing.lg,
                    childAspectRatio: 0.82,
                  ),
                  itemCount: featuredServices.take(6).length,
                  itemBuilder: (context, index) {
                    final service = featuredServices[index];
                    return AppCard(
                      padding: EdgeInsets.zero,
                      onTap: () => context.go(AppRouter.booking),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 5,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.network(
                                    service.imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(color: AppColors.goldMuted),
                                  ),
                                  Positioned(
                                    top: 12,
                                    right: 12,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withAlpha(180),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: AppColors.goldPrimary, width: 1),
                                      ),
                                      child: Text(
                                        '\$${service.price.toStringAsFixed(0)}',
                                        style: const TextStyle(
                                          color: AppColors.goldPrimary,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(AppSpacing.md),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.access_time, size: 14, color: AppColors.goldPrimary),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${service.durationMinutes} mins',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColors.goldPrimary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        service.category.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 10,
                                          letterSpacing: 1.2,
                                          fontWeight: FontWeight.w700,
                                          color: Theme.of(context).textTheme.bodySmall?.color?.withAlpha(140),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: AppSpacing.xs),
                                  Text(
                                    service.name,
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: AppSpacing.xs),
                                  Expanded(
                                    child: Text(
                                      service.description,
                                      style: TextStyle(
                                        fontSize: 12,
                                        height: 1.4,
                                        color: Theme.of(context).textTheme.bodyMedium?.color?.withAlpha(180),
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.sm),
                                  AppButton(
                                    text: 'Book Ritual',
                                    size: AppButtonSize.sm,
                                    isFullWidth: true,
                                    variant: AppButtonVariant.outline,
                                    onPressed: () => context.go(AppRouter.booking),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          const SizedBox(height: AppSpacing.xxl),
          AppButton(
            text: 'View Complete Catalog',
            variant: AppButtonVariant.primary,
            size: AppButtonSize.md,
            icon: Icons.arrow_forward,
            isTrailingIcon: true,
            onPressed: () => context.go(AppRouter.services),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// 4. MASTER ARTISANS SECTION
// -------------------------------------------------------------
class _ArtisansSection extends StatelessWidget {
  const _ArtisansSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final beauticiansProvider = context.watch<BeauticiansProvider>();
    final beauticians = beauticiansProvider.activeBeauticians;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurfaceVariant,
      ),
      child: ResponsiveContainer(
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.horizontalPadding(context),
          vertical: AppSpacing.xxxl,
        ),
        child: Column(
          children: [
            AppSectionHeader(
              eyebrow: 'Our Specialists',
              title: 'Meet the Master Artisans',
              subtitle:
                  'Trained across world capitals of fashion and wellness, our team brings meticulous attention to every client session.',
              isCentered: true,
            ),
            const SizedBox(height: AppSpacing.xl),
            if (beauticians.isEmpty)
              const AppLoader(message: 'Loading artisans...')
            else
              LayoutBuilder(
                builder: (context, constraints) {
                  final columns = Responsive.gridColumns(context, mobile: 1, tablet: 2, desktop: 4);
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: AppSpacing.lg,
                      mainAxisSpacing: AppSpacing.lg,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: beauticians.take(4).length,
                    itemBuilder: (context, index) {
                      final artisan = beauticians[index];
                      return AppCard(
                        padding: EdgeInsets.zero,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 6,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                child: Image.network(
                                  artisan.imageUrl,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(color: AppColors.goldMuted),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(AppSpacing.md),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      artisan.name,
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      artisan.title,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.goldPrimary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: AppSpacing.xs),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.star, size: 14, color: AppColors.goldPrimary),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${artisan.rating} (${artisan.reviewCount} reviews)',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: theme.textTheme.bodySmall?.color?.withAlpha(160),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
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
    );
  }
}

// -------------------------------------------------------------
// 5. CLIENT REVIEWS SECTION
// -------------------------------------------------------------
class _ReviewsSection extends StatelessWidget {
  const _ReviewsSection();

  @override
  Widget build(BuildContext context) {
    final reviewsProvider = context.watch<ReviewsProvider>();
    final reviews = reviewsProvider.approvedReviews;

    return ResponsiveContainer(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.horizontalPadding(context),
        vertical: AppSpacing.xxxl,
      ),
      child: Column(
        children: [
          AppSectionHeader(
            eyebrow: 'Client Words',
            title: 'Testimonials of Radiance',
            subtitle: 'Read genuine impressions from guests who made Aura & Co. their sacred sanctuary of self-care.',
            isCentered: true,
          ),
          const SizedBox(height: AppSpacing.xl),
          if (reviews.isEmpty)
            const AppLoader(message: 'Loading reviews...')
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final columns = Responsive.gridColumns(context, mobile: 1, tablet: 2, desktop: 3);
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: AppSpacing.lg,
                    mainAxisSpacing: AppSpacing.lg,
                    childAspectRatio: 1.25,
                  ),
                  itemCount: reviews.take(3).length,
                  itemBuilder: (context, index) {
                    final review = reviews[index];
                    return AppCard(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: List.generate(
                              5,
                              (i) => Icon(
                                i < review.rating ? Icons.star : Icons.star_border,
                                size: 16,
                                color: AppColors.goldPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Expanded(
                            child: Text(
                              '"${review.comment}"',
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                height: 1.5,
                                fontSize: 13,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 4,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: AppColors.goldPrimary.withAlpha(40),
                                child: Text(
                                  review.clientName.substring(0, 1).toUpperCase(),
                                  style: const TextStyle(
                                    color: AppColors.goldPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    review.clientName,
                                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                                  ),
                                  Text(
                                    review.serviceName,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.goldPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
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
    );
  }
}

// -------------------------------------------------------------
// 6. CTA BANNER SECTION
// -------------------------------------------------------------
class _CtaBannerSection extends StatelessWidget {
  const _CtaBannerSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF141318),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 64),
            child: Column(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.goldPrimary, width: 1.5),
                  ),
                  child: const Center(
                    child: Icon(Icons.auto_awesome, color: AppColors.goldPrimary, size: 24),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                const Text(
                  'Begin Your Personalized Beauty Journey',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                const Text(
                  'Reserve your bespoke ritual today with our award-winning master artisans. Luxury, privacy, and impeccable results await.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFFA5A5B5),
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                AppButton(
                  text: 'Reserve Appointment Now',
                  size: AppButtonSize.lg,
                  icon: Icons.calendar_month,
                  onPressed: () => context.go(AppRouter.booking),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
