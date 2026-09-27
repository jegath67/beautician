import 'package:flutter/material.dart';
import '../../data/repositories/booking_repository.dart';
import '../../domain/models/booking_model.dart';
import 'audit_provider.dart';

class BookingsProvider extends ChangeNotifier {
  final BookingRepository _bookingRepository;
  final AuditProvider? _auditProvider;

  List<BookingModel> _bookings = [];
  BookingStatus? _statusFilter;
  DateTime? _dateFilter;
  bool _isLoading = false;
  bool _isSubmitting = false;

  BookingsProvider({
    BookingRepository? bookingRepository,
    AuditProvider? auditProvider,
  })  : _bookingRepository = bookingRepository ?? MockBookingRepository(),
        _auditProvider = auditProvider {
    loadBookings();
  }

  List<BookingModel> get allBookings => _bookings;
  BookingStatus? get statusFilter => _statusFilter;
  DateTime? get dateFilter => _dateFilter;
  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;

  List<BookingModel> get filteredBookings {
    return _bookings.where((b) {
      if (_statusFilter != null && b.status != _statusFilter) return false;
      if (_dateFilter != null) {
        if (b.bookingDate.year != _dateFilter!.year ||
            b.bookingDate.month != _dateFilter!.month ||
            b.bookingDate.day != _dateFilter!.day) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  // Demo KPI Metrics (Clearly annotated as simulated/demo metrics in UI)
  int get totalBookingsCount => _bookings.length;

  int get todayBookingsCount {
    final now = DateTime.now();
    return _bookings.where((b) =>
        b.bookingDate.year == now.year &&
        b.bookingDate.month == now.month &&
        b.bookingDate.day == now.day &&
        b.status != BookingStatus.cancelled).length;
  }

  int get pendingBookingsCount =>
      _bookings.where((b) => b.status == BookingStatus.pending).length;

  int get confirmedBookingsCount =>
      _bookings.where((b) => b.status == BookingStatus.confirmed).length;

  int get completedBookingsCount =>
      _bookings.where((b) => b.status == BookingStatus.completed).length;

  double get demoEstimatedRevenue {
    return _bookings
        .where((b) => b.status == BookingStatus.completed || b.status == BookingStatus.confirmed)
        .fold(0.0, (sum, b) => sum + b.priceAtBooking);
  }

  Future<void> loadBookings() async {
    _isLoading = true;
    notifyListeners();

    _bookings = await _bookingRepository.getBookings();
    _isLoading = false;
    notifyListeners();
  }

  void setStatusFilter(BookingStatus? status) {
    _statusFilter = status;
    notifyListeners();
  }

  void setDateFilter(DateTime? date) {
    _dateFilter = date;
    notifyListeners();
  }

  void clearFilters() {
    _statusFilter = null;
    _dateFilter = null;
    notifyListeners();
  }

  Future<BookingModel> createBooking(BookingModel booking) async {
    _isSubmitting = true;
    notifyListeners();

    try {
      await _bookingRepository.createBooking(booking);
      await _auditProvider?.logAction(
        actorName: 'Client: ${booking.customerName}',
        actionType: 'CREATE',
        entityType: 'Booking',
        entityId: booking.id,
        entityTitle: '${booking.customerName} - ${booking.serviceTitle}',
        previousValue: null,
        newValue: 'Status: Pending, Price: ₹${booking.priceAtBooking}, Slot: ${booking.timeSlot}',
        summary: 'New booking created for ${booking.serviceTitle} with ${booking.beauticianName}.',
      );
      await loadBookings();
      _isSubmitting = false;
      notifyListeners();
      return booking;
    } catch (e) {
      _isSubmitting = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateBookingStatus(String id, BookingStatus newStatus) =>
      updateStatus(id, newStatus);

  Future<void> updateStatus(
    String id,
    BookingStatus newStatus, {
    String actorName = 'Admin',
  }) async {
    final booking = _bookings.firstWhere((b) => b.id == id);
    final prevStatus = booking.status;

    await _bookingRepository.updateBookingStatus(id, newStatus);
    await _auditProvider?.logAction(
      actorName: actorName,
      actionType: 'STATUS_CHANGE',
      entityType: 'Booking',
      entityId: id,
      entityTitle: '${booking.customerName} - ${booking.serviceTitle}',
      previousValue: 'Status: ${prevStatus.label}',
      newValue: 'Status: ${newStatus.label}',
      summary: 'Updated booking #${booking.id} status from ${prevStatus.label} to ${newStatus.label}.',
    );
    await loadBookings();
  }

  Future<void> deleteBooking(String id, {String actorName = 'Admin'}) async {
    final booking = _bookings.firstWhere((b) => b.id == id);
    await _bookingRepository.deleteBooking(id);
    await _auditProvider?.logAction(
      actorName: actorName,
      actionType: 'DELETE',
      entityType: 'Booking',
      entityId: id,
      entityTitle: '${booking.customerName} - ${booking.serviceTitle}',
      previousValue: 'Status: ${booking.status.label}',
      newValue: null,
      summary: 'Removed booking #${booking.id}.',
    );
    await loadBookings();
  }
}
