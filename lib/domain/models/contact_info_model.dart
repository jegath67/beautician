/// Dynamic Contact Information & Business Hours.
class ContactInfoModel {
  final String phone;
  final String email;
  final String whatsapp;
  final String address;
  final String cityStateZip;
  final String googleMapsEmbedUrl;
  final String googleMapsDirectionsUrl;
  final String weekDayHours; // e.g. "09:00 AM - 08:00 PM"
  final String weekendHours; // e.g. "10:00 AM - 06:00 PM"
  final String closedDays; // e.g. "Closed on National Holidays"

  const ContactInfoModel({
    required this.phone,
    required this.email,
    required this.whatsapp,
    required this.address,
    required this.cityStateZip,
    required this.googleMapsEmbedUrl,
    required this.googleMapsDirectionsUrl,
    required this.weekDayHours,
    required this.weekendHours,
    required this.closedDays,
  });

  ContactInfoModel copyWith({
    String? phone,
    String? email,
    String? whatsapp,
    String? address,
    String? cityStateZip,
    String? googleMapsEmbedUrl,
    String? googleMapsDirectionsUrl,
    String? weekDayHours,
    String? weekendHours,
    String? closedDays,
  }) {
    return ContactInfoModel(
      phone: phone ?? this.phone,
      email: email ?? this.email,
      whatsapp: whatsapp ?? this.whatsapp,
      address: address ?? this.address,
      cityStateZip: cityStateZip ?? this.cityStateZip,
      googleMapsEmbedUrl: googleMapsEmbedUrl ?? this.googleMapsEmbedUrl,
      googleMapsDirectionsUrl: googleMapsDirectionsUrl ?? this.googleMapsDirectionsUrl,
      weekDayHours: weekDayHours ?? this.weekDayHours,
      weekendHours: weekendHours ?? this.weekendHours,
      closedDays: closedDays ?? this.closedDays,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'email': email,
      'whatsapp': whatsapp,
      'address': address,
      'cityStateZip': cityStateZip,
      'googleMapsEmbedUrl': googleMapsEmbedUrl,
      'googleMapsDirectionsUrl': googleMapsDirectionsUrl,
      'weekDayHours': weekDayHours,
      'weekendHours': weekendHours,
      'closedDays': closedDays,
    };
  }

  factory ContactInfoModel.fromJson(Map<String, dynamic> json) {
    return ContactInfoModel(
      phone: json['phone'] as String,
      email: json['email'] as String,
      whatsapp: json['whatsapp'] as String,
      address: json['address'] as String,
      cityStateZip: json['cityStateZip'] as String,
      googleMapsEmbedUrl: json['googleMapsEmbedUrl'] as String,
      googleMapsDirectionsUrl: json['googleMapsDirectionsUrl'] as String,
      weekDayHours: json['weekDayHours'] as String,
      weekendHours: json['weekendHours'] as String,
      closedDays: json['closedDays'] as String,
    );
  }
}
