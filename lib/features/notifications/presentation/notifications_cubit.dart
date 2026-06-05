import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/notification_repository.dart';
import '../models/notification_item.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit(this._repository) : super(const NotificationsState());

  final NotificationRepository _repository;

  Future<void> loadNotifications() async {
    emit(state.copyWith(status: NotificationsStatus.loading));
    try {
      final notifications = await _repository.fetchNotifications();
      emit(
        state.copyWith(
          status: NotificationsStatus.success,
          notifications: notifications,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: NotificationsStatus.failure,
          error: error.toString(),
        ),
      );
    }
  }

  Future<void> markRead(NotificationItem item) async {
    final updated = await _repository.markRead(item);
    emit(
      state.copyWith(
        notifications: state.notifications
            .map((entry) => entry.id == updated.id ? updated : entry)
            .toList(),
      ),
    );
  }

  void setUnreadOnly(bool unreadOnly) =>
      emit(state.copyWith(unreadOnly: unreadOnly));
}
