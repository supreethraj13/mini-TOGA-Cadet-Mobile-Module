part of 'study_cubit.dart';

enum StudyStatus { initial, loading, success, failure }

class StudyState extends Equatable {
  const StudyState({
    this.status = StudyStatus.initial,
    this.detailStatus = StudyStatus.initial,
    this.subjects = const [],
    this.selectedSubject,
    this.query = '',
    this.filter,
    this.error,
  });

  final StudyStatus status;
  final StudyStatus detailStatus;
  final List<StudySubject> subjects;
  final StudySubject? selectedSubject;
  final String query;
  final SubjectStatus? filter;
  final String? error;

  List<StudySubject> get filteredSubjects => subjects.where((subject) {
    final matchesQuery = subject.subject.toLowerCase().contains(
      query.toLowerCase(),
    );
    final matchesFilter = filter == null || subject.status == filter;
    return matchesQuery && matchesFilter;
  }).toList();

  StudyState copyWith({
    StudyStatus? status,
    StudyStatus? detailStatus,
    List<StudySubject>? subjects,
    StudySubject? selectedSubject,
    String? query,
    SubjectStatus? filter,
    bool clearFilter = false,
    String? error,
  }) {
    return StudyState(
      status: status ?? this.status,
      detailStatus: detailStatus ?? this.detailStatus,
      subjects: subjects ?? this.subjects,
      selectedSubject: selectedSubject ?? this.selectedSubject,
      query: query ?? this.query,
      filter: clearFilter ? null : filter ?? this.filter,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    status,
    detailStatus,
    subjects,
    selectedSubject,
    query,
    filter,
    error,
  ];
}
