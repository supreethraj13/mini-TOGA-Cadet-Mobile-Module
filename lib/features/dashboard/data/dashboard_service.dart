import '../../../core/data/mock_data.dart';

class DashboardService {
  Future<Map<String, dynamic>> fetchDashboard() async {
    await Future<void>.delayed(const Duration(milliseconds: 650));
    return mockDashboardJson;
  }
}
