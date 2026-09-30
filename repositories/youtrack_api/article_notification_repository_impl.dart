import 'package:fpdart/src/either.dart';
import 'package:youtrack_frontend/core/errors/failure.dart';
import 'package:youtrack_frontend/features/knowledge_base/domain/entities/article_notification.dart';
import 'package:youtrack_frontend/core/repositories/abstractions/article_notification_repository.dart';

class ArticleNotificationRepositoryImpl
    implements ArticleNotificationRepository {
  @override
  Future<Either<Failure, List<ArticleNotification>>> getUnreadNotifications(
    String userId,
  ) {
    // TODO: implement getUnreadNotifications
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> markAsRead(String notificationId) {
    // TODO: implement markAsRead
    throw UnimplementedError();
  }

  @override
  Stream<List<ArticleNotification>> subscribeToNewNotifications(String userId) {
    // TODO: implement subscribeToNewNotifications
    throw UnimplementedError();
  }
}
