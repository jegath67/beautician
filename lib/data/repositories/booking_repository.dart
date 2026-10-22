import '../../domain/models/booking_model.dart';
import '../datasources/in_memory_store.dart';

abstract class BookingRepository {
  Future<List<BookingModel>> getBookings({
    BookingStatus? status,
    DateTime? date,
  });
  Future<BookingModel?> getBookingById(String id);
  Future<void> createBooking(BookingModel booking);
  Future<void> updateBookingStatus(String id, BookingStatus status);
  Future<void> deleteBooking(String id);
}

class MockBookingRepository implements BookingRepository {
  final InMemoryStore _store;

  MockBookingRepository({InMemoryStore? store})
    : _store = store ?? InMemoryStore.instance;

  @override
  Future<List<BookingModel>> getBookings({
    BookingStatus? status,
    DateTime? date,
  }) async {
    return _store.bookings.where((b) {
      if (status != null && b.status != status) return false;
      if (date != null) {
        if (b.bookingDate.year != date.year ||
            b.bookingDate.month != date.month ||
            b.bookingDate.day != date.day) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  @override
  Future<BookingModel?> getBookingById(String id) async {
    final index = _store.bookings.indexWhere((b) => b.id == id);
    return index != -1 ? _store.bookings[index] : null;
  }

  @override
  Future<void> createBooking(BookingModel booking) async {
    _store.bookings.insert(0, booking);
  }

  @override
  Future<void> updateBookingStatus(String id, BookingStatus status) async {
    final index = _store.bookings.indexWhere((b) => b.id == id);
    if (index != -1) {
      _store.bookings[index] = _store.bookings[index].copyWith(status: status);
    }
  }

  @override
  Future<void> deleteBooking(String id) async {
    _store.bookings.removeWhere((b) => b.id == id);
  }
}
