import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/enums/tag_permission_scope_enum.dart';
import 'package:issues_tracking/core/enums/tag_subscription_event_enum.dart';
import '../../domain/usecases/create_tag.dart';
import '../../domain/usecases/get_project_members.dart';
import '../../domain/usecases/get_project_groups.dart';
import '../../domain/usecases/is_tag_name_unique.dart';
import '../../domain/usecases/associate_tag_with_issue.dart';
import 'new_tag_state.dart';

class NewTagCubit extends Cubit<NewTagState> {
  final CreateTag createTagUseCase;
  final GetProjectMembers getProjectMembersUseCase;
  final GetProjectGroups getProjectGroupsUseCase;
  final IsTagNameUnique isTagNameUniqueUseCase;
  final AssociateTagWithIssue associateTagUseCase;

  NewTagCubit({
    required this.createTagUseCase,
    required this.getProjectMembersUseCase,
    required this.getProjectGroupsUseCase,
    required this.isTagNameUniqueUseCase,
    required this.associateTagUseCase,
  }) : super(const NewTagState());

  Future<void> loadMembers(String projectId) async {
    emit(state.copyWith(status: NewTagStatus.loading));
    final result = await getProjectMembersUseCase(
      params: GetProjectMembersParams(projectId: projectId),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: NewTagStatus.failure,
        errorMessage: failure.message,
      )),
      (members) {
        // Default owner to first member or current user if found (simulated)
        final ownerId = members.isNotEmpty ? members.first.id : null;
        emit(state.copyWith(
          status: NewTagStatus.initial,
          members: members,
          ownerId: ownerId,
        ));
      },
    );

    await _loadGroups(projectId);
  }

  Future<void> _loadGroups(String projectId) async {
    final result = await getProjectGroupsUseCase(
      params: GetProjectGroupsParams(projectId: projectId),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: NewTagStatus.failure,
        errorMessage: failure.message,
      )),
      (groups) => emit(state.copyWith(projectGroups: groups)),
    );
  }

  void updateName(String name) {
    emit(state.copyWith(name: name, clearNameError: true));
  }

  void updateOwner(String ownerId) {
    emit(state.copyWith(ownerId: ownerId));
  }

  void updateShared(bool shared) {
    emit(state.copyWith(shared: shared));
  }

  void updateRemoveOnResolution(bool remove) {
    emit(state.copyWith(removeOnResolution: remove));
  }

  void updateFavorite(bool favorite) {
    emit(state.copyWith(favorite: favorite));
  }

  void updatePermission(String type, TagPermissionScope scope) {
    final newPermissions = Map<String, TagPermissionScope>.from(state.permissions);
    newPermissions[type] = scope;
    emit(state.copyWith(permissions: newPermissions));
  }

  void updateSpecificUsers(List<String> userIds) {
    emit(state.copyWith(specificUserIds: userIds));
  }

  void updateSpecificGroups(List<String> groupIds) {
    emit(state.copyWith(specificGroupIds: groupIds));
  }

  void toggleSubscription(TagSubscriptionEvent event) {
    final newSubscriptions = List<TagSubscriptionEvent>.from(state.subscriptions);
    if (newSubscriptions.contains(event)) {
      newSubscriptions.remove(event);
    } else {
      newSubscriptions.add(event);
    }
    emit(state.copyWith(subscriptions: newSubscriptions));
  }

  Future<void> createTag({
    required String projectId,
    String? currentIssueId,
  }) async {
    if (state.name.trim().isEmpty) {
      emit(state.copyWith(nameError: 'Tag name is required'));
      return;
    }

    emit(state.copyWith(status: NewTagStatus.submitting));

    // 1. Check uniqueness
    final uniqueResult = await isTagNameUniqueUseCase(
      params: IsTagNameUniqueParams(name: state.name, projectId: projectId),
    );

    bool isUnique = false;
    uniqueResult.fold(
      (f) => emit(state.copyWith(status: NewTagStatus.failure, errorMessage: f.message)),
      (unique) => isUnique = unique,
    );

    if (!isUnique && state.status != NewTagStatus.failure) {
      emit(state.copyWith(
        status: NewTagStatus.initial,
        nameError: 'A tag with this name already exists',
      ));
      return;
    }

    if (state.status == NewTagStatus.failure) return;

    // 2. Create Tag
    final createResult = await createTagUseCase(
      params: CreateTagParams(
        name: state.name,
        projectId: projectId,
        ownerId: state.ownerId ?? '',
        shared: state.shared,
        removeOnResolution: state.removeOnResolution,
        favorite: state.favorite,
        permissions: state.permissions,
        specificUserIds: state.specificUserIds,
        specificGroupIds: state.specificGroupIds,
        subscriptions: state.subscriptions,
      ),
    );

    createResult.fold(
      (failure) => emit(state.copyWith(
        status: NewTagStatus.failure,
        errorMessage: failure.message,
      )),
      (tag) async {
        // 3. Associate with current issue if provided
        if (currentIssueId != null) {
          await associateTagUseCase(
            params: AssociateTagWithIssueParams(
              issueId: currentIssueId,
              tagId: tag.id,
            ),
          );
        }
        emit(state.copyWith(status: NewTagStatus.success, createdTag: tag));
      },
    );
  }
}
