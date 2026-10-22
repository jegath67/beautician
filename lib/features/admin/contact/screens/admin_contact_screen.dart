import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../presentation/providers/content_provider.dart';
import '../../shared/admin_scaffold.dart';

class AdminContactScreen extends StatefulWidget {
  const AdminContactScreen({super.key});

  @override
  State<AdminContactScreen> createState() => _AdminContactScreenState();
}

class _AdminContactScreenState extends State<AdminContactScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _phoneCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _whatsappCtrl;
  late TextEditingController _addressCtrl;
  late TextEditingController _cityStateZipCtrl;
  late TextEditingController _weekDayHoursCtrl;
  late TextEditingController _weekendHoursCtrl;

  bool _initialized = false;
  bool _isSaving = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final info = context.read<ContentProvider>().contactInfo;
      _phoneCtrl = TextEditingController(text: info?.phone ?? '');
      _emailCtrl = TextEditingController(text: info?.email ?? '');
      _whatsappCtrl = TextEditingController(text: info?.whatsapp ?? '');
      _addressCtrl = TextEditingController(text: info?.address ?? '');
      _cityStateZipCtrl = TextEditingController(text: info?.cityStateZip ?? '');
      _weekDayHoursCtrl = TextEditingController(text: info?.weekDayHours ?? '');
      _weekendHoursCtrl = TextEditingController(text: info?.weekendHours ?? '');
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _whatsappCtrl.dispose();
    _addressCtrl.dispose();
    _cityStateZipCtrl.dispose();
    _weekDayHoursCtrl.dispose();
    _weekendHoursCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    final provider = context.read<ContentProvider>();
    final current = provider.contactInfo;

    if (current != null) {
      final updated = current.copyWith(
        phone: _phoneCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        whatsapp: _whatsappCtrl.text.trim(),
        address: _addressCtrl.text.trim(),
        cityStateZip: _cityStateZipCtrl.text.trim(),
        weekDayHours: _weekDayHoursCtrl.text.trim(),
        weekendHours: _weekendHoursCtrl.text.trim(),
      );

      await provider.updateContactInfo(updated);
    }

    setState(() => _isSaving = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contact details and operating hours saved.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: 'Contact Info & Business Hours CMS',
      currentRoute: AppRouter.adminContact,
      actions: [
        AppButton(
          text: 'Save Details',
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
                const Text('Public Contact Channels', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: AppSpacing.md),
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth < 600) {
                      return Column(
                        children: [
                          AppTextField(controller: _phoneCtrl, label: 'Concierge Phone'),
                          const SizedBox(height: AppSpacing.sm),
                          AppTextField(controller: _emailCtrl, label: 'Concierge Email'),
                        ],
                      );
                    }
                    return Row(
                      children: [
                        Expanded(child: AppTextField(controller: _phoneCtrl, label: 'Concierge Phone')),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(child: AppTextField(controller: _emailCtrl, label: 'Concierge Email')),
                      ],
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.sm),
                AppTextField(controller: _whatsappCtrl, label: 'WhatsApp Concierge Link/Number'),
                const SizedBox(height: AppSpacing.xl),

                const Text('Sanctuary Physical Address', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: AppSpacing.md),
                AppTextField(controller: _addressCtrl, label: 'Street Address'),
                const SizedBox(height: AppSpacing.sm),
                AppTextField(controller: _cityStateZipCtrl, label: 'City, State, Zipcode'),
                const SizedBox(height: AppSpacing.xl),

                const Text('Operating Hours', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: AppSpacing.md),
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth < 600) {
                      return Column(
                        children: [
                          AppTextField(controller: _weekDayHoursCtrl, label: 'Monday - Friday'),
                          const SizedBox(height: AppSpacing.sm),
                          AppTextField(controller: _weekendHoursCtrl, label: 'Saturday & Sunday'),
                        ],
                      );
                    }
                    return Row(
                      children: [
                        Expanded(child: AppTextField(controller: _weekDayHoursCtrl, label: 'Monday - Friday')),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(child: AppTextField(controller: _weekendHoursCtrl, label: 'Saturday & Sunday')),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
