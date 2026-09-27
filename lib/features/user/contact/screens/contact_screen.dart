import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/responsive/responsive_layout.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../presentation/providers/content_provider.dart';
import '../../../../presentation/providers/enquiries_provider.dart';
import '../../shared/user_scaffold.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  bool _isSuccess = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmitEnquiry() async {
    if (!_formKey.currentState!.validate()) return;

    final enquiriesProvider = context.read<EnquiriesProvider>();

    final success = await enquiriesProvider.submitEnquiry(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      subject: _subjectController.text.trim(),
      message: _messageController.text.trim(),
    );

    if (success) {
      setState(() {
        _isSuccess = true;
      });
      _nameController.clear();
      _emailController.clear();
      _phoneController.clear();
      _subjectController.clear();
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context) || Responsive.isWideDesktop(context);
    final contentProvider = context.watch<ContentProvider>();
    final contact = contentProvider.contactInfo;

    return UserScaffold(
      currentRoute: AppRouter.contact,
      child: ResponsiveContainer(
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.horizontalPadding(context),
          vertical: AppSpacing.xxl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppSectionHeader(
              eyebrow: 'Direct Access',
              title: 'Connect with Our Concierge',
              subtitle:
                  'Whether seeking a tailored consultation, bespoke bridal enquiry, or assistance with appointments, our concierge is at your service.',
            ),
            const SizedBox(height: AppSpacing.xl),

            if (isDesktop)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 5, child: _buildContactInfoCards(contact)),
                  const SizedBox(width: AppSpacing.xxl),
                  Expanded(flex: 7, child: _buildEnquiryForm()),
                ],
              )
            else
              Column(
                children: [
                  _buildContactInfoCards(contact),
                  const SizedBox(height: AppSpacing.xxl),
                  _buildEnquiryForm(),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfoCards(dynamic contact) {
    final phone = contact?.phone ?? '+1 (800) 892-AURA';
    final email = contact?.email ?? 'concierge@aurasalon.com';
    final address = contact?.address ?? '42 Luxury Avenue, Suite 100, Mayfair District';
    final weekday = contact?.weekDayHours ?? 'Mon - Fri: 09:00 AM - 08:00 PM';
    final weekend = contact?.weekendHours ?? 'Sat - Sun: 10:00 AM - 06:00 PM';

    return Column(
      children: [
        _InfoCard(
          icon: Icons.location_on_outlined,
          title: 'Sanctuary Address',
          subtitle: address,
        ),
        const SizedBox(height: AppSpacing.md),
        _InfoCard(
          icon: Icons.phone_outlined,
          title: 'Direct Telephone',
          subtitle: phone,
        ),
        const SizedBox(height: AppSpacing.md),
        _InfoCard(
          icon: Icons.email_outlined,
          title: 'Concierge Inquiries',
          subtitle: email,
        ),
        const SizedBox(height: AppSpacing.md),
        _InfoCard(
          icon: Icons.access_time_outlined,
          title: 'Hours of Operation',
          subtitle: '$weekday\n$weekend',
        ),
      ],
    );
  }

  Widget _buildEnquiryForm() {
    final enquiriesProvider = context.watch<EnquiriesProvider>();

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Send a Private Message',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              'We respect your privacy. Our concierge typically responds within 2 business hours.',
              style: TextStyle(fontSize: 13, color: Theme.of(context).textTheme.bodySmall?.color?.withAlpha(160)),
            ),
            const SizedBox(height: AppSpacing.lg),

            if (_isSuccess) ...[
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.success.withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.success.withAlpha(80)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle, color: AppColors.success),
                    SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'Your message has been received! Our concierge will contact you shortly.',
                        style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.success),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],

            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: _nameController,
                    label: 'Full Name *',
                    hint: 'Your name',
                    validator: (v) => v == null || v.trim().isEmpty ? 'Please enter your name' : null,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: AppTextField(
                    controller: _emailController,
                    label: 'Email *',
                    hint: 'Your email address',
                    validator: (v) => v == null || !v.contains('@') ? 'Valid email required' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: _phoneController,
                    label: 'Phone Number',
                    hint: '+1 ...',
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: AppTextField(
                    controller: _subjectController,
                    label: 'Subject *',
                    hint: 'e.g. Bridal Package, Consultation',
                    validator: (v) => v == null || v.trim().isEmpty ? 'Subject required' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: _messageController,
              label: 'Message *',
              hint: 'Write your questions or specific requirements...',
              maxLines: 4,
              validator: (v) => v == null || v.trim().isEmpty ? 'Please provide a message' : null,
            ),
            const SizedBox(height: AppSpacing.xl),
            AppButton(
              text: 'Transmit Message',
              icon: Icons.send_outlined,
              isLoading: enquiriesProvider.isSubmitting,
              onPressed: _handleSubmitEnquiry,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.goldPrimary.withAlpha(25),
              border: Border.all(color: AppColors.goldPrimary, width: 1),
            ),
            child: Icon(icon, color: AppColors.goldPrimary, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: Theme.of(context).textTheme.bodySmall?.color?.withAlpha(180),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
