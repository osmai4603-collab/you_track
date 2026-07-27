import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/features/knowledge_base/domain/entities/article_notification.dart';

abstract class ArticleNotificationRepository {
  Future<Either<Failure, List<ArticleNotification>>> getUnreadNotifications(
    String userId,
  );
  Future<Either<Failure, void>> markAsRead(String notificationId);
  Stream<List<ArticleNotification>> subscribeToNewNotifications(String userId);
}
