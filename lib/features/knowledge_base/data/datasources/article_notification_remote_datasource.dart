import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/article_notification_model.dart';

abstract class ArticleNotificationRemoteDataSource {
  Future<List<ArticleNotificationModel>> getUnreadNotifications(String userId);
  Future<void> markAsRead(String notificationId);
  Stream<List<ArticleNotificationModel>> subscribeToNewNotifications(
    String userId,
  );
}

class ArticleNotificationRemoteDataSourceImpl
    implements ArticleNotificationRemoteDataSource {
  final SupabaseClient supabase;

  ArticleNotificationRemoteDataSourceImpl(this.supabase);

  @override
  Future<List<ArticleNotificationModel>> getUnreadNotifications(
    String userId,
  ) async {
    final response = await supabase
        .from('article_notifications')
        .select()
        .eq('recipient_id', userId)
        .eq('is_read', false)
        .order('created_at', ascending: false);
    return (response as List)
        .map((e) => ArticleNotificationModel.fromJson(e))
        .toList();
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    await supabase
        .from('article_notifications')
        .update({'is_read': true}).eq('id', notificationId);
  }

  @override
  Stream<List<ArticleNotificationModel>> subscribeToNewNotifications(
    String userId,
  ) {
    final controller = StreamController<List<ArticleNotificationModel>>();

    supabase
        .from('article_notifications')
        .stream(primaryKey: ['id'])
        .eq('recipient_id', userId)
        .listen((data) {
      final notifications =
          data.map((e) => ArticleNotificationModel.fromJson(e)).toList();
      controller.add(notifications);
    }).onError((error) {
      controller.addError(error);
    });

    return controller.stream;
  }
}
