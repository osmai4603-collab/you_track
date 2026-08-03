import 'package:issues_tracking/features/issues/data/models/issue_link_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/tag_model.dart';

abstract class TagRemoteDatasource {
  Future<TagModel> createTag({
    required String name,
    required String projectId,
    required String ownerId,
    required bool shared,
    required bool removeOnResolution,
    required bool favorite,
    required Map<String, String> permissions,
    List<String>? specificUserIds,
    required List<String> subscriptionEvents,
  });

  Future<void> associateTagWithIssue({
    required String issueId,
    required String tagId,
  });

  Future<List<Map<String, dynamic>>> getProjectMembers({
    required String projectId,
  });

  Future<bool> isTagNameUnique({
    required String name,
    required String projectId,
  });

  Future<List<TagModel>> getTagsByIssueId({required String issueId});

  Future<List<IssueLinkModel>> getLinksByIssueId({required String issueId});
}

class TagRemoteDatasourceImpl implements TagRemoteDatasource {
  final SupabaseClient supabase;

  TagRemoteDatasourceImpl(this.supabase);

  @override
  Future<TagModel> createTag({
    required String name,
    required String projectId,
    required String ownerId,
    required bool shared,
    required bool removeOnResolution,
    required bool favorite,
    required Map<String, String> permissions,
    List<String>? specificUserIds,
    required List<String> subscriptionEvents,
  }) async {
    // 1. Create Tag
    final tagResponse = await supabase
        .from('tags')
        .insert({
          'name': name,
          'project_id': projectId,
          'owner_id': ownerId,
          'shared': shared,
          'remove_on_resolution': removeOnResolution,
          'favorite': favorite,
          'created_by': supabase.auth.currentUser?.id ?? ownerId,
        })
        .select()
        .single();

    final tagId = tagResponse['id'].toString();

    // 2. Create Permissions
    for (final entry in permissions.entries) {
      final permissionResponse = await supabase
          .from('tag_permissions')
          .insert({
            'tag_id': tagId,
            'permission_type': entry.key,
            'scope': entry.value,
          })
          .select()
          .single();

      final permissionId = permissionResponse['id'].toString();

      if (entry.value == 'specific_users' && specificUserIds != null) {
        final userPermissionData = specificUserIds
            .map(
              (userId) => {
                'tag_permission_id': permissionId,
                'user_id': userId,
              },
            )
            .toList();
        await supabase.from('tag_permission_users').insert(userPermissionData);
      }
    }

    // 3. Create Subscriptions
    if (subscriptionEvents.isNotEmpty) {
      final subscriptionData = subscriptionEvents
          .map((event) => {'tag_id': tagId, 'event_type': event})
          .toList();
      await supabase.from('tag_subscriptions').insert(subscriptionData);
    }

    // 4. Return full Tag model (with nested data if needed, but here we can just fetch it again or assemble)
    final fullTagResponse = await supabase
        .from('tags')
        .select(
          '*, tag_permissions(*, tag_permission_users(*)), tag_subscriptions(*)',
        )
        .eq('id', tagId)
        .single();

    return TagModel.fromJson(fullTagResponse);
  }

  @override
  Future<void> associateTagWithIssue({
    required String issueId,
    required String tagId,
  }) async {
    await supabase.from('issue_tags').insert({
      'issue_id': issueId,
      'tag_id': tagId,
    });
  }

  @override
  Future<List<Map<String, dynamic>>> getProjectMembers({
    required String projectId,
  }) async {
    // This assumes a junction table between projects and users, or a members table
    // Adjust based on actual project structure if known.
    // Based on ProjectMemberEntity, let's assume 'project_members' table.
    final response = await supabase
        .from('project_members')
        .select('*, users(*)')
        .eq('project_id', projectId);
    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Future<bool> isTagNameUnique({
    required String name,
    required String projectId,
  }) async {
    final response = await supabase
        .from('tags')
        .select('id')
        .eq('project_id', projectId)
        .ilike('name', name)
        .maybeSingle();
    return response == null;
  }

  @override
  Future<List<TagModel>> getTagsByIssueId({required String issueId}) async {
    final response = await supabase
        .from('issue_tags')
        .select()
        .eq('issue_id', issueId);

    return response.map((e) => TagModel.fromJson(e)).toList();
  }

  @override
  Future<List<IssueLinkModel>> getLinksByIssueId({
    required String issueId,
  }) async {
    final response = await supabase
        .from('issue_links')
        .select()
        .eq('issue_id', issueId);

    return response.map((e) => IssueLinkModel.fromJson(e)).toList();
  }
}
