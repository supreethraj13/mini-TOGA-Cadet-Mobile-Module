import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/notes_repository.dart';
import '../models/study_note.dart';

part 'notes_state.dart';

class NotesCubit extends Cubit<NotesState> {
  NotesCubit(this._repository) : super(const NotesState());

  final NotesRepository _repository;

  Future<void> loadNotes() async {
    emit(state.copyWith(status: NotesStatus.loading));
    try {
      final notes = await _repository.loadNotes();
      emit(state.copyWith(status: NotesStatus.success, notes: notes));
    } catch (error) {
      emit(
        state.copyWith(status: NotesStatus.failure, error: error.toString()),
      );
    }
  }

  Future<void> saveNote({
    required String subjectId,
    required String subject,
    required String body,
  }) async {
    emit(state.copyWith(actionStatus: NotesStatus.loading));
    try {
      final note = await _repository.saveNote(
        subjectId: subjectId,
        subject: subject,
        body: body,
      );
      emit(
        state.copyWith(
          status: NotesStatus.success,
          actionStatus: NotesStatus.success,
          notes: [note, ...state.notes],
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          actionStatus: NotesStatus.failure,
          error: error.toString(),
        ),
      );
    }
  }

  Future<void> syncNote(StudyNote note) async {
    final syncing = note.copyWith(syncStatus: SyncStatus.syncing);
    emit(
      state.copyWith(
        notes: _replace(syncing),
        actionStatus: NotesStatus.loading,
      ),
    );
    try {
      final synced = await _repository.sync(note);
      emit(
        state.copyWith(
          notes: _replace(synced),
          actionStatus: NotesStatus.success,
        ),
      );
    } catch (error) {
      final failed = note.copyWith(
        syncStatus: SyncStatus.failed,
        failureMessage: error.toString(),
      );
      emit(
        state.copyWith(
          notes: _replace(failed),
          actionStatus: NotesStatus.failure,
          error: error.toString(),
        ),
      );
    }
  }

  List<StudyNote> _replace(StudyNote note) =>
      state.notes.map((item) => item.id == note.id ? note : item).toList();
}
