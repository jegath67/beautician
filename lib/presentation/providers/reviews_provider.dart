import 'package:flutter/material.dart';
import '../../data/repositories/review_repository.dart';
import '../../domain/models/content_status.dart';
import '../../domain/models/review_model.dart';
import 'audit_provider.dart';

class ReviewsProvider extends ChangeNotifier {
  final ReviewRepository _reviewRepository;
  final AuditProvider? _auditProvider;

  List<ReviewModel> _reviews = [];
  bool _isLoading = false;

  ReviewsProvider({
    ReviewRepository? reviewRepository,
    AuditProvider? auditProvider,
  })  : _reviewRepository = reviewRepository ?? MockReviewRepository(),
        _auditProvider = auditProvider {
    loadReviews();
  }

  List<ReviewModel> get allReviews => _reviews;
  List<ReviewModel> get approvedReviews => publishedReviews;
  List<ReviewModel> get publishedReviews =>
      _reviews.where((r) => r.status == ContentStatus.published).toList();
  List<ReviewModel> get pendingReviews =>
      _reviews.where((r) => r.status != ContentStatus.published).toList();
  int get pendingReviewsCount => pendingReviews.length;
  List<ReviewModel> get featuredReviews =>
      publishedReviews.where((r) => r.isFeatured).toList();
  bool get isLoading => _isLoading;

  Future<void> loadReviews() async {
    _isLoading = true;
    notifyListeners();

    _reviews = await _reviewRepository.getReviews();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> createReview(
    ReviewModel review, {
    String actorName = 'Admin',
  }) async {
    await _reviewRepository.createReview(review);
    await _auditProvider?.logAction(
      actorName: actorName,
      actionType: 'CREATE',
      entityType: 'Review',
      entityId: review.id,
      entityTitle: '${review.clientName} - ${review.serviceName}',
      previousValue: null,
      newValue: 'Rating: ${review.rating}★, Status: ${review.status.label}',
      summary: 'Added review from client "${review.clientName}".',
    );
    await loadReviews();
  }

  Future<void> updateReview(
    ReviewModel updated, {
    String actorName = 'Admin',
    ReviewModel? previous,
  }) async {
    await _reviewRepository.updateReview(updated);
    await _auditProvider?.logAction(
      actorName: actorName,
      actionType: 'UPDATE',
      entityType: 'Review',
      entityId: updated.id,
      entityTitle: '${updated.clientName} - ${updated.serviceName}',
      previousValue: previous != null ? 'Rating: ${previous.rating}★, Status: ${previous.status.label}' : null,
      newValue: 'Rating: ${updated.rating}★, Status: ${updated.status.label}',
      summary: 'Updated review by "${updated.clientName}".',
    );
    await loadReviews();
  }

  Future<void> togglePublishStatus(
    ReviewModel review,
    ContentStatus newStatus, {
    String actorName = 'Admin',
  }) async {
    final updated = review.copyWith(status: newStatus);
    await _reviewRepository.updateReview(updated);
    await _auditProvider?.logAction(
      actorName: actorName,
      actionType: newStatus == ContentStatus.published ? 'PUBLISH' : 'STATUS_CHANGE',
      entityType: 'Review',
      entityId: review.id,
      entityTitle: '${review.clientName} - ${review.serviceName}',
      previousValue: 'Status: ${review.status.label}',
      newValue: 'Status: ${newStatus.label}',
      summary: 'Changed status of review by "${review.clientName}" to ${newStatus.label}.',
    );
    await loadReviews();
  }

  Future<void> deleteReview(
    ReviewModel review, {
    String actorName = 'Admin',
  }) async {
    await _reviewRepository.deleteReview(review.id);
    await _auditProvider?.logAction(
      actorName: actorName,
      actionType: 'DELETE',
      entityType: 'Review',
      entityId: review.id,
      entityTitle: '${review.clientName} - ${review.serviceName}',
      previousValue: 'Status: ${review.status.label}',
      newValue: null,
      summary: 'Deleted review by "${review.clientName}".',
    );
    await loadReviews();
  }

  Future<void> approveReview(String id) async {
    final review = _reviews.firstWhere((r) => r.id == id, orElse: () => _reviews.first);
    await togglePublishStatus(review, ContentStatus.published);
  }

  Future<void> togglePublishStatusById(String id) async {
    final review = _reviews.firstWhere((r) => r.id == id, orElse: () => _reviews.first);
    final newStatus = review.status == ContentStatus.published
        ? ContentStatus.draft
        : ContentStatus.published;
    await togglePublishStatus(review, newStatus);
  }

  Future<void> deleteReviewById(String id) async {
    final review = _reviews.firstWhere((r) => r.id == id, orElse: () => _reviews.first);
    await deleteReview(review);
  }
}
