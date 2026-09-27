import 'content_status.dart';

/// Represents a salon service catalog item.
class ServiceModel {
  final String id;
  final String title;
  final String category; // e.g. "Hair", "Skin", "Bridal", "Makeup", "Nails", "Spa"
  final double price;
  final int durationMinutes;
  final String description;
  final String imageUrl;
  final ContentStatus status;
  final bool isFeatured;

  const ServiceModel({
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    required this.durationMinutes,
    required this.description,
    required this.imageUrl,
    this.status = ContentStatus.published,
    this.isFeatured = false,
  });

  String get name => title;
  String get formattedPrice => '₹${price.toStringAsFixed(0)}';
  String get formattedDuration => '$durationMinutes mins';

  ServiceModel copyWith({
    String? id,
    String? title,
    String? category,
    double? price,
    int? durationMinutes,
    String? description,
    String? imageUrl,
    ContentStatus? status,
    bool? isFeatured,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      price: price ?? this.price,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      status: status ?? this.status,
      isFeatured: isFeatured ?? this.isFeatured,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'price': price,
      'durationMinutes': durationMinutes,
      'description': description,
      'imageUrl': imageUrl,
      'status': status.name,
      'isFeatured': isFeatured,
    };
  }

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      durationMinutes: json['durationMinutes'] as int,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      status: ContentStatus.fromString(json['status'] as String? ?? 'published'),
      isFeatured: json['isFeatured'] as bool? ?? false,
    );
  }
}
