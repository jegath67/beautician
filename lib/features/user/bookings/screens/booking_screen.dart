import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/responsive/responsive_layout.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../domain/models/beautician_model.dart';
import '../../../../domain/models/booking_model.dart';
import '../../../../domain/models/service_model.dart';
import '../../../../presentation/providers/beauticians_provider.dart';
import '../../../../presentation/providers/bookings_provider.dart';
import '../../../../presentation/providers/services_provider.dart';
import '../../shared/user_scaffold.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int _currentStep = 0;

  ServiceModel? _selectedService;
  BeauticianModel? _selectedBeautician;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  String? _selectedTimeSlot;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _notesController = TextEditingController();

  BookingModel? _confirmedBooking;

  final List<String> _timeSlots = [
    '09:30 AM',
    '11:00 AM',
    '12:30 PM',
    '02:00 PM',
    '03:30 PM',
    '05:00 PM',
    '06:30 PM',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _handleBookAppointment() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedService == null || _selectedBeautician == null || _selectedTimeSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all selection steps first.')),
      );
      return;
    }

    final bookingsProvider = context.read<BookingsProvider>();

    final newBooking = BookingModel(
      id: 'BK-${DateTime.now().millisecondsSinceEpoch}',
      customerName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      serviceId: _selectedService!.id,
      serviceTitle: _selectedService!.name,
      beauticianId: _selectedBeautician!.id,
      beauticianName: _selectedBeautician!.name,
      priceAtBooking: _selectedService!.price,
      durationMinutes: _selectedService!.durationMinutes,
      bookingDate: _selectedDate,
      timeSlot: _selectedTimeSlot!,
      status: BookingStatus.pending,
      notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
      createdAt: DateTime.now(),
    );

    try {
      final res = await bookingsProvider.createBooking(newBooking);
      setState(() {
        _confirmedBooking = res;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to book: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_confirmedBooking != null) {
      return UserScaffold(
        currentRoute: AppRouter.booking,
        child: _buildSuccessView(context),
      );
    }

    return UserScaffold(
      currentRoute: AppRouter.booking,
      child: ResponsiveContainer(
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.horizontalPadding(context),
          vertical: AppSpacing.xxl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppSectionHeader(
              eyebrow: 'Bespoke Experience',
              title: 'Reserve Your Ritual',
              subtitle: 'Select your preferred treatment, master artisan, and convenient schedule.',
            ),
            const SizedBox(height: AppSpacing.xl),

            // Step Progress Indicator
            _buildStepIndicator(),
            const SizedBox(height: AppSpacing.xxl),

            // Step Content
            switch (_currentStep) {
              0 => _buildServiceSelection(),
              1 => _buildBeauticianSelection(),
              2 => _buildDateTimeSelection(),
              3 => _buildGuestDetailsForm(),
              _ => const SizedBox.shrink(),
            },
            const SizedBox(height: AppSpacing.xxl),

            // Bottom Navigation Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentStep > 0)
                  AppButton(
                    text: 'Previous Step',
                    variant: AppButtonVariant.outline,
                    onPressed: () => setState(() => _currentStep--),
                  )
                else
                  const SizedBox.shrink(),
                if (_currentStep < 3)
                  AppButton(
                    text: 'Continue',
                    icon: Icons.arrow_forward,
                    isTrailingIcon: true,
                    onPressed: () {
                      if (_currentStep == 0 && _selectedService == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please select a service first.')),
                        );
                        return;
                      }
                      if (_currentStep == 1 && _selectedBeautician == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please select a beautician specialist.')),
                        );
                        return;
                      }
                      if (_currentStep == 2 && _selectedTimeSlot == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please select a preferred time slot.')),
                        );
                        return;
                      }
                      setState(() => _currentStep++);
                    },
                  )
                else
                  Consumer<BookingsProvider>(
                    builder: (context, provider, _) => AppButton(
                      text: 'Confirm & Reserve Ritual',
                      isLoading: provider.isSubmitting,
                      icon: Icons.check_circle_outline,
                      onPressed: _handleBookAppointment,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    final steps = ['1. Select Service', '2. Choose Artist', '3. Date & Time', '4. Confirmation'];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        if (isMobile) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Step ${_currentStep + 1} of 4: ${steps[_currentStep]}',
                style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.goldPrimary),
              ),
              Text(
                '${((_currentStep + 1) / 4 * 100).toInt()}%',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          );
        }

        return Row(
          children: List.generate(steps.length, (index) {
            final isCompleted = index < _currentStep;
            final isCurrent = index == _currentStep;

            return Expanded(
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCurrent || isCompleted ? AppColors.goldPrimary : Colors.transparent,
                      border: Border.all(
                        color: isCurrent || isCompleted ? AppColors.goldPrimary : AppColors.goldMuted,
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: isCompleted
                          ? const Icon(Icons.check, size: 16, color: Colors.black)
                          : Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isCurrent ? Colors.black : null,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    steps[index],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                      color: isCurrent ? AppColors.goldPrimary : null,
                    ),
                  ),
                  if (index < steps.length - 1)
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                        height: 1,
                        color: isCompleted ? AppColors.goldPrimary : Colors.white24,
                      ),
                    ),
                ],
              ),
            );
          }),
        );
      },
    );
  }

  // STEP 1: SERVICE SELECTION
  Widget _buildServiceSelection() {
    final servicesProvider = context.watch<ServicesProvider>();
    final services = servicesProvider.services;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Your Desired Treatment',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppSpacing.md),
        LayoutBuilder(
          builder: (context, constraints) {
            final cols = Responsive.gridColumns(context, mobile: 1, tablet: 2, desktop: 3);
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cols,
                crossAxisSpacing: AppSpacing.md,
                mainAxisSpacing: AppSpacing.md,
                childAspectRatio: 1.15,
              ),
              itemCount: services.length,
              itemBuilder: (context, index) {
                final s = services[index];
                final isSelected = _selectedService?.id == s.id;

                return AppCard(
                  onTap: () => setState(() => _selectedService = s),
                  border: isSelected
                      ? Border.all(color: AppColors.goldPrimary, width: 2)
                      : null,
                  backgroundColor: isSelected
                      ? AppColors.goldPrimary.withAlpha(20)
                      : null,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.goldPrimary.withAlpha(30),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              s.category.toUpperCase(),
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.goldPrimary),
                            ),
                          ),
                          Text(
                            '\$${s.price.toStringAsFixed(0)}',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.goldPrimary),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        s.name,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 13, color: AppColors.goldPrimary),
                          const SizedBox(width: 4),
                          Text('${s.durationMinutes} mins', style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Expanded(
                        child: Text(
                          s.description,
                          style: TextStyle(fontSize: 12, height: 1.4, color: Theme.of(context).textTheme.bodySmall?.color?.withAlpha(160)),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
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
    );
  }

  // STEP 2: BEAUTICIAN SELECTION
  Widget _buildBeauticianSelection() {
    final beauticiansProvider = context.watch<BeauticiansProvider>();
    final beauticians = beauticiansProvider.activeBeauticians;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Your Master Specialist',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppSpacing.md),
        LayoutBuilder(
          builder: (context, constraints) {
            final cols = Responsive.gridColumns(context, mobile: 1, tablet: 2, desktop: 3);
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cols,
                crossAxisSpacing: AppSpacing.md,
                mainAxisSpacing: AppSpacing.md,
                childAspectRatio: 1.25,
              ),
              itemCount: beauticians.length,
              itemBuilder: (context, index) {
                final b = beauticians[index];
                final isSelected = _selectedBeautician?.id == b.id;

                return AppCard(
                  onTap: () => setState(() => _selectedBeautician = b),
                  border: isSelected
                      ? Border.all(color: AppColors.goldPrimary, width: 2)
                      : null,
                  backgroundColor: isSelected
                      ? AppColors.goldPrimary.withAlpha(20)
                      : null,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: AppRadius.borderSm,
                        child: Image.network(
                          b.imageUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 80,
                            height: 80,
                            color: AppColors.goldMuted,
                            child: const Icon(Icons.person, color: AppColors.goldPrimary),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              b.name,
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              b.title,
                              style: const TextStyle(fontSize: 12, color: AppColors.goldPrimary, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.star, size: 14, color: AppColors.goldPrimary),
                                const SizedBox(width: 4),
                                Text(
                                  '${b.rating} (${b.reviewCount})',
                                  style: const TextStyle(fontSize: 11),
                                ),
                              ],
                            ),
                          ],
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
    );
  }

  // STEP 3: DATE & TIME SELECTION
  Widget _buildDateTimeSelection() {
    final dateFormat = DateFormat('EEEE, MMMM d, yyyy');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Appointment Date & Time',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Date Picker Action
        AppCard(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              const Icon(Icons.calendar_month, color: AppColors.goldPrimary, size: 28),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Selected Date', style: TextStyle(fontSize: 12, color: AppColors.goldPrimary)),
                    const SizedBox(height: 2),
                    Text(
                      dateFormat.format(_selectedDate),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              AppButton(
                text: 'Choose Another Date',
                size: AppButtonSize.sm,
                variant: AppButtonVariant.outline,
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 90)),
                  );
                  if (picked != null) {
                    setState(() => _selectedDate = picked);
                  }
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),

        const Text(
          'Available Time Slots',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppSpacing.md),

        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          children: _timeSlots.map((slot) {
            final isSelected = _selectedTimeSlot == slot;
            return ChoiceChip(
              label: Text(slot),
              selected: isSelected,
              selectedColor: AppColors.goldPrimary,
              labelStyle: TextStyle(
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Colors.black : null,
              ),
              onSelected: (_) => setState(() => _selectedTimeSlot = slot),
            );
          }).toList(),
        ),
      ],
    );
  }

  // STEP 4: GUEST DETAILS & CONFIRMATION
  Widget _buildGuestDetailsForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Contact Information',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: _nameController,
                  label: 'Full Name *',
                  hint: 'e.g. Eleanor Vance',
                  prefixIcon: const Icon(Icons.person_outline, size: 20),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Please enter your name' : null,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: AppTextField(
                  controller: _phoneController,
                  label: 'Phone Number *',
                  hint: '+1 (555) 000-0000',
                  keyboardType: TextInputType.phone,
                  prefixIcon: const Icon(Icons.phone_outlined, size: 20),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Please enter your phone number' : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: _emailController,
            label: 'Email Address *',
            hint: 'eleanor@example.com',
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(Icons.email_outlined, size: 20),
            validator: (v) => v == null || !v.contains('@') ? 'Please enter a valid email address' : null,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: _notesController,
            label: 'Special Requests / Notes (Optional)',
            hint: 'Mention any allergies, hair length, skin sensitivity or preferences...',
            maxLines: 3,
          ),
          const SizedBox(height: AppSpacing.xl),

          // Reservation Summary Card
          AppCard(
            backgroundColor: AppColors.goldPrimary.withAlpha(20),
            border: Border.all(color: AppColors.goldPrimary.withAlpha(80)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'RESERVATION SUMMARY',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                    color: AppColors.goldPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Service:'),
                    Text(_selectedService?.name ?? '', style: const TextStyle(fontWeight: FontWeight.w700)),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Specialist:'),
                    Text(_selectedBeautician?.name ?? '', style: const TextStyle(fontWeight: FontWeight.w700)),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Date & Time:'),
                    Text(
                      '${DateFormat('MMM d, yyyy').format(_selectedDate)} at $_selectedTimeSlot',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Estimated Price:'),
                    Text(
                      '\$${_selectedService?.price.toStringAsFixed(0) ?? '0'}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.goldPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // SUCCESS CONFIRMATION VIEW
  Widget _buildSuccessView(BuildContext context) {
    return ResponsiveContainer(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.horizontalPadding(context),
        vertical: AppSpacing.xxxl,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 580),
          child: AppCard(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.goldPrimary.withAlpha(30),
                    border: Border.all(color: AppColors.goldPrimary, width: 2),
                  ),
                  child: const Center(
                    child: Icon(Icons.check, size: 36, color: AppColors.goldPrimary),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                const Text(
                  'Reservation Confirmed!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Booking Reference: ${_confirmedBooking?.id}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.goldPrimary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Thank you, ${_confirmedBooking?.customerName}. We have received your booking for ${_confirmedBooking?.serviceTitle} with ${_confirmedBooking?.beauticianName}. Our salon concierge will reach out via phone or email for any pre-ritual consultations.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: Theme.of(context).textTheme.bodyMedium?.color?.withAlpha(190),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppButton(
                      text: 'Return to Home',
                      size: AppButtonSize.md,
                      onPressed: () => context.go(AppRouter.home),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    AppButton(
                      text: 'Book Another',
                      variant: AppButtonVariant.outline,
                      size: AppButtonSize.md,
                      onPressed: () {
                        setState(() {
                          _confirmedBooking = null;
                          _currentStep = 0;
                          _selectedService = null;
                          _selectedBeautician = null;
                          _selectedTimeSlot = null;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
