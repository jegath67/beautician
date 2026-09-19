import '../../domain/models/audit_log_entry_model.dart';

abstract class AuditRepository {
  Future<List<AuditLogEntryModel>> getAuditLogs({String? entityType, String? actionType, int? limit});
  Future<void> recordLog(AuditLogEntryModel log);
}

class MockAuditRepository implements AuditRepository {
  final List<AuditLogEntryModel> _logs = [
    AuditLogEntryModel(
      id: 'log_1',
      actorName: 'Priya Sharma (Manager)',
      actionType: 'PUBLISH',
      entityType: 'Service',
      entityId: 'srv_1',
      entityTitle: 'Royal Bridal Makeover & Styling',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      previousValue: 'Status: Draft, Price: ₹18000',
      newValue: 'Status: Published, Price: ₹18500',
      summary: 'Updated bridal package pricing and published to public catalog.',
    ),
    AuditLogEntryModel(
      id: 'log_2',
      actorName: 'Priya Sharma (Manager)',
      actionType: 'STATUS_CHANGE',
      entityType: 'Booking',
      entityId: 'BK-10821',
      entityTitle: 'Kavita Menon - Bridal Booking',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      previousValue: 'Status: Pending',
      newValue: 'Status: Confirmed',
      summary: 'Confirmed bridal makeover appointment after customer deposit call.',
    ),
    AuditLogEntryModel(
      id: 'log_3',
      actorName: 'System Engine',
      actionType: 'CREATE',
      entityType: 'Booking',
      entityId: 'BK-10822',
      entityTitle: 'Sneha Reddy - Hydra-Glow Facial',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      previousValue: null,
      newValue: 'Status: Pending, Slot: 02:30 PM',
      summary: 'Customer submitted new online appointment booking.',
    ),
  ];

  @override
  Future<List<AuditLogEntryModel>> getAuditLogs({String? entityType, String? actionType, int? limit}) async {
    var list = _logs.where((l) {
      if (entityType != null && entityType.isNotEmpty && entityType != 'All') {
        if (l.entityType.toLowerCase() != entityType.toLowerCase()) return false;
      }
      if (actionType != null && actionType.isNotEmpty && actionType != 'All') {
        if (l.actionType.toLowerCase() != actionType.toLowerCase()) return false;
      }
      return true;
    }).toList();

    list.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    if (limit != null && limit > 0 && limit < list.length) {
      list = list.sublist(0, limit);
    }
    return list;
  }

  @override
  Future<void> recordLog(AuditLogEntryModel log) async {
    _logs.insert(0, log);
  }
}
