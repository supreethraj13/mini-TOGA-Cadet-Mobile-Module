part of 'notifications_cubit.dart';

enum NotificationsStatus { initial, loading, success, failure }

class NotificationsState extends Equatable {
  const NotificationsState({
    this.status = NotificationsStatus.initial,
    this.notifications = const [],
    this.unreadOnly = false,
    this.error,
  });

  final NotificationsStatus status;
  final List<NotificationItem> notifications;
  final bool unreadOnly;
  final String? error;

  List<NotificationItem> get filtered => unreadOnly
      ? notifications.where((item) => !item.isRead).toList()
      : notifications;

  NotificationsState copyWith({
    NotificationsStatus? status,
    List<NotificationItem>? notifications,
    bool? unreadOnly,
    String? error,
  }) {
    return NotificationsState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      unreadOnly: unreadOnly ?? this.unreadOnly,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, notifications, unreadOnly, error];
}
