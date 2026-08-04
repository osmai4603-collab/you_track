import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/constants/app_radius.dart';
import 'package:issues_tracking/core/init_dependencies.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/groups/domain/entities/group_entity.dart';
import 'package:issues_tracking/features/groups/presentation/bloc/groups_bloc.dart';
import 'package:issues_tracking/features/groups/presentation/bloc/groups_event.dart';
import 'package:issues_tracking/features/groups/presentation/bloc/groups_state.dart';
import 'package:issues_tracking/features/roles/presentation/bloc/roles_bloc.dart';
import 'package:issues_tracking/features/roles/presentation/bloc/roles_event.dart';
import 'package:issues_tracking/features/roles/presentation/bloc/roles_state.dart';
import 'package:issues_tracking/features/users/domain/entities/user_entity.dart';
import 'package:issues_tracking/features/users/domain/usecases/get_users.dart';
import '../cubits/project_members_cubit.dart';

class AddProjectMembersPage extends StatefulWidget {
  final String projectId;

  const AddProjectMembersPage({super.key, required this.projectId});

  static void show(BuildContext context, {required String projectId}) {
    showDialog(
      context: context,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: get_it<ProjectMembersCubit>()),
          BlocProvider.value(
            value: get_it<GroupsBloc>()..add(const LoadGroups()),
          ),
          BlocProvider.value(
            value: get_it<RolesBloc>()..add(const LoadRoles()),
          ),
        ],
        child: AddProjectMembersPage(projectId: projectId),
      ),
    );
  }

  @override
  State<AddProjectMembersPage> createState() => _AddProjectMembersPageState();
}

class _SelectedMember {
  final bool isSelected;
  final String role;
  final bool isGroup;

  const _SelectedMember({
    required this.isSelected,
    required this.role,
    required this.isGroup,
  });

  _SelectedMember copyWith({bool? isSelected, String? role, bool? isGroup}) {
    return _SelectedMember(
      isSelected: isSelected ?? this.isSelected,
      role: role ?? this.role,
      isGroup: isGroup ?? this.isGroup,
    );
  }
}

