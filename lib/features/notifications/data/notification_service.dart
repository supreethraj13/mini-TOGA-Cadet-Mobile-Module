import '../../../core/data/mock_data.dart';

class NotificationService {
  Future<List<Map<String, dynamic>>> fetchNotifications() async {
    await Future<void>.delayed(const Duration(milliseconds: 550));
    return mockNotificationsJson.map((item) => Map<String, dynamic>.from(item)).toList();
  }

  Future<Map<String, dynamic>> markRead(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return {'success': true, 'id': id};
  }
}
