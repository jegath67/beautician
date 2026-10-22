import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/content_status.dart';
import '../../domain/models/review_model.dart';
import '../datasources/in_memory_store.dart';
import 'review_repository.dart';

class FirestoreReviewRepository implements ReviewRepository {
  final FirebaseFirestore? _customFirestore;
  final String collectionPath;

  FirestoreReviewRepository({
    FirebaseFirestore? firestore,
    this.collectionPath = 'reviews',
  }) : _customFirestore = firestore;

  FirebaseFirestore get _firestore =>
      _customFirestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(collectionPath);

  @override
  Future<List<ReviewModel>> getReviews({
    ContentStatus? status,
    bool? onlyFeatured,
  }) async {
    try {
      Query<Map<String, dynamic>> query = _collection;

      if (status != null) {
        query = query.where('status', isEqualTo: status.name);
      }
      if (onlyFeatured == true) {
        query = query.where('isFeatured', isEqualTo: true);
      }

      final snapshot = await query.get();
      if (snapshot.docs.isNotEmpty) {
        final reviews = snapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = data['id'] ?? doc.id;
          return ReviewModel.fromJson(data);
        }).toList();

        reviews.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return reviews;
      }
    } catch (_) {
      // Fallback
    }

    var list = InMemoryStore.instance.reviews.where((r) {
      if (status != null && r.status != status) return false;
      if (onlyFeatured == true && !r.isFeatured) return false;
      return true;
    }).toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  @override
  Future<ReviewModel?> getReviewById(String id) async {
    final doc = await _collection.doc(id).get();
    if (!doc.exists || doc.data() == null) return null;
    final data = doc.data()!;
    data['id'] = data['id'] ?? doc.id;
    return ReviewModel.fromJson(data);
  }

  @override
  Future<void> createReview(ReviewModel review) async {
    final docRef = review.id.isNotEmpty
        ? _collection.doc(review.id)
        : _collection.doc();
    final data = review.toJson();
    data['id'] = docRef.id;
    data['updatedAt'] = FieldValue.serverTimestamp();
    await docRef.set(data);
  }

  @override
  Future<void> updateReview(ReviewModel review) async {
    final data = review.toJson();
    data['updatedAt'] = FieldValue.serverTimestamp();
    await _collection.doc(review.id).set(data, SetOptions(merge: true));
  }

  @override
  Future<void> deleteReview(String id) async {
    await _collection.doc(id).delete();
  }
}
