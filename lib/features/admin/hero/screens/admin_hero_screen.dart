import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_dialog.dart';
import '../../../../core/widgets/app_image_upload_field.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../domain/models/content_status.dart';
import '../../../../domain/models/hero_slide_model.dart';
import '../../../../presentation/providers/content_provider.dart';
import '../../shared/admin_scaffold.dart';

class AdminHeroScreen extends StatelessWidget {
  const AdminHeroScreen({super.key});

  void _showAddEditHeroDialog(BuildContext context, [HeroSlideModel? existing]) {
    final titleCtrl = TextEditingController(text: existing?.title ?? '');
    final subCtrl = TextEditingController(text: existing?.subtitle ?? '');
    final ctaTextCtrl = TextEditingController(text: existing?.ctaText ?? 'Book Appointment');
    final ctaLinkCtrl = TextEditingController(text: existing?.ctaLink ?? '/booking');
    final imgCtrl = TextEditingController(
      text: existing?.imageUrl ?? 'https://images.unsplash.com/photo-1560066984-138dadb4c035?auto=format&fit=crop&w=1920&q=80',
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(existing == null ? 'Add Hero Carousel Slide' : 'Edit Slide'),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppTextField(controller: titleCtrl, label: 'Hero Title'),
                const SizedBox(height: AppSpacing.sm),
                AppTextField(controller: subCtrl, label: 'Eyebrow Subtitle (e.g. LUXURY SPA)'),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(child: AppTextField(controller: ctaTextCtrl, label: 'Button Label')),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(child: AppTextField(controller: ctaLinkCtrl, label: 'Destination Route')),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                AppImageUploadField(
                  controller: imgCtrl,
                  label: 'High-Res Hero Image',
                  storageFolder: 'hero',
                  entityId: existing?.id,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          AppButton(
            text: existing == null ? 'Create Slide' : 'Save Changes',
            size: AppButtonSize.sm,
            onPressed: () async {
              final provider = context.read<ContentProvider>();
              final slide = HeroSlideModel(
                id: existing?.id ?? 'HERO-${DateTime.now().millisecondsSinceEpoch}',
                title: titleCtrl.text.trim(),
                subtitle: subCtrl.text.trim(),
                primaryCtaText: ctaTextCtrl.text.trim(),
                primaryCtaUrl: ctaLinkCtrl.text.trim(),
                secondaryCtaText: 'Explore Services',
                secondaryCtaUrl: '/services',
                imageUrl: imgCtrl.text.trim(),
                displayOrder: existing?.displayOrder ?? 0,
                status: existing?.status ?? ContentStatus.published,
                isActive: existing?.isActive ?? true,
              );

              await provider.saveHeroSlide(slide, isNew: existing == null);
              if (ctx.mounted) Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final contentProvider = context.watch<ContentProvider>();
    final slides = contentProvider.allHeroSlides;

    return AdminScaffold(
      title: 'Hero Banner Carousel CMS',
      currentRoute: AppRouter.adminHero,
      actions: [
        AppButton(
          text: 'Add Slide',
          size: AppButtonSize.sm,
          icon: Icons.add,
          onPressed: () => _showAddEditHeroDialog(context),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: AppCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: slides.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(AppSpacing.xxl),
                  child: Center(child: Text('No hero slides defined.')),
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Preview')),
                      DataColumn(label: Text('Headline')),
                      DataColumn(label: Text('Tagline')),
                      DataColumn(label: Text('CTA Button')),
                      DataColumn(label: Text('Active')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: slides.map((s) {
                      return DataRow(
                        cells: [
                          DataCell(
                            ClipRRect(
                              borderRadius: AppRadius.borderXs,
                              child: Image.network(
                                s.imageUrl,
                                width: 64,
                                height: 36,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(width: 64, height: 36, color: AppColors.goldMuted),
                              ),
                            ),
                          ),
                          DataCell(Text(s.title, style: const TextStyle(fontWeight: FontWeight.bold))),
                          DataCell(Text(s.subtitle)),
                          DataCell(Text('${s.ctaText} (${s.ctaLink})', style: const TextStyle(fontSize: 12))),
                          DataCell(
                            Switch(
                              value: s.isActive,
                              activeThumbColor: AppColors.goldPrimary,
                              onChanged: (val) {
                                final updated = s.copyWith(isActive: val);
                                contentProvider.saveHeroSlide(updated);
                              },
                            ),
                          ),
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined, size: 18),
                                  onPressed: () => _showAddEditHeroDialog(context, s),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.error),
                                  onPressed: () async {
                                    final confirm = await AppDialog.showConfirmation(
                                      context: context,
                                      title: 'Delete Hero Slide',
                                      subtitle: 'Remove "${s.title}" from the homepage carousel?',
                                      confirmText: 'Delete',
                                      isDestructive: true,
                                    );
                                    if (confirm == true) {
                                      await contentProvider.deleteHeroSlideById(s.id);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
        ),
      ),
    );
  }
}
