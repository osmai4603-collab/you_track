import 'package:issues_tracking/features/knowledge_base/data/datasources/article_local_datasource.dart';

class GetDraft {
  final ArticleLocalDataSource localDataSource;
  const GetDraft(this.localDataSource);

  Future<Map<String, dynamic>?> call({required String articleId}) async {
    return await localDataSource.getDraft(articleId);
  }
}
