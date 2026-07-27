import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/article_model.dart';

abstract class ArticleRemoteDataSource {
  Future<List<ArticleModel>> getArticleTree(String projectId);
  Future<ArticleModel> getArticleById(String articleId);
  Future<ArticleModel> createArticle(ArticleModel article);
  Future<ArticleModel> updateArticle(ArticleModel article);
  Future<void> deleteArticle(String articleId);
  Future<List<ArticleModel>> searchArticles(String projectId, String query);
}

class ArticleRemoteDataSourceImpl implements ArticleRemoteDataSource {
  final SupabaseClient supabase;

  ArticleRemoteDataSourceImpl(this.supabase);

  @override
  Future<List<ArticleModel>> getArticleTree(String projectId) async {
    final response = await supabase
        .from('articles')
        .select()
        .eq('project_id', projectId)
        .order('sort_order');
    return (response as List).map((e) => ArticleModel.fromJson(e)).toList();
  }

  @override
  Future<ArticleModel> getArticleById(String articleId) async {
    final response =
        await supabase.from('articles').select().eq('id', articleId).single();
    return ArticleModel.fromJson(response);
  }

  @override
  Future<ArticleModel> createArticle(ArticleModel article) async {
    final response = await supabase
        .from('articles')
        .insert(article.toInsertJson())
        .select()
        .single();
    return ArticleModel.fromJson(response);
  }

  @override
  Future<ArticleModel> updateArticle(ArticleModel article) async {
    final response = await supabase
        .from('articles')
        .update(article.toJson())
        .eq('id', article.id)
        .select()
        .single();
    return ArticleModel.fromJson(response);
  }

  @override
  Future<void> deleteArticle(String articleId) async {
    await supabase.from('articles').delete().eq('id', articleId);
  }

  @override
  Future<List<ArticleModel>> searchArticles(
    String projectId,
    String query,
  ) async {
    final response = await supabase
        .from('articles')
        .select()
        .eq('project_id', projectId)
        .or('title.ilike.%$query%,content_markdown.ilike.%$query%')
        .order('sort_order');
    return (response as List).map((e) => ArticleModel.fromJson(e)).toList();
  }
}
