import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/work_type_entity.dart';
import '../cubits/work_types_cubit.dart';
import 'work_type_form_dialog.dart';

class WorkTypesSection extends StatefulWidget {
  final String? selectedWorkTypeId;
  final ValueChanged<WorkTypeEntity>? onWorkTypeSelected;

  const WorkTypesSection({
    super.key,
    this.selectedWorkTypeId,
    this.onWorkTypeSelected,
  });

  @override
  State<WorkTypesSection> createState() => _WorkTypesSectionState();
}

class _WorkTypesSectionState extends State<WorkTypesSection> {
  @override
  void initState() {
    super.initState();
    context.read<WorkTypesCubit>().loadWorkTypes();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkTypesCubit, WorkTypesState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Work Types',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                TextButton.icon(
                  onPressed: () => _showAddDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Work Type'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (state is WorkTypesLoading)
              const Center(child: CircularProgressIndicator())
            else if (state is WorkTypesError)
              Center(child: SelectableText(state.message))
            else if (state is WorkTypesLoaded) ...[
              if (state.workTypes.isEmpty)
                _buildEmptyState(context)
              else
                _buildWorkTypesList(context, state.workTypes),
            ],
          ],
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.work_outline, size: 48, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 12),
            const Text(
              'No work types defined',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Text(
              'Add work types to categorize time entries',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkTypesList(BuildContext context, List<WorkTypeEntity> workTypes) {
    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: workTypes.length,
      onReorderItem: (oldIndex, newIndex) {
        context.read<WorkTypesCubit>().reorderWorkTypes(oldIndex, newIndex);
      },
      itemBuilder: (context, index) {
        final workType = workTypes[index];
        final isSelected = widget.selectedWorkTypeId == workType.id;

        return Card(
          key: ValueKey(workType.id),
          color: isSelected
              ? Theme.of(context).colorScheme.primaryContainer
              : null,
          child: ListTile(
            onTap: () => widget.onWorkTypeSelected?.call(workType),
            leading: const Icon(Icons.drag_handle),
            title: Text(workType.name),
            subtitle: workType.description != null ? Text(workType.description!) : null,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: workType.isActive
                        ? Colors.green.withValues(alpha: 0.1)
                        : Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    workType.isActive ? 'Active' : 'Inactive',
                    style: TextStyle(
                      fontSize: 12,
                      color: workType.isActive ? Colors.green : Colors.grey,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: () => _showEditDialog(context, workType),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 20),
                  onPressed: () => _showDeleteConfirmation(context, workType),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<WorkTypesCubit>(),
        child: WorkTypeFormDialog(
          onSave: (name, description) {
            context.read<WorkTypesCubit>().addWorkType(
                  name: name,
                  description: description,
                );
          },
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, WorkTypeEntity workType) {
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<WorkTypesCubit>(),
        child: WorkTypeFormDialog(
          initialName: workType.name,
          initialDescription: workType.description,
          onSave: (name, description) {
            context.read<WorkTypesCubit>().updateWorkType(
                  workTypeId: workType.id,
                  name: name,
                  description: description,
                );
          },
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WorkTypeEntity workType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Work Type?'),
        content: Text(
          'Are you sure you want to delete "${workType.name}"? '
          'Existing time entries with this work type will retain their reference.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<WorkTypesCubit>().deleteWorkType(workType.id);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
