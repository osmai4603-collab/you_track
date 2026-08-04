import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/enums/issue_priority_type_enum.dart';
import 'package:issues_tracking/core/enums/issue_state_enum.dart';
import 'package:issues_tracking/core/enums/issue_type_enum.dart';
import 'package:issues_tracking/core/init_dependencies.dart';
import 'package:issues_tracking/core/localization/app_localizations.dart';
import 'package:issues_tracking/core/widgets/avatar_url_chip.dart';
import 'package:issues_tracking/core/widgets/issue_priority_chip.dart';
import 'package:issues_tracking/core/widgets/issue_state_chip.dart';
import 'package:issues_tracking/features/issues/presentation/cubits/issue_form_cubit.dart';
import 'package:issues_tracking/features/issues/presentation/pages/issue_form.dart';
import 'package:issues_tracking/features/issues/presentation/widgets/add_sprint_dialog.dart';
import 'package:issues_tracking/features/issues/presentation/widgets/add_subsystem_dialog.dart';
import 'package:issues_tracking/features/issues/presentation/widgets/new_tag_dialog.dart';
import 'package:issues_tracking/features/issues/presentation/widgets/add_build_dialog.dart';
import 'package:issues_tracking/features/issues/presentation/widgets/add_link_dialog.dart';
import 'package:issues_tracking/features/projects/domain/entities/project_entity.dart';
import 'package:issues_tracking/features/projects/domain/entities/subsystem_entity.dart';
import 'package:issues_tracking/features/projects/domain/usecases/get_subsystems_use_case.dart';
import 'package:issues_tracking/features/projects/presentation/widgets/project_icon.dart';

