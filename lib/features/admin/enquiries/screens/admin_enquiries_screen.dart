import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../domain/models/contact_enquiry_model.dart';
import '../../../../presentation/providers/enquiries_provider.dart';
import '../../shared/admin_scaffold.dart';

class AdminEnquiriesScreen extends StatelessWidget {
  const AdminEnquiriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final enquiriesProvider = context.watch<EnquiriesProvider>();
    final enquiries = enquiriesProvider.filteredEnquiries;

    return AdminScaffold(
      title: 'Client Enquiries & Concierge CRM',
      currentRoute: '/admin/enquiries',
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Filters
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FilterChip(
                    label: 'All (${enquiriesProvider.allEnquiries.length})',
                    isSelected: enquiriesProvider.statusFilter == null,
                    onTap: () => enquiriesProvider.setStatusFilter(null),
                  ),
                  _FilterChip(
                    label: 'New (${enquiriesProvider.newEnquiriesCount})',
                    isSelected: enquiriesProvider.statusFilter == EnquiryStatus.newEnquiry,
                    onTap: () => enquiriesProvider.setStatusFilter(EnquiryStatus.newEnquiry),
                  ),
                  _FilterChip(
                    label: 'Read',
                    isSelected: enquiriesProvider.statusFilter == EnquiryStatus.read,
                    onTap: () => enquiriesProvider.setStatusFilter(EnquiryStatus.read),
                  ),
                  _FilterChip(
                    label: 'Replied',
                    isSelected: enquiriesProvider.statusFilter == EnquiryStatus.replied,
                    onTap: () => enquiriesProvider.setStatusFilter(EnquiryStatus.replied),
                  ),
                  _FilterChip(
                    label: 'Archived',
                    isSelected: enquiriesProvider.statusFilter == EnquiryStatus.archived,
                    onTap: () => enquiriesProvider.setStatusFilter(EnquiryStatus.archived),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            AppCard(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: enquiries.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(AppSpacing.xxl),
                      child: Center(child: Text('No inquiries in selected status.')),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Guest Name')),
                          DataColumn(label: Text('Contact Info')),
                          DataColumn(label: Text('Subject')),
                          DataColumn(label: Text('Message Details')),
                          DataColumn(label: Text('Received')),
                          DataColumn(label: Text('Status')),
                          DataColumn(label: Text('Action')),
                        ],
                        rows: enquiries.map((e) {
                          return DataRow(
                            cells: [
                              DataCell(Text(e.name, style: const TextStyle(fontWeight: FontWeight.bold))),
                              DataCell(
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(e.phone, style: const TextStyle(fontSize: 12)),
                                    Text(e.email, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                                  ],
                                ),
                              ),
                              DataCell(Text(e.subject, style: const TextStyle(fontWeight: FontWeight.w600))),
                              DataCell(
                                ConstrainedBox(
                                  constraints: const BoxConstraints(maxWidth: 240),
                                  child: Text(
                                    e.message,
                                    style: const TextStyle(fontSize: 12),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              DataCell(Text(DateFormat('MMM d, h:mm a').format(e.createdAt))),
                              DataCell(_buildStatusBadge(e.status)),
                              DataCell(
                                PopupMenuButton<EnquiryStatus>(
                                  tooltip: 'Update Status',
                                  icon: const Icon(Icons.more_vert, size: 18),
                                  onSelected: (newStatus) {
                                    enquiriesProvider.updateStatus(e.id, newStatus);
                                  },
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                      value: EnquiryStatus.read,
                                      child: Text('Mark Read'),
                                    ),
                                    const PopupMenuItem(
                                      value: EnquiryStatus.replied,
                                      child: Text('Mark Replied'),
                                    ),
                                    const PopupMenuItem(
                                      value: EnquiryStatus.archived,
                                      child: Text('Archive Inquiry'),
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

  Widget _buildStatusBadge(EnquiryStatus status) {
    Color bg;
    Color fg;

    switch (status) {
      case EnquiryStatus.newEnquiry:
        bg = AppColors.info.withAlpha(25);
        fg = AppColors.info;
        break;
      case EnquiryStatus.read:
        bg = AppColors.warning.withAlpha(25);
        fg = AppColors.warning;
        break;
      case EnquiryStatus.replied:
        bg = AppColors.success.withAlpha(25);
        fg = AppColors.success;
        break;
      case EnquiryStatus.archived:
        bg = Colors.grey.withAlpha(25);
        fg = Colors.grey;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(4)),
      child: Text(
        status.name,
        style: TextStyle(color: fg, fontWeight: FontWeight.bold, fontSize: 11),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({required this.label, required this.isSelected, required this.onTap});

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
