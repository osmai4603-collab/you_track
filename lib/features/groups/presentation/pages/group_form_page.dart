import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/features/groups/presentation/bloc/groups_bloc.dart';
import 'package:issues_tracking/features/groups/presentation/bloc/groups_event.dart';
import 'package:issues_tracking/features/groups/presentation/bloc/groups_state.dart';

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

    return BlocBuilder<GroupsBloc, GroupsState>(
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
              _Header(group: group, colors: colors, textTheme: textTheme),
              const Divider(height: 1),
              _TabBarWidget(tabController: _tabController, colors: colors),
              const Divider(height: 1),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _MembersTab(colors: colors, textTheme: textTheme),
                    _RolesTab(colors: colors, textTheme: textTheme),
                    _ProjectTeamsTab(colors: colors, textTheme: textTheme),
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

  const _Header({
    required this.group,
    required this.colors,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
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
          IconButton(
            icon: const Icon(Icons.link, size: 18),
            onPressed: () {},
            tooltip: 'Copy link',
            visualDensity: VisualDensity.compact,
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert, size: 18),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'edit', child: Text('Edit')),
              const PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            onPressed: () {
              context.read<GroupsBloc>().add(const SelectGroup(null));
            },
            tooltip: 'Close',
            visualDensity: VisualDensity.compact,
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

class _MembersTab extends StatelessWidget {
  final ColorScheme colors;
  final TextTheme textTheme;

  const _MembersTab({required this.colors, required this.textTheme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.medium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FilledButton.icon(
                onPressed: () {},
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
          Text('No members yet', style: textTheme.bodySmall?.copyWith(
            color: colors.onSurfaceVariant,
          )),
        ],
      ),
    );
  }
}

class _RolesTab extends StatelessWidget {
  final ColorScheme colors;
  final TextTheme textTheme;

  const _RolesTab({required this.colors, required this.textTheme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.medium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FilledButton.icon(
                onPressed: () {},
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
          Text('No roles assigned', style: textTheme.bodySmall?.copyWith(
            color: colors.onSurfaceVariant,
          )),
        ],
      ),
    );
  }
}

class _ProjectTeamsTab extends StatelessWidget {
  final ColorScheme colors;
  final TextTheme textTheme;

  const _ProjectTeamsTab({required this.colors, required this.textTheme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.medium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FilledButton.icon(
                onPressed: () {},
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
          Text('Not linked to any projects', style: textTheme.bodySmall?.copyWith(
            color: colors.onSurfaceVariant,
          )),
        ],
      ),
    );
  }
}

class _SettingsTab extends StatelessWidget {
  final dynamic group;
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
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.medium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Field(
            label: 'Name',
            child: TextField(
              controller: nameController,
              decoration: const InputDecoration(isDense: true),
            ),
          ),
          const SizedBox(height: AppSpacing.medium),
          _Field(
            label: 'Description',
            child: TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(isDense: true),
            ),
          ),
          const SizedBox(height: AppSpacing.medium),
          _Field(
            label: 'Logo',
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(color: colors.outlineVariant),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.cloud_upload, color: colors.onSurfaceVariant, size: 24),
                    const SizedBox(height: 4),
                    Text(
                      'Upload a JPG, GIF, PNG, or SVG file.\nThe image is resized to 192x192 pixels.',
                      textAlign: TextAlign.center,
                      style: textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                        fontSize: 11,
                      ),
                    ),
                  ],
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
              selected: {group.autoJoin},
              onSelectionChanged: (v) {},
            ),
          ),
          const SizedBox(height: AppSpacing.medium),
          _Field(
            label: 'Auto-join domains',
            child: TextField(
              controller: domainsController,
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
              selected: {group.twoFactorAuth},
              onSelectionChanged: (v) {},
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
              selected: {group.groupType},
              onSelectionChanged: (v) {},
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
        Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w500,
        )),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}
