import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../presentation/providers/content_provider.dart';
import '../../shared/admin_scaffold.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _salonNameCtrl;
  late TextEditingController _taglineCtrl;
  late TextEditingController _currencyCtrl;
  late TextEditingController _announcementCtrl;
  bool _isAnnouncementActive = false;

  bool _initialized = false;
  bool _isSaving = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final settings = context.read<ContentProvider>().brandingSettings;
      _salonNameCtrl = TextEditingController(text: settings?.brandName ?? 'AURA & CO.');
      _taglineCtrl = TextEditingController(text: settings?.tagline ?? 'Luxury Salon & Spa');
      _currencyCtrl = TextEditingController(text: settings?.currencySymbol ?? '₹');
      _announcementCtrl = TextEditingController(text: settings?.metaDescription ?? '');
      _isAnnouncementActive = false;
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _salonNameCtrl.dispose();
    _taglineCtrl.dispose();
    _currencyCtrl.dispose();
    _announcementCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    final provider = context.read<ContentProvider>();
    final current = provider.brandingSettings;

    if (current != null) {
      final updated = current.copyWith(
        brandName: _salonNameCtrl.text.trim(),
        tagline: _taglineCtrl.text.trim(),
        currencySymbol: _currencyCtrl.text.trim(),
        metaDescription: _announcementCtrl.text.trim(),
      );

      await provider.updateBrandingSettings(updated);
    }

    setState(() => _isSaving = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Branding and salon settings updated.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: 'Salon Branding & General Settings',
      currentRoute: AppRouter.adminSettings,
      actions: [
        AppButton(
          text: 'Save Settings',
          size: AppButtonSize.sm,
          icon: Icons.save_outlined,
          isLoading: _isSaving,
          onPressed: _handleSave,
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: AppCard(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Brand Identity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: AppSpacing.md),
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth < 600) {
                      return Column(
                        children: [
                          AppTextField(controller: _salonNameCtrl, label: 'Salon / Brand Title'),
                          const SizedBox(height: AppSpacing.sm),
                          AppTextField(controller: _currencyCtrl, label: 'Currency Symbol (₹, \$, €)'),
                        ],
                      );
                    }
                    return Row(
                      children: [
                        Expanded(child: AppTextField(controller: _salonNameCtrl, label: 'Salon / Brand Title')),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(child: AppTextField(controller: _currencyCtrl, label: 'Currency Symbol (₹, \$, €)')),
                      ],
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.sm),
                AppTextField(controller: _taglineCtrl, label: 'Tagline & Brand Motto'),
                const SizedBox(height: AppSpacing.xl),

                const Text('Public Announcement Banner', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: AppSpacing.md),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Show Announcement Banner on Public Header'),
                  subtitle: const Text('Displays a luxury top notification banner across all client pages.'),
                  activeTrackColor: AppColors.goldPrimary,
                  value: _isAnnouncementActive,
                  onChanged: (val) => setState(() => _isAnnouncementActive = val),
                ),
                const SizedBox(height: AppSpacing.sm),
                AppTextField(
                  controller: _announcementCtrl,
                  label: 'Announcement Text',
                  hint: 'e.g. Exclusive Festive Bridal Packages now open for reservations.',
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
