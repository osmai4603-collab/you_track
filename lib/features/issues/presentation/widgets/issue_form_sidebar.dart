import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/enums/issue_priority_type_enum.dart';
import 'package:issues_tracking/core/enums/issue_state_enum.dart';
import 'package:issues_tracking/core/enums/issue_type_enum.dart';
import 'package:issues_tracking/core/localization/app_localizations.dart';
import 'package:issues_tracking/features/issues/presentation/cubits/issue_form_cubit.dart';
import 'package:issues_tracking/features/issues/presentation/cubits/issue_form_state.dart';
import 'package:issues_tracking/features/issues/presentation/pages/issue_form.dart';

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
            shape: RoundedRectangleBorder(borderRadius: .circular(16)),
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
                    mainAxisAlignment: .end,
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
                    child: const Center(
                      child: Text(
                        'DEM',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 7,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
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
                  onTap: () {
                    // TODO: Show assignee picker
                  },
                ),
                _buildField(
                  label: 'Subsystem',
                  value: state.subsystem.isEmpty
                      ? 'No Subsystem'
                      : state.subsystem,
                  onTap: () {
                    // TODO: Show subsystem picker
                  },
                ),
                _buildField(
                  label: 'Fix versions',
                  value: state.fixVersions.isEmpty
                      ? 'Unscheduled'
                      : state.fixVersions,
                  onTap: () {
                    // TODO: Show fix versions picker
                  },
                ),
                _buildField(
                  label: 'Fixed in build',
                  value: state.fixedInBuild,
                  onTap: () {
                    // TODO: Show build picker
                  },
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

  void _showPriorityPicker(
    BuildContext context,
    IssuePriorityTypeEnum current,
    AppLocalizations localization,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _PickerSheet(
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
      builder: (context) => _PickerSheet(
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
      builder: (context) => _PickerSheet(
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
