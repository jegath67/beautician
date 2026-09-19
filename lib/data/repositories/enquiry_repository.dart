import '../../domain/models/contact_enquiry_model.dart';

abstract class EnquiryRepository {
  Future<List<ContactEnquiryModel>> getEnquiries({EnquiryStatus? status});
  Future<ContactEnquiryModel?> getEnquiryById(String id);
  Future<void> submitEnquiry(ContactEnquiryModel enquiry);
  Future<void> updateEnquiryStatus(String id, EnquiryStatus status);
  Future<void> deleteEnquiry(String id);
}

class MockEnquiryRepository implements EnquiryRepository {
  final List<ContactEnquiryModel> _enquiries = [
    ContactEnquiryModel(
      id: 'enq_1',
      name: 'Pooja Hegde',
      email: 'pooja.h@example.com',
      phone: '+91 99001 22334',
      subject: 'Destination Wedding Makeup Quote for Dec 2026',
      message: 'Hello! I am planning a 3-day destination wedding in Udaipur with 6 bridesmaids. Wanted to enquire about Ananya’s availability and comprehensive package rates.',
      status: EnquiryStatus.newEnquiry,
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    ContactEnquiryModel(
      id: 'enq_2',
      name: 'Nandini Swamy',
      email: 'nandini.s@example.com',
      phone: '+91 98200 44556',
      subject: 'Corporate Spa Day Booking',
      message: 'Looking to book exclusive salon access for a team of 8 on a Friday afternoon for facial and massage therapies.',
      status: EnquiryStatus.read,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  @override
  Future<List<ContactEnquiryModel>> getEnquiries({EnquiryStatus? status}) async {
    return _enquiries.where((e) {
      if (status != null && e.status != status) return false;
      return true;
    }).toList();
  }

  @override
  Future<ContactEnquiryModel?> getEnquiryById(String id) async {
    final index = _enquiries.indexWhere((e) => e.id == id);
    return index != -1 ? _enquiries[index] : null;
  }

  @override
  Future<void> submitEnquiry(ContactEnquiryModel enquiry) async {
    _enquiries.insert(0, enquiry);
  }

  @override
  Future<void> updateEnquiryStatus(String id, EnquiryStatus status) async {
    final index = _enquiries.indexWhere((e) => e.id == id);
    if (index != -1) {
      _enquiries[index] = _enquiries[index].copyWith(status: status);
    }
  }

  @override
  Future<void> deleteEnquiry(String id) async {
    _enquiries.removeWhere((e) => e.id == id);
  }
}
