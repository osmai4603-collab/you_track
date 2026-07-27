import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/article_comment_model.dart';

abstract class ArticleCommentRemoteDataSource {
  Future<List<ArticleCommentModel>> getComments(String articleId);
  Future<ArticleCommentModel> addComment(ArticleCommentModel comment);
  Future<void> resolveComment(
    String commentId,
    String resolvedBy,
  );
  Future<void> deleteComment(String commentId);
}

class ArticleCommentRemoteDataSourceImpl
    implements ArticleCommentRemoteDataSource {
  final SupabaseClient supabase;

  ArticleCommentRemoteDataSourceImpl(this.supabase);

  @override
  Future<List<ArticleCommentModel>> getComments(String articleId) async {
    final response = await supabase
        .from('article_comments')
        .select()
        .eq('article_id', articleId)
        .order('created_at');
    return (response as List)
        .map((e) => ArticleCommentModel.fromJson(e))
        .toList();
  }

  @override
  Future<ArticleCommentModel> addComment(ArticleCommentModel comment) async {
    final response = await supabase
        .from('article_comments')
        .insert(comment.toInsertJson())
        .select()
        .single();
    return ArticleCommentModel.fromJson(response);
  }

  @override
  Future<void> resolveComment(String commentId, String resolvedBy) async {
    await supabase.from('article_comments').update({
      'is_resolved': true,
      'resolved_by': resolvedBy,
      'resolved_at': DateTime.now().toIso8601String(),
    }).eq('id', commentId);
  }

  @override
  Future<void> deleteComment(String commentId) async {
    await supabase.from('article_comments').delete().eq('id', commentId);
  }
}
