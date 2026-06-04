import '../../../core/network/api_client.dart';

class NotificationService {
  NotificationService(this._apiClient);

  final ApiClient _apiClient;

  Future<List<Map<String, dynamic>>> fetchNotifications() async {
    return _apiClient.getList('/toga/notifications');
  }

  Future<Map<String, dynamic>> markRead(String id) async {
    return _apiClient.patchMap('/toga/notifications/$id/read');
  }
}
