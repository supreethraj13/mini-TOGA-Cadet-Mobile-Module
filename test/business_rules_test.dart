import 'package:flutter_test/flutter_test.dart';
import 'package:mini_toga_cadet/features/notifications/models/notification_item.dart';
import 'package:mini_toga_cadet/features/notes/models/study_note.dart';
import 'package:mini_toga_cadet/features/study/models/study_subject.dart';

void main() {
  group('StudySubject business rules', () {
    test('study progress status calculation works correctly', () {
      expect(SubjectStatus.fromProgress(0), SubjectStatus.notStarted);
      expect(SubjectStatus.fromProgress(64), SubjectStatus.inProgress);
      expect(SubjectStatus.fromProgress(100), SubjectStatus.completed);
    });

    test('invalid progress greater than 100 is handled', () {
      expect(() => SubjectStatus.fromProgress(101), throwsException);
    });

    test('fromJson and toJson work for StudySubject', () {
      final json = {
        'id': 'met',
        'subject': 'Meteorology',
        'progress': 72,
        'lessons_completed': 18,
        'total_lessons': 25,
        'quiz_score': 81,
        'status': 'In Progress',
        'chapters': [
          {'id': 'met-1', 'chapter': 'Atmosphere', 'completed': true},
        ],
      };

      final subject = StudySubject.fromJson(json);

      expect(subject.subject, 'Meteorology');
      expect(subject.toJson()['status'], 'In Progress');
      expect(subject.toJson()['chapters'], isA<List<dynamic>>());
    });
  });

  group('StudyNote', () {
    test('sync status changes correctly', () {
      final note = StudyNote(
        id: 'note-1',
        subjectId: 'met',
        subject: 'Meteorology',
        body: 'Cloud base observation',
        createdAt: DateTime.utc(2026, 5, 10),
        syncStatus: SyncStatus.pending,
      );

      expect(note.copyWith(syncStatus: SyncStatus.syncing).syncStatus, SyncStatus.syncing);
      expect(note.copyWith(syncStatus: SyncStatus.synced).syncStatus, SyncStatus.synced);
      expect(note.copyWith(syncStatus: SyncStatus.failed).syncStatus, SyncStatus.failed);
    });

    test('fromJson and toJson work for StudyNote', () {
      final note = StudyNote.fromJson({
        'id': 'note-1',
        'subject_id': 'nav',
        'subject': 'Navigation',
        'body': 'Revise wind correction angle.',
        'created_at': '2026-05-10T00:00:00.000Z',
        'sync_status': 'Pending Sync',
        'failure_message': null,
      });

      expect(note.subject, 'Navigation');
      expect(note.toJson()['sync_status'], 'Pending Sync');
    });
  });

  test('notification read/unread logic works', () {
    final notification = NotificationItem(
      id: 'n1',
      title: 'Study reminder',
      message: 'Complete Thunderstorms.',
      type: 'study',
      time: DateTime.utc(2026, 5, 16),
      isRead: false,
    );

    expect(notification.isRead, isFalse);
    expect(notification.copyWith(isRead: true).isRead, isTrue);
  });
}
