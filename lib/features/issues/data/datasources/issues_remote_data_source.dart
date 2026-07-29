import 'package:issues_tracking/features/issues/data/models/build_model.dart';
import 'package:issues_tracking/features/issues/data/models/sprint_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/issue_filter.dart';
import '../../domain/entities/sprint.dart';
import '../../domain/entities/tag.dart';
import '../../domain/entities/issue_link.dart';
import '../models/issue_model.dart';
import '../models/tag_model.dart';
import '../models/issue_link_model.dart';

abstract class IssuesRemoteDataSource {
  Future<List<IssueModel>> getIssues(IssueFilter filter);
  Future<IssueModel> getIssueById(String id);
  Future<List<TagModel>> getAllTags();
  Future<List<SprintModel>> getSprints(String projectId);
  Future<List<BuildModel>> getBuilds(String projectId);
  Future<BuildModel> createBuild(Map<String, dynamic> buildData);

  Future<IssueModel> createIssue(IssueModel issue);
  Future<IssueModel> updateIssue(IssueModel issue);
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
  Future<List<BuildModel>> getBuilds(String projectId) async {
    try {
      final response = await supabase.from('builds').select('*').eq('project_id', projectId);
      return (response as List).map((e) => BuildModel.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<BuildModel> createBuild(Map<String, dynamic> buildData) async {
    final response = await supabase.from('builds').insert(buildData).select().single();
    return BuildModel.fromJson(response);
  }

  @override
  Future<List<IssueModel>> getIssues(IssueFilter filter) async {
    var query = supabase.from('issues').select('*, build:builds(*), sprints(*), tags(*), issue_links:issue_links!issue_links_source_issue_id_fkey(*)');

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
        .select('*, build:builds(*), sprints(*), tags(*), issue_links:issue_links!issue_links_source_issue_id_fkey(*)')
        .eq('id', id)
        .single();
    return IssueModel.fromJson(response);
  }

  @override
  Future<List<TagModel>> getAllTags() async {
    try {
      final response = await supabase.from('tags').select('*');
      return (response as List).map((e) => TagModel.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<List<SprintModel>> getSprints(String projectId) async {
    try {
      final response = await supabase.from('sprints').select('*').eq('project_id', projectId);
      return (response as List).map((e) => SprintModel.fromJson(e)).toList();
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
  Future<IssueModel> createIssue(IssueModel issue) async {
    final issueData = issue.toJson();
    final sprints = issue.sprints;
    final tags = issue.tags;
    final links = issue.links;

    issueData.remove('id');
    issueData.remove('sprints');
    issueData.remove('tags');
    issueData.remove('issue_links');

    final response = await supabase
        .from('issues')
        .insert(issueData)
        .select()
        .single();

    final createdIssue = IssueModel.fromJson(response);

    if (sprints.isNotEmpty) {
      final sprintData = sprints.map((s) => (s as SprintModel).toJson()).toList();
      await supabase.from('sprints').upsert(sprintData);

      final junctionData = sprints.map((s) => {
        'issue_id': createdIssue.id,
        'sprint_id': s.id,
      }).toList();
      
      await supabase.from('issue_sprints').insert(junctionData);
    }

    if (tags.isNotEmpty) {
      final tagData = tags.map((t) => (t as TagModel).toJson()).toList();
      await supabase.from('tags').upsert(tagData);

      final junctionData = tags.map((t) => {
        'issue_id': createdIssue.id,
        'tag_id': t.id,
      }).toList();
      
      await supabase.from('issue_tags').insert(junctionData);
    }

    if (links.isNotEmpty) {
      final linkData = links.map((l) => (l as IssueLinkModel).toJson()).toList();
      await supabase.from('issue_links').insert(linkData);
    }

    return createdIssue;
  }

  @override
  Future<IssueModel> updateIssue(IssueModel issue) async {
    final updates = issue.toJson();
    final sprints = issue.sprints;
    final tags = issue.tags;
    final links = issue.links;
    final issueId = issue.id;

    updates.remove('id');
    updates.remove('sprints');
    updates.remove('tags');
    updates.remove('issue_links');
    updates['updated_at'] = DateTime.now().toIso8601String();

    final response = await supabase
        .from('issues')
        .update(updates)
        .eq('id', issueId)
        .select()
        .single();

    await supabase.from('issue_sprints').delete().eq('issue_id', issueId);
    if (sprints.isNotEmpty) {
      final sprintData = sprints.map((s) => (s as SprintModel).toJson()).toList();
      await supabase.from('sprints').upsert(sprintData);

      final junctionData = sprints.map((s) => {
        'issue_id': issueId,
        'sprint_id': s.id,
      }).toList();
      
      await supabase.from('issue_sprints').insert(junctionData);
    }

    await supabase.from('issue_tags').delete().eq('issue_id', issueId);
    if (tags.isNotEmpty) {
      final tagData = tags.map((t) => (t as TagModel).toJson()).toList();
      await supabase.from('tags').upsert(tagData);

      final junctionData = tags.map((t) => {
        'issue_id': issueId,
        'tag_id': t.id,
      }).toList();
      
      await supabase.from('issue_tags').insert(junctionData);
    }

    await supabase.from('issue_links').delete().eq('source_issue_id', issueId);
    if (links.isNotEmpty) {
      final linkData = links.map((l) => (l as IssueLinkModel).toJson()).toList();
      await supabase.from('issue_links').insert(linkData);
    }

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
