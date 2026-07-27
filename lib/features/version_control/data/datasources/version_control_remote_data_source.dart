import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:issues_tracking/features/version_control/data/models/vcs_integration_model.dart';
import 'package:issues_tracking/features/version_control/data/models/vcs_user_mapping_model.dart';
import 'package:issues_tracking/features/version_control/data/models/vcs_commit_model.dart';
import 'package:issues_tracking/features/version_control/data/models/vcs_pull_request_model.dart';

abstract class VersionControlRemoteDataSource {
  // Integrations
  Future<List<VcsIntegrationModel>> getIntegrations(String projectId);

  Future<VcsIntegrationModel> getIntegrationById(String integrationId);

  Future<VcsIntegrationModel> createIntegration(VcsIntegrationModel integration);

  Future<VcsIntegrationModel> updateIntegration(VcsIntegrationModel integration);

  Future<void> deleteIntegration(String integrationId);

  // User Mappings
  Future<List<VcsUserMappingModel>> getUserMappings(String integrationId);

  Future<VcsUserMappingModel> createUserMapping(VcsUserMappingModel mapping);

  Future<void> deleteUserMapping(String mappingId);

  // Commits
  Future<List<VcsCommitModel>> getCommits(String integrationId, {String? taskId});

  Future<VcsCommitModel> createCommit(VcsCommitModel commit);

  // Pull Requests
  Future<List<VcsPullRequestModel>> getPullRequests(String integrationId,
      {String? taskId});

  Future<VcsPullRequestModel> createPullRequest(VcsPullRequestModel pullRequest);

  Future<VcsPullRequestModel> updatePullRequest(VcsPullRequestModel pullRequest);
}

class VersionControlRemoteDataSourceImpl
    implements VersionControlRemoteDataSource {
  final SupabaseClient supabase;

  VersionControlRemoteDataSourceImpl(this.supabase);

  @override
  Future<List<VcsIntegrationModel>> getIntegrations(String projectId) async {
    final response = await supabase
        .from('vcs_integrations')
        .select()
        .eq('project_id', projectId)
        .order('created_at', ascending: true);
    return (response as List)
        .map((e) => VcsIntegrationModel.fromJson(e))
        .toList();
  }

  @override
  Future<VcsIntegrationModel> getIntegrationById(String integrationId) async {
    final response = await supabase
        .from('vcs_integrations')
        .select()
        .eq('id', integrationId)
        .single();
    return VcsIntegrationModel.fromJson(response);
  }

  @override
  Future<VcsIntegrationModel> createIntegration(
      VcsIntegrationModel integration) async {
    final response = await supabase
        .from('vcs_integrations')
        .insert(integration.toInsertJson())
        .select()
        .single();
    return VcsIntegrationModel.fromJson(response);
  }

  @override
  Future<VcsIntegrationModel> updateIntegration(
      VcsIntegrationModel integration) async {
    final response = await supabase
        .from('vcs_integrations')
        .update(integration.toJson())
        .eq('id', integration.id)
        .select()
        .single();
    return VcsIntegrationModel.fromJson(response);
  }

  @override
  Future<void> deleteIntegration(String integrationId) async {
    await supabase.from('vcs_integrations').delete().eq('id', integrationId);
  }

  @override
  Future<List<VcsUserMappingModel>> getUserMappings(
      String integrationId) async {
    final response = await supabase
        .from('vcs_user_mappings')
        .select()
        .eq('integration_id', integrationId);
    return (response as List)
        .map((e) => VcsUserMappingModel.fromJson(e))
        .toList();
  }

  @override
  Future<VcsUserMappingModel> createUserMapping(
      VcsUserMappingModel mapping) async {
    final response = await supabase
        .from('vcs_user_mappings')
        .insert(mapping.toInsertJson())
        .select()
        .single();
    return VcsUserMappingModel.fromJson(response);
  }

  @override
  Future<void> deleteUserMapping(String mappingId) async {
    await supabase.from('vcs_user_mappings').delete().eq('id', mappingId);
  }

  @override
  Future<List<VcsCommitModel>> getCommits(String integrationId,
      {String? taskId}) async {
    var query = supabase
        .from('vcs_commits')
        .select()
        .eq('integration_id', integrationId);
    if (taskId != null) {
      query = query.eq('task_id', taskId);
    }
    final response = await query.order('committed_at', ascending: false);
    return (response as List)
        .map((e) => VcsCommitModel.fromJson(e))
        .toList();
  }

  @override
  Future<VcsCommitModel> createCommit(VcsCommitModel commit) async {
    final response = await supabase
        .from('vcs_commits')
        .insert(commit.toInsertJson())
        .select()
        .single();
    return VcsCommitModel.fromJson(response);
  }

  @override
  Future<List<VcsPullRequestModel>> getPullRequests(String integrationId,
      {String? taskId}) async {
    var query = supabase
        .from('vcs_pull_requests')
        .select()
        .eq('integration_id', integrationId);
    if (taskId != null) {
      query = query.eq('task_id', taskId);
    }
    final response = await query.order('opened_at', ascending: false);
    return (response as List)
        .map((e) => VcsPullRequestModel.fromJson(e))
        .toList();
  }

  @override
  Future<VcsPullRequestModel> createPullRequest(
      VcsPullRequestModel pullRequest) async {
    final response = await supabase
        .from('vcs_pull_requests')
        .insert(pullRequest.toInsertJson())
        .select()
        .single();
    return VcsPullRequestModel.fromJson(response);
  }

  @override
  Future<VcsPullRequestModel> updatePullRequest(
      VcsPullRequestModel pullRequest) async {
    final response = await supabase
        .from('vcs_pull_requests')
        .update(pullRequest.toJson())
        .eq('id', pullRequest.id)
        .select()
        .single();
    return VcsPullRequestModel.fromJson(response);
  }
}
