import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:issues_tracking/features/knowledge_base/data/datasources/article_local_datasource.dart';
import 'package:issues_tracking/features/knowledge_base/domain/usecases/get_draft.dart';

class MockArticleLocalDataSource extends Mock
    implements ArticleLocalDataSource {}

void main() {
  late GetDraft useCase;
  late MockArticleLocalDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockArticleLocalDataSource();
    useCase = GetDraft(mockDataSource);
  });

  test('returns draft when it exists', () async {
    final draftData = {
      'article_id': '1',
      'title': 'Draft Title',
      'content_markdown': 'Draft content',
      'saved_at': DateTime.now().toIso8601String(),
      'synced': false,
    };
    when(() => mockDataSource.getDraft('1'))
        .thenAnswer((_) async => draftData);

    final result = await useCase(articleId: '1');

    expect(result, isNotNull);
    expect(result!['title'], 'Draft Title');
  });

  test('returns null when draft does not exist', () async {
    when(() => mockDataSource.getDraft('1')).thenAnswer((_) async => null);

    final result = await useCase(articleId: '1');

    expect(result, isNull);
  });
}
