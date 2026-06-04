import '../../../core/network/api_client.dart';

class NotesService {
  NotesService(this._apiClient);

  final ApiClient _apiClient;

  Future<bool> syncNote(Map<String, dynamic> noteJson) async {
    await _apiClient.postMap(
      '/toga/study/notes',
      body: {
        'subject_id': noteJson['subject_id'],
        'subject': noteJson['subject'],
        'body': noteJson['body'],
      },
    );
    return true;
  }
}
