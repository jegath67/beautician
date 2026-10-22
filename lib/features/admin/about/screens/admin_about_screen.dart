import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_image_upload_field.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../presentation/providers/content_provider.dart';
import '../../shared/admin_scaffold.dart';

class AdminAboutScreen extends StatefulWidget {
  const AdminAboutScreen({super.key});

  @override
  State<AdminAboutScreen> createState() => _AdminAboutScreenState();
}

class _AdminAboutScreenState extends State<AdminAboutScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleCtrl;
  late TextEditingController _subtitleCtrl;
  late TextEditingController _storyCtrl;
  late TextEditingController _missionCtrl;
  late TextEditingController _founderNameCtrl;
  late TextEditingController _founderRoleCtrl;
  late TextEditingController _founderBioCtrl;
  late TextEditingController _founderImgCtrl;

  bool _initialized = false;
  bool _isSaving = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final content = context.read<ContentProvider>().aboutContent;
      _titleCtrl = TextEditingController(text: content?.title ?? '');
      _subtitleCtrl = TextEditingController(text: content?.subtitle ?? '');
      _storyCtrl = TextEditingController(text: content?.story ?? '');
      _missionCtrl = TextEditingController(text: content?.mission ?? '');
      _founderNameCtrl = TextEditingController(text: content?.founderName ?? '');
      _founderRoleCtrl = TextEditingController(text: content?.founderRole ?? '');
      _founderBioCtrl = TextEditingController(text: content?.founderBio ?? '');
      _founderImgCtrl = TextEditingController(text: content?.founderImageUrl ?? '');
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _subtitleCtrl.dispose();
    _storyCtrl.dispose();
    _missionCtrl.dispose();
    _founderNameCtrl.dispose();
    _founderRoleCtrl.dispose();
    _founderBioCtrl.dispose();
    _founderImgCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    final provider = context.read<ContentProvider>();
    final current = provider.aboutContent;

    if (current != null) {
      final updated = current.copyWith(
        title: _titleCtrl.text.trim(),
        subtitle: _subtitleCtrl.text.trim(),
        story: _storyCtrl.text.trim(),
        mission: _missionCtrl.text.trim(),
        founderName: _founderNameCtrl.text.trim(),
        founderRole: _founderRoleCtrl.text.trim(),
        founderBio: _founderBioCtrl.text.trim(),
        founderImageUrl: _founderImgCtrl.text.trim(),
      );

      await provider.updateAboutContent(updated);
    }

    setState(() => _isSaving = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('About Us content saved and updated.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: 'About Us Content CMS',
      currentRoute: AppRouter.adminAbout,
      actions: [
        AppButton(
          text: 'Save Changes',
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
                const Text('Brand Story & Philosophy', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: AppSpacing.md),
                AppTextField(controller: _titleCtrl, label: 'Page Header Title'),
                const SizedBox(height: AppSpacing.sm),
                AppTextField(controller: _subtitleCtrl, label: 'Header Subtitle'),
                const SizedBox(height: AppSpacing.sm),
                AppTextField(controller: _storyCtrl, label: 'Brand Heritage Story', maxLines: 4),
                const SizedBox(height: AppSpacing.sm),
                AppTextField(controller: _missionCtrl, label: 'Mission Statement', maxLines: 3),
                const SizedBox(height: AppSpacing.xl),

                const Text('Founder Profile', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: AppSpacing.md),
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth < 600) {
                      return Column(
                        children: [
                          AppTextField(controller: _founderNameCtrl, label: 'Founder Name'),
                          const SizedBox(height: AppSpacing.sm),
                          AppTextField(controller: _founderRoleCtrl, label: 'Founder Title / Role'),
                        ],
                      );
                    }
                    return Row(
                      children: [
                        Expanded(child: AppTextField(controller: _founderNameCtrl, label: 'Founder Name')),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(child: AppTextField(controller: _founderRoleCtrl, label: 'Founder Title / Role')),
                      ],
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.sm),
                AppImageUploadField(
                  controller: _founderImgCtrl,
                  label: 'Founder Portrait',
                  storageFolder: 'about',
                  entityId: 'founder',
                ),
                const SizedBox(height: AppSpacing.sm),
                AppTextField(controller: _founderBioCtrl, label: 'Founder Bio', maxLines: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
