import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/core/services/supabase_storage_service.dart';
import 'package:issues_tracking/core/widgets/avatar_url_chip.dart';
import 'package:issues_tracking/core/widgets/project_chip.dart';
import 'package:issues_tracking/features/groups/domain/entities/group_entity.dart';
import 'package:issues_tracking/features/groups/presentation/bloc/groups_bloc.dart';
import 'package:issues_tracking/features/groups/presentation/bloc/groups_event.dart';
import 'package:issues_tracking/features/groups/presentation/bloc/groups_state.dart';
import 'package:issues_tracking/features/groups/presentation/widgets/add_members_dialog.dart';
import 'package:issues_tracking/features/groups/presentation/widgets/add_project_dialog.dart';
import 'package:issues_tracking/features/groups/presentation/widgets/assign_role_dialog.dart';
import 'package:issues_tracking/core/localization/app_localizations.dart';

class GroupFormPage extends StatefulWidget {
  const GroupFormPage({super.key});

  @override
  State<GroupFormPage> createState() => _GroupFormPageState();
}

class _GroupFormPageState extends State<GroupFormPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _domainsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _domainsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocConsumer<GroupsBloc, GroupsState>(
      listener: (context, state) {
        if (state is GroupsError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        if (state is! GroupsLoaded || state.selectedGroupId == null) {
          return const SizedBox.shrink();
        }

        final groupIndex = state.groups.indexWhere(
          (g) => g.id == state.selectedGroupId,
        );
        if (groupIndex == -1) {
          return const SizedBox.shrink();
        }
        final group = state.groups[groupIndex];

        _nameController.text = group.name;
        _descriptionController.text = group.description ?? '';
        _domainsController.text = group.autoJoinDomains.join(', ');

        return Container(
          width: 500,
          decoration: BoxDecoration(
            color: colors.surface,
            border: Border(left: BorderSide(color: colors.outlineVariant)),
          ),
          child: Column(
            children: [
              _Header(
                group: group,
                colors: colors,
                textTheme: textTheme,
                nameController: _nameController,
                descriptionController: _descriptionController,
                domainsController: _domainsController,
              ),
              const Divider(height: 1),
              _TabBarWidget(tabController: _tabController, colors: colors),
              const Divider(height: 1),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _MembersTab(
                      group: group,
                      colors: colors,
                      textTheme: textTheme,
                    ),
                    _RolesTab(
                      group: group,
                      colors: colors,
                      textTheme: textTheme,
                    ),
                    _ProjectTeamsTab(
                      group: group,
                      colors: colors,
                      textTheme: textTheme,
                    ),
                    _SettingsTab(
                      group: group,
                      nameController: _nameController,
                      descriptionController: _descriptionController,
                      domainsController: _domainsController,
                      colors: colors,
                      textTheme: textTheme,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  final dynamic group;
  final ColorScheme colors;
  final TextTheme textTheme;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController domainsController;

  const _Header({
    required this.group,
    required this.colors,
    required this.textTheme,
    required this.nameController,
    required this.descriptionController,
    required this.domainsController,
  });

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.medium,
        vertical: AppSpacing.small,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: colors.primaryContainer,
            child: group.logo != null
                ? ClipOval(
                    child: Image.network(
                      group.logo!,
                      width: 36,
                      height: 36,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Icon(
                        Icons.group,
                        size: 18,
                        color: colors.onPrimaryContainer,
                      ),
                    ),
                  )
                : Icon(Icons.group, size: 18, color: colors.onPrimaryContainer),
          ),
          const SizedBox(width: AppSpacing.small),
          Expanded(
            child: Text(
              group.name,
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colors.onSurface,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<GroupsBloc>().add(const SelectGroup(null));
            },
            child: Text(localization.cancelButton),
          ),
          const SizedBox(width: AppSpacing.small),
          FilledButton(
            onPressed: () {
              context.read<GroupsBloc>().add(
                UpdateGroupSettingsEvent(
                  groupId: group.id,
                  name: nameController.text,
                  description: descriptionController.text,
                  autoJoin: group.autoJoin,
                  autoJoinDomains: domainsController.text.isNotEmpty
                      ? domainsController.text
                            .split(',')
                            .map((e) => e.trim())
                            .where((e) => e.isNotEmpty)
                            .toList()
                      : const [],
                  twoFactorAuth: group.twoFactorAuth,
                  groupType: group.groupType,
                  logo: group.logo,
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings saved successfully')),
              );
              context.read<GroupsBloc>().add(const SelectGroup(null));
            },
            style: FilledButton.styleFrom(visualDensity: VisualDensity.compact),
            child: Text(localization.saveButton),
          ),
        ],
      ),
    );
  }
}

class _TabBarWidget extends StatelessWidget {
  final TabController tabController;
  final ColorScheme colors;

  const _TabBarWidget({required this.tabController, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colors.surface,
      child: TabBar(
        controller: tabController,
        isScrollable: true,
        labelColor: colors.onSurface,
        unselectedLabelColor: colors.onSurfaceVariant,
        indicatorColor: colors.primary,
        indicatorWeight: 2,
        tabs: const [
          Tab(text: 'Members'),
          Tab(text: 'Roles'),
          Tab(text: 'Project Teams'),
          Tab(text: 'Settings'),
        ],
      ),
    );
  }
}

class _MembersTab extends StatefulWidget {
  final GroupEntity group;
  final ColorScheme colors;
  final TextTheme textTheme;

  const _MembersTab({
    required this.group,
    required this.colors,
    required this.textTheme,
  });

  @override
  State<_MembersTab> createState() => _MembersTabState();
}

class _MembersTabState extends State<_MembersTab> {
  @override
  Widget build(BuildContext context) {
    final members = widget.group.members;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.medium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FilledButton.icon(
                onPressed: () async {
                  final result = await AddMembersDialog.show(
                    context,
                    widget.group.id,
                    members,
                  );
                  if (result != null && result.isNotEmpty && context.mounted) {
                    context.read<GroupsBloc>().add(
                          AddGroupMembersEvent(
                            groupId: widget.group.id,
                            userIds: result,
                          ),
                        );
                  }
                },
                icon: const Icon(Icons.person_add, size: 16),
                label: const Text('Add members'),
              ),
              const SizedBox(width: AppSpacing.small),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search for text or add a filter',
                    isDense: true,
                    prefixIcon: Icon(Icons.search, size: 18),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.medium),
          if (members.isEmpty)
            Text(
              'No members yet',
              style: widget.textTheme.bodySmall?.copyWith(
                color: widget.colors.onSurfaceVariant,
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                itemCount: members.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final member = members[index];
                  return Material(
                    color: Colors.transparent,
                    child: ListTile(
                      leading: AvatarUrlChip(
                        avatarUrl: members[index].user?.avatarUrl,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 4,
                      ),
                      title: Text(member.user?.userName ?? ''),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          size: 18,
                          color: widget.colors.error,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _RolesTab extends StatelessWidget {
  final GroupEntity group;
  final ColorScheme colors;
  final TextTheme textTheme;

  const _RolesTab({
    required this.group,
    required this.colors,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    final groupRoles = group.roles;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.medium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FilledButton.icon(
                onPressed: () async {
                  final result = await AssignRoleDialog.show(context, group.id);
                  if (result != null && context.mounted) {
                    context.read<GroupsBloc>().add(
                          AssignRoleEvent(
                            groupId: group.id,
                            roleName: result.roleName,
                            projectId: result.projectId,
                            isGlobal: result.projectId == null,
                          ),
                        );
                  }
                },
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Assign role'),
              ),
              const SizedBox(width: AppSpacing.small),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search...',
                    isDense: true,
                    prefixIcon: Icon(Icons.search, size: 18),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.medium),
          if (groupRoles.isEmpty)
            Text(
              'No roles assigned',
              style: textTheme.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                itemCount: groupRoles.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final role = groupRoles[index];
                  return Material(
                    color: Colors.transparent,
                    child: ListTile(
                      leading: ProjectChip(
                        colors: colors,
                        textTheme: textTheme,
                        shortKey: role.project?.projectId ?? '',
                      ),
                      title: Text(role.roleName),
                      subtitle: Text(role.project?.projectName ?? ''),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          size: 16,
                          color: colors.error,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _ProjectTeamsTab extends StatelessWidget {
  final GroupEntity group;
  final ColorScheme colors;
  final TextTheme textTheme;

  const _ProjectTeamsTab({
    required this.group,
    required this.colors,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    final projects = group.projects;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.medium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FilledButton.icon(
                onPressed: () async {
                  final result = await AddProjectDialog.show(
                    context,
                    group.id,
                    projects,
                  );
                  if (result != null && result.isNotEmpty && context.mounted) {
                    context.read<GroupsBloc>().add(
                          AddGroupProjectsEvent(
                            groupId: group.id,
                            projectIds: result,
                          ),
                        );
                  }
                },
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add to project'),
              ),
              const SizedBox(width: AppSpacing.small),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search project...',
                    isDense: true,
                    prefixIcon: Icon(Icons.search, size: 18),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.medium),
          if (projects.isEmpty)
            Text(
              'Not linked to any projects',
              style: textTheme.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                itemCount: projects.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final project = projects[index];
                  return Material(
                    color: Colors.transparent,
                    child: ListTile(
                      leading: ProjectChip(
                        colors: colors,
                        textTheme: textTheme,
                        shortKey: project.project?.projectId ?? '',
                      ),
                      title: Text(project.project?.projectName ?? ''),
                      subtitle: Text(project.project?.projectId ?? ''),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          size: 18,
                          color: colors.error,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _SettingsTab extends StatefulWidget {
  final GroupEntity group;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController domainsController;
  final ColorScheme colors;
  final TextTheme textTheme;

  const _SettingsTab({
    required this.group,
    required this.nameController,
    required this.descriptionController,
    required this.domainsController,
    required this.colors,
    required this.textTheme,
  });

  @override
  State<_SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<_SettingsTab> {
  late bool _autoJoin;
  late String _twoFactorAuth;
  late String _groupType;
  String? _logoUrl;
  bool _isUploadingLogo = false;

  @override
  void initState() {
    super.initState();
    _autoJoin = widget.group.autoJoin;
    _twoFactorAuth = widget.group.twoFactorAuth;
    _groupType = widget.group.groupType;
    _logoUrl = widget.group.logo;
  }

  void _save() {
    context.read<GroupsBloc>().add(
      UpdateGroupSettingsEvent(
        groupId: widget.group.id,
        name: widget.nameController.text,
        description: widget.descriptionController.text,
        autoJoin: _autoJoin,
        autoJoinDomains: widget.domainsController.text.isNotEmpty
            ? widget.domainsController.text
                  .split(',')
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty)
                  .toList()
            : const [],
        twoFactorAuth: _twoFactorAuth,
        groupType: _groupType,
        logo: _logoUrl,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings saved successfully')),
    );
  }

  Future<void> _pickAndUploadLogo() async {
    try {
      final result = await FilePicker.pickFiles(type: FileType.image);

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        setState(() => _isUploadingLogo = true);

        final fileName =
            '${widget.group.id}_${DateTime.now().millisecondsSinceEpoch}';
        final storageService = SupabaseStorageService();

        final stream = storageService.uploadFile(path: fileName, file: file);

        await for (final state in stream) {
          if (state.status == UploadStatus.success) {
            setState(() {
              _logoUrl = state.downloadUrl;
              _isUploadingLogo = false;
            });
            _save();
            break;
          } else if (state.status == UploadStatus.failure) {
            setState(() => _isUploadingLogo = false);
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage ?? 'Upload failed')),
              );
            }
            break;
          }
        }
      }
    } catch (e) {
      setState(() => _isUploadingLogo = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to pick image: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.medium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Field(
            label: 'Name',
            child: TextField(
              controller: widget.nameController,
              decoration: const InputDecoration(isDense: true),
            ),
          ),
          const SizedBox(height: AppSpacing.medium),
          _Field(
            label: 'Description',
            child: TextField(
              controller: widget.descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(isDense: true),
            ),
          ),
          const SizedBox(height: AppSpacing.medium),
          _Field(
            label: 'Logo',
            child: InkWell(
              onTap: _isUploadingLogo ? null : _pickAndUploadLogo,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: widget.colors.outlineVariant),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _isUploadingLogo
                    ? const Center(child: CircularProgressIndicator())
                    : _logoUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(_logoUrl!, fit: BoxFit.cover),
                      )
                    : Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.cloud_upload,
                              color: widget.colors.onSurfaceVariant,
                              size: 24,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Upload a JPG, GIF, PNG, or SVG file.\nThe image is resized to 192x192 pixels.',
                              textAlign: TextAlign.center,
                              style: widget.textTheme.bodySmall?.copyWith(
                                color: widget.colors.onSurfaceVariant,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.medium),
          _Field(
            label: 'Auto-join',
            child: SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: false, label: Text('Disabled')),
                ButtonSegment(value: true, label: Text('Enabled')),
              ],
              selected: {_autoJoin},
              onSelectionChanged: (v) {
                setState(() => _autoJoin = v.first);
                _save();
              },
            ),
          ),
          const SizedBox(height: AppSpacing.medium),
          _Field(
            label: 'Auto-join domains',
            child: TextField(
              controller: widget.domainsController,
              decoration: const InputDecoration(
                isDense: true,
                hintText: 'example.com',
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.medium),
          _Field(
            label: 'Two-factor authentication',
            child: SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'optional', label: Text('Optional')),
                ButtonSegment(value: 'required', label: Text('Required')),
              ],
              selected: {_twoFactorAuth},
              onSelectionChanged: (v) {
                setState(() => _twoFactorAuth = v.first);
                _save();
              },
            ),
          ),
          const SizedBox(height: AppSpacing.medium),
          _Field(
            label: 'Group type',
            child: SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'users', label: Text('Users')),
                ButtonSegment(value: 'teams', label: Text('Teams')),
              ],
              selected: {_groupType},
              onSelectionChanged: (v) {
                setState(() => _groupType = v.first);
                _save();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final Widget child;

  const _Field({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}
