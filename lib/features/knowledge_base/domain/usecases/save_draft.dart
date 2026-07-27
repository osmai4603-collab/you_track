import 'package:issues_tracking/features/knowledge_base/data/datasources/article_local_datasource.dart';

class SaveDraft {
  final ArticleLocalDataSource localDataSource;
  const SaveDraft(this.localDataSource);

  Future<void> call({
    required String articleId,
    required String title,
    required String content,
  }) async {
    await localDataSource.saveDraft(articleId, title, content);
  }
}
