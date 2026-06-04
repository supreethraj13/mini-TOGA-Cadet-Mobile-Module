part of 'notes_cubit.dart';

enum NotesStatus { initial, loading, success, failure }

class NotesState extends Equatable {
  const NotesState({
    this.status = NotesStatus.initial,
    this.actionStatus = NotesStatus.initial,
    this.notes = const [],
    this.error,
  });

  final NotesStatus status;
  final NotesStatus actionStatus;
  final List<StudyNote> notes;
  final String? error;

  NotesState copyWith({
    NotesStatus? status,
    NotesStatus? actionStatus,
    List<StudyNote>? notes,
    String? error,
  }) {
    return NotesState(
      status: status ?? this.status,
      actionStatus: actionStatus ?? this.actionStatus,
      notes: notes ?? this.notes,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, actionStatus, notes, error];
}
