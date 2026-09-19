import 'package:flutter_test/flutter_test.dart';
import 'package:beautician/data/repositories/audit_repository.dart';
import 'package:beautician/data/repositories/booking_repository.dart';
import 'package:beautician/data/repositories/service_repository.dart';
import 'package:beautician/domain/models/audit_log_entry_model.dart';
import 'package:beautician/domain/models/booking_model.dart';
import 'package:beautician/domain/models/content_status.dart';

void main() {
  group('Repository Tests', () {
    test('ServiceRepository filters published services vs drafts', () async {
      final repo = MockServiceRepository();
      final all = await repo.getServices();
      final published = await repo.getServices(status: ContentStatus.published);
      final drafts = await repo.getServices(status: ContentStatus.draft);

      expect(all.length, greaterThan(published.length));
      expect(drafts.isNotEmpty, isTrue);
    });

    test('BookingRepository creates and stores immutable price snapshot', () async {
      final repo = MockBookingRepository();
      final newBooking = BookingModel(
        id: 'BK-TEST-99',
        customerName: 'Aarti Rao',
        email: 'aarti@example.com',
        phone: '9876543210',
        serviceId: 'srv_1',
        serviceTitle: 'Royal Bridal Makeover & Styling',
        beauticianId: 'bt_1',
        beauticianName: 'Ananya Deshmukh',
        priceAtBooking: 18500,
        durationMinutes: 180,
        bookingDate: DateTime(2026, 11, 20),
        timeSlot: '11:00 AM',
        status: BookingStatus.pending,
        createdAt: DateTime.now(),
      );

      await repo.createBooking(newBooking);
      final retrieved = await repo.getBookingById('BK-TEST-99');

      expect(retrieved, isNotNull);
      expect(retrieved!.priceAtBooking, equals(18500));
      expect(retrieved.serviceTitle, equals('Royal Bridal Makeover & Styling'));

      await repo.updateBookingStatus('BK-TEST-99', BookingStatus.confirmed);
      final updated = await repo.getBookingById('BK-TEST-99');
      expect(updated!.status, equals(BookingStatus.confirmed));
    });

    test('AuditRepository records and filters audit events', () async {
      final repo = MockAuditRepository();
      final initialLogs = await repo.getAuditLogs();

      final newEntry = AuditLogEntryModel(
        id: 'log_test',
        actorName: 'Super Admin',
        actionType: 'PUBLISH',
        entityType: 'Service',
        entityId: 'srv_test',
        entityTitle: 'Test Service',
        timestamp: DateTime.now(),
        previousValue: 'Status: Draft',
        newValue: 'Status: Published',
        summary: 'Published test service.',
      );

      await repo.recordLog(newEntry);
      final updatedLogs = await repo.getAuditLogs();
      expect(updatedLogs.length, equals(initialLogs.length + 1));

      final serviceLogs = await repo.getAuditLogs(entityType: 'Service');
      expect(serviceLogs.any((l) => l.id == 'log_test'), isTrue);
    });
  });
}
