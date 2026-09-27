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
import '../../../../domain/models/booking_model.dart';
import '../../../../presentation/providers/bookings_provider.dart';
import '../../../../presentation/providers/enquiries_provider.dart';
import '../../../../presentation/providers/reviews_provider.dart';
import '../../shared/admin_scaffold.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bookingsProvider = context.watch<BookingsProvider>();
    final enquiriesProvider = context.watch<EnquiriesProvider>();
    final reviewsProvider = context.watch<ReviewsProvider>();

    return AdminScaffold(
      title: 'Salon Operations Dashboard',
      currentRoute: AppRouter.adminDashboard,
      actions: [
        AppButton(
          text: 'New Reservation',
          size: AppButtonSize.sm,
          icon: Icons.add,
          onPressed: () => context.go(AppRouter.adminBookings),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // KPI Summary Row
            _buildKpiMetrics(
              context,
              totalBookings: bookingsProvider.totalBookingsCount,
              todayBookings: bookingsProvider.todayBookingsCount,
              pendingBookings: bookingsProvider.pendingBookingsCount,
              revenue: bookingsProvider.demoEstimatedRevenue,
              newEnquiries: enquiriesProvider.newEnquiriesCount,
              pendingReviews: reviewsProvider.pendingReviewsCount,
            ),
            const SizedBox(height: AppSpacing.xxl),

            // Recent Bookings & Quick Moderation Section
            LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth >= 1024;
                if (isDesktop) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 7,
                        child: _buildRecentBookingsTable(context, bookingsProvider),
                      ),
                      const SizedBox(width: AppSpacing.xl),
                      Expanded(
                        flex: 4,
                        child: Column(
                          children: [
                            _buildPendingReviewsCard(context, reviewsProvider),
                            const SizedBox(height: AppSpacing.lg),
                            _buildRecentEnquiriesCard(context, enquiriesProvider),
                          ],
                        ),
                      ),
                    ],
                  );
                }

                return Column(
                  children: [
                    _buildRecentBookingsTable(context, bookingsProvider),
                    const SizedBox(height: AppSpacing.xl),
                    _buildPendingReviewsCard(context, reviewsProvider),
                    const SizedBox(height: AppSpacing.lg),
                    _buildRecentEnquiriesCard(context, enquiriesProvider),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKpiMetrics(
    BuildContext context, {
    required int totalBookings,
    required int todayBookings,
    required int pendingBookings,
    required double revenue,
    required int newEnquiries,
    required int pendingReviews,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cols = Responsive.gridColumns(context, mobile: 1, tablet: 2, desktop: 4);

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: cols,
          crossAxisSpacing: AppSpacing.lg,
          mainAxisSpacing: AppSpacing.lg,
          childAspectRatio: 1.6,
          children: [
            _KpiCard(
              title: 'Today Appointments',
              value: '$todayBookings',
              subtitle: 'Active today',
              icon: Icons.calendar_today,
              color: AppColors.goldPrimary,
            ),
            _KpiCard(
              title: 'Pending Approvals',
              value: '$pendingBookings',
              subtitle: 'Requires confirmation',
              icon: Icons.hourglass_top,
              color: AppColors.warning,
            ),
            _KpiCard(
              title: 'Total Revenue (Est)',
              value: '₹${revenue.toStringAsFixed(0)}',
              subtitle: 'Simulated demo KPI',
              icon: Icons.payments_outlined,
              color: AppColors.success,
            ),
            _KpiCard(
              title: 'New Enquiries',
              value: '$newEnquiries',
              subtitle: '$pendingReviews pending reviews',
              icon: Icons.mail_outline,
              color: AppColors.info,
            ),
          ],
        );
      },
    );
  }

  Widget _buildRecentBookingsTable(BuildContext context, BookingsProvider provider) {
    final recentBookings = provider.allBookings.take(6).toList();

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Client Reservations',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              TextButton(
                onPressed: () => context.go(AppRouter.adminBookings),
                child: const Text('View All Bookings'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (recentBookings.isEmpty)
            const Padding(
              padding: EdgeInsets.all(AppSpacing.xl),
              child: Center(child: Text('No reservations on record.')),
            )
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Ref ID')),
                  DataColumn(label: Text('Guest Name')),
                  DataColumn(label: Text('Ritual Service')),
                  DataColumn(label: Text('Date & Time')),
                  DataColumn(label: Text('Specialist')),
                  DataColumn(label: Text('Status')),
                ],
                rows: recentBookings.map((b) {
                  return DataRow(
                    cells: [
                      DataCell(Text(b.id, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
                      DataCell(Text(b.customerName, style: const TextStyle(fontWeight: FontWeight.bold))),
                      DataCell(Text(b.serviceTitle)),
                      DataCell(Text('${DateFormat('MMM d').format(b.bookingDate)} at ${b.timeSlot}')),
                      DataCell(Text(b.beauticianName)),
                      DataCell(_buildStatusChip(b.status)),
                    ],
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPendingReviewsCard(BuildContext context, ReviewsProvider provider) {
    final pending = provider.pendingReviews.take(3).toList();

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Pending Reviews', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              TextButton(
                onPressed: () => context.go(AppRouter.adminReviews),
                child: const Text('Moderation Queue'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          if (pending.isEmpty)
            const Text('No reviews awaiting moderation.', style: TextStyle(fontSize: 13))
          else
            ...pending.map((r) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: AppColors.goldPrimary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${r.clientName}: "${r.comment}"',
                          style: const TextStyle(fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.check, size: 16, color: AppColors.success),
                        onPressed: () => provider.approveReview(r.id),
                        splashRadius: 16,
                      ),
                    ],
                  ),
                )),
        ],
      ),
    );
  }

  Widget _buildRecentEnquiriesCard(BuildContext context, EnquiriesProvider provider) {
    final newEnquiries = provider.allEnquiries.where((e) => e.status.name == 'newEnquiry').take(3).toList();

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Fresh Inquiries', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              TextButton(
                onPressed: () => context.go(AppRouter.adminEnquiries),
                child: const Text('Open CRM'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          if (newEnquiries.isEmpty)
            const Text('No new inquiries.', style: TextStyle(fontSize: 13))
          else
            ...newEnquiries.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Row(
                    children: [
                      const Icon(Icons.mark_email_unread_outlined, size: 16, color: AppColors.info),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(e.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                            Text(
                              e.subject,
                              style: TextStyle(fontSize: 11, color: Theme.of(context).textTheme.bodySmall?.color?.withAlpha(160)),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
        ],
      ),
    );
  }

  Widget _buildStatusChip(BookingStatus status) {
    Color bg;
    Color fg;

    switch (status) {
      case BookingStatus.confirmed:
        bg = AppColors.success.withAlpha(25);
        fg = AppColors.success;
        break;
      case BookingStatus.completed:
        bg = AppColors.info.withAlpha(25);
        fg = AppColors.info;
        break;
      case BookingStatus.cancelled:
        bg = AppColors.error.withAlpha(25);
        fg = AppColors.error;
        break;
      case BookingStatus.pending:
      default:
        bg = AppColors.warning.withAlpha(25);
        fg = AppColors.warning;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status.label,
        style: TextStyle(color: fg, fontWeight: FontWeight.bold, fontSize: 11),
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _KpiCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withAlpha(25),
              border: Border.all(color: color.withAlpha(80)),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.bodySmall?.color?.withAlpha(160),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 11, color: color),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
