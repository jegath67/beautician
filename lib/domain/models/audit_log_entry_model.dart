/// Immutable Audit Log Entry tracking administrative mutations.
class AuditLogEntryModel {
  final String id;
  final String actorName;
  final String actionType; // CREATE, UPDATE, DELETE, PUBLISH, ARCHIVE, STATUS_CHANGE
  final String entityType; // Service, HeroSlide, Beautician, Booking, Gallery, Review, Settings, About
  final String entityId;
  final String entityTitle;
  final DateTime timestamp;
  final String? previousValue;
  final String? newValue;
  final String summary;

  const AuditLogEntryModel({
    required this.id,
    required this.actorName,
    required this.actionType,
    required this.entityType,
    required this.entityId,
    required this.entityTitle,
    required this.timestamp,
    this.previousValue,
    this.newValue,
    required this.summary,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'actorName': actorName,
      'actionType': actionType,
      'entityType': entityType,
      'entityId': entityId,
      'entityTitle': entityTitle,
      'timestamp': timestamp.toIso8601String(),
      'previousValue': previousValue,
      'newValue': newValue,
      'summary': summary,
    };
  }

  factory AuditLogEntryModel.fromJson(Map<String, dynamic> json) {
    return AuditLogEntryModel(
      id: json['id'] as String,
      actorName: json['actorName'] as String,
      actionType: json['actionType'] as String,
      entityType: json['entityType'] as String,
      entityId: json['entityId'] as String,
      entityTitle: json['entityTitle'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      previousValue: json['previousValue'] as String?,
      newValue: json['newValue'] as String?,
      summary: json['summary'] as String,
    );
  }
}
