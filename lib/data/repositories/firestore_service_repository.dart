import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/content_status.dart';
import '../../domain/models/service_model.dart';
import '../datasources/in_memory_store.dart';
import 'service_repository.dart';

class FirestoreServiceRepository implements ServiceRepository {
  final FirebaseFirestore? _customFirestore;
  final String collectionPath;

  FirestoreServiceRepository({
    FirebaseFirestore? firestore,
    this.collectionPath = 'services',
  }) : _customFirestore = firestore;

  FirebaseFirestore get _firestore =>
      _customFirestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(collectionPath);

  @override
  Future<List<ServiceModel>> getServices({
    ContentStatus? status,
    String? category,
  }) async {
    try {
      Query<Map<String, dynamic>> query = _collection;

      if (status != null) {
        query = query.where('status', isEqualTo: status.name);
      }
      if (category != null && category.isNotEmpty && category != 'All') {
        query = query.where('category', isEqualTo: category);
      }

      final snapshot = await query.get();
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = data['id'] ?? doc.id;
          return ServiceModel.fromJson(data);
        }).toList();
      }
    } catch (_) {
      // Fallback to in-memory store if Firestore is empty or unreachable/offline
    }

    return InMemoryStore.instance.services.where((s) {
      if (status != null && s.status != status) return false;
      if (category != null && category.isNotEmpty && category != 'All') {
        if (s.category.toLowerCase() != category.toLowerCase()) return false;
      }
      return true;
    }).toList();
  }

  @override
  Future<ServiceModel?> getServiceById(String id) async {
    final doc = await _collection.doc(id).get();
    if (!doc.exists || doc.data() == null) {
      return null;
    }
    final data = doc.data()!;
    data['id'] = data['id'] ?? doc.id;
    return ServiceModel.fromJson(data);
  }

  @override
  Future<void> createService(ServiceModel service) async {
    final docRef = service.id.isNotEmpty
        ? _collection.doc(service.id)
        : _collection.doc();
    final data = service.toJson();
    data['id'] = docRef.id;
    data['createdAt'] = FieldValue.serverTimestamp();
    data['updatedAt'] = FieldValue.serverTimestamp();
    await docRef.set(data);
  }

  @override
  Future<void> updateService(ServiceModel service) async {
    final data = service.toJson();
    data['updatedAt'] = FieldValue.serverTimestamp();
    await _collection.doc(service.id).set(data, SetOptions(merge: true));
  }

  @override
  Future<void> deleteService(String id) async {
    await _collection.doc(id).delete();
  }
}
