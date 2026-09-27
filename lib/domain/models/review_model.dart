import 'content_status.dart';

/// Represents a customer testimonial or review.
class ReviewModel {
  final String id;
  final String clientName;
  final double rating; // 1.0 to 5.0
  final String comment;
  final String serviceName;
  final String? avatarUrl;
  final DateTime date;
  final ContentStatus status;
  final bool isFeatured;

  const ReviewModel({
    required this.id,
    required this.clientName,
    required this.rating,
    required this.comment,
    required this.serviceName,
    this.avatarUrl,
    required this.date,
    this.status = ContentStatus.published,
    this.isFeatured = true,
  });

  DateTime get createdAt => date;

  ReviewModel copyWith({
    String? id,
    String? clientName,
    double? rating,
    String? comment,
    String? serviceName,
    String? avatarUrl,
    DateTime? date,
    ContentStatus? status,
    bool? isFeatured,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      clientName: clientName ?? this.clientName,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      serviceName: serviceName ?? this.serviceName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      date: date ?? this.date,
      status: status ?? this.status,
      isFeatured: isFeatured ?? this.isFeatured,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientName': clientName,
      'rating': rating,
      'comment': comment,
      'serviceName': serviceName,
      'avatarUrl': avatarUrl,
      'date': date.toIso8601String(),
      'status': status.name,
      'isFeatured': isFeatured,
    };
  }

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as String,
      clientName: json['clientName'] as String,
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] as String,
      serviceName: json['serviceName'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      date: DateTime.parse(json['date'] as String),
      status: ContentStatus.fromString(json['status'] as String? ?? 'published'),
      isFeatured: json['isFeatured'] as bool? ?? false,
    );
  }
}
