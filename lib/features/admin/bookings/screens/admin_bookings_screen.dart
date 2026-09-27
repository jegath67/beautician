import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../domain/models/booking_model.dart';
import '../../../../presentation/providers/bookings_provider.dart';
import '../../shared/admin_scaffold.dart';

class AdminBookingsScreen extends StatelessWidget {
  const AdminBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bookingsProvider = context.watch<BookingsProvider>();
    final bookings = bookingsProvider.filteredBookings;

    return AdminScaffold(
      title: 'Appointment Management',
      currentRoute: '/admin/bookings',
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Filter Tabs
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FilterTab(
                    label: 'All (${bookingsProvider.allBookings.length})',
                    isSelected: bookingsProvider.statusFilter == null,
                    onTap: () => bookingsProvider.setStatusFilter(null),
                  ),
                  _FilterTab(
                    label: 'Pending (${bookingsProvider.pendingBookingsCount})',
                    isSelected: bookingsProvider.statusFilter == BookingStatus.pending,
                    onTap: () => bookingsProvider.setStatusFilter(BookingStatus.pending),
                  ),
                  _FilterTab(
                    label: 'Confirmed (${bookingsProvider.confirmedBookingsCount})',
                    isSelected: bookingsProvider.statusFilter == BookingStatus.confirmed,
                    onTap: () => bookingsProvider.setStatusFilter(BookingStatus.confirmed),
                  ),
                  _FilterTab(
                    label: 'Completed (${bookingsProvider.completedBookingsCount})',
                    isSelected: bookingsProvider.statusFilter == BookingStatus.completed,
                    onTap: () => bookingsProvider.setStatusFilter(BookingStatus.completed),
                  ),
                  _FilterTab(
                    label: 'Cancelled',
                    isSelected: bookingsProvider.statusFilter == BookingStatus.cancelled,
                    onTap: () => bookingsProvider.setStatusFilter(BookingStatus.cancelled),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Bookings Table
            AppCard(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: bookings.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(AppSpacing.xxl),
                      child: Center(child: Text('No bookings match the selected filter.')),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: 24,
                        columns: const [
                          DataColumn(label: Text('Ref ID')),
                          DataColumn(label: Text('Guest Name')),
                          DataColumn(label: Text('Contact Info')),
                          DataColumn(label: Text('Service')),
                          DataColumn(label: Text('Specialist')),
                          DataColumn(label: Text('Date & Slot')),
                          DataColumn(label: Text('Price')),
                          DataColumn(label: Text('Status')),
                          DataColumn(label: Text('Actions')),
                        ],
                        rows: bookings.map((b) {
                          return DataRow(
                            cells: [
                              DataCell(Text(b.id, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                              DataCell(Text(b.customerName, style: const TextStyle(fontWeight: FontWeight.w600))),
                              DataCell(
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(b.phone, style: const TextStyle(fontSize: 12)),
                                    Text(b.email, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                                  ],
                                ),
                              ),
                              DataCell(Text(b.serviceTitle)),
                              DataCell(Text(b.beauticianName)),
                              DataCell(Text('${DateFormat('MMM d, yyyy').format(b.bookingDate)}\n${b.timeSlot}', style: const TextStyle(fontSize: 12))),
                              DataCell(Text(b.formattedPrice, style: const TextStyle(fontWeight: FontWeight.bold))),
                              DataCell(_buildStatusBadge(b.status)),
                              DataCell(
                                PopupMenuButton<BookingStatus>(
                                  tooltip: 'Update Status',
                                  icon: const Icon(Icons.more_vert, size: 18),
                                  onSelected: (newStatus) {
                                    bookingsProvider.updateBookingStatus(b.id, newStatus);
                                  },
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                      value: BookingStatus.confirmed,
                                      child: Text('Confirm Booking'),
                                    ),
                                    const PopupMenuItem(
                                      value: BookingStatus.completed,
                                      child: Text('Mark Completed'),
                                    ),
                                    const PopupMenuItem(
                                      value: BookingStatus.cancelled,
                                      child: Text('Cancel Appointment'),
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
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BookingStatus status) {
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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

class _FilterTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: AppColors.goldPrimary,
        labelStyle: TextStyle(
          color: isSelected ? Colors.black : null,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        ),
        onSelected: (_) => onTap(),
      ),
    );
  }
}
