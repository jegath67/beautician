import 'package:flutter/material.dart';
import '../../data/repositories/audit_repository.dart';
import '../../domain/models/audit_log_entry_model.dart';

class AuditProvider extends ChangeNotifier {
  final AuditRepository _auditRepository;
  List<AuditLogEntryModel> _logs = [];
  bool _isLoading = false;
  String _selectedEntityType = 'All';
  String _selectedActionType = 'All';

  AuditProvider({AuditRepository? auditRepository})
      : _auditRepository = auditRepository ?? MockAuditRepository() {
    loadLogs();
  }

  List<AuditLogEntryModel> get logs => _logs;
  bool get isLoading => _isLoading;
  String get selectedEntityType => _selectedEntityType;
  String get selectedActionType => _selectedActionType;

  Future<void> loadLogs() async {
    _isLoading = true;
    notifyListeners();

    _logs = await _auditRepository.getAuditLogs(
      entityType: _selectedEntityType,
      actionType: _selectedActionType,
    );
    _isLoading = false;
    notifyListeners();
  }

  void filterByEntityType(String entityType) {
    _selectedEntityType = entityType;
    loadLogs();
  }

  void filterByActionType(String actionType) {
    _selectedActionType = actionType;
    loadLogs();
  }

  Future<void> logAction({
    required String actorName,
    required String actionType,
    required String entityType,
    required String entityId,
    required String entityTitle,
    String? previousValue,
    String? newValue,
    required String summary,
  }) async {
    final entry = AuditLogEntryModel(
      id: 'log_${DateTime.now().millisecondsSinceEpoch}',
      actorName: actorName,
      actionType: actionType,
      entityType: entityType,
      entityId: entityId,
      entityTitle: entityTitle,
      timestamp: DateTime.now(),
      previousValue: previousValue,
      newValue: newValue,
      summary: summary,
    );

    await _auditRepository.recordLog(entry);
    await loadLogs();
  }
}
