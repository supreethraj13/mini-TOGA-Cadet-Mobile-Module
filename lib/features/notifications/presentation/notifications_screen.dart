import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/error_state.dart';
import '../../../shared/widgets/loading_state.dart';
import '../../../shared/widgets/status_badge.dart';
import 'notifications_cubit.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, state) {
        if (state.status == NotificationsStatus.loading || state.status == NotificationsStatus.initial) {
          return const ShimmerSkeleton(lines: 5);
        }
        if (state.status == NotificationsStatus.failure) {
          return ErrorState(
            message: state.error ?? 'Notifications failed.',
            onRetry: () => context.read<NotificationsCubit>().loadNotifications(),
          );
        }
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(value: false, label: Text('All'), icon: Icon(Icons.inbox_rounded)),
                  ButtonSegment(value: true, label: Text('Unread'), icon: Icon(Icons.mark_email_unread_rounded)),
                ],
                selected: {state.unreadOnly},
                onSelectionChanged: (value) => context.read<NotificationsCubit>().setUnreadOnly(value.first),
              ),
            ),
            Expanded(
              child: state.filtered.isEmpty
                  ? const EmptyState(title: 'No notifications', message: 'TOGA updates and Skynet sync messages will appear here.')
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = state.filtered[index];
                        return Card(
                          child: ListTile(
                            leading: Icon(_iconFor(item.type), color: Theme.of(context).colorScheme.primary),
                            title: Text(item.title, style: TextStyle(fontWeight: item.isRead ? FontWeight.w500 : FontWeight.w900)),
                            subtitle: Text('${item.message}\n${item.time.toLocal()}'),
                            isThreeLine: true,
                            trailing: item.isRead
                                ? const StatusBadge(label: 'Read', tone: BadgeTone.neutral)
                                : TextButton(
                                    onPressed: () => context.read<NotificationsCubit>().markRead(item),
                                    child: const Text('Mark Read'),
                                  ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  IconData _iconFor(String type) => switch (type) {
        'flight' => Icons.flight_takeoff_rounded,
        'study' => Icons.menu_book_rounded,
        'fto' => Icons.hub_rounded,
        'feedback' => Icons.rate_review_rounded,
        'sync' => Icons.sync_rounded,
        _ => Icons.notifications_rounded,
      };
}