class IssueFormSidebar extends StatelessWidget {
  const IssueFormSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final textTheme = TextTheme.of(context);
    final colors = ColorScheme.of(context);
    final cubit = context.watch<IssueFormCubit>();
    return Container(
      width: 280,
      decoration: ShapeDecoration(
        color: ColorScheme.of(context).surfaceContainerHigh,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      padding: const EdgeInsets.all(12),
      child: SingleChildScrollView(
        child: Column(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: .centerEnd,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${cubit.state.isEditing ? 0 : 0}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  IconButton(
                    onPressed: () =>
                        context.read<IssueFormCubit>().toggleFavorite(),
                    icon: Icon(
                      cubit.state.isFavorite ? Icons.star : Icons.star_border,
                      size: 20,
                      color: cubit.state.isFavorite
                          ? Colors.amber
                          : Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
            ),
            CompactFieldWidget(
              label: 'Project',
              trailing: cubit.state.project == null
                  ? null
                  : ProjectIcon(projectCode: cubit.state.project!.projectKey),
              value: cubit.state.project?.name ?? 'No project selected',
              onTap: () => _showProjectPicker(context),
            ),
            CompactFieldWidget(
              label: 'Priority',
              value: cubit.state.priority.displayName(localization),
              trailing: IssuePriorityChip(
                textTheme: textTheme,
                colors: colors,
                localization: localization,
                type: cubit.state.priority,
              ),
              onTap: () => _showPriorityPicker(
                context,
                cubit.state.priority,
                localization,
              ),
            ),
            CompactFieldWidget(
              label: 'State',
              value: cubit.state.state.displayName(localization),
              trailing: IssueStateChip(
                textTheme: textTheme,
                colors: colors,
                localization: localization,
                state: cubit.state.state,
              ),
              onTap: () =>
                  _showStatePicker(context, cubit.state.state, localization),
            ),
            CompactFieldWidget(
              label: 'Type',
              trailing: IssueTypeChip(
                textTheme: textTheme,
                colors: colors,
                localization: localization,
                type: cubit.state.issueType,
              ),
              value: cubit.state.issueType.displayName(localization),
              onTap: () =>
                  _showTypePicker(context, cubit.state.issueType, localization),
            ),
            CompactFieldWidget(
              label: 'Assignee',
              trailing: cubit.state.assignee == null
                  ? null
                  : AvatarUrlChip(avatarUrl: cubit.state.assignee?.avatarUrl),
              value: cubit.state.assignee?.name ?? 'Unassigned',
              onTap: () => _showAssigneePicker(context, cubit),
            ),
            CompactFieldWidget(
              label: 'Subsystem',
              trailing: cubit.state.subsystem == null
                  ? null
                  : IssueSubsystemChip(subsystem: cubit.state.subsystem!),
              value: cubit.state.subsystem?.name ?? 'No Subsystem',
              onTap: () => _showSubsystemPicker(
                context,
                cubit.state.subsystem,
                localization,
                cubit.subsystems,
              ),
            ),
            CompactFieldWidget(
              label: 'Fix versions',
              value: cubit.state.fixVersions.isEmpty
                  ? 'Unscheduled'
                  : cubit.state.fixVersions,
              onTap: () => _showTextPicker(
                context,
                'Fix versions',
                cubit.state.fixVersions,
                (v) => context.read<IssueFormCubit>().updateFixVersions(v),
              ),
            ),
            CompactFieldWidget(
              label: 'Fixed in build',
              value: cubit.state.build?.name ?? 'Next Build',
              onTap: () => _showBuildPicker(context, cubit),
            ),
            CompactFieldWidget(
              label: 'Sprints',
              value: cubit.availableSprints.isEmpty
                  ? 'No Sprints'
                  : cubit.availableSprints.map((s) => s.name).join(', '),
              onTap: () => _showSprintsPicker(context, cubit),
            ),
            CompactFieldWidget(
              label: 'Estimation',
              value: cubit.state.estimation != null
                  ? '${cubit.state.estimation!.inHours}h ${cubit.state.estimation!.inMinutes % 60}m'
                  : '?',
              onTap: () => _showDurationPicker(
                context,
                'Estimation',
                cubit.state.estimation,
                (duration) =>
                    context.read<IssueFormCubit>().updateEstimation(duration),
              ),
            ),
            CompactFieldWidget(
              label: 'Spent time',
              value: cubit.state.spentTime != null
                  ? '${cubit.state.spentTime!.inHours}h ${cubit.state.spentTime!.inMinutes % 60}m'
                  : '?',
              onTap: () => _showDurationPicker(
                context,
                'Spent time',
                cubit.state.spentTime,
                (duration) =>
                    context.read<IssueFormCubit>().updateSpentTime(duration),
              ),
            ),
            CompactFieldWidget(
              label: 'Tags',
              value: cubit.tags.isEmpty
                  ? 'Add tags...'
                  : cubit.tags.map((t) => t.name).join(', '),
              onTap: () => _showTagsPicker(context, cubit),
            ),
            CompactFieldWidget(
              label: 'Links',
              value: cubit.links.isEmpty
                  ? 'Add links...'
                  : '${cubit.links.length} links',
              onTap: () => _showLinksPicker(context, cubit),
            ),
          ],
        ),
      ),
    );
  }

