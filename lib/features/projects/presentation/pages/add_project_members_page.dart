import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/constants/app_radius.dart';
import 'package:issues_tracking/core/init_dependencies.dart';
import 'package:issues_tracking/features/groups/domain/entities/group_entity.dart';
import 'package:issues_tracking/features/groups/presentation/bloc/groups_bloc.dart';
import 'package:issues_tracking/features/groups/presentation/bloc/groups_event.dart';
import 'package:issues_tracking/features/groups/presentation/bloc/groups_state.dart';
import 'package:issues_tracking/features/roles/presentation/bloc/roles_bloc.dart';
import 'package:issues_tracking/features/roles/presentation/bloc/roles_event.dart';
import 'package:issues_tracking/features/roles/presentation/bloc/roles_state.dart';
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
          BlocProvider.value(value: get_it<GroupsBloc>()..add(const LoadGroups())),
          BlocProvider.value(value: get_it<RolesBloc>()..add(const LoadRoles())),
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

  @override
  void initState() {
    super.initState();
    _initializeSelectedMembers();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _initializeSelectedMembers() {
    final members = context.read<ProjectMembersCubit>().state.members;
    for (final member in members) {
      _selectedMembers[member.id] = _SelectedMember(
        isSelected: false,
        role: member.roles.firstOrNull ?? 'Contributor',
        isGroup: false,
      );
    }
  }

  List<String> get _currentAvailableRoles {
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

  List<dynamic> get _filteredUsers {
    final query = _controller.text.toLowerCase();
    final members = context.read<ProjectMembersCubit>().state.members;
    return members.where((m) {
      if (_removedRows.contains(m.id)) return false;
      if (query.isEmpty) return true;
      return m.name.toLowerCase().contains(query) ||
          m.email.toLowerCase().contains(query);
    }).toList();
  }

  List<GroupEntity> get _filteredGroups {
    final query = _controller.text.toLowerCase();
    return _currentAvailableGroups.where((g) {
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

  void _invite() {
    final selectedIds = _selectedMembers.entries
        .where((e) => e.value.isSelected && !_removedRows.contains(e.key))
        .map((e) => e.key)
        .toList();

    if (selectedIds.isEmpty && _controller.text.trim().isNotEmpty) {
      final value = _controller.text.trim();
      if (value.contains('@')) {
        context.read<ProjectMembersCubit>().addMember(
          projectId: widget.projectId,
          name: value.split('@').first,
          email: value,
          roles: const ['Contributor'],
          userId: '',
        );
      }
    } else {
      for (final id in selectedIds) {
        final memberState = _selectedMembers[id];
        if (memberState == null) continue;

        if (memberState.isGroup) {
          context.read<GroupsBloc>().add(AddGroupProjectsEvent(
                groupId: id,
                projectIds: [widget.projectId],
              ));
          context.read<GroupsBloc>().add(AssignRoleEvent(
                groupId: id,
                roleName: memberState.role,
                projectId: widget.projectId,
              ));
        } else {
          final members = context.read<ProjectMembersCubit>().state.members;
          try {
            final memberData = members.firstWhere((m) => m.id == id);
            context.read<ProjectMembersCubit>().addMember(
              projectId: widget.projectId,
              name: memberData.name,
              email: memberData.email,
              roles: [memberState.role],
              userId: memberData.userId,
            );
          } catch (e) {
          }
        }
      }
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
                  hintText: 'Select users and groups or enter an email address',
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
                    onPressed: _invite,
                    style: FilledButton.styleFrom(backgroundColor: Colors.blue),
                    child: const Text('Invite'),
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
    );
  }

  Widget _buildMembersTableCard() {
    return Container(
      constraints: const BoxConstraints(maxHeight: 320),
      decoration: BoxDecoration(
        borderRadius: AppRadius.smallBorderRadius,
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTableHeader(),
          if (!_hasResults && _isTyping)
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
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _filteredUsers.length,
                  itemBuilder: (_, i) => _buildUserRow(_filteredUsers[i]),
                ),
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

  Widget _buildUserRow(dynamic member) {
    final memberData = member as dynamic;
    final initials = (memberData.name as String)
        .split(' ')
        .map((w) => w.isNotEmpty ? w[0] : '')
        .join();
    final selected = _selectedMembers[memberData.id];

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
                        memberData.name,
                        style: const TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        memberData.email,
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
              onChanged: (_) => _toggleMember(memberData.id, false),
              activeThumbColor: Colors.blue,
            ),
          ),
          Expanded(
            flex: 2,
            child: _buildRoleDropdown(
              memberData.id,
              selected?.role ?? 'Contributor',
              false,
            ),
          ),
          SizedBox(
            width: 32,
            child: IconButton(
              icon: Icon(Icons.close, size: 18, color: Colors.grey.shade500),
              onPressed: () => _removeMember(memberData.id),
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
            child: _buildRoleDropdown(group.id, selected?.role ?? 'Contributor', true),
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
    
    final validRole = available.contains(currentRole) ? currentRole : available.first;

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
