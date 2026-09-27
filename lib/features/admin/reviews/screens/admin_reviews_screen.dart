import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../domain/models/content_status.dart';
import '../../../../presentation/providers/reviews_provider.dart';
import '../../shared/admin_scaffold.dart';

class AdminReviewsScreen extends StatelessWidget {
  const AdminReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reviewsProvider = context.watch<ReviewsProvider>();
    final reviews = reviewsProvider.allReviews;

    return AdminScaffold(
      title: 'Client Reviews Moderation Queue',
      currentRoute: '/admin/reviews',
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _StatusCounter(
                  label: 'Pending Approval',
                  count: reviewsProvider.pendingReviewsCount,
                  color: AppColors.warning,
                ),
                const SizedBox(width: AppSpacing.md),
                _StatusCounter(
                  label: 'Approved & Live',
                  count: reviewsProvider.approvedReviews.length,
                  color: AppColors.success,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            AppCard(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: reviews.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(AppSpacing.xxl),
                      child: Center(child: Text('No client reviews submitted yet.')),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Client')),
                          DataColumn(label: Text('Rating')),
                          DataColumn(label: Text('Review Details')),
                          DataColumn(label: Text('Service')),
                          DataColumn(label: Text('Date')),
                          DataColumn(label: Text('Status')),
                          DataColumn(label: Text('Moderation')),
                        ],
                        rows: reviews.map((r) {
                          final isApproved = r.status == ContentStatus.published;

                          return DataRow(
                            cells: [
                              DataCell(Text(r.clientName, style: const TextStyle(fontWeight: FontWeight.bold))),
                              DataCell(
                                Row(
                                  children: [
                                    const Icon(Icons.star, size: 14, color: AppColors.goldPrimary),
                                    const SizedBox(width: 4),
                                    Text('${r.rating}.0'),
                                  ],
                                ),
                              ),
                              DataCell(
                                ConstrainedBox(
                                  constraints: const BoxConstraints(maxWidth: 280),
                                  child: Text(
                                    '"${r.comment}"',
                                    style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              DataCell(Text(r.serviceName)),
                              DataCell(Text(DateFormat('MMM d, yyyy').format(r.createdAt))),
                              DataCell(
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: (isApproved ? AppColors.success : AppColors.warning).withAlpha(25),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    isApproved ? 'Approved' : 'Pending',
                                    style: TextStyle(
                                      color: isApproved ? AppColors.success : AppColors.warning,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (!isApproved)
                                      AppButton(
                                        text: 'Approve',
                                        size: AppButtonSize.sm,
                                        onPressed: () => reviewsProvider.approveReview(r.id),
                                      )
                                    else
                                      AppButton(
                                        text: 'Unpublish',
                                        size: AppButtonSize.sm,
                                        variant: AppButtonVariant.outline,
                                        onPressed: () => reviewsProvider.togglePublishStatusById(r.id),
                                      ),
                                    const SizedBox(width: AppSpacing.xs),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.error),
                                      onPressed: () => reviewsProvider.deleteReviewById(r.id),
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
}

class _StatusCounter extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _StatusCounter({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(width: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
            child: Text(
              '$count',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
