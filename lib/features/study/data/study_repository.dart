import '../../../core/storage/local_storage.dart';
import '../models/chapter.dart';
import '../models/study_subject.dart';
import 'study_service.dart';

class StudyRepository {
  StudyRepository(this._service);

  final StudyService _service;

  Future<List<StudySubject>> fetchSubjects() async {
    final items = await _service.fetchSubjects();
    return items.map(_hydrateSubject).toList();
  }

  Future<StudySubject> fetchSubject(String id) async {
    final item = await _service.fetchSubject(id);
    return _hydrateSubject(item);
  }

  Future<StudySubject> toggleChapter(
    StudySubject subject,
    Chapter chapter,
  ) async {
    final nextValue = !chapter.completed;
    final item = await _service.updateChapterCompletion(
      subjectId: subject.id,
      chapterId: chapter.id,
      completed: nextValue,
    );
    final updated = StudySubject.fromJson(item);
    final box = LocalStorage.box(LocalStorage.chapterBox);
    for (final updatedChapter in updated.chapters) {
      await box.put(updatedChapter.id, updatedChapter.completed);
    }
    return updated;
  }

  StudySubject _hydrateSubject(Map<String, dynamic> item) {
    final box = LocalStorage.box(LocalStorage.chapterBox);
    var hasOverrides = false;
    final chapters = (item['chapters'] as List).map((raw) {
      final map = Map<String, dynamic>.from(raw as Map);
      final override = box.get(map['id'] as String);
      if (override is bool) {
        map['completed'] = override;
        hasOverrides = true;
      }
      return map;
    }).toList();
    final subject = StudySubject.fromJson({...item, 'chapters': chapters});
    return hasOverrides
        ? subject.recalculateFromChapters(subject.chapters)
        : subject;
  }
}
