import '../models/dashboard_model.dart';
import 'dashboard_service.dart';

class DashboardRepository {
  DashboardRepository(this._service);

  final DashboardService _service;

  Future<DashboardModel> fetchDashboard() async {
    final json = await _service.fetchDashboard();
    return DashboardModel.fromJson(json);
  }
}
