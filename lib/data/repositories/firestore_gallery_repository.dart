import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/content_status.dart';
import '../../domain/models/gallery_item_model.dart';
import 'gallery_repository.dart';

class FirestoreGalleryRepository implements GalleryRepository {
  final FirebaseFirestore? _customFirestore;
  final String collectionPath;

  FirestoreGalleryRepository({
    FirebaseFirestore? firestore,
    this.collectionPath = 'gallery',
  }) : _customFirestore = firestore;

  FirebaseFirestore get _firestore =>
      _customFirestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(collectionPath);

  @override
  Future<List<GalleryItemModel>> getGalleryItems({
    ContentStatus? status,
    String? category,
    int? limit,
    int? offset,
  }) async {
    Query<Map<String, dynamic>> query = _collection;

    if (status != null) {
      query = query.where('status', isEqualTo: status.name);
    }
    if (category != null && category.isNotEmpty && category != 'All') {
      query = query.where('category', isEqualTo: category);
    }

    final snapshot = await query.get();
    var items = snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = data['id'] ?? doc.id;
      return GalleryItemModel.fromJson(data);
    }).toList();

    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    if (offset != null && offset > 0) {
      if (offset >= items.length) return [];
      items = items.sublist(offset);
    }

    if (limit != null && limit > 0 && limit < items.length) {
      items = items.sublist(0, limit);
    }

    return items;
  }

  @override
  Future<GalleryItemModel?> getGalleryItemById(String id) async {
    final doc = await _collection.doc(id).get();
    if (!doc.exists || doc.data() == null) return null;
    final data = doc.data()!;
    data['id'] = data['id'] ?? doc.id;
    return GalleryItemModel.fromJson(data);
  }

  @override
  Future<void> createGalleryItem(GalleryItemModel item) async {
    final docRef = item.id.isNotEmpty
        ? _collection.doc(item.id)
        : _collection.doc();
    final data = item.toJson();
    data['id'] = docRef.id;
    data['createdAt'] = item.createdAt.toIso8601String();
    data['updatedAt'] = FieldValue.serverTimestamp();
    await docRef.set(data);
  }

  @override
  Future<void> updateGalleryItem(GalleryItemModel item) async {
    final data = item.toJson();
    data['updatedAt'] = FieldValue.serverTimestamp();
    await _collection.doc(item.id).set(data, SetOptions(merge: true));
  }

  @override
  Future<void> deleteGalleryItem(String id) async {
    await _collection.doc(id).delete();
  }
}
