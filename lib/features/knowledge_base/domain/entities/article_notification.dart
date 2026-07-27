import 'package:issues_tracking/core/entities/entity.dart';

class ArticleNotification extends Entity {
  final String id;
  final String recipientId;
  final String senderId;
  final String articleId;
  final String? commentId;
  final String notificationType;
  final bool isRead;
  final DateTime createdAt;

  const ArticleNotification({
    required this.id,
    required this.recipientId,
    required this.senderId,
    required this.articleId,
    this.commentId,
    this.notificationType = 'mention',
    this.isRead = false,
    required this.createdAt,
  });

  @override
  ArticleNotification copyWith({
    String? id,
    String? recipientId,
    String? senderId,
    String? articleId,
    String? commentId,
    String? notificationType,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return ArticleNotification(
      id: id ?? this.id,
      recipientId: recipientId ?? this.recipientId,
      senderId: senderId ?? this.senderId,
      articleId: articleId ?? this.articleId,
      commentId: commentId ?? this.commentId,
      notificationType: notificationType ?? this.notificationType,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        recipientId,
        senderId,
        articleId,
        commentId,
        notificationType,
        isRead,
        createdAt,
      ];
}
