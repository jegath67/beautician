import 'package:flutter/material.dart';
import '../../data/repositories/enquiry_repository.dart';
import '../../domain/models/contact_enquiry_model.dart';
import 'audit_provider.dart';

class EnquiriesProvider extends ChangeNotifier {
  final EnquiryRepository _enquiryRepository;
  final AuditProvider? _auditProvider;

  List<ContactEnquiryModel> _enquiries = [];
  EnquiryStatus? _statusFilter;
  bool _isLoading = false;
  bool _isSubmitting = false;

  EnquiriesProvider({
    EnquiryRepository? enquiryRepository,
    AuditProvider? auditProvider,
  })  : _enquiryRepository = enquiryRepository ?? MockEnquiryRepository(),
        _auditProvider = auditProvider {
    loadEnquiries();
  }

  List<ContactEnquiryModel> get allEnquiries => _enquiries;
  EnquiryStatus? get statusFilter => _statusFilter;
  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;

  int get newEnquiriesCount =>
      _enquiries.where((e) => e.status == EnquiryStatus.newEnquiry).length;

  List<ContactEnquiryModel> get filteredEnquiries {
    if (_statusFilter == null) return _enquiries;
    return _enquiries.where((e) => e.status == _statusFilter).toList();
  }

  Future<void> loadEnquiries() async {
    _isLoading = true;
    notifyListeners();

    _enquiries = await _enquiryRepository.getEnquiries();
    _isLoading = false;
    notifyListeners();
  }

  void setStatusFilter(EnquiryStatus? status) {
    _statusFilter = status;
    notifyListeners();
  }

  Future<bool> submitEnquiry({
    required String name,
    required String email,
    required String phone,
    required String subject,
    required String message,
  }) async {
    _isSubmitting = true;
    notifyListeners();

    try {
      final enquiry = ContactEnquiryModel(
        id: 'enq_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        email: email,
        phone: phone,
        subject: subject,
        message: message,
        status: EnquiryStatus.newEnquiry,
        createdAt: DateTime.now(),
      );

      await _enquiryRepository.submitEnquiry(enquiry);
      await _auditProvider?.logAction(
        actorName: 'Visitor: $name',
        actionType: 'CREATE',
        entityType: 'Enquiry',
        entityId: enquiry.id,
        entityTitle: '$name - $subject',
        previousValue: null,
        newValue: 'Status: New, Subject: $subject',
        summary: 'Received new contact enquiry from $name.',
      );

      await loadEnquiries();
      _isSubmitting = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isSubmitting = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> updateStatus(
    String id,
    EnquiryStatus newStatus, {
    String actorName = 'Admin',
  }) async {
    final enq = _enquiries.firstWhere((e) => e.id == id);
    final prev = enq.status;

    await _enquiryRepository.updateEnquiryStatus(id, newStatus);
    await _auditProvider?.logAction(
      actorName: actorName,
      actionType: 'STATUS_CHANGE',
      entityType: 'Enquiry',
      entityId: id,
      entityTitle: '${enq.name} - ${enq.subject}',
      previousValue: 'Status: ${prev.label}',
      newValue: 'Status: ${newStatus.label}',
      summary: 'Updated enquiry #${enq.id} status to ${newStatus.label}.',
    );
    await loadEnquiries();
  }

  Future<void> deleteEnquiry(String id, {String actorName = 'Admin'}) async {
    final enq = _enquiries.firstWhere((e) => e.id == id);
    await _enquiryRepository.deleteEnquiry(id);
    await _auditProvider?.logAction(
      actorName: actorName,
      actionType: 'DELETE',
      entityType: 'Enquiry',
      entityId: id,
      entityTitle: '${enq.name} - ${enq.subject}',
      previousValue: 'Status: ${enq.status.label}',
      newValue: null,
      summary: 'Deleted enquiry from ${enq.name}.',
    );
    await loadEnquiries();
  }
}
