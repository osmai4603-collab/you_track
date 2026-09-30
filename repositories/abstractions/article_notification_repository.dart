import 'package:fpdart/fpdart.dart';
import 'package:youtrack_frontend/core/errors/failure.dart';
import 'package:youtrack_frontend/features/knowledge_base/domain/entities/article_notification.dart';

abstract class ArticleNotificationRepository {
  Future<Either<Failure, List<ArticleNotification>>> getUnreadNotifications(
    String userId,
  );
  Future<Either<Failure, void>> markAsRead(String notificationId);
  Stream<List<ArticleNotification>> subscribeToNewNotifications(String userId);
}
