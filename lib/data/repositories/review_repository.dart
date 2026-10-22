import '../../domain/models/content_status.dart';
import '../../domain/models/review_model.dart';
import '../datasources/in_memory_store.dart';

abstract class ReviewRepository {
  Future<List<ReviewModel>> getReviews({
    ContentStatus? status,
    bool? onlyFeatured,
  });
  Future<ReviewModel?> getReviewById(String id);
  Future<void> createReview(ReviewModel review);
  Future<void> updateReview(ReviewModel review);
  Future<void> deleteReview(String id);
}

class MockReviewRepository implements ReviewRepository {
  final InMemoryStore _store;

  MockReviewRepository({InMemoryStore? store})
    : _store = store ?? InMemoryStore.instance;

  @override
  Future<List<ReviewModel>> getReviews({
    ContentStatus? status,
    bool? onlyFeatured,
  }) async {
    return _store.reviews.where((r) {
      if (status != null && r.status != status) return false;
      if (onlyFeatured == true && !r.isFeatured) return false;
      return true;
    }).toList();
  }

  @override
  Future<ReviewModel?> getReviewById(String id) async {
    final index = _store.reviews.indexWhere((r) => r.id == id);
    return index != -1 ? _store.reviews[index] : null;
  }

  @override
  Future<void> createReview(ReviewModel review) async {
    _store.reviews.insert(0, review);
  }

  @override
  Future<void> updateReview(ReviewModel review) async {
    final index = _store.reviews.indexWhere((r) => r.id == review.id);
    if (index != -1) {
      _store.reviews[index] = review;
    }
  }

  @override
  Future<void> deleteReview(String id) async {
    _store.reviews.removeWhere((r) => r.id == id);
  }
}
