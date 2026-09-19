import '../../domain/models/content_status.dart';
import '../../domain/models/review_model.dart';

abstract class ReviewRepository {
  Future<List<ReviewModel>> getReviews({ContentStatus? status, bool? onlyFeatured});
  Future<ReviewModel?> getReviewById(String id);
  Future<void> createReview(ReviewModel review);
  Future<void> updateReview(ReviewModel review);
  Future<void> deleteReview(String id);
}

class MockReviewRepository implements ReviewRepository {
  final List<ReviewModel> _reviews = [
    ReviewModel(
      id: 'rev_1',
      clientName: 'Shalini Sundaram',
      rating: 5.0,
      comment: 'Ananya made me look like an absolute royalty on my wedding day! The makeup stayed immaculate for over 14 hours despite crying and dancing. Everyone was stunned!',
      serviceName: 'Royal Bridal Makeover',
      avatarUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=200&q=80',
      date: DateTime.now().subtract(const Duration(days: 7)),
      status: ContentStatus.published,
      isFeatured: true,
    ),
    ReviewModel(
      id: 'rev_2',
      clientName: 'Dr. Tanya Roy',
      rating: 5.0,
      comment: 'The Hydra-Glow facial completely restored my dull, exhausted skin. Pooja explained every single botanical ingredient and customized the cold cryo treatment perfectly.',
      serviceName: 'Hydra-Glow Signature Facial',
      avatarUrl: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=200&q=80',
      date: DateTime.now().subtract(const Duration(days: 12)),
      status: ContentStatus.published,
      isFeatured: true,
    ),
    ReviewModel(
      id: 'rev_3',
      clientName: 'Aishwarya Raman',
      rating: 5.0,
      comment: 'Meera is a true color magician. My balayage looks so natural, seamlessly blended, and healthy. The salon ambiance is pure luxury and peaceful comfort.',
      serviceName: 'Couture Balayage & Gloss',
      avatarUrl: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=200&q=80',
      date: DateTime.now().subtract(const Duration(days: 18)),
      status: ContentStatus.published,
      isFeatured: true,
    ),
    ReviewModel(
      id: 'rev_4',
      clientName: 'Deepa Varma',
      rating: 4.8,
      comment: 'Best gel nail sculpting experience in the city. The hygiene standards and precision detailing are unmatched. Definitely my go-to luxury salon now.',
      serviceName: 'Luxe Gel Sculpting',
      avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=200&q=80',
      date: DateTime.now().subtract(const Duration(days: 25)),
      status: ContentStatus.published,
      isFeatured: false,
    ),
  ];

  @override
  Future<List<ReviewModel>> getReviews({ContentStatus? status, bool? onlyFeatured}) async {
    return _reviews.where((r) {
      if (status != null && r.status != status) return false;
      if (onlyFeatured == true && !r.isFeatured) return false;
      return true;
    }).toList();
  }

  @override
  Future<ReviewModel?> getReviewById(String id) async {
    final index = _reviews.indexWhere((r) => r.id == id);
    return index != -1 ? _reviews[index] : null;
  }

  @override
  Future<void> createReview(ReviewModel review) async {
    _reviews.insert(0, review);
  }

  @override
  Future<void> updateReview(ReviewModel review) async {
    final index = _reviews.indexWhere((r) => r.id == review.id);
    if (index != -1) {
      _reviews[index] = review;
    }
  }

  @override
  Future<void> deleteReview(String id) async {
    _reviews.removeWhere((r) => r.id == id);
  }
}
