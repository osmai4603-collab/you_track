import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/core/init_dependencies.dart';
import 'package:issues_tracking/core/widgets/animated_content_switcher.dart';
import 'package:issues_tracking/core/widgets/shimmer_loading.dart';
import 'package:issues_tracking/features/projects/domain/entities/project_entity.dart';
import 'package:issues_tracking/features/projects/domain/usecases/update_project_use_case.dart';
import 'package:issues_tracking/features/projects/presentation/cubits/project_details_cubit.dart';
import 'package:issues_tracking/features/time_tracking/domain/entities/work_item_attribute_entity.dart';
import 'package:issues_tracking/features/time_tracking/domain/repositories/time_tracking_repository.dart';
import 'package:issues_tracking/features/time_tracking/presentation/cubits/time_tracking_config_cubit.dart';
import 'package:issues_tracking/features/time_tracking/presentation/widgets/time_tracking_toggle.dart';
import 'package:issues_tracking/features/time_tracking/presentation/widgets/field_configuration_section.dart';
import 'package:issues_tracking/features/time_tracking/presentation/widgets/work_item_attribute_dialog.dart';
import 'package:issues_tracking/core/enums/permission_enum.dart';
import 'package:issues_tracking/features/users/domain/usecases/user_session.dart';

class ProjectTimeTrackingSettingsSection extends StatefulWidget {
  final String projectId;

  const ProjectTimeTrackingSettingsSection({
    super.key,
    required this.projectId,
  });

  @override
  State<ProjectTimeTrackingSettingsSection> createState() =>
      _ProjectTimeTrackingSettingsSectionState();
}

