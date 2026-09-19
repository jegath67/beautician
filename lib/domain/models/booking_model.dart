enum BookingStatus {
  pending,
  confirmed,
  completed,
  cancelled;

  String get label {
    switch (this) {
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
    }
  }

  static BookingStatus fromString(String value) {
    return BookingStatus.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => BookingStatus.pending,
    );
  }
}

/// Represents an appointment booking with immutable snapshots of price & service at booking time.
class BookingModel {
  final String id;
  final String customerName;
  final String email;
  final String phone;
  final String serviceId;
  final String serviceTitle; // Snapshot
  final String beauticianId;
  final String beauticianName; // Snapshot
  final double priceAtBooking; // Snapshot
  final int durationMinutes; // Snapshot
  final DateTime bookingDate;
  final String timeSlot;
  final BookingStatus status;
  final String? notes;
  final DateTime createdAt;

  const BookingModel({
    required this.id,
    required this.customerName,
    required this.email,
    required this.phone,
    required this.serviceId,
    required this.serviceTitle,
    required this.beauticianId,
    required this.beauticianName,
    required this.priceAtBooking,
    required this.durationMinutes,
    required this.bookingDate,
    required this.timeSlot,
    this.status = BookingStatus.pending,
    this.notes,
    required this.createdAt,
  });

  String get formattedPrice => '₹${priceAtBooking.toStringAsFixed(0)}';

  BookingModel copyWith({
    String? id,
    String? customerName,
    String? email,
    String? phone,
    String? serviceId,
    String? serviceTitle,
    String? beauticianId,
    String? beauticianName,
    double? priceAtBooking,
    int? durationMinutes,
    DateTime? bookingDate,
    String? timeSlot,
    BookingStatus? status,
    String? notes,
    DateTime? createdAt,
  }) {
    return BookingModel(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      serviceId: serviceId ?? this.serviceId,
      serviceTitle: serviceTitle ?? this.serviceTitle,
      beauticianId: beauticianId ?? this.beauticianId,
      beauticianName: beauticianName ?? this.beauticianName,
      priceAtBooking: priceAtBooking ?? this.priceAtBooking,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      bookingDate: bookingDate ?? this.bookingDate,
      timeSlot: timeSlot ?? this.timeSlot,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerName': customerName,
      'email': email,
      'phone': phone,
      'serviceId': serviceId,
      'serviceTitle': serviceTitle,
      'beauticianId': beauticianId,
      'beauticianName': beauticianName,
      'priceAtBooking': priceAtBooking,
      'durationMinutes': durationMinutes,
      'bookingDate': bookingDate.toIso8601String(),
      'timeSlot': timeSlot,
      'status': status.name,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as String,
      customerName: json['customerName'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      serviceId: json['serviceId'] as String,
      serviceTitle: json['serviceTitle'] as String,
      beauticianId: json['beauticianId'] as String,
      beauticianName: json['beauticianName'] as String,
      priceAtBooking: (json['priceAtBooking'] as num).toDouble(),
      durationMinutes: json['durationMinutes'] as int,
      bookingDate: DateTime.parse(json['bookingDate'] as String),
      timeSlot: json['timeSlot'] as String,
      status: BookingStatus.fromString(json['status'] as String? ?? 'pending'),
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
