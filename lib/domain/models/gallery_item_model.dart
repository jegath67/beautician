import 'content_status.dart';

/// Represents a gallery transformation / styling photo.
class GalleryItemModel {
  final String id;
  final String title;
  final String category; // e.g. "Bridal", "Hair", "Skin", "Nails", "Makeup"
  final String imageUrl;
  final String? description;
  final List<String> tags;
  final ContentStatus status;
  final DateTime createdAt;

  const GalleryItemModel({
    required this.id,
    required this.title,
    required this.category,
    required this.imageUrl,
    this.description,
    this.tags = const [],
    this.status = ContentStatus.published,
    required this.createdAt,
  });

  GalleryItemModel copyWith({
    String? id,
    String? title,
    String? category,
    String? imageUrl,
    String? description,
    List<String>? tags,
    ContentStatus? status,
    DateTime? createdAt,
  }) {
    return GalleryItemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'imageUrl': imageUrl,
      'description': description,
      'tags': tags,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory GalleryItemModel.fromJson(Map<String, dynamic> json) {
    return GalleryItemModel(
      id: json['id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      imageUrl: json['imageUrl'] as String,
      description: json['description'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      status: ContentStatus.fromString(json['status'] as String? ?? 'published'),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
