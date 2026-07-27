import 'package:hive/hive.dart';

abstract class ArticleLocalDataSource {
  Future<void> saveDraft(String articleId, String title, String content);
  Future<Map<String, dynamic>?> getDraft(String articleId);
  Future<void> deleteDraft(String articleId);
  Future<List<Map<String, dynamic>>> getAllUnsyncedDrafts();
  Future<void> markDraftSynced(String articleId);
}

class ArticleLocalDataSourceImpl implements ArticleLocalDataSource {
  final Box box;

  ArticleLocalDataSourceImpl(this.box);

  @override
  Future<void> saveDraft(String articleId, String title, String content) async {
    await box.put(articleId, {
      'article_id': articleId,
      'title': title,
      'content_markdown': content,
      'saved_at': DateTime.now().toIso8601String(),
      'synced': false,
    });
  }

  @override
  Future<Map<String, dynamic>?> getDraft(String articleId) async {
    final data = box.get(articleId);
    if (data == null) return null;
    return Map<String, dynamic>.from(data);
  }

  @override
  Future<void> deleteDraft(String articleId) async {
    await box.delete(articleId);
  }

  @override
  Future<List<Map<String, dynamic>>> getAllUnsyncedDrafts() async {
    final drafts = <Map<String, dynamic>>[];
    for (final key in box.keys) {
      final data = box.get(key);
      if (data != null) {
        final map = Map<String, dynamic>.from(data);
        if (map['synced'] == false) {
          drafts.add(map);
        }
      }
    }
    return drafts;
  }

  @override
  Future<void> markDraftSynced(String articleId) async {
    final data = box.get(articleId);
    if (data != null) {
      final map = Map<String, dynamic>.from(data);
      map['synced'] = true;
      await box.put(articleId, map);
    }
  }
}
