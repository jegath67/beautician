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
import '../../../../domain/models/gallery_item_model.dart';
import '../../../../presentation/providers/gallery_provider.dart';
import '../../shared/admin_scaffold.dart';

class AdminGalleryScreen extends StatelessWidget {
  const AdminGalleryScreen({super.key});

  void _showAddEditItemDialog(BuildContext context, [GalleryItemModel? existing]) {
    final titleCtrl = TextEditingController(text: existing?.title ?? '');
    final catCtrl = TextEditingController(text: existing?.category ?? 'Hair Design');
    final descCtrl = TextEditingController(text: existing?.description ?? '');
    final imgCtrl = TextEditingController(
      text: existing?.imageUrl ?? 'https://images.unsplash.com/photo-1560066984-138dadb4c035?auto=format&fit=crop&w=800&q=80',
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(existing == null ? 'Add Transformation Artwork' : 'Edit Artwork'),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppTextField(controller: titleCtrl, label: 'Transformation Title'),
                const SizedBox(height: AppSpacing.sm),
                AppTextField(controller: catCtrl, label: 'Category (Bridal, Hair, Skin, Nails)'),
                const SizedBox(height: AppSpacing.sm),
                AppImageUploadField(
                  controller: imgCtrl,
                  label: 'Artwork Image',
                  storageFolder: 'gallery',
                  entityId: existing?.id,
                ),
                const SizedBox(height: AppSpacing.sm),
                AppTextField(controller: descCtrl, label: 'Description & Client Details', maxLines: 3),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          AppButton(
            text: existing == null ? 'Add to Gallery' : 'Save Changes',
            size: AppButtonSize.sm,
            onPressed: () async {
              final provider = context.read<GalleryProvider>();
              final item = GalleryItemModel(
                id: existing?.id ?? 'GAL-${DateTime.now().millisecondsSinceEpoch}',
                title: titleCtrl.text.trim(),
                category: catCtrl.text.trim(),
                description: descCtrl.text.trim(),
                imageUrl: imgCtrl.text.trim(),
                status: existing?.status ?? ContentStatus.published,
                createdAt: existing?.createdAt ?? DateTime.now(),
              );

              if (existing == null) {
                await provider.addItem(item);
              } else {
                await provider.updateItem(item);
              }
              if (ctx.mounted) Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final galleryProvider = context.watch<GalleryProvider>();
    final items = galleryProvider.allItems;

    return AdminScaffold(
      title: 'Gallery & Transformation Portfolio Studio',
      currentRoute: AppRouter.adminGallery,
      actions: [
        AppButton(
          text: 'Upload Artwork',
          size: AppButtonSize.sm,
          icon: Icons.add_photo_alternate_outlined,
          onPressed: () => _showAddEditItemDialog(context),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: AppCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: items.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(AppSpacing.xxl),
                  child: Center(child: Text('No artworks in gallery.')),
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Artwork')),
                      DataColumn(label: Text('Title')),
                      DataColumn(label: Text('Category')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: items.map((i) {
                      return DataRow(
                        cells: [
                          DataCell(
                            ClipRRect(
                              borderRadius: AppRadius.borderXs,
                              child: Image.network(
                                i.imageUrl,
                                width: 44,
                                height: 44,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(width: 44, height: 44, color: AppColors.goldMuted),
                              ),
                            ),
                          ),
                          DataCell(
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(i.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                                Text(i.description ?? '', style: TextStyle(fontSize: 11, color: Theme.of(context).textTheme.bodySmall?.color?.withAlpha(160))),
                              ],
                            ),
                          ),
                          DataCell(Text(i.category)),
                          DataCell(
                            Switch(
                              value: i.status == ContentStatus.published,
                              activeThumbColor: AppColors.goldPrimary,
                              onChanged: (_) => galleryProvider.togglePublishStatusById(i.id),
                            ),
                          ),
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined, size: 18),
                                  onPressed: () => _showAddEditItemDialog(context, i),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.error),
                                  onPressed: () async {
                                    final confirm = await AppDialog.showConfirmation(
                                      context: context,
                                      title: 'Delete Artwork',
                                      subtitle: 'Remove "${i.title}" from the public gallery?',
                                      confirmText: 'Delete',
                                      isDestructive: true,
                                    );
                                    if (confirm == true) {
                                      await galleryProvider.deleteItem(i.id);
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
