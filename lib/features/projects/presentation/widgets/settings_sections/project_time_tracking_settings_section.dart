import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/core/init_dependencies.dart';
import 'package:issues_tracking/features/projects/presentation/cubits/project_details_cubit.dart';
import 'package:issues_tracking/features/time_tracking/presentation/cubits/time_tracking_config_cubit.dart';
import 'package:issues_tracking/features/time_tracking/presentation/cubits/work_types_cubit.dart';
import 'package:issues_tracking/features/time_tracking/presentation/cubits/custom_attributes_cubit.dart';
import 'package:issues_tracking/features/time_tracking/presentation/widgets/time_tracking_toggle.dart';
import 'package:issues_tracking/features/time_tracking/presentation/widgets/field_configuration_section.dart';
import 'package:issues_tracking/features/time_tracking/presentation/widgets/aggregation_section.dart';
import 'package:issues_tracking/features/time_tracking/presentation/widgets/work_types_section.dart';
import 'package:issues_tracking/features/time_tracking/presentation/widgets/custom_attributes_section.dart';
import 'package:issues_tracking/features/time_tracking/presentation/widgets/time_tracking_save_bar.dart';

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
  @override
  void initState() {
    super.initState();
    context.read<TimeTrackingConfigCubit>().loadConfig(widget.projectId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectDetailsCubit, ProjectDetailsState>(
      builder: (context, projectState) {
        final project = projectState.project;
        final isAdmin = true;

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
            if (state is TimeTrackingConfigLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is TimeTrackingConfigError) {
              return Center(child: SelectableText(state.message));
            }

            if (state is TimeTrackingConfigStale) {
              return Center(
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
            }

            if (state is TimeTrackingConfigLoaded) {
              return Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.large,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TimeTrackingToggle(
                          state: state,
                          onToggle: () => context
                              .read<TimeTrackingConfigCubit>()
                              .toggleEnabled(),
                        ),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          child: state.config.enabled
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Divider(),
                                    const SizedBox(height: AppSpacing.medium),
                                    FieldConfigurationSection(
                                      availableFields: state.availableFields,
                                    ),
                                    const SizedBox(height: AppSpacing.large),
                                    const AggregationSection(),
                                    const SizedBox(height: AppSpacing.large),
                                    BlocProvider<WorkTypesCubit>(
                                      create: (_) => WorkTypesCubit(
                                        getWorkTypesUseCase: get_it(),
                                        addWorkTypeUseCase: get_it(),
                                        updateWorkTypeUseCase: get_it(),
                                        deleteWorkTypeUseCase: get_it(),
                                        reorderWorkTypesUseCase: get_it(),
                                        projectId: widget.projectId,
                                      ),
                                      child: const WorkTypesSection(),
                                    ),
                                    const SizedBox(height: AppSpacing.large),
                                    BlocProvider<CustomAttributesCubit>(
                                      create: (_) => CustomAttributesCubit(
                                        getAttributesUseCase: get_it(),
                                        addAttributeUseCase: get_it(),
                                        updateAttributeUseCase: get_it(),
                                        deleteAttributeUseCase: get_it(),
                                        projectId: widget.projectId,
                                      ),
                                      child: const CustomAttributesSection(),
                                    ),
                                    const SizedBox(height: 100),
                                  ],
                                )
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                  if (state.config.enabled)
                    Positioned(
                      bottom: 24,
                      right: 24,
                      child: TimeTrackingSaveBar(
                        hasChanges: state.hasChanges,
                        isSaving: state.isSaving,
                        onSave: () =>
                            context.read<TimeTrackingConfigCubit>().save(),
                        onDiscard: () =>
                            context.read<TimeTrackingConfigCubit>().discard(),
                      ),
                    ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        );
      },
    );
  }
}
