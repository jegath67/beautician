/// Represents a beautician/stylist specialist on staff.
class BeauticianModel {
  final String id;
  final String name;
  final String role; // e.g. "Master Stylist", "Senior Aesthetician", "Bridal Specialist"
  final String bio;
  final List<String> specialties; // e.g. ["Bridal Hair", "Balayage", "HydraFacial"]
  final String avatarUrl;
  final List<int> workingDays; // 1 = Mon, 7 = Sun
  final String workingHoursStart; // "09:00"
  final String workingHoursEnd; // "19:00"
  final String breakStart; // "13:00"
  final String breakEnd; // "14:00"
  final double rating;
  final int reviewCount;
  final bool isActive;

  const BeauticianModel({
    required this.id,
    required this.name,
    required this.role,
    required this.bio,
    required this.specialties,
    required this.avatarUrl,
    this.workingDays = const [1, 2, 3, 4, 5, 6], // Mon - Sat default
    this.workingHoursStart = '09:00',
    this.workingHoursEnd = '19:00',
    this.breakStart = '13:00',
    this.breakEnd = '14:00',
    this.rating = 4.9,
    this.reviewCount = 120,
    this.isActive = true,
  });

  String get title => role;
  String get imageUrl => avatarUrl;

  BeauticianModel copyWith({
    String? id,
    String? name,
    String? role,
    String? bio,
    List<String>? specialties,
    String? avatarUrl,
    List<int>? workingDays,
    String? workingHoursStart,
    String? workingHoursEnd,
    String? breakStart,
    String? breakEnd,
    double? rating,
    int? reviewCount,
    bool? isActive,
  }) {
    return BeauticianModel(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      bio: bio ?? this.bio,
      specialties: specialties ?? this.specialties,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      workingDays: workingDays ?? this.workingDays,
      workingHoursStart: workingHoursStart ?? this.workingHoursStart,
      workingHoursEnd: workingHoursEnd ?? this.workingHoursEnd,
      breakStart: breakStart ?? this.breakStart,
      breakEnd: breakEnd ?? this.breakEnd,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'bio': bio,
      'specialties': specialties,
      'avatarUrl': avatarUrl,
      'workingDays': workingDays,
      'workingHoursStart': workingHoursStart,
      'workingHoursEnd': workingHoursEnd,
      'breakStart': breakStart,
      'breakEnd': breakEnd,
      'rating': rating,
      'reviewCount': reviewCount,
      'isActive': isActive,
    };
  }

  factory BeauticianModel.fromJson(Map<String, dynamic> json) {
    return BeauticianModel(
      id: json['id'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
      bio: json['bio'] as String,
      specialties: (json['specialties'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      avatarUrl: json['avatarUrl'] as String,
      workingDays: (json['workingDays'] as List<dynamic>?)?.map((e) => e as int).toList() ?? [1, 2, 3, 4, 5, 6],
      workingHoursStart: json['workingHoursStart'] as String? ?? '09:00',
      workingHoursEnd: json['workingHoursEnd'] as String? ?? '19:00',
      breakStart: json['breakStart'] as String? ?? '13:00',
      breakEnd: json['breakEnd'] as String? ?? '14:00',
      rating: (json['rating'] as num?)?.toDouble() ?? 4.9,
      reviewCount: json['reviewCount'] as int? ?? 0,
      isActive: json['isActive'] as bool? ?? true,
    );
  }
}