class _ProjectTimeTrackingSettingsSectionState
    extends State<ProjectTimeTrackingSettingsSection> {
  // String? _selectedWorkTypeId;
  // String? _selectedWorkTypeName;
  WorkItemAttributeEntity? workItemAttributeSelected;
  List<WorkItemAttributeEntity> _workItemAttributes = [];
  WorkItemAttributeEntity? _selectedAttribute;
  bool _loadingAttributes = false;
  String? _attributeError;
  bool _isProjectSaving = false;

  // void _onWorkTypeSelected(WorkTypeEntity workType) {
  //   setState(() {
  //     _selectedWorkTypeId = workType.id;
  //     _selectedWorkTypeName = workType.name;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    context.read<TimeTrackingConfigCubit>().loadConfig(widget.projectId);
    _loadWorkItemAttributes();
  }

  Future<void> _loadWorkItemAttributes() async {
    setState(() {
      _loadingAttributes = true;
      _attributeError = null;
    });

    final result = await get_it<TimeTrackingRepository>().getWorkItemAttributes(
      widget.projectId,
    );

    result.fold(
      (failure) {
        setState(() {
          _attributeError = failure.message;
          _workItemAttributes = [];
          _loadingAttributes = false;
        });
      },
      (attributes) {
        setState(() {
          _workItemAttributes = attributes;
          _loadingAttributes = false;
        });
      },
    );
  }

  void _showAttributeDetails(WorkItemAttributeEntity attribute) {
    setState(() {
      _selectedAttribute = attribute;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userSession = context.watch<UserSession>();
    final isAdmin = userSession.hasPermission(Permission.projectUpdateProject);

    return BlocBuilder<ProjectDetailsCubit, ProjectDetailsState>(
      builder: (context, projectState) {
        if (!isAdmin) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.lock_outline,
                  size: 48,
                  color: Theme.of(context).colorScheme.outline,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Access Denied',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Text(
                  'Only project administrators can manage time tracking settings.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
            ),
          );
        }

        return BlocConsumer<TimeTrackingConfigCubit, TimeTrackingConfigState>(
          listener: (context, state) {
            if (state is TimeTrackingConfigSaved) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings saved successfully')),
              );
            } else if (state is TimeTrackingConfigSaveError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: SelectableText(state.message),
                  action: SnackBarAction(
                    label: 'Retry',
                    onPressed: () {
                      context.read<TimeTrackingConfigCubit>().save();
                    },
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            Widget content;
            if (state is TimeTrackingConfigLoading) {
              content = Center(
                key: const ValueKey('project-time-tracking-loading'),
                child: SizedBox(
                  width: 480,
                  child: ShimmerLoading.list(itemCount: 6),
                ),
              );
            } else if (state is TimeTrackingConfigError) {
              content = Center(
                key: const ValueKey('project-time-tracking-error'),
                child: SelectableText(state.message),
              );
            } else if (state is TimeTrackingConfigStale) {
              content = Center(
                key: const ValueKey('project-time-tracking-stale'),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SelectableText(state.message),
                    const SizedBox(height: AppSpacing.medium),
                    ElevatedButton(
                      onPressed: () {
                        context.read<TimeTrackingConfigCubit>().loadConfig(
                          widget.projectId,
                        );
                      },
                      child: const Text('Reload'),
                    ),
                  ],
                ),
              );
            } else if (state is TimeTrackingConfigLoaded) {
              content = buildTimeTracking(state, context, projectState.project);
            } else {
              content = const SizedBox.shrink(key: ValueKey('project-time-tracking-empty'));
            }

            return AnimatedContentSwitcher(child: content);
          },
        );
      },
    );
  }

  Padding buildTimeTracking(
    TimeTrackingConfigLoaded state,
    BuildContext context,
    ProjectEntity? project,
  ) {
    final hasTimeTracking = project?.hasTimeTracking ?? false;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.medium,
            children: [
              TimeTrackingToggle(
                enabled: hasTimeTracking,
                onToggle: () => _toggleProjectTimeTracking(project),
              ),
              if (hasTimeTracking)
                Expanded(
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FieldConfigurationSection(
                            availableFields: state.availableFields,
                          ),
                          const SizedBox(height: AppSpacing.large),
                          Text(
                            'Work Item Attributes',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          FilledButton.icon(
                            onPressed: _onWorkItemAttributePressed,
                            icon: const Icon(Icons.settings),
                            label: const Text('Add Work Item Attribute'),
                          ),
                          const SizedBox(height: AppSpacing.medium),
                          Expanded(
                            child: SingleChildScrollView(child: _buildTable()),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          if (_isProjectSaving)
            Positioned.fill(
              child: Container(
                color: Theme.of(context)
                    .colorScheme
                    .surface
                    .withValues(alpha: 0.7),
                child: Center(
                  child: ShimmerLoading.center(width: 48, height: 48),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _onWorkItemAttributePressed() async {
    final result = await showDialog<WorkItemAttributeEntity>(
      context: context,
      builder: (_) => WorkItemAttributeDialog(projectId: widget.projectId),
    );

    if (result != null) {
      setState(() {
        _workItemAttributes = [..._workItemAttributes, result];
        _selectedAttribute = result;
      });
    }
  }

  Future<void> _toggleProjectTimeTracking(ProjectEntity? project) async {
    if (project == null) return;

    setState(() {
      _isProjectSaving = true;
    });

    final updatedProject = project.copyWith(
      hasTimeTracking: !project.hasTimeTracking,
    );

    debugPrint('Updating project id: ${project.id}, toggle to ${updatedProject.hasTimeTracking}');

    final result = await get_it<UpdateProjectUseCase>()(
      params: UpdateProjectParams(project: updatedProject),
    );

    if (!mounted) return;

    result.fold(
      (failure) {
        debugPrint('UpdateProject failed: ${failure.message}');
        setState(() {
          _isProjectSaving = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: SelectableText('Failed to save project: ${failure.message}'),
          ),
        );
      },
      (savedProject) {
        setState(() {
          _isProjectSaving = false;
        });
        context.read<ProjectDetailsCubit>().loadProject(savedProject.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: SelectableText('Project settings saved')), 
        );
      },
    );
  }

  Widget _buildTable() {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    final panelWidth = width * 0.5;

    return LayoutBuilder(
      builder: (context, constraints) {
        final constrainedHeight = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : 320.0;

        return SizedBox(
          height: constrainedHeight.clamp(320.0, 640.0),
          child: Stack(
            children: [
              Positioned.fill(
                child: _loadingAttributes
                    ? Center(child: ShimmerLoading.center(width: 48, height: 48))
                    : _attributeError != null
                    ? Center(child: Text(_attributeError!))
                    : _workItemAttributes.isEmpty
                    ? Center(
                        child: Text(
                          'No work item attributes yet.',
                          style: theme.textTheme.bodyMedium,
                        ),
                      )
                    : DataTable(
                      showCheckboxColumn: false,
                        columns: const [
                          DataColumn(label: Text('Attribute Name'), columnWidth: FixedColumnWidth(150)),
                          DataColumn(label: Text('Values'), columnWidth: FixedColumnWidth(250)),
                        ],
                        rows: _workItemAttributes.map((attribute) {
                          return DataRow(
                            selected: _selectedAttribute?.id == attribute.id,
                            onSelectChanged: (_) =>
                                _showAttributeDetails(attribute),
                            cells: [
                              DataCell(Text(attribute.name)),
                              DataCell(
                                Text(
                                  attribute.values
                                      .map((v) => v.value)
                                      .join(', '),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                top: 0,
                right: _selectedAttribute == null ? -panelWidth : 0,
                width: panelWidth,
                bottom: 0,
                child: _buildWorkItemAttributePrfile(theme),
              ),
            ],
          ),
        );
      },
    );
  }

  Material _buildWorkItemAttributePrfile(ThemeData theme) {
    return Material(
      elevation: 8,
      color: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.large),
        child: _selectedAttribute == null
            ? const SizedBox.shrink()
            : _workItemAttributeCard(theme),
      ),
    );
  }

  Column _workItemAttributeCard(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_selectedAttribute!.name, style: theme.textTheme.titleLarge),
            IconButton(
              onPressed: () => setState(() => _selectedAttribute = null),
              icon: const Icon(Icons.close),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.medium),
        Text('Values', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.small),
        Expanded(
          child: ListView.separated(
            itemCount: _selectedAttribute!.values.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final value = _selectedAttribute!.values[index];
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: theme.colorScheme.outlineVariant),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Color(value.color),
                      child: Text(
                        value.firstLetter,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(value.value)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
