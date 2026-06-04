import '../../../core/network/api_client.dart';

class DashboardService {
  DashboardService(this._apiClient);

  final ApiClient _apiClient;

  Future<Map<String, dynamic>> fetchDashboard() async {
    return _apiClient.getMap('/toga/cadet/dashboard');
  }
}
