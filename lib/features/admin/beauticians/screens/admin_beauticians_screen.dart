import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_dialog.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../domain/models/beautician_model.dart';
import '../../../../presentation/providers/beauticians_provider.dart';
import '../../shared/admin_scaffold.dart';

class AdminBeauticiansScreen extends StatelessWidget {
  const AdminBeauticiansScreen({super.key});

  void _showAddEditBeauticianDialog(BuildContext context, [BeauticianModel? existing]) {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final titleCtrl = TextEditingController(text: existing?.title ?? 'Master Stylist');
    final roleCtrl = TextEditingController(text: existing?.role ?? 'Senior Artist');
    final bioCtrl = TextEditingController(text: existing?.bio ?? '');
    final imgCtrl = TextEditingController(
      text: existing?.imageUrl ?? 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80',
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(existing == null ? 'Add New Beautician Specialist' : 'Edit Specialist'),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppTextField(controller: nameCtrl, label: 'Full Name'),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(child: AppTextField(controller: titleCtrl, label: 'Title (e.g. Master Colorist)')),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(child: AppTextField(controller: roleCtrl, label: 'Role')),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                AppTextField(controller: imgCtrl, label: 'Portrait Image URL'),
                const SizedBox(height: AppSpacing.sm),
                AppTextField(controller: bioCtrl, label: 'Biography & Certifications', maxLines: 3),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          AppButton(
            text: existing == null ? 'Add Specialist' : 'Save Changes',
            size: AppButtonSize.sm,
            onPressed: () async {
              final provider = context.read<BeauticiansProvider>();
              final beautician = BeauticianModel(
                id: existing?.id ?? 'ART-${DateTime.now().millisecondsSinceEpoch}',
                name: nameCtrl.text.trim(),
                role: titleCtrl.text.trim(),
                bio: bioCtrl.text.trim(),
                avatarUrl: imgCtrl.text.trim(),
                rating: existing?.rating ?? 4.9,
                reviewCount: existing?.reviewCount ?? 12,
                specialties: existing?.specialties ?? ['Hair', 'Color'],
                isActive: existing?.isActive ?? true,
              );

              if (existing == null) {
                await provider.createBeautician(beautician);
              } else {
                await provider.updateBeautician(beautician);
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
    final beauticiansProvider = context.watch<BeauticiansProvider>();
    final beauticians = beauticiansProvider.allBeauticians;

    return AdminScaffold(
      title: 'Salon Specialists & Artisans CMS',
      currentRoute: '/admin/beauticians',
      actions: [
        AppButton(
          text: 'Add Specialist',
          size: AppButtonSize.sm,
          icon: Icons.person_add_outlined,
          onPressed: () => _showAddEditBeauticianDialog(context),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: AppCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: beauticians.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(AppSpacing.xxl),
                  child: Center(child: Text('No specialists registered.')),
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Photo')),
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Title')),
                      DataColumn(label: Text('Rating')),
                      DataColumn(label: Text('Active')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: beauticians.map((b) {
                      return DataRow(
                        cells: [
                          DataCell(
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(b.imageUrl),
                              backgroundColor: AppColors.goldMuted,
                            ),
                          ),
                          DataCell(
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(b.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                Text(b.role, style: TextStyle(fontSize: 11, color: Theme.of(context).textTheme.bodySmall?.color?.withAlpha(160))),
                              ],
                            ),
                          ),
                          DataCell(Text(b.title)),
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.star, size: 14, color: AppColors.goldPrimary),
                                const SizedBox(width: 4),
                                Text('${b.rating} (${b.reviewCount})'),
                              ],
                            ),
                          ),
                          DataCell(
                            Switch(
                              value: b.isActive,
                              activeColor: AppColors.goldPrimary,
                              onChanged: (_) => beauticiansProvider.toggleActiveStatus(b.id),
                            ),
                          ),
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined, size: 18),
                                  onPressed: () => _showAddEditBeauticianDialog(context, b),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.error),
                                  onPressed: () async {
                                    final confirm = await AppDialog.showConfirmation(
                                      context: context,
                                      title: 'Delete Specialist',
                                      subtitle: 'Are you sure you want to remove "${b.name}" from the salon staff list?',
                                      confirmText: 'Delete',
                                      isDestructive: true,
                                    );
                                    if (confirm == true) {
                                      await beauticiansProvider.deleteBeauticianById(b.id);
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
