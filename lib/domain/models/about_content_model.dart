import 'content_status.dart';

/// Dynamic About Us content model.
class AboutContentModel {
  final String id;
  final String title;
  final String subtitle;
  final String story;
  final String mission;
  final List<String> values;
  final String founderName;
  final String founderRole;
  final String founderBio;
  final String founderImageUrl;
  final List<String> credentials;
  final ContentStatus status;

  const AboutContentModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.story,
    required this.mission,
    required this.values,
    required this.founderName,
    required this.founderRole,
    required this.founderBio,
    required this.founderImageUrl,
    required this.credentials,
    this.status = ContentStatus.published,
  });

  AboutContentModel copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? story,
    String? mission,
    List<String>? values,
    String? founderName,
    String? founderRole,
    String? founderBio,
    String? founderImageUrl,
    List<String>? credentials,
    ContentStatus? status,
  }) {
    return AboutContentModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      story: story ?? this.story,
      mission: mission ?? this.mission,
      values: values ?? this.values,
      founderName: founderName ?? this.founderName,
      founderRole: founderRole ?? this.founderRole,
      founderBio: founderBio ?? this.founderBio,
      founderImageUrl: founderImageUrl ?? this.founderImageUrl,
      credentials: credentials ?? this.credentials,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'story': story,
      'mission': mission,
      'values': values,
      'founderName': founderName,
      'founderRole': founderRole,
      'founderBio': founderBio,
      'founderImageUrl': founderImageUrl,
      'credentials': credentials,
      'status': status.name,
    };
  }

  factory AboutContentModel.fromJson(Map<String, dynamic> json) {
    return AboutContentModel(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      story: json['story'] as String,
      mission: json['mission'] as String,
      values: (json['values'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      founderName: json['founderName'] as String,
      founderRole: json['founderRole'] as String,
      founderBio: json['founderBio'] as String,
      founderImageUrl: json['founderImageUrl'] as String,
      credentials: (json['credentials'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      status: ContentStatus.fromString(json['status'] as String? ?? 'published'),
    );
  }
}
