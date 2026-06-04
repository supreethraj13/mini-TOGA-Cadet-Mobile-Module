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

  Future<StudySubject> toggleChapter(StudySubject subject, Chapter chapter) async {
    final box = LocalStorage.box(LocalStorage.chapterBox);
    final nextValue = !chapter.completed;
    await box.put(chapter.id, nextValue);
    final chapters = subject.chapters
        .map((item) => item.id == chapter.id ? item.copyWith(completed: nextValue) : item)
        .toList();
    return subject.recalculateFromChapters(chapters);
  }

  StudySubject _hydrateSubject(Map<String, dynamic> item) {
    final box = LocalStorage.box(LocalStorage.chapterBox);
    final chapters = (item['chapters'] as List)
        .map((raw) {
          final map = Map<String, dynamic>.from(raw as Map);
          final override = box.get(map['id'] as String);
          if (override is bool) map['completed'] = override;
          return map;
        })
        .toList();
    return StudySubject.fromJson({...item, 'chapters': chapters});
  }
}
