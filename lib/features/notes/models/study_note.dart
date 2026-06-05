import '../../../core/errors/app_error.dart';

enum SyncStatus {
  pending('Pending Sync'),
  syncing('Syncing'),
  synced('Synced'),
  failed('Failed');

  const SyncStatus(this.label);
  final String label;

  static SyncStatus fromLabel(String label) => SyncStatus.values.firstWhere(
    (value) => value.label == label,
    orElse: () => SyncStatus.pending,
  );
}

class StudyNote {
  StudyNote({
    required this.id,
    required this.subjectId,
    required this.subject,
    required this.body,
    required this.createdAt,
    required this.syncStatus,
    this.failureMessage,
  }) {
    if (body.trim().isEmpty) {
      throw AppError('Study note cannot be empty.', code: 'empty_note');
    }
  }

  final String id;
  final String subjectId;
  final String subject;
  final String body;
  final DateTime createdAt;
  final SyncStatus syncStatus;
  final String? failureMessage;

  StudyNote copyWith({SyncStatus? syncStatus, String? failureMessage}) =>
      StudyNote(
        id: id,
        subjectId: subjectId,
        subject: subject,
        body: body,
        createdAt: createdAt,
        syncStatus: syncStatus ?? this.syncStatus,
        failureMessage: failureMessage,
      );

  factory StudyNote.fromJson(Map<String, dynamic> json) => StudyNote(
    id: json['id'] as String,
    subjectId: json['subject_id'] as String,
    subject: json['subject'] as String,
    body: json['body'] as String,
    createdAt: DateTime.parse(json['created_at'] as String),
    syncStatus: SyncStatus.fromLabel(json['sync_status'] as String),
    failureMessage: json['failure_message'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'subject_id': subjectId,
    'subject': subject,
    'body': body,
    'created_at': createdAt.toIso8601String(),
    'sync_status': syncStatus.label,
    'failure_message': failureMessage,
  };
}
