import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/responsive/responsive_layout.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../domain/models/service_model.dart';
import '../../../../presentation/providers/services_provider.dart';
import '../../shared/user_scaffold.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = [
    'All',
    'Hair Design',
    'Facials & Skin',
    'Bridal & Glamour',
    'Nail Couture',
    'Body & Spa',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final servicesProvider = context.watch<ServicesProvider>();
    final allServices = servicesProvider.services;

    final filteredServices = allServices.where((s) {
      final matchesCategory = _selectedCategory == 'All' ||
          s.category.toLowerCase().contains(_selectedCategory.toLowerCase().split(' ').first);
      final matchesSearch = _searchQuery.isEmpty ||
          s.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s.description.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return UserScaffold(
      currentRoute: AppRouter.services,
      child: ResponsiveContainer(
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.horizontalPadding(context),
          vertical: AppSpacing.xxl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppSectionHeader(
              eyebrow: 'Comprehensive Menu',
              title: 'Curated Services & Rituals',
              subtitle:
                  'Every treatment at Aura & Co. is a ritual of rejuvenation, orchestrated by masters of aesthetic care.',
            ),
            const SizedBox(height: AppSpacing.lg),

            // Search and Category Filters
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: _searchController,
                    hint: 'Search services, treatments, or ingredients...',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    onChanged: (val) => setState(() => _searchQuery = val),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Category Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _categories.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.sm),
                    child: FilterChip(
                      selected: isSelected,
                      label: Text(cat),
                      labelStyle: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? Colors.black : null,
                      ),
                      selectedColor: AppColors.goldPrimary,
                      checkmarkColor: Colors.black,
                      onSelected: (_) => setState(() => _selectedCategory = cat),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Results count
            Text(
              'Showing ${filteredServices.length} treatments',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.bodySmall?.color?.withAlpha(160),
                  ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Service Cards Grid
            if (filteredServices.isEmpty)
              AppEmptyState(
                icon: Icons.spa_outlined,
                title: 'No treatments found',
                description: 'Try adjusting your search query or choosing another category.',
                actionLabel: 'Reset Filters',
                onAction: () {
                  _searchController.clear();
                  setState(() {
                    _searchQuery = '';
                    _selectedCategory = 'All';
                  });
                },
              )
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
                      childAspectRatio: 0.85,
                    ),
                    itemCount: filteredServices.length,
                    itemBuilder: (context, index) {
                      final service = filteredServices[index];
                      return _ServiceCatalogCard(service: service);
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

class _ServiceCatalogCard extends StatelessWidget {
  final ServiceModel service;

  const _ServiceCatalogCard({required this.service});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
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
                      const Icon(Icons.access_time, size: 14, color: AppColors.goldPrimary),
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
                    text: 'Book This Ritual',
                    size: AppButtonSize.sm,
                    isFullWidth: true,
                    icon: Icons.calendar_today_outlined,
                    onPressed: () => context.go(AppRouter.booking),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
