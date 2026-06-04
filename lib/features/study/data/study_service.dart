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
}
