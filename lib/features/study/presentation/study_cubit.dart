import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/study_repository.dart';
import '../models/chapter.dart';
import '../models/study_subject.dart';

part 'study_state.dart';

class StudyCubit extends Cubit<StudyState> {
  StudyCubit(this._repository) : super(const StudyState());

  final StudyRepository _repository;

  Future<void> loadSubjects() async {
    emit(state.copyWith(status: StudyStatus.loading));
    try {
      final subjects = await _repository.fetchSubjects();
      emit(state.copyWith(status: StudyStatus.success, subjects: subjects));
    } catch (error) {
      emit(
        state.copyWith(status: StudyStatus.failure, error: error.toString()),
      );
    }
  }

  Future<void> selectSubject(String id) async {
    emit(state.copyWith(detailStatus: StudyStatus.loading));
    try {
      final subject = await _repository.fetchSubject(id);
      emit(
        state.copyWith(
          detailStatus: StudyStatus.success,
          selectedSubject: subject,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          detailStatus: StudyStatus.failure,
          error: error.toString(),
        ),
      );
    }
  }

  Future<void> toggleChapter(Chapter chapter) async {
    final selected = state.selectedSubject;
    if (selected == null) return;
    try {
      final updated = await _repository.toggleChapter(selected, chapter);
      final subjects = state.subjects
          .map((item) => item.id == updated.id ? updated : item)
          .toList();
      emit(
        state.copyWith(
          selectedSubject: updated,
          subjects: subjects,
          error: null,
        ),
      );
    } catch (error) {
      emit(state.copyWith(error: error.toString()));
    }
  }

  void setQuery(String query) => emit(state.copyWith(query: query));
  void setFilter(SubjectStatus? filter) =>
      emit(state.copyWith(filter: filter, clearFilter: filter == null));
}
