import '../../../core/network/api_client.dart';

class StudyService {
  StudyService(this._apiClient);

  final ApiClient _apiClient;

  Future<List<Map<String, dynamic>>> fetchSubjects() async {
    return _apiClient.getList('/toga/study/subjects');
  }

  Future<Map<String, dynamic>> fetchSubject(String id) async {
    return _apiClient.getMap('/toga/study/subjects/$id');
  }

  Future<Map<String, dynamic>> updateChapterCompletion({
    required String subjectId,
    required String chapterId,
    required bool completed,
  }) async {
    return _apiClient.postMap(
      '/toga/study/subjects/$subjectId/chapters/$chapterId/completion',
      body: {'completed': completed},
    );
  }
}
