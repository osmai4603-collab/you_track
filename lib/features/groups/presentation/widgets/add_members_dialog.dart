import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/groups/domain/entities/group_member_entity.dart';
import 'package:issues_tracking/features/groups/presentation/bloc/groups_bloc.dart';
import 'package:issues_tracking/features/groups/presentation/bloc/groups_event.dart';
import 'package:issues_tracking/features/users/domain/entities/user_entity.dart';
import 'package:issues_tracking/features/users/domain/usecases/get_users.dart';

class AddMembersDialog extends StatefulWidget {
  final String groupId;
  final List<GroupMemberEntity> existingMembers;

  const AddMembersDialog({
    super.key,
    required this.groupId,
    required this.existingMembers,
  });

  static Future<void> show(
    BuildContext context,
    String groupId,
    List<GroupMemberEntity> existingMembers,
  ) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => BlocProvider.value(
        value: context.read<GroupsBloc>(),
        child: AddMembersDialog(
          groupId: groupId,
          existingMembers: existingMembers,
        ),
      ),
    );
  }

  @override
  State<AddMembersDialog> createState() => _AddMembersDialogState();
}

class _AddMembersDialogState extends State<AddMembersDialog> {
  final _getUsers = GetIt.I<GetUsers>();

  List<UserEntity>? _users;
  bool _isLoading = true;
  bool _isSubmitting = false;

  final _selectedUserIds = <String>{};
  Set<String> _existingUserIds = {};

  @override
  void initState() {
    super.initState();
    _existingUserIds = widget.existingMembers.map((m) => m.userId).toSet();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final result = await _getUsers(params: const NoParams());
    result.fold(
      (_) {
        if (!mounted) return;
        setState(() => _isLoading = false);
      },
      (users) {
        if (!mounted) return;
        setState(() {
          _users = users;
          _isLoading = false;
        });
      },
    );
  }

  void _onAddMembers() {
    if (_selectedUserIds.isEmpty) return;

    setState(() => _isSubmitting = true);

    if (!mounted) return;
    context.read<GroupsBloc>().add(
      AddGroupMembersEvent(
        groupId: widget.groupId,
        userIds: _selectedUserIds.toList(),
      ),
    );

    Navigator.pop(context, _selectedUserIds.toList());
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Card(
        margin: EdgeInsets.zero,
        child: SizedBox(
          width: 500,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Text(
                      'Add members',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: _isSubmitting
                          ? null
                          : () => Navigator.pop(context),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else ...[
                  Expanded(
                    child: SingleChildScrollView(
                      child: DataTable(
                        columnSpacing: 16,
                        headingRowHeight: 40,
                        dataRowMinHeight: 40,
                        dataRowMaxHeight: 48,
                        columns: [
                          DataColumn(
                            label: Text(
                              '',
                              style: textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'User',
                              style: textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Email',
                              style: textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                        rows:
                            _users?.map((user) {
                              final isExisting = _existingUserIds.contains(
                                user.id,
                              );
                              final isSelected = _selectedUserIds.contains(
                                user.id,
                              );
                              return DataRow(
                                selected: isSelected,
                                onSelectChanged: isExisting
                                    ? null
                                    : (selected) {
                                        if (selected == true) {
                                          setState(
                                            () => _selectedUserIds.add(user.id),
                                          );
                                        } else {
                                          setState(
                                            () => _selectedUserIds.remove(
                                              user.id,
                                            ),
                                          );
                                        }
                                      },
                                cells: [
                                  DataCell(
                                    Checkbox(
                                      value: isSelected || isExisting,
                                      onChanged: isExisting
                                          ? null
                                          : (value) {
                                              setState(() {
                                                if (value == true) {
                                                  _selectedUserIds.add(user.id);
                                                } else {
                                                  _selectedUserIds.remove(
                                                    user.id,
                                                  );
                                                }
                                              });
                                            },
                                    ),
                                  ),
                                  DataCell(
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CircleAvatar(
                                          radius: 14,
                                          backgroundColor:
                                              colors.primaryContainer,
                                          child: Text(
                                            user.initials,
                                            style: textTheme.bodySmall
                                                ?.copyWith(
                                                  color:
                                                      colors.onPrimaryContainer,
                                                  fontSize: 10,
                                                ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          user.fullName,
                                          style: textTheme.bodySmall?.copyWith(
                                            color: isExisting
                                                ? colors.onSurfaceVariant
                                                : colors.onSurface,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      user.email,
                                      style: textTheme.bodySmall?.copyWith(
                                        color: isExisting
                                            ? colors.onSurfaceVariant
                                            : colors.onSurface,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }).toList() ??
                            [],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: _isSubmitting
                            ? null
                            : () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        onPressed: _selectedUserIds.isNotEmpty && !_isSubmitting
                            ? _onAddMembers
                            : null,
                        child: _isSubmitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Add members'),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
