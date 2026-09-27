import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../presentation/providers/audit_provider.dart';
import '../../shared/admin_scaffold.dart';

class AdminAuditLogsScreen extends StatelessWidget {
  const AdminAuditLogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auditProvider = context.watch<AuditProvider>();
    final logs = auditProvider.logs;

    return AdminScaffold(
      title: 'Security & Activity Audit Logs',
      currentRoute: '/admin/audit-logs',
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filters Row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const Text('Entity Filter: ', style: TextStyle(fontWeight: FontWeight.w600)),
                  ...['All', 'Booking', 'Service', 'Beautician', 'Review', 'Content'].map((e) {
                    final isSelected = auditProvider.selectedEntityType == e;
                    return Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.xs),
                      child: FilterChip(
                        label: Text(e),
                        selected: isSelected,
                        selectedColor: AppColors.goldPrimary,
                        checkmarkColor: Colors.black,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.black : null,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                        onSelected: (_) => auditProvider.filterByEntityType(e),
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            AppCard(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: logs.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(AppSpacing.xxl),
                      child: Center(child: Text('No audit logs on record.')),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Timestamp')),
                          DataColumn(label: Text('Actor')),
                          DataColumn(label: Text('Action')),
                          DataColumn(label: Text('Entity')),
                          DataColumn(label: Text('Details / Summary')),
                        ],
                        rows: logs.map((l) {
                          return DataRow(
                            cells: [
                              DataCell(Text(DateFormat('MMM d, h:mm a').format(l.timestamp), style: const TextStyle(fontSize: 12))),
                              DataCell(Text(l.actorName, style: const TextStyle(fontWeight: FontWeight.bold))),
                              DataCell(_buildActionBadge(l.actionType)),
                              DataCell(Text('${l.entityType}: ${l.entityTitle}', style: const TextStyle(fontWeight: FontWeight.w600))),
                              DataCell(
                                ConstrainedBox(
                                  constraints: const BoxConstraints(maxWidth: 320),
                                  child: Text(l.summary, style: const TextStyle(fontSize: 12)),
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

  Widget _buildActionBadge(String action) {
    Color bg;
    Color fg;

    switch (action.toUpperCase()) {
      case 'CREATE':
        bg = AppColors.success.withAlpha(25);
        fg = AppColors.success;
        break;
      case 'UPDATE':
        bg = AppColors.info.withAlpha(25);
        fg = AppColors.info;
        break;
      case 'DELETE':
        bg = AppColors.error.withAlpha(25);
        fg = AppColors.error;
        break;
      default:
        bg = Colors.grey.withAlpha(25);
        fg = Colors.grey;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(4)),
      child: Text(
        action.toUpperCase(),
        style: TextStyle(color: fg, fontWeight: FontWeight.bold, fontSize: 10),
      ),
    );
  }
}
