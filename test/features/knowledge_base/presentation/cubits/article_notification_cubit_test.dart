import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:issues_tracking/features/knowledge_base/domain/usecases/subscribe_to_notifications.dart';
import 'package:issues_tracking/features/knowledge_base/presentation/cubits/article_notification_cubit.dart';

class MockSubscribeToNotifications extends Mock
    implements SubscribeToNotifications {}

void main() {
  late ArticleNotificationCubit cubit;
  late MockSubscribeToNotifications mockSubscribe;

  setUp(() {
    mockSubscribe = MockSubscribeToNotifications();
    cubit = ArticleNotificationCubit(
      subscribeToNotifications: mockSubscribe,
    );
  });

  tearDown(() => cubit.close());

  group('ArticleNotificationCubit', () {
    test('initial state is ArticleNotificationInitial', () {
      expect(cubit.state, isA<ArticleNotificationInitial>());
    });
  });
}
