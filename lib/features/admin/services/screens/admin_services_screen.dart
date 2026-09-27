import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_dialog.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../domain/models/content_status.dart';
import '../../../../domain/models/service_model.dart';
import '../../../../presentation/providers/services_provider.dart';
import '../../shared/admin_scaffold.dart';

class AdminServicesScreen extends StatelessWidget {
  const AdminServicesScreen({super.key});

  void _showAddEditServiceDialog(BuildContext context, [ServiceModel? existing]) {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final catCtrl = TextEditingController(text: existing?.category ?? 'Hair Design');
    final descCtrl = TextEditingController(text: existing?.description ?? '');
    final priceCtrl = TextEditingController(text: existing != null ? existing.price.toStringAsFixed(0) : '120');
    final durationCtrl = TextEditingController(text: existing != null ? existing.durationMinutes.toString() : '60');
    final imgCtrl = TextEditingController(
      text: existing?.imageUrl ?? 'https://images.unsplash.com/photo-1560066984-138dadb4c035?auto=format&fit=crop&w=800&q=80',
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(existing == null ? 'Add New Ritual Service' : 'Edit Service'),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppTextField(controller: nameCtrl, label: 'Service Name'),
                const SizedBox(height: AppSpacing.sm),
                AppTextField(controller: catCtrl, label: 'Category'),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(child: AppTextField(controller: priceCtrl, label: 'Price (\$)', keyboardType: TextInputType.number)),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(child: AppTextField(controller: durationCtrl, label: 'Duration (Mins)', keyboardType: TextInputType.number)),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                AppTextField(controller: imgCtrl, label: 'Cover Image URL'),
                const SizedBox(height: AppSpacing.sm),
                AppTextField(controller: descCtrl, label: 'Description', maxLines: 3),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          AppButton(
            text: existing == null ? 'Add Service' : 'Save Changes',
            size: AppButtonSize.sm,
            onPressed: () async {
              final provider = context.read<ServicesProvider>();
              final service = ServiceModel(
                id: existing?.id ?? 'SRV-${DateTime.now().millisecondsSinceEpoch}',
                title: nameCtrl.text.trim(),
                category: catCtrl.text.trim(),
                description: descCtrl.text.trim(),
                price: double.tryParse(priceCtrl.text.trim()) ?? 100.0,
                durationMinutes: int.tryParse(durationCtrl.text.trim()) ?? 60,
                imageUrl: imgCtrl.text.trim(),
                status: existing?.status ?? ContentStatus.published,
                isFeatured: existing?.isFeatured ?? false,
              );

              if (existing == null) {
                await provider.createService(service);
              } else {
                await provider.updateService(service);
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
    final servicesProvider = context.watch<ServicesProvider>();
    final services = servicesProvider.allServices;

    return AdminScaffold(
      title: 'Services & Treatment Catalog CMS',
      currentRoute: '/admin/services',
      actions: [
        AppButton(
          text: 'Add New Service',
          size: AppButtonSize.sm,
          icon: Icons.add,
          onPressed: () => _showAddEditServiceDialog(context),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: AppCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: services.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(AppSpacing.xxl),
                  child: Center(child: Text('No services found in database.')),
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Preview')),
                      DataColumn(label: Text('Service Name')),
                      DataColumn(label: Text('Category')),
                      DataColumn(label: Text('Duration')),
                      DataColumn(label: Text('Price')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: services.map((s) {
                      return DataRow(
                        cells: [
                          DataCell(
                            ClipRRect(
                              borderRadius: AppRadius.borderXs,
                              child: Image.network(
                                s.imageUrl,
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
                                Text(s.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                if (s.isFeatured)
                                  const Text('FEATURED', style: TextStyle(fontSize: 10, color: AppColors.goldPrimary, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          DataCell(Text(s.category)),
                          DataCell(Text('${s.durationMinutes} mins')),
                          DataCell(Text('\$${s.price.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold))),
                          DataCell(
                            Switch(
                              value: s.status == ContentStatus.published,
                              activeColor: AppColors.goldPrimary,
                              onChanged: (_) => servicesProvider.togglePublishStatusById(s.id),
                            ),
                          ),
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined, size: 18),
                                  onPressed: () => _showAddEditServiceDialog(context, s),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.error),
                                  onPressed: () async {
                                    final confirm = await AppDialog.showConfirmation(
                                      context: context,
                                      title: 'Delete Service',
                                      subtitle: 'Are you sure you want to delete "${s.name}"? This action cannot be undone.',
                                      confirmText: 'Delete',
                                      isDestructive: true,
                                    );
                                    if (confirm == true) {
                                      await servicesProvider.deleteServiceById(s.id);
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
