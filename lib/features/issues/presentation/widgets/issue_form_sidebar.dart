import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/enums/issue_priority_type_enum.dart';
import 'package:issues_tracking/core/enums/issue_state_enum.dart';
import 'package:issues_tracking/core/enums/issue_type_enum.dart';
import 'package:issues_tracking/core/enums/issue_subsystem_enum.dart';
import 'package:issues_tracking/core/localization/app_localizations.dart';
import 'package:issues_tracking/features/issues/presentation/cubits/issue_form_cubit.dart';
import 'package:issues_tracking/features/issues/presentation/cubits/issue_form_state.dart';
import 'package:issues_tracking/features/issues/presentation/pages/issue_form.dart';
import 'package:issues_tracking/features/issues/presentation/widgets/add_sprint_dialog.dart';
import 'package:issues_tracking/features/issues/presentation/widgets/new_tag_dialog.dart';
import 'package:issues_tracking/features/issues/presentation/widgets/add_build_dialog.dart';
import 'package:issues_tracking/features/issues/presentation/widgets/add_link_dialog.dart';

class IssueFormSidebar extends StatelessWidget {
  const IssueFormSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return BlocBuilder<IssueFormCubit, IssueFormState>(
      builder: (context, state) {
        return Container(
          width: 280,
          decoration: ShapeDecoration(
            color: ColorScheme.of(context).surfaceContainerHigh,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
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
                        '${state.isEditing ? 0 : 0}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      IconButton(
                        onPressed: _onFavoritePressed,
                        icon: Icon(
                          state.isEditing ? Icons.star : Icons.star_border,
                          size: 20,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                ),
                _buildField(
                  label: 'Project',
                  value: state.projectKey ?? 'Demo project',
                  leading: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: YTColors.mainColor,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Center(
                      child: Text(
                        (state.projectKey ?? 'DEM')
                            .substring(
                              0,
                              (state.projectKey ?? 'DEM').length > 3
                                  ? 3
                                  : (state.projectKey ?? 'DEM').length,
                            )
                            .toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 7,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  onTap: () => _showProjectPicker(context, state),
                ),
                _buildField(
                  label: 'Priority',
                  value: state.priority.displayName(localization),
                  leading: ColorBadge(
                    letter: state.priority.displayName(localization)[0],
                    backgroundColor: Color(state.priority.color),
                    foregroundColor: Colors.white,
                  ),
                  onTap: () => _showPriorityPicker(
                    context,
                    state.priority,
                    localization,
                  ),
                ),
                _buildField(
                  label: 'State',
                  value: state.state.displayName(localization),
                  leading: ColorBadge(
                    letter: state.state.displayName(localization)[0],
                    backgroundColor: Color(state.state.color),
                    foregroundColor: Colors.white,
                  ),
                  onTap: () =>
                      _showStatePicker(context, state.state, localization),
                ),
                _buildField(
                  label: 'Type',
                  value: state.issueType.displayName(localization),
                  onTap: () =>
                      _showTypePicker(context, state.issueType, localization),
                ),
                _buildField(
                  label: 'Assignee',
                  value: state.assigneeName ?? 'Unassigned',
                  onTap: () => _showAssigneePicker(context, state),
                ),
                _buildField(
                  label: 'Subsystem',
                  value: state.subsystem.displayName(localization),
                  onTap: () => _showSubsystemPicker(
                    context,
                    state.subsystem,
                    localization,
                  ),
                ),
                _buildField(
                  label: 'Fix versions',
                  value: state.fixVersions.isEmpty
                      ? 'Unscheduled'
                      : state.fixVersions,
                  onTap: () => _showTextPicker(
                    context,
                    'Fix versions',
                    state.fixVersions,
                    (v) => context.read<IssueFormCubit>().updateFixVersions(v),
                  ),
                ),
                _buildField(
                  label: 'Fixed in build',
                  value: state.build?.name ?? 'Next Build',
                  onTap: () => _showBuildPicker(context, state),
                ),
                _buildField(
                  label: 'Sprints',
                  value: state.sprints.isEmpty
                      ? 'No Sprints'
                      : state.sprints.map((s) => s.name).join(', '),
                  onTap: () => _showSprintsPicker(context, state),
                ),
                _buildField(
                  label: 'Estimation',
                  value: state.estimation != null
                      ? '${state.estimation!.inHours}h ${state.estimation!.inMinutes % 60}m'
                      : '?',
                  onTap: () => _showDurationPicker(
                    context,
                    'Estimation',
                    state.estimation,
                    (duration) => context
                        .read<IssueFormCubit>()
                        .updateEstimation(duration),
                  ),
                ),
                _buildField(
                  label: 'Spent time',
                  value: state.spentTime != null
                      ? '${state.spentTime!.inHours}h ${state.spentTime!.inMinutes % 60}m'
                      : '?',
                  onTap: () => _showDurationPicker(
                    context,
                    'Spent time',
                    state.spentTime,
                    (duration) => context
                        .read<IssueFormCubit>()
                        .updateSpentTime(duration),
                  ),
                ),
                _buildField(
                  label: 'Tags',
                  value: state.tags.isEmpty
                      ? 'Add tags...'
                      : state.tags.map((t) => t.name).join(', '),
                  onTap: () => _showTagsPicker(context, state),
                ),
                _buildField(
                  label: 'Links',
                  value: state.links.isEmpty
                      ? 'Add links...'
                      : '${state.links.length} links',
                  onTap: () => _showLinksPicker(context, state),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildField({
    required String label,
    required String value,
    Widget? leading,
    VoidCallback? onTap,
  }) {
    return CompactFieldWidget(
      label: label,
      value: value,
      leading: leading,
      onTap: onTap,
    );
  }

  void _showSubsystemPicker(
    BuildContext context,
    IssueSubsystemEnum current,
    AppLocalizations localization,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _PickerSheet(
        title: 'Subsystem',
        children: IssueSubsystemEnum.values
            .map(
              (s) => ListTile(
                title: Text(s.displayName(localization)),
                trailing: s == current ? const Icon(Icons.check) : null,
                onTap: () {
                  context.read<IssueFormCubit>().updateSubsystem(s);
                  Navigator.pop(context);
                },
              ),
            )
            .toList(),
      ),
    );
  }

  void _showProjectPicker(BuildContext context, IssueFormState state) {
    if (state.availableProjects.isEmpty) return;
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => _PickerSheet(
        title: 'Project',
        children: state.availableProjects
            .map(
              (p) => ListTile(
                leading: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: YTColors.mainColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Text(
                      p.projectKey
                          .substring(
                            0,
                            p.projectKey.length > 3 ? 3 : p.projectKey.length,
                          )
                          .toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                title: Text(p.name),
                subtitle: Text(p.projectKey),
                trailing: p.projectKey == state.projectKey
                    ? const Icon(Icons.check)
                    : null,
                onTap: () {
                  context.read<IssueFormCubit>().updateProjectKey(p.projectKey);
                  Navigator.pop(context);
                },
              ),
            )
            .toList(),
      ),
    );
  }

  void _showAssigneePicker(BuildContext context, IssueFormState state) {
    if (state.projectMembers.isEmpty) return;
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
            trailing: state.assigneeId == null ? const Icon(Icons.check) : null,
            onTap: () {
              context.read<IssueFormCubit>().clearAssignee();
              Navigator.pop(sheetContext);
            },
          ),
          ...state.projectMembers
              .map(
                (m) => ListTile(
                  leading: CircleAvatar(
                    radius: 12,
                    backgroundImage: m.avatarUrl != null ? NetworkImage(m.avatarUrl!) : null,
                    backgroundColor: YTColors.mainColor,
                    child: m.avatarUrl == null
                        ? Text(
                            m.name.isNotEmpty ? m.name[0].toUpperCase() : '?',
                            style: const TextStyle(color: Colors.white, fontSize: 10),
                          )
                        : null,
                  ),
                  title: Text(m.name),
                  subtitle: Text(m.email),
                  trailing: m.id == state.assigneeId ? const Icon(Icons.check) : null,
                  onTap: () {
                    context.read<IssueFormCubit>().updateAssignee(m.id, m.name);
                    Navigator.pop(sheetContext);
                  },
                ),
              )
              .toList(),
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

  void _showTagsPicker(BuildContext context, IssueFormState state) {
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
              final newTag = await NewTagDialog.show(
                context,
                projectId:
                    state.projectKey ??
                    'DEM', // TODO: Get from state correctly if needed
                currentIssueId: state.isEditing ? state.issueId : null,
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

  void _showLinksPicker(BuildContext context, IssueFormState state) {
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
                currentIssueId: state.issueId,
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

  void _showBuildPicker(BuildContext context, IssueFormState state) {
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
            trailing: state.build == null ? const Icon(Icons.check) : null,
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
              trailing: state.build?.id == build.id
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

  void _showSprintsPicker(BuildContext context, IssueFormState state) {
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
          ...state.sprints.map(
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

  void _onFavoritePressed() {}
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
