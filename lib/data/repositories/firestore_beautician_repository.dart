import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/beautician_model.dart';
import '../datasources/in_memory_store.dart';
import 'beautician_repository.dart';

class FirestoreBeauticianRepository implements BeauticianRepository {
  final FirebaseFirestore? _customFirestore;
  final String collectionPath;

  FirestoreBeauticianRepository({
    FirebaseFirestore? firestore,
    this.collectionPath = 'beauticians',
  }) : _customFirestore = firestore;

  FirebaseFirestore get _firestore =>
      _customFirestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(collectionPath);

  @override
  Future<List<BeauticianModel>> getBeauticians({bool? onlyActive}) async {
    try {
      Query<Map<String, dynamic>> query = _collection;

      if (onlyActive == true) {
        query = query.where('isActive', isEqualTo: true);
      }

      final snapshot = await query.get();
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = data['id'] ?? doc.id;
          return BeauticianModel.fromJson(data);
        }).toList();
      }
    } catch (_) {
      // Fallback
    }

    return InMemoryStore.instance.beauticians.where((b) {
      if (onlyActive == true && !b.isActive) return false;
      return true;
    }).toList();
  }

  @override
  Future<BeauticianModel?> getBeauticianById(String id) async {
    final doc = await _collection.doc(id).get();
    if (!doc.exists || doc.data() == null) return null;
    final data = doc.data()!;
    data['id'] = data['id'] ?? doc.id;
    return BeauticianModel.fromJson(data);
  }

  @override
  Future<void> createBeautician(BeauticianModel beautician) async {
    final docRef = beautician.id.isNotEmpty
        ? _collection.doc(beautician.id)
        : _collection.doc();
    final data = beautician.toJson();
    data['id'] = docRef.id;
    data['createdAt'] = FieldValue.serverTimestamp();
    data['updatedAt'] = FieldValue.serverTimestamp();
    await docRef.set(data);
  }

  @override
  Future<void> updateBeautician(BeauticianModel beautician) async {
    final data = beautician.toJson();
    data['updatedAt'] = FieldValue.serverTimestamp();
    await _collection.doc(beautician.id).set(data, SetOptions(merge: true));
  }

  @override
  Future<void> deleteBeautician(String id) async {
    await _collection.doc(id).delete();
  }
}
