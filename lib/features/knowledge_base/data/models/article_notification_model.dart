import '../../domain/entities/article_notification.dart';

class ArticleNotificationModel extends ArticleNotification {
  const ArticleNotificationModel({
    required super.id,
    required super.recipientId,
    required super.senderId,
    required super.articleId,
    super.commentId,
    super.notificationType,
    super.isRead,
    required super.createdAt,
  });

  factory ArticleNotificationModel.fromJson(Map<String, dynamic> json) {
    return ArticleNotificationModel(
      id: (json['id'] ?? '').toString(),
      recipientId: (json['recipient_id'] ?? '').toString(),
      senderId: (json['sender_id'] ?? '').toString(),
      articleId: (json['article_id'] ?? '').toString(),
      commentId: json['comment_id']?.toString(),
      notificationType: (json['notification_type'] ?? 'mention').toString(),
      isRead: json['is_read'] == true,
      createdAt: _parseDate(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'recipient_id': recipientId,
      'sender_id': senderId,
      'article_id': articleId,
      'comment_id': commentId,
      'notification_type': notificationType,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
    };
  }

  static DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.now();
    try {
      return DateTime.parse(value.toString());
    } catch (_) {
      return DateTime.now();
    }
  }
}
