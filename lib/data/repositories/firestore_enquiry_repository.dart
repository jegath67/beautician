import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/contact_enquiry_model.dart';
import 'enquiry_repository.dart';

class FirestoreEnquiryRepository implements EnquiryRepository {
  final FirebaseFirestore? _customFirestore;
  final String collectionPath;

  FirestoreEnquiryRepository({
    FirebaseFirestore? firestore,
    this.collectionPath = 'enquiries',
  }) : _customFirestore = firestore;

  FirebaseFirestore get _firestore =>
      _customFirestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(collectionPath);

  @override
  Future<List<ContactEnquiryModel>> getEnquiries({EnquiryStatus? status}) async {
    Query<Map<String, dynamic>> query = _collection;

    if (status != null) {
      query = query.where('status', isEqualTo: status.name);
    }

    final snapshot = await query.get();
    final enquiries = snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = data['id'] ?? doc.id;
      return ContactEnquiryModel.fromJson(data);
    }).toList();

    enquiries.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return enquiries;
  }

  @override
  Future<ContactEnquiryModel?> getEnquiryById(String id) async {
    final doc = await _collection.doc(id).get();
    if (!doc.exists || doc.data() == null) return null;
    final data = doc.data()!;
    data['id'] = data['id'] ?? doc.id;
    return ContactEnquiryModel.fromJson(data);
  }

  @override
  Future<void> submitEnquiry(ContactEnquiryModel enquiry) async {
    final docRef = enquiry.id.isNotEmpty
        ? _collection.doc(enquiry.id)
        : _collection.doc();
    final data = enquiry.toJson();
    data['id'] = docRef.id;
    data['updatedAt'] = FieldValue.serverTimestamp();
    await docRef.set(data);
  }

  @override
  Future<void> updateEnquiryStatus(String id, EnquiryStatus status) async {
    await _collection.doc(id).update({
      'status': status.name,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> deleteEnquiry(String id) async {
    await _collection.doc(id).delete();
  }
}