class _AddProjectMembersPageState extends State<AddProjectMembersPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final Map<String, _SelectedMember> _selectedMembers = {};
  final Set<String> _removedRows = {};

  List<UserEntity> _allUsers = [];
  bool _isLoadingUsers = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _loadUsers() async {
    final result = await get_it<GetUsers>()(params: const NoParams());
    if (!mounted) return;
    result.fold(
      (_) => setState(() => _isLoadingUsers = false),
      (users) => setState(() {
        _allUsers = users;
        _isLoadingUsers = false;
      }),
    );
  }

  List<String> get _currentAvailableRoles {
    final groupState = context.read<GroupsBloc>().state;
    if (groupState is GroupsLoaded) {
      final roles = groupState.groups
          .expand((g) => g.roles)
          .where((r) => r.projectId == widget.projectId)
          .map((r) => r.roleName.trim())
          .where((r) => r.isNotEmpty)
          .toSet()
          .toList();
      if (roles.isNotEmpty) return roles;
    }

    final state = context.read<RolesBloc>().state;
    if (state is RolesLoaded) {
      return state.roles.map((r) => r.name).toList();
    }
    return ['Contributor'];
  }

  List<GroupEntity> get _currentAvailableGroups {
    final state = context.read<GroupsBloc>().state;
    if (state is GroupsLoaded) {
      return state.groups;
    }
    return [];
  }

  Set<String> get _currentMemberUserIds {
    final members = context.read<ProjectMembersCubit>().state.members;
    return members.map((m) => m.userId).where((id) => id.isNotEmpty).toSet();
  }

  Set<String> get _currentProjectGroupIds {
    final state = context.read<GroupsBloc>().state;
    if (state is GroupsLoaded) {
      return state.groups
          .where((g) => g.projects.any((p) => p.projectId == widget.projectId))
          .map((g) => g.id)
          .toSet();
    }
    return {};
  }

  List<UserEntity> get _filteredUsers {
    final query = _controller.text.toLowerCase();
    final memberIds = _currentMemberUserIds;
    return _allUsers.where((u) {
      if (memberIds.contains(u.id)) return false;
      if (_removedRows.contains(u.id)) return false;
      if (query.isEmpty) return true;
      return u.username.toLowerCase().contains(query) ||
          u.email.toLowerCase().contains(query);
    }).toList();
  }

  List<GroupEntity> get _filteredGroups {
    final query = _controller.text.toLowerCase();
    final projectGroupIds = _currentProjectGroupIds;
    return _currentAvailableGroups.where((g) {
      if (projectGroupIds.contains(g.id)) return false;
      if (_removedRows.contains(g.id)) return false;
      if (query.isEmpty) return true;
      return g.name.toLowerCase().contains(query);
    }).toList();
  }

  bool get _hasResults =>
      _filteredUsers.isNotEmpty || _filteredGroups.isNotEmpty;

  bool get _isTyping => _controller.text.isNotEmpty;

  void _toggleMember(String id, bool isGroup) {
    setState(() {
      final current = _selectedMembers[id];
      if (current != null) {
        _selectedMembers[id] = current.copyWith(
          isSelected: !current.isSelected,
        );
      } else {
        _selectedMembers[id] = _SelectedMember(
          isSelected: true,
          role: 'Contributor',
          isGroup: isGroup,
        );
      }
    });
  }

  void _updateRole(String id, String newRole, bool isGroup) {
    setState(() {
      final current = _selectedMembers[id];
      if (current != null) {
        _selectedMembers[id] = current.copyWith(role: newRole);
      } else {
        _selectedMembers[id] = _SelectedMember(
          isSelected: false,
          role: newRole,
          isGroup: isGroup,
        );
      }
    });
  }

  void _removeMember(String id) {
    setState(() {
      _removedRows.add(id);
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _invite() async {
    final messenger = ScaffoldMessenger.of(context);
    final cubit = context.read<ProjectMembersCubit>();
    final groupsBloc = context.read<GroupsBloc>();
    final memberUserIds = _currentMemberUserIds;
    final projectGroupIds = _currentProjectGroupIds;

    final selectedIds = _selectedMembers.entries
        .where((e) => e.value.isSelected && !_removedRows.contains(e.key))
        .map((e) => e.key)
        .toList();

    if (selectedIds.isEmpty) {
      final email = _controller.text.trim();
      if (email.isEmpty) {
        _showMessage('Select at least one user or group to add');
        return;
      }
      if (!email.contains('@')) {
        _showMessage('Enter a valid email address');
        return;
      }
      final user = _allUsers
          .where((u) => u.email.toLowerCase() == email.toLowerCase())
          .firstOrNull;
      if (user == null) {
        _showMessage('No user found with this email');
        return;
      }
      if (memberUserIds.contains(user.id)) {
        _showMessage('This user is already a member of the project');
        return;
      }
      setState(() => _isSaving = true);
      final ok = await cubit.addMember(
        projectId: widget.projectId,
        name: user.username,
        email: user.email,
        roles: const ['Contributor'],
        userId: user.id,
      );
      if (!mounted) return;
      setState(() => _isSaving = false);
      if (!ok) {
        messenger.showSnackBar(
          const SnackBar(content: Text('Failed to add member')),
        );
        return;
      }
      Navigator.pop(context);
      return;
    }

    setState(() => _isSaving = true);
    var hasError = false;

    for (final id in selectedIds) {
      final memberState = _selectedMembers[id];
      if (memberState == null) continue;

      if (memberState.isGroup) {
        if (!projectGroupIds.contains(id)) {
          groupsBloc.add(
            AddGroupProjectsEvent(
              groupId: id,
              projectIds: [widget.projectId],
            ),
          );
        }
        groupsBloc.add(
          AssignRoleEvent(
            groupId: id,
            roleName: memberState.role,
            projectId: widget.projectId,
          ),
        );
      } else {
        final user = _allUsers.where((u) => u.id == id).firstOrNull;
        if (user == null || memberUserIds.contains(user.id)) continue;
        final ok = await cubit.addMember(
          projectId: widget.projectId,
          name: user.username,
          email: user.email,
          roles: [memberState.role],
          userId: user.id,
        );
        if (!ok) hasError = true;
      }
    }

    if (!mounted) return;
    setState(() => _isSaving = false);
    if (hasError) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Some members could not be added')),
      );
      return;
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    context.watch<RolesBloc>();
    context.watch<GroupsBloc>();

    final textTheme = Theme.of(context).textTheme;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.mediumBorderRadius),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Add People', style: textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text(
                  'You can add users who already have YouTrack accounts or invite new users by email',
                  style: textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText:
                        'Select users and groups or enter an email address',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: AppRadius.extraSmallBorderRadius,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildMembersTableCard(),
                const SizedBox(height: 16),
                Row(
                  children: [
                    FilledButton(
                      onPressed: _isSaving ? null : _invite,
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Invite'),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const Spacer(),
                    Text(
                      'Standard user licenses: 8',
                      style: textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMembersTableCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: AppRadius.smallBorderRadius,
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTableHeader(),
          if (_isLoadingUsers && _filteredGroups.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else if (!_hasResults && _isTyping)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                'No members found',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
              ),
            )
          else if (!_hasResults && !_isTyping)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                'No members available to add',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
              ),
            )
          else ...[
            if (_filteredGroups.isNotEmpty) ...[
              ..._filteredGroups.map((group) => _buildGroupRow(group)),
            ],
            if (_filteredGroups.isNotEmpty && _filteredUsers.isNotEmpty)
              Divider(height: 1, color: Colors.grey.shade200),
            if (_filteredUsers.isNotEmpty) ...[
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _filteredUsers.length,
                itemBuilder: (_, i) => _buildUserRow(_filteredUsers[i]),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              'Name',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade500,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Add to team',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade500,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Roles',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade500,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(width: 32),
        ],
      ),
    );
  }

  Widget _buildUserRow(UserEntity member) {
    final initials = member.username
        .split(' ')
        .map((w) => w.isNotEmpty ? w[0] : '')
        .join();
    final selected = _selectedMembers[member.id];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.blue.shade100,
                  child: Text(
                    initials.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member.username,
                        style: const TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        member.email,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Switch(
              value: selected?.isSelected ?? false,
              onChanged: (_) => _toggleMember(member.id, false),
              activeThumbColor: Colors.blue,
            ),
          ),
          Expanded(
            flex: 2,
            child: _buildRoleDropdown(
              member.id,
              selected?.role ?? 'Contributor',
              false,
            ),
          ),
          SizedBox(
            width: 32,
            child: IconButton(
              icon: Icon(Icons.close, size: 18, color: Colors.grey.shade500),
              onPressed: () => _removeMember(member.id),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupRow(GroupEntity group) {
    final selected = _selectedMembers[group.id];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Icon(Icons.group, size: 28, color: Colors.grey.shade400),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    group.name,
                    style: const TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Switch(
              value: selected?.isSelected ?? false,
              onChanged: (_) => _toggleMember(group.id, true),
              activeThumbColor: Colors.blue,
            ),
          ),
          Expanded(
            flex: 2,
            child: _buildRoleDropdown(
              group.id,
              selected?.role ?? 'Contributor',
              true,
            ),
          ),
          SizedBox(
            width: 32,
            child: IconButton(
              icon: Icon(Icons.close, size: 18, color: Colors.grey.shade500),
              onPressed: () => _removeMember(group.id),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleDropdown(String memberId, String currentRole, bool isGroup) {
    final available = _currentAvailableRoles;
    if (available.isEmpty) return const SizedBox.shrink();

    final validRole = available.contains(currentRole)
        ? currentRole
        : available.first;

    return DropdownButton<String>(
      value: validRole,
      isDense: true,
      underline: const SizedBox(),
      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
      items: available.map((role) {
        return DropdownMenuItem(value: role, child: Text(role));
      }).toList(),
      onChanged: (newRole) {
        if (newRole != null) {
          _updateRole(memberId, newRole, isGroup);
        }
      },
    );
  }
}
