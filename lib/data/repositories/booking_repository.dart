import '../../domain/models/booking_model.dart';

abstract class BookingRepository {
  Future<List<BookingModel>> getBookings({BookingStatus? status, DateTime? date});
  Future<BookingModel?> getBookingById(String id);
  Future<void> createBooking(BookingModel booking);
  Future<void> updateBookingStatus(String id, BookingStatus status);
  Future<void> deleteBooking(String id);
}

class MockBookingRepository implements BookingRepository {
  final List<BookingModel> _bookings = [
    BookingModel(
      id: 'BK-10821',
      customerName: 'Kavita Menon',
      email: 'kavita.m@example.com',
      phone: '+91 98401 23456',
      serviceId: 'srv_1',
      serviceTitle: 'Royal Bridal Makeover & Styling',
      beauticianId: 'bt_1',
      beauticianName: 'Ananya Deshmukh',
      priceAtBooking: 18500,
      durationMinutes: 180,
      bookingDate: DateTime.now().add(const Duration(days: 1)),
      timeSlot: '10:00 AM',
      status: BookingStatus.confirmed,
      notes: 'South Indian wedding look with custom temple jewelry pairing.',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    BookingModel(
      id: 'BK-10822',
      customerName: 'Sneha Reddy',
      email: 'sneha.r@example.com',
      phone: '+91 98840 56789',
      serviceId: 'srv_2',
      serviceTitle: 'Hydra-Glow Signature Facial',
      beauticianId: 'bt_2',
      beauticianName: 'Pooja Krishnan',
      priceAtBooking: 4500,
      durationMinutes: 75,
      bookingDate: DateTime.now().add(const Duration(days: 2)),
      timeSlot: '02:30 PM',
      status: BookingStatus.pending,
      notes: 'First time facial at Aura. Sensitive skin.',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    BookingModel(
      id: 'BK-10823',
      customerName: 'Radhika Swaminathan',
      email: 'radhika.s@example.com',
      phone: '+91 94440 98765',
      serviceId: 'srv_3',
      serviceTitle: 'Couture Balayage & Gloss Finish',
      beauticianId: 'bt_3',
      beauticianName: 'Meera Sengupta',
      priceAtBooking: 8500,
      durationMinutes: 150,
      bookingDate: DateTime.now().add(const Duration(days: 3)),
      timeSlot: '11:00 AM',
      status: BookingStatus.confirmed,
      notes: 'Caramel highlights on dark brown base.',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    BookingModel(
      id: 'BK-10820',
      customerName: 'Divya Bharathi',
      email: 'divya.b@example.com',
      phone: '+91 97900 11223',
      serviceId: 'srv_4',
      serviceTitle: 'Luxe Gel Sculpting & Nail Art',
      beauticianId: 'bt_1',
      beauticianName: 'Ananya Deshmukh',
      priceAtBooking: 3200,
      durationMinutes: 90,
      bookingDate: DateTime.now().subtract(const Duration(days: 1)),
      timeSlot: '04:00 PM',
      status: BookingStatus.completed,
      notes: 'Chrome finish with nude base.',
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
  ];

  @override
  Future<List<BookingModel>> getBookings({BookingStatus? status, DateTime? date}) async {
    return _bookings.where((b) {
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
    final index = _bookings.indexWhere((b) => b.id == id);
    return index != -1 ? _bookings[index] : null;
  }

  @override
  Future<void> createBooking(BookingModel booking) async {
    _bookings.insert(0, booking);
  }

  @override
  Future<void> updateBookingStatus(String id, BookingStatus status) async {
    final index = _bookings.indexWhere((b) => b.id == id);
    if (index != -1) {
      _bookings[index] = _bookings[index].copyWith(status: status);
    }
  }

  @override
  Future<void> deleteBooking(String id) async {
    _bookings.removeWhere((b) => b.id == id);
  }
}
