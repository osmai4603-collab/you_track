import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/features/knowledge_base/domain/entities/article_notification.dart';
import 'package:issues_tracking/features/knowledge_base/domain/usecases/subscribe_to_notifications.dart';

abstract class ArticleNotificationState extends Equatable {
  const ArticleNotificationState();
  @override
  List<Object?> get props => [];
}

class ArticleNotificationInitial extends ArticleNotificationState {}

class ArticleNotificationLoading extends ArticleNotificationState {}

class ArticleNotificationLoaded extends ArticleNotificationState {
  final List<ArticleNotification> notifications;

  const ArticleNotificationLoaded(this.notifications);

  @override
  List<Object?> get props => [notifications];
}

class ArticleNotificationError extends ArticleNotificationState {
  final String message;
  const ArticleNotificationError(this.message);

  @override
  List<Object?> get props => [message];
}

class ArticleNotificationCubit extends Cubit<ArticleNotificationState> {
  final SubscribeToNotifications subscribeToNotifications;
  StreamSubscription<List<ArticleNotification>>? _subscription;

  ArticleNotificationCubit({
    required this.subscribeToNotifications,
  }) : super(ArticleNotificationInitial());

  void subscribe(String userId) {
    _subscription?.cancel();
    _subscription = subscribeToNotifications(userId: userId).listen(
      (notifications) {
        emit(ArticleNotificationLoaded(notifications));
      },
      onError: (error) {
        emit(ArticleNotificationError(error.toString()));
      },
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
