import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/features/knowledge_base/domain/entities/article_notification.dart';
import 'package:issues_tracking/features/knowledge_base/presentation/cubits/article_notification_cubit.dart';
import 'package:intl/intl.dart';

class ArticleNotificationBadge extends StatelessWidget {
  final Function(String articleId, String? commentId) onNotificationTap;

  const ArticleNotificationBadge({
    super.key,
    required this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArticleNotificationCubit, ArticleNotificationState>(
      builder: (context, state) {
        final unreadCount = state is ArticleNotificationLoaded
            ? state.notifications.where((n) => !n.isRead).length
            : 0;

        return IconButton(
          icon: Badge(
            isLabelVisible: unreadCount > 0,
            label: Text(
              unreadCount > 99 ? '99+' : '$unreadCount',
              style: const TextStyle(fontSize: 10),
            ),
            child: const Icon(Icons.notifications_outlined),
          ),
          tooltip: 'Notifications',
          onPressed: () => _showNotificationPopup(context, state),
        );
      },
    );
  }

  void _showNotificationPopup(
    BuildContext context,
    ArticleNotificationState state,
  ) {
    final notifications = state is ArticleNotificationLoaded
        ? state.notifications
        : <ArticleNotification>[];

    final RenderBox button =
        context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;

    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromCenter(
        center: button.localToGlobal(
          Offset.zero,
          ancestor: overlay,
        ) +
            Offset(button.size.width / 2, button.size.height),
        width: 320,
        height: 0,
      ),
      Rect.fromLTWH(0, 0, overlay.size.width, overlay.size.height),
    );

    showMenu(
      context: context,
      position: position,
      constraints: const BoxConstraints(maxWidth: 360, maxHeight: 400),
      items: [
        PopupMenuItem(
          enabled: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Notifications',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              if (notifications.isNotEmpty)
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Mark all read'),
                ),
            ],
          ),
        ),
        if (notifications.isEmpty)
          const PopupMenuItem(
            enabled: false,
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'No notifications',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
        ...notifications.map(
          (notification) => PopupMenuItem(
            onTap: () {
              onNotificationTap(
                notification.articleId,
                notification.commentId,
              );
            },
            child: _NotificationTile(notification: notification),
          ),
        ),
      ],
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final ArticleNotification notification;

  const _NotificationTile({required this.notification});

  String _timeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return DateFormat.MMMd().format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 6, right: 10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: notification.isRead
                  ? Colors.transparent
                  : Theme.of(context).colorScheme.primary,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodySmall,
                    children: [
                      TextSpan(
                        text: notification.senderId,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(text: ' '),
                      TextSpan(
                        text: _notificationText(notification.notificationType),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _timeAgo(notification.createdAt),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _notificationText(String type) {
    switch (type) {
      case 'mention':
        return 'mentioned you in a comment';
      case 'comment':
        return 'commented on an article';
      case 'edit':
        return 'edited an article';
      default:
        return 'interacted with an article';
    }
  }
}
