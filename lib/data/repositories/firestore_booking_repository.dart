import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/booking_model.dart';
import 'booking_repository.dart';

class FirestoreBookingRepository implements BookingRepository {
  final FirebaseFirestore? _customFirestore;
  final String collectionPath;

  FirestoreBookingRepository({
    FirebaseFirestore? firestore,
    this.collectionPath = 'bookings',
  }) : _customFirestore = firestore;

  FirebaseFirestore get _firestore =>
      _customFirestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(collectionPath);

  @override
  Future<List<BookingModel>> getBookings({
    BookingStatus? status,
    DateTime? date,
  }) async {
    Query<Map<String, dynamic>> query = _collection;

    if (status != null) {
      query = query.where('status', isEqualTo: status.name);
    }

    final snapshot = await query.get();
    var bookings = snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = data['id'] ?? doc.id;
      return BookingModel.fromJson(data);
    }).toList();

    if (date != null) {
      bookings = bookings.where((b) {
        return b.bookingDate.year == date.year &&
            b.bookingDate.month == date.month &&
            b.bookingDate.day == date.day;
      }).toList();
    }

    bookings.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return bookings;
  }

  @override
  Future<BookingModel?> getBookingById(String id) async {
    final doc = await _collection.doc(id).get();
    if (!doc.exists || doc.data() == null) return null;
    final data = doc.data()!;
    data['id'] = data['id'] ?? doc.id;
    return BookingModel.fromJson(data);
  }

  @override
  Future<void> createBooking(BookingModel booking) async {
    final docRef = booking.id.isNotEmpty
        ? _collection.doc(booking.id)
        : _collection.doc();
    final data = booking.toJson();
    data['id'] = docRef.id;
    data['updatedAt'] = FieldValue.serverTimestamp();
    await docRef.set(data);
  }

  @override
  Future<void> updateBookingStatus(String id, BookingStatus status) async {
    await _collection.doc(id).update({
      'status': status.name,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> deleteBooking(String id) async {
    await _collection.doc(id).delete();
  }
}
