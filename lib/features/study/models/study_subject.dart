import '../../../core/errors/app_error.dart';
import 'chapter.dart';

enum SubjectStatus {
  notStarted('Not Started'),
  inProgress('In Progress'),
  completed('Completed');

  const SubjectStatus(this.label);
  final String label;

  static SubjectStatus fromProgress(int progress) {
    if (progress < 0 || progress > 100) {
      throw AppError('Study progress must be between 0 and 100.', code: 'invalid_progress');
    }
    if (progress == 0) return SubjectStatus.notStarted;
    if (progress == 100) return SubjectStatus.completed;
    return SubjectStatus.inProgress;
  }

  static SubjectStatus fromLabel(String label) => SubjectStatus.values.firstWhere(
        (value) => value.label == label,
        orElse: () => SubjectStatus.fromProgress(0),
      );
}

class StudySubject {
  StudySubject({
    required this.id,
    required this.subject,
    required this.progress,
    required this.lessonsCompleted,
    required this.totalLessons,
    required this.quizScore,
    required this.status,
    required this.chapters,
  }) {
    if (progress < 0 || progress > 100) {
      throw AppError('Study progress must be between 0 and 100.', code: 'invalid_progress');
    }
    if (quizScore < 0 || quizScore > 100) {
      throw AppError('Quiz score must be between 0 and 100.', code: 'invalid_quiz_score');
    }
    final expected = SubjectStatus.fromProgress(progress);
    if (status != expected) {
      throw AppError('Subject status must match progress boundary rules.', code: 'invalid_status');
    }
  }

  final String id;
  final String subject;
  final int progress;
  final int lessonsCompleted;
  final int totalLessons;
  final int quizScore;
  final SubjectStatus status;
  final List<Chapter> chapters;

  StudySubject copyWith({
    int? progress,
    int? lessonsCompleted,
    int? totalLessons,
    SubjectStatus? status,
    List<Chapter>? chapters,
  }) {
    final nextProgress = progress ?? this.progress;
    return StudySubject(
      id: id,
      subject: subject,
      progress: nextProgress,
      lessonsCompleted: lessonsCompleted ?? this.lessonsCompleted,
      totalLessons: totalLessons ?? this.totalLessons,
      quizScore: quizScore,
      status: status ?? SubjectStatus.fromProgress(nextProgress),
      chapters: chapters ?? this.chapters,
    );
  }

  StudySubject recalculateFromChapters(List<Chapter> nextChapters) {
    if (nextChapters.isEmpty) return copyWith(chapters: nextChapters);
    final completedCount = nextChapters.where((chapter) => chapter.completed).length;
    final nextProgress = ((completedCount / nextChapters.length) * 100).round();
    return copyWith(
      progress: nextProgress,
      lessonsCompleted: completedCount,
      totalLessons: nextChapters.length,
      status: SubjectStatus.fromProgress(nextProgress),
      chapters: nextChapters,
    );
  }

  factory StudySubject.fromJson(Map<String, dynamic> json) {
    final progress = json['progress'] as int;
    return StudySubject(
      id: json['id'] as String,
      subject: json['subject'] as String,
      progress: progress,
      lessonsCompleted: json['lessons_completed'] as int,
      totalLessons: json['total_lessons'] as int,
      quizScore: json['quiz_score'] as int,
      status: SubjectStatus.fromLabel(json['status'] as String),
      chapters: (json['chapters'] as List? ?? const [])
          .map((item) => Chapter.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'subject': subject,
        'progress': progress,
        'lessons_completed': lessonsCompleted,
        'total_lessons': totalLessons,
        'quiz_score': quizScore,
        'status': status.label,
        'chapters': chapters.map((chapter) => chapter.toJson()).toList(),
      };
}