  void _showSubsystemPicker(
    BuildContext context,
    SubsystemEntity? current,
    AppLocalizations localization,
    List<SubsystemEntity> availableSubsystems,
  ) async {
    final cubit = context.read<IssueFormCubit>();

    if (context.mounted == false) return;
    final result = await showModalBottomSheet(
      context: context,
      builder: (contextModal) => _PickerSheet(
        title: 'Subsystem',
        children: [
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('New Subsystem'),
            onTap: () {
              Navigator.pop(contextModal, 'new system');
            },
          ),
          ...cubit.subsystems.map(
            (subsystem) => ListTile(
              title: Text(subsystem.name),
              trailing: subsystem.id == current?.id
                  ? const Icon(Icons.check)
                  : null,
              onTap: () => Navigator.pop(contextModal, subsystem),
            ),
          ),
        ],
      ),
    );
    if (result == null) return;
    if (result is String && context.mounted) {
      final subsystem = await AddSubsystemDialog.show(
        context,
        projectId: cubit.state.project!.id,
      );
      if (subsystem != null && context.mounted) {
        cubit.updateSubsystem(subsystem);
      }
      return;
    }
    if (result is SubsystemEntity) {
      cubit.updateSubsystem(result);
    }
  }

  void _showProjectPicker(BuildContext context) async {
    final cubit = context.read<IssueFormCubit>();
    if (cubit.availableProjects.isEmpty) return;

    final projectSelected = await showModalBottomSheet<ProjectEntity>(
      context: context,
      builder: (sheetContext) => _PickerSheet(
        title: 'Project',
        children: cubit.availableProjects
            .map(
              (project) => ListTile(
                leading: ProjectIcon(projectCode: project.projectKey),
                title: Text(project.name),
                subtitle: Text(project.projectKey),
                trailing: project.projectKey == cubit.state.project?.projectKey
                    ? const Icon(Icons.check)
                    : null,
                onTap: () {
                  Navigator.pop(sheetContext, project);
                },
              ),
            )
            .toList(),
      ),
    );
    if (projectSelected != null && context.mounted) {
      cubit.updateProject(projectSelected);
    }
  }

  void _showAssigneePicker(BuildContext context, IssueFormCubit state) {
    if (state.projectMembers.isEmpty) return;
    final cubit = context.read<IssueFormCubit>();
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => _PickerSheet(
        title: 'Assignee',
        children: [
          ListTile(
            leading: const CircleAvatar(
              radius: 12,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person_off, size: 16, color: Colors.white),
            ),
            title: const Text('Unassigned'),
            trailing: state.state.assignee == null
                ? const Icon(Icons.check)
                : null,
            onTap: () {
              cubit.clearAssignee();
              Navigator.pop(sheetContext);
            },
          ),
          ...state.projectMembers.map(
            (m) => ListTile(
              leading: CircleAvatar(
                radius: 12,
                backgroundImage: m.avatarUrl != null
                    ? NetworkImage(m.avatarUrl!)
                    : null,
                backgroundColor: YTColors.mainColor,
                child: m.avatarUrl == null
                    ? Text(
                        m.name.isNotEmpty ? m.name[0].toUpperCase() : '?',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      )
                    : null,
              ),
              title: Text(m.name),
              subtitle: Text(m.email),
              trailing: m.id == state.state.assignee?.id
                  ? const Icon(Icons.check)
                  : null,
              onTap: () {
                cubit.updateAssignee(m);
                Navigator.pop(sheetContext);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showTextPicker(
    BuildContext context,
    String title,
    String current,
    Function(String) onSelected,
  ) {
    final controller = TextEditingController(text: current);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(
                labelText: title,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    onSelected(controller.text);
                    Navigator.pop(context);
                  },
                  child: const Text('Set'),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showPriorityPicker(
    BuildContext context,
    IssuePriorityTypeEnum current,
    AppLocalizations localization,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => _PickerSheet(
        title: 'Priority',
        children: IssuePriorityTypeEnum.values
            .map(
              (p) => ListTile(
                leading: ColorBadge(
                  letter: p.displayName(localization)[0],
                  backgroundColor: Color(p.color),
                  foregroundColor: Colors.white,
                ),
                title: Text(p.displayName(localization)),
                trailing: p == current ? const Icon(Icons.check) : null,
                onTap: () {
                  context.read<IssueFormCubit>().updatePriority(p);
                  Navigator.pop(context);
                },
              ),
            )
            .toList(),
      ),
    );
  }

  void _showStatePicker(
    BuildContext context,
    IssueStateEnum current,
    AppLocalizations localization,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => _PickerSheet(
        title: 'State',
        children: IssueStateEnum.values
            .map(
              (s) => ListTile(
                leading: ColorBadge(
                  letter: s.displayName(localization)[0],
                  backgroundColor: Color(s.color),
                  foregroundColor: Colors.white,
                ),
                title: Text(s.displayName(localization)),
                trailing: s == current ? const Icon(Icons.check) : null,
                onTap: () {
                  context.read<IssueFormCubit>().updateState(s);
                  Navigator.pop(context);
                },
              ),
            )
            .toList(),
      ),
    );
  }

  void _showTypePicker(
    BuildContext context,
    IssueTypeEnum current,
    AppLocalizations localization,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => _PickerSheet(
        title: 'Type',
        children: IssueTypeEnum.values
            .map(
              (t) => ListTile(
                title: Text(t.displayName(localization)),
                trailing: t == current ? const Icon(Icons.check) : null,
                onTap: () {
                  context.read<IssueFormCubit>().updateIssueType(t);
                  Navigator.pop(context);
                },
              ),
            )
            .toList(),
      ),
    );
  }

  void _showDurationPicker(
    BuildContext context,
    String title,
    Duration? current,
    Function(Duration?) onSelected,
  ) {
    final hoursController = TextEditingController(
      text: current != null ? current.inHours.toString() : '',
    );
    final minutesController = TextEditingController(
      text: current != null ? (current.inMinutes % 60).toString() : '',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: hoursController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Hours',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: minutesController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Minutes',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    onSelected(null);
                    Navigator.pop(context);
                  },
                  child: const Text('Clear'),
                ),
                FilledButton(
                  onPressed: () {
                    final hours = int.tryParse(hoursController.text) ?? 0;
                    final minutes = int.tryParse(minutesController.text) ?? 0;
                    onSelected(Duration(hours: hours, minutes: minutes));
                    Navigator.pop(context);
                  },
                  child: const Text('Set'),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showTagsPicker(BuildContext context, IssueFormCubit state) {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => _PickerSheet(
        title: 'Tags',
        children: [
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('New Tag'),
            onTap: () async {
              Navigator.pop(context);
              final project = state.availableProjects
                  .cast<ProjectEntity?>()
                  .firstWhere(
                    (p) => p?.id == state.state.project?.id,
                    orElse: () => null,
                  );
              final newTag = await NewTagDialog.show(
                context,
                projectId: project!.id,
                currentIssueId: state.state.isEditing
                    ? state.state.issueId
                    : null,
              );
              if (newTag != null && context.mounted) {
                context.read<IssueFormCubit>().addTag(newTag);
              }
            },
          ),
          ...state.tags.map(
            (tag) => ListTile(
              title: Text(tag.name),
              trailing: const Icon(Icons.check),
              onTap: () {
                context.read<IssueFormCubit>().removeTag(tag.id);
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showLinksPicker(BuildContext context, IssueFormCubit state) {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => _PickerSheet(
        title: 'Links',
        children: [
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Add link'),
            onTap: () {
              Navigator.pop(context);
              AddLinkDialog.show(
                context,
                currentIssueId: state.state.issueId,
                onSave: (link) {
                  context.read<IssueFormCubit>().addLink(link);
                },
              );
            },
          ),
          ...state.links.map(
            (link) => ListTile(
              title: Text('${link.linkType.name}: ${link.issueLinkedId}'),
              trailing: const Icon(Icons.delete_outline),
              onTap: () {
                context.read<IssueFormCubit>().removeLink(link.id);
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showBuildPicker(BuildContext context, IssueFormCubit state) {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => _PickerSheet(
        title: 'Fixed in build',
        children: [
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Add value'),
            onTap: () async {
              Navigator.pop(context);
              await AddBuildDialog.show(
                context,
                onSave: (build) {
                  context.read<IssueFormCubit>().addBuild(build);
                },
              );
            },
          ),
          ListTile(
            title: const Text('Next Build'),
            trailing: state.state.build == null
                ? const Icon(Icons.check)
                : null,
            onTap: () {
              context.read<IssueFormCubit>().updateBuild(null);
              Navigator.pop(context);
            },
          ),
          ...state.availableBuilds.map(
            (build) => ListTile(
              title: Text(build.name),
              subtitle: build.date != null
                  ? Text(build.date!.toLocal().toString().split(' ')[0])
                  : null,
              trailing: state.state.build?.id == build.id
                  ? const Icon(Icons.check)
                  : null,
              onTap: () {
                context.read<IssueFormCubit>().updateBuild(build);
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showSprintsPicker(BuildContext context, IssueFormCubit state) {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => _PickerSheet(
        title: 'Sprints',
        children: [
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Add value'),
            onTap: () {
              Navigator.pop(context);
              AddSprintDialog.show(
                context,
                onSave: (sprint) {
                  context.read<IssueFormCubit>().addSprint(sprint);
                },
              );
            },
          ),
          ...state.availableSprints.map(
            (sprint) => ListTile(
              leading: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Color(sprint.color),
                  shape: BoxShape.circle,
                ),
              ),
              title: Text(sprint.name),
              trailing: const Icon(Icons.check),
              onTap: () {
                context.read<IssueFormCubit>().removeSprint(sprint.id);
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PickerSheet extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _PickerSheet({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          Flexible(child: ListView(shrinkWrap: true, children: children)),
        ],
      ),
    );
  }
}
