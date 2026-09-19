import 'package:flutter_test/flutter_test.dart';
import 'package:beautician/domain/models/beautician_model.dart';
import 'package:beautician/domain/models/booking_model.dart';
import 'package:beautician/domain/services/availability_service.dart';

void main() {
  group('AvailabilityService Tests', () {
    const beautician = BeauticianModel(
      id: 'bt_test',
      name: 'Test Stylist',
      role: 'Specialist',
      bio: 'Bio',
      specialties: ['Hair'],
      avatarUrl: '',
      workingDays: [1, 2, 3, 4, 5, 6], // Mon - Sat
      workingHoursStart: '09:00',
      workingHoursEnd: '17:00',
      breakStart: '13:00',
      breakEnd: '14:00',
      isActive: true,
    );

    // Fixed mock Monday: 2026-10-12
    final testDate = DateTime(2026, 10, 12);
    final mockNow = DateTime(2026, 10, 1, 8, 0); // Well in the past so whole day is open

    test('calculates standard slots without bookings or break overlaps', () {
      final slots = AvailabilityService.getAvailableSlots(
        beautician: beautician,
        date: testDate,
        serviceDurationMinutes: 60,
        existingBookings: [],
        now: mockNow,
      );

      // 09:00 - 17:00 (Break 13:00-14:00)
      // Slots: 09:00 AM, 09:30 AM, 10:00 AM, 10:30 AM, 11:00 AM, 11:30 AM, 12:00 PM (ends at 13:00)
      // Break: 13:00-14:00
      // Afternoon: 02:00 PM, 02:30 PM, 03:00 PM, 03:30 PM, 04:00 PM (ends at 17:00)
      expect(slots.isNotEmpty, isTrue);
      expect(slots.contains('09:00 AM'), isTrue);
      expect(slots.contains('12:00 PM'), isTrue);
      expect(slots.contains('01:00 PM'), isFalse); // Break period start
      expect(slots.contains('01:30 PM'), isFalse); // In break period
      expect(slots.contains('02:00 PM'), isTrue); // Afternoon restart
      expect(slots.contains('04:00 PM'), isTrue);
      expect(slots.contains('04:30 PM'), isFalse); // 60 min service ends at 17:30 (exceeds 17:00)
    });

    test('excludes slots that collide with existing active bookings', () {
      final existingBooking = BookingModel(
        id: 'bk_1',
        customerName: 'Existing Client',
        email: 'client@test.com',
        phone: '1234567890',
        serviceId: 'srv_1',
        serviceTitle: 'Haircut',
        beauticianId: 'bt_test',
        beauticianName: 'Test Stylist',
        priceAtBooking: 1000,
        durationMinutes: 60,
        bookingDate: testDate,
        timeSlot: '10:00 AM',
        status: BookingStatus.confirmed,
        createdAt: DateTime(2026, 10, 1),
      );

      final slots = AvailabilityService.getAvailableSlots(
        beautician: beautician,
        date: testDate,
        serviceDurationMinutes: 60,
        existingBookings: [existingBooking],
        now: mockNow,
      );

      // Existing booking runs 10:00 AM - 11:00 AM
      expect(slots.contains('09:00 AM'), isTrue);
      expect(slots.contains('09:30 AM'), isFalse); // 09:30 - 10:30 overlaps with 10:00 - 11:00
      expect(slots.contains('10:00 AM'), isFalse); // 10:00 - 11:00 exact collision
      expect(slots.contains('10:30 AM'), isFalse); // 10:30 - 11:30 overlaps with 10:00 - 11:00
      expect(slots.contains('11:00 AM'), isTrue);  // 11:00 - 12:00 free!
    });

    test('returns empty slots for off-days (e.g. Sunday)', () {
      final sunday = DateTime(2026, 10, 18); // Sunday
      final slots = AvailabilityService.getAvailableSlots(
        beautician: beautician,
        date: sunday,
        serviceDurationMinutes: 60,
        existingBookings: [],
        now: mockNow,
      );

      expect(slots, isEmpty);
    });

    test('returns empty slots for past dates', () {
      final pastDate = DateTime(2026, 9, 1);
      final slots = AvailabilityService.getAvailableSlots(
        beautician: beautician,
        date: pastDate,
        serviceDurationMinutes: 60,
        existingBookings: [],
        now: DateTime(2026, 10, 1),
      );

      expect(slots, isEmpty);
    });
  });
}
