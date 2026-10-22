import '../../domain/models/contact_enquiry_model.dart';
import '../datasources/in_memory_store.dart';

abstract class EnquiryRepository {
  Future<List<ContactEnquiryModel>> getEnquiries({EnquiryStatus? status});
  Future<ContactEnquiryModel?> getEnquiryById(String id);
  Future<void> submitEnquiry(ContactEnquiryModel enquiry);
  Future<void> updateEnquiryStatus(String id, EnquiryStatus status);
  Future<void> deleteEnquiry(String id);
}

class MockEnquiryRepository implements EnquiryRepository {
  final InMemoryStore _store;

  MockEnquiryRepository({InMemoryStore? store})
    : _store = store ?? InMemoryStore.instance;

  @override
  Future<List<ContactEnquiryModel>> getEnquiries({
    EnquiryStatus? status,
  }) async {
    return _store.enquiries.where((e) {
      if (status != null && e.status != status) return false;
      return true;
    }).toList();
  }

  @override
  Future<ContactEnquiryModel?> getEnquiryById(String id) async {
    final index = _store.enquiries.indexWhere((e) => e.id == id);
    return index != -1 ? _store.enquiries[index] : null;
  }

  @override
  Future<void> submitEnquiry(ContactEnquiryModel enquiry) async {
    _store.enquiries.insert(0, enquiry);
  }

  @override
  Future<void> updateEnquiryStatus(String id, EnquiryStatus status) async {
    final index = _store.enquiries.indexWhere((e) => e.id == id);
    if (index != -1) {
      _store.enquiries[index] = _store.enquiries[index].copyWith(
        status: status,
      );
    }
  }

  @override
  Future<void> deleteEnquiry(String id) async {
    _store.enquiries.removeWhere((e) => e.id == id);
  }
}
