enum EnquiryStatus {
  newEnquiry,
  read,
  replied,
  archived;

  String get label {
    switch (this) {
      case EnquiryStatus.newEnquiry:
        return 'New';
      case EnquiryStatus.read:
        return 'Read';
      case EnquiryStatus.replied:
        return 'Replied';
      case EnquiryStatus.archived:
        return 'Archived';
    }
  }

  static EnquiryStatus fromString(String value) {
    return EnquiryStatus.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => EnquiryStatus.newEnquiry,
    );
  }
}

/// Represents a customer message/enquiry submitted via the Contact form.
class ContactEnquiryModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String subject;
  final String message;
  final EnquiryStatus status;
  final DateTime createdAt;

  const ContactEnquiryModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.subject,
    required this.message,
    this.status = EnquiryStatus.newEnquiry,
    required this.createdAt,
  });

  ContactEnquiryModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? subject,
    String? message,
    EnquiryStatus? status,
    DateTime? createdAt,
  }) {
    return ContactEnquiryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      subject: subject ?? this.subject,
      message: message ?? this.message,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'subject': subject,
      'message': message,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ContactEnquiryModel.fromJson(Map<String, dynamic> json) {
    return ContactEnquiryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      subject: json['subject'] as String,
      message: json['message'] as String,
      status: EnquiryStatus.fromString(json['status'] as String? ?? 'newEnquiry'),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
