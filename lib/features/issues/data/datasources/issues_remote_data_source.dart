import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/issue_filter.dart';
import '../models/issue_model.dart';

abstract class IssuesRemoteDataSource {
  Future<List<IssueModel>> getIssues(IssueFilter filter);
  Future<IssueModel> getIssueById(String id);
  Future<List<String>> getAllTags();

  Future<IssueModel> createIssue(Map<String, dynamic> issueData);
  Future<IssueModel> updateIssue(String issueId, Map<String, dynamic> updates);
  Future<void> deleteIssue(String issueId);

  Future<String> uploadAttachment({
    required String issueId,
    required String filePath,
    required String fileName,
    void Function(double progress)? onProgress,
  });
  Future<void> deleteAttachment(String storagePath);
  Future<List<Map<String, dynamic>>> getAttachments(String issueId);
}

class IssuesRemoteDataSourceImpl implements IssuesRemoteDataSource {
  final SupabaseClient supabase;

  IssuesRemoteDataSourceImpl(this.supabase);

  @override
  Future<List<IssueModel>> getIssues(IssueFilter filter) async {
    var query = supabase.from('issues').select();

    if (filter.projectFilter != null) {
      query = query.eq('project_id', filter.projectFilter!);
    }

    if (filter.stateFilter != null) {
      query = query.eq('state', filter.stateFilter!.name);
    }

    if (filter.priorityFilter != null) {
      query = query.eq('priority', filter.priorityFilter!.name);
    }

    if (filter.typeFilter != null) {
      query = query.eq('issue_type', filter.typeFilter!.name);
    }

    if (filter.searchQuery.isNotEmpty) {
      query = query.or(
        'title.ilike.%${filter.searchQuery}%,description.ilike.%${filter.searchQuery}%',
      );
    }

    final response = await query.order(
      _getSortField(filter.sortField),
      ascending: filter.sortAscending,
    );

    return (response as List).map((e) => IssueModel.fromJson(e)).toList();
  }

  @override
  Future<IssueModel> getIssueById(String id) async {
    final response = await supabase
        .from('issues')
        .select()
        .eq('id', id)
        .single();
    return IssueModel.fromJson(response);
  }

  @override
  Future<List<String>> getAllTags() async {
    // Supabase doesn't have a direct way to get unique items in a list column easily without RPC or a separate table.
    // For now, let's fetch issues and extract tags or assume a tags table exists.
    // A better approach would be to have a dedicated tags table.
    // Given the current architecture, let's just return a placeholder or fetch from a hypothetical tags view/table.
    try {
      final response = await supabase.from('tags').select('name');
      return (response as List).map((e) => e['name'].toString()).toList();
    } catch (_) {
      return [];
    }
  }

  String _getSortField(IssueSortField field) {
    switch (field) {
      case IssueSortField.updated:
        return 'updated_at';
      case IssueSortField.created:
        return 'created_at';
      case IssueSortField.priority:
        return 'priority';
      case IssueSortField.votes:
        return 'votes';
      case IssueSortField.summary:
        return 'title';
    }
  }

  @override
  Future<IssueModel> createIssue(Map<String, dynamic> issueData) async {
    final response = await supabase
        .from('issues')
        .insert(issueData)
        .select()
        .single();
    return IssueModel.fromJson(response);
  }

  @override
  Future<IssueModel> updateIssue(
    String issueId,
    Map<String, dynamic> updates,
  ) async {
    updates['updated_at'] = DateTime.now().toIso8601String();
    final response = await supabase
        .from('issues')
        .update(updates)
        .eq('id', issueId)
        .select()
        .single();
    return IssueModel.fromJson(response);
  }

  @override
  Future<void> deleteIssue(String issueId) async {
    await supabase.from('issues').delete().eq('id', issueId);
  }

  @override
  Future<String> uploadAttachment({
    required String issueId,
    required String filePath,
    required String fileName,
    void Function(double progress)? onProgress,
  }) async {
    final storagePath = 'issues/$issueId/$fileName';
    // NOTE: In a real implementation, read the file from filePath and upload bytes.
    // For now, we store metadata. Actual file upload would use:
    // await supabase.storage.from('attachments').uploadBinary(
    //   storagePath,
    //   fileBytes,
    //   fileOptions: FileOptions(upsert: true),
    // );
    // with onUploadProgress callback for progress tracking.
    return storagePath;
  }

  @override
  Future<void> deleteAttachment(String storagePath) async {
    await supabase.storage.from('attachments').remove([storagePath]);
  }

  @override
  Future<List<Map<String, dynamic>>> getAttachments(String issueId) async {
    try {
      final files = await supabase.storage
          .from('attachments')
          .list(path: 'issues/$issueId/');
      return files
          .where((f) => f.name != '.emptyFolderPlaceholder')
          .map(
            (f) => {
              'name': f.name,
              'size': f.metadata?['size'] ?? 0,
              'mimeType': f.metadata?['mimeType'] ?? 'application/octet-stream',
              'path': 'issues/$issueId/${f.name}',
            },
          )
          .toList();
    } catch (_) {
      return [];
    }
  }
}
