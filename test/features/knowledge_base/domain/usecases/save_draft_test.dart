import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/features/knowledge_base/domain/repositories/article_repository.dart';
import 'package:issues_tracking/features/knowledge_base/domain/usecases/save_draft.dart';
import 'package:issues_tracking/features/knowledge_base/data/datasources/article_local_datasource.dart';

class MockArticleLocalDataSource extends Mock
    implements ArticleLocalDataSource {}

void main() {
  late SaveDraft useCase;
  late MockArticleLocalDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockArticleLocalDataSource();
    useCase = SaveDraft(mockDataSource);
  });

  test('saves draft to local data source', () async {
    when(() => mockDataSource.saveDraft('1', 'Title', 'Content'))
        .thenAnswer((_) async {});

    await useCase(articleId: '1', title: 'Title', content: 'Content');

    verify(() => mockDataSource.saveDraft('1', 'Title', 'Content')).called(1);
  });

  test('propagates exceptions from data source', () async {
    when(() => mockDataSource.saveDraft('1', 'Title', 'Content'))
        .thenThrow(Exception('Save failed'));

    expect(
      () => useCase(articleId: '1', title: 'Title', content: 'Content'),
      throwsA(isA<Exception>()),
    );
  });
}
