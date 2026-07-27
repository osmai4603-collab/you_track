import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/features/knowledge_base/data/datasources/article_notification_remote_datasource.dart';
import 'package:issues_tracking/features/knowledge_base/data/models/article_notification_model.dart';
import 'package:issues_tracking/features/knowledge_base/data/repositories/article_notification_repository_impl.dart';
import 'package:issues_tracking/features/knowledge_base/domain/entities/article_notification.dart';

class MockArticleNotificationRemoteDataSource extends Mock
    implements ArticleNotificationRemoteDataSource {}

void main() {
  late ArticleNotificationRepositoryImpl repository;
  late MockArticleNotificationRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockArticleNotificationRemoteDataSource();
    repository =
        ArticleNotificationRepositoryImpl(remoteDataSource: mockDataSource);
  });

  final now = DateTime.now();
  final testNotification = ArticleNotificationModel(
    id: 'n1',
    recipientId: 'u1',
    senderId: 'u2',
    articleId: 'a1',
    notificationType: 'mention',
    createdAt: now,
  );

  group('getUnreadNotifications', () {
    test('returns list of notifications on success', () async {
      when(() => mockDataSource.getUnreadNotifications('u1'))
          .thenAnswer((_) async => [testNotification]);

      final result = await repository.getUnreadNotifications('u1');

      expect(result, isA<Right<Failure, List<ArticleNotification>>>());
      result.fold(
        (l) => fail('Expected Right'),
        (r) => expect(r.length, 1),
      );
    });

    test('returns ServerFailure on exception', () async {
      when(() => mockDataSource.getUnreadNotifications('u1'))
          .thenThrow(Exception('Error'));

      final result = await repository.getUnreadNotifications('u1');

      expect(result, isA<Left<Failure, List<ArticleNotification>>>());
    });
  });

  group('markAsRead', () {
    test('returns Right(null) on success', () async {
      when(() => mockDataSource.markAsRead('n1'))
          .thenAnswer((_) async {});

      final result = await repository.markAsRead('n1');

      expect(result, isA<Right<Failure, void>>());
    });

    test('returns ServerFailure on exception', () async {
      when(() => mockDataSource.markAsRead('n1'))
          .thenThrow(Exception('Error'));

      final result = await repository.markAsRead('n1');

      expect(result, isA<Left<Failure, void>>());
    });
  });
}
