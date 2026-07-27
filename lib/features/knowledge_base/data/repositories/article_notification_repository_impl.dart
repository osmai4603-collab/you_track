import 'dart:async';
import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/features/knowledge_base/domain/entities/article_notification.dart';
import 'package:issues_tracking/features/knowledge_base/domain/repositories/article_notification_repository.dart';
import 'package:issues_tracking/features/knowledge_base/data/datasources/article_notification_remote_datasource.dart';

class ArticleNotificationRepositoryImpl
    implements ArticleNotificationRepository {
  final ArticleNotificationRemoteDataSource remoteDataSource;

  ArticleNotificationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ArticleNotification>>> getUnreadNotifications(
    String userId,
  ) async {
    try {
      final notifications = await remoteDataSource.getUnreadNotifications(userId);
      return Right(notifications);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(String notificationId) async {
    try {
      await remoteDataSource.markAsRead(notificationId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<List<ArticleNotification>> subscribeToNewNotifications(
    String userId,
  ) {
    return remoteDataSource.subscribeToNewNotifications(userId).map(
          (models) => models.cast<ArticleNotification>(),
        );
  }
}
