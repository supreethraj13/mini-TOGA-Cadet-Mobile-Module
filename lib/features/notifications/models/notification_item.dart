class NotificationItem {
  const NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.time,
    required this.isRead,
  });

  final String id;
  final String title;
  final String message;
  final String type;
  final DateTime time;
  final bool isRead;

  NotificationItem copyWith({bool? isRead}) => NotificationItem(
    id: id,
    title: title,
    message: message,
    type: type,
    time: time,
    isRead: isRead ?? this.isRead,
  );

  factory NotificationItem.fromJson(Map<String, dynamic> json) =>
      NotificationItem(
        id: json['id'] as String,
        title: json['title'] as String,
        message: json['message'] as String,
        type: json['type'] as String,
        time: DateTime.parse(json['time'] as String),
        isRead: json['is_read'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'message': message,
    'type': type,
    'time': time.toIso8601String(),
    'is_read': isRead,
  };
}
