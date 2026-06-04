import '../../../core/storage/local_storage.dart';
import '../models/notification_item.dart';
import 'notification_service.dart';

class NotificationRepository {
  NotificationRepository(this._service);

  final NotificationService _service;

  Future<List<NotificationItem>> fetchNotifications() async {
    final readBox = LocalStorage.box(LocalStorage.notificationBox);
    final items = await _service.fetchNotifications();
    return items.map((item) {
      final id = item['id'] as String;
      final persisted = readBox.get(id);
      if (persisted is bool) item['is_read'] = persisted;
      return NotificationItem.fromJson(item);
    }).toList();
  }

  Future<NotificationItem> markRead(NotificationItem item) async {
    await _service.markRead(item.id);
    final updated = item.copyWith(isRead: true);
    await LocalStorage.box(LocalStorage.notificationBox).put(item.id, true);
    return updated;
  }
}
