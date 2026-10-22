import '../../domain/models/audit_log_entry_model.dart';
import '../datasources/in_memory_store.dart';

abstract class AuditRepository {
  Future<List<AuditLogEntryModel>> getAuditLogs({
    String? entityType,
    String? actionType,
    int? limit,
  });
  Future<void> recordLog(AuditLogEntryModel log);
}

class MockAuditRepository implements AuditRepository {
  final InMemoryStore _store;

  MockAuditRepository({InMemoryStore? store})
    : _store = store ?? InMemoryStore.instance;

  @override
  Future<List<AuditLogEntryModel>> getAuditLogs({
    String? entityType,
    String? actionType,
    int? limit,
  }) async {
    var list = _store.auditLogs.where((l) {
      if (entityType != null && entityType.isNotEmpty && entityType != 'All') {
        if (l.entityType.toLowerCase() != entityType.toLowerCase()) {
          return false;
        }
      }
      if (actionType != null && actionType.isNotEmpty && actionType != 'All') {
        if (l.actionType.toLowerCase() != actionType.toLowerCase()) {
          return false;
        }
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
    _store.auditLogs.insert(0, log);
  }
}
