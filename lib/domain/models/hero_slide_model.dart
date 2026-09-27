import 'content_status.dart';

/// Represents dynamic Hero Carousel Slides on the public landing page.
class HeroSlideModel {
  final String id;
  final String title;
  final String subtitle;
  final String primaryCtaText;
  final String primaryCtaUrl;
  final String secondaryCtaText;
  final String secondaryCtaUrl;
  final String imageUrl;
  final int displayOrder;
  final ContentStatus status;
  final bool isActive;

  const HeroSlideModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.primaryCtaText,
    required this.primaryCtaUrl,
    required this.secondaryCtaText,
    required this.secondaryCtaUrl,
    required this.imageUrl,
    required this.displayOrder,
    this.status = ContentStatus.published,
    this.isActive = true,
  });

  String get ctaText => primaryCtaText;
  String get ctaLink => primaryCtaUrl;

  HeroSlideModel copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? primaryCtaText,
    String? primaryCtaUrl,
    String? secondaryCtaText,
    String? secondaryCtaUrl,
    String? imageUrl,
    int? displayOrder,
    ContentStatus? status,
    bool? isActive,
  }) {
    return HeroSlideModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      primaryCtaText: primaryCtaText ?? this.primaryCtaText,
      primaryCtaUrl: primaryCtaUrl ?? this.primaryCtaUrl,
      secondaryCtaText: secondaryCtaText ?? this.secondaryCtaText,
      secondaryCtaUrl: secondaryCtaUrl ?? this.secondaryCtaUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      displayOrder: displayOrder ?? this.displayOrder,
      status: status ?? this.status,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'primaryCtaText': primaryCtaText,
      'primaryCtaUrl': primaryCtaUrl,
      'secondaryCtaText': secondaryCtaText,
      'secondaryCtaUrl': secondaryCtaUrl,
      'imageUrl': imageUrl,
      'displayOrder': displayOrder,
      'status': status.name,
      'isActive': isActive,
    };
  }

  factory HeroSlideModel.fromJson(Map<String, dynamic> json) {
    return HeroSlideModel(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      primaryCtaText: json['primaryCtaText'] as String,
      primaryCtaUrl: json['primaryCtaUrl'] as String,
      secondaryCtaText: json['secondaryCtaText'] as String,
      secondaryCtaUrl: json['secondaryCtaUrl'] as String,
      imageUrl: json['imageUrl'] as String,
      displayOrder: json['displayOrder'] as int? ?? 0,
      status: ContentStatus.fromString(json['status'] as String? ?? 'published'),
      isActive: json['isActive'] as bool? ?? true,
    );
  }
}
