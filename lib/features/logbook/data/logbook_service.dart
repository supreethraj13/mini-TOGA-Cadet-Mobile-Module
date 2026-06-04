import '../../../core/network/api_client.dart';

class LogbookService {
  LogbookService(this._apiClient);

  final ApiClient _apiClient;

  Future<Map<String, dynamic>> fetchSummary() async {
    return _apiClient.getMap('/toga/logbook/summary');
  }
}
