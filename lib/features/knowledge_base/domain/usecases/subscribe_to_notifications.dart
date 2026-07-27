import 'package:issues_tracking/features/knowledge_base/domain/entities/article_notification.dart';
import 'package:issues_tracking/features/knowledge_base/domain/repositories/article_notification_repository.dart';

class SubscribeToNotifications {
  final ArticleNotificationRepository repository;
  const SubscribeToNotifications(this.repository);

  Stream<List<ArticleNotification>> call({required String userId}) {
    return repository.subscribeToNewNotifications(userId);
  }
}
