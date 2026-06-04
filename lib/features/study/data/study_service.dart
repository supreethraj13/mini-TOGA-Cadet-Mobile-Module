import '../../../core/data/mock_data.dart';

class StudyService {
  Future<List<Map<String, dynamic>>> fetchSubjects() async {
    await Future<void>.delayed(const Duration(milliseconds: 650));
    return mockSubjectsJson.map((item) => Map<String, dynamic>.from(item)).toList();
  }

  Future<Map<String, dynamic>> fetchSubject(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return mockSubjectsJson
        .map((item) => Map<String, dynamic>.from(item))
        .firstWhere((item) => item['id'] == id);
  }
}
