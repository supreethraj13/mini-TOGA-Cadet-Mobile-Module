import 'package:uuid/uuid.dart';

import '../../../core/errors/app_error.dart';
import '../../../core/storage/local_storage.dart';
import '../models/study_note.dart';
import 'notes_service.dart';

class NotesRepository {
  NotesRepository(this._service);

  final NotesService _service;
  final _uuid = const Uuid();

  Future<List<StudyNote>> loadNotes() async {
    final box = LocalStorage.box(LocalStorage.notesBox);
    return box.values
        .map(
          (value) =>
              StudyNote.fromJson(Map<String, dynamic>.from(value as Map)),
        )
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<StudyNote> saveNote({
    required String subjectId,
    required String subject,
    required String body,
  }) async {
    final note = StudyNote(
      id: _uuid.v4(),
      subjectId: subjectId,
      subject: subject,
      body: body,
      createdAt: DateTime.now(),
      syncStatus: SyncStatus.pending,
    );
    await LocalStorage.box(LocalStorage.notesBox).put(note.id, note.toJson());
    return note;
  }

  Future<StudyNote> sync(StudyNote note) async {
    final box = LocalStorage.box(LocalStorage.notesBox);
    if (!box.containsKey(note.id)) {
      throw AppError(
        'Offline note must be saved before sync.',
        code: 'note_not_saved',
      );
    }
    var next = note.copyWith(syncStatus: SyncStatus.syncing);
    await box.put(note.id, next.toJson());
    final ok = await _service.syncNote(note.toJson());
    next = ok
        ? note.copyWith(syncStatus: SyncStatus.synced)
        : note.copyWith(
            syncStatus: SyncStatus.failed,
            failureMessage:
                'Skynet queue rejected this attempt. Retry is safe.',
          );
    await box.put(note.id, next.toJson());
    return next;
  }
}
