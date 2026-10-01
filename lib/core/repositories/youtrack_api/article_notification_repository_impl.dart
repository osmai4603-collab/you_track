import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/features/knowledge_base/domain/entities/article_notification.dart';
import 'package:issues_tracking/core/repositories/abstractions/article_notification_repository.dart';
import 'package:youtrack_api/youtrack_api.dart';
import 'api_failure_mapper.dart';

class ArticleNotificationRepositoryImpl
    implements ArticleNotificationRepository {
  final ArticleNotificationsApi _api;

  ArticleNotificationRepositoryImpl(this._api);

  @override
  Future<Either<Failure, List<ArticleNotification>>> getUnreadNotifications(
    String userId,
  ) async {
    final result = await _api.getUnread(userId);
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return Right(
      result.data.map(_notificationFromJson).toList(growable: false),
    );
  }

  @override
  Future<Either<Failure, void>> markAsRead(String notificationId) async {
    final result = await _api.markRead(notificationId);
    if (result.isFailure) return Left(failureFromApiError(result.error));
    return const Right(null);
  }

  @override
  Stream<List<ArticleNotification>> subscribeToNewNotifications(String userId) {
    late StreamController<List<ArticleNotification>> controller;
    Timer? timer;

    Future<void> refresh() async {
      final result = await _api.getUnread(userId);
      if (result.isSuccess) {
        controller.add(
          result.data.map(_notificationFromJson).toList(growable: false),
        );
      } else {
        controller.addError(failureFromApiError(result.error));
      }
    }

    controller = StreamController<List<ArticleNotification>>(
      onListen: () {
        refresh();
        timer = Timer.periodic(const Duration(seconds: 30), (_) => refresh());
      },
      onCancel: () => timer?.cancel(),
    );
    return controller.stream;
  }
}

ArticleNotification _notificationFromJson(JsonObject json) =>
    ArticleNotification(
      id: (json['id'] ?? '').toString(),
      recipientId: (json['recipientId'] ?? json['recipient_id'] ?? '')
          .toString(),
      senderId: (json['senderId'] ?? json['sender_id'] ?? '').toString(),
      articleId: (json['articleId'] ?? json['article_id'] ?? '').toString(),
      commentId: (json['commentId'] ?? json['comment_id'])?.toString(),
      notificationType:
          (json['notificationType'] ?? json['notification_type'] ?? 'mention')
              .toString(),
      isRead: json['isRead'] == true || json['is_read'] == true,
      createdAt: json['createdAt'] is int
          ? DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int)
          : DateTime.tryParse(
                  (json['createdAt'] ?? json['created_at'] ?? '').toString(),
                ) ??
                DateTime.fromMillisecondsSinceEpoch(0),
    );
