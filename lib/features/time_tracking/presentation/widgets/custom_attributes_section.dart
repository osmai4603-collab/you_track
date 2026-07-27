import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/custom_work_item_attribute_entity.dart';
import '../cubits/custom_attributes_cubit.dart';
import 'custom_attribute_form_dialog.dart';

class CustomAttributesSection extends StatefulWidget {
  const CustomAttributesSection({super.key});

  @override
  State<CustomAttributesSection> createState() => _CustomAttributesSectionState();
}

class _CustomAttributesSectionState extends State<CustomAttributesSection> {
  @override
  void initState() {
    super.initState();
    context.read<CustomAttributesCubit>().loadAttributes();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomAttributesCubit, CustomAttributesState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Custom Attributes',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                TextButton.icon(
                  onPressed: () => _showAddDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Custom Attribute'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (state is CustomAttributesLoading)
              const Center(child: CircularProgressIndicator())
            else if (state is CustomAttributesError)
              Center(child: Text(state.message))
            else if (state is CustomAttributesLoaded) ...[
              if (state.attributes.isEmpty)
                _buildEmptyState(context)
              else
                _buildAttributesList(context, state.attributes),
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
            Icon(Icons.list_alt, size: 48, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 12),
            const Text(
              'No custom attributes defined',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Text(
              'Add custom attributes to collect additional data with time entries',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttributesList(BuildContext context, List<CustomWorkItemAttributeEntity> attributes) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: attributes.length,
      itemBuilder: (context, index) {
        final attribute = attributes[index];
        return Card(
          child: ListTile(
            title: Text(attribute.name),
            subtitle: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    attribute.fieldType.value.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: attribute.isRequired
                        ? Colors.orange.withValues(alpha: 0.1)
                        : Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    attribute.isRequired ? 'Required' : 'Optional',
                    style: TextStyle(
                      fontSize: 10,
                      color: attribute.isRequired ? Colors.orange : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: () => _showEditDialog(context, attribute),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 20),
                  onPressed: () => _showDeleteConfirmation(context, attribute),
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
        value: context.read<CustomAttributesCubit>(),
        child: CustomAttributeFormDialog(
          onSave: (name, fieldType, isRequired, options) {
            context.read<CustomAttributesCubit>().addAttribute(
                  name: name,
                  fieldType: fieldType,
                  isRequired: isRequired,
                  options: options,
                );
          },
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, CustomWorkItemAttributeEntity attribute) {
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<CustomAttributesCubit>(),
        child: CustomAttributeFormDialog(
          initialName: attribute.name,
          initialFieldType: attribute.fieldType,
          initialIsRequired: attribute.isRequired,
          initialOptions: attribute.options,
          onSave: (name, fieldType, isRequired, options) {
            context.read<CustomAttributesCubit>().updateAttribute(
                  attributeId: attribute.id,
                  name: name,
                  fieldType: fieldType,
                  isRequired: isRequired,
                  options: options,
                );
          },
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, CustomWorkItemAttributeEntity attribute) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Custom Attribute?'),
        content: Text(
          'Are you sure you want to delete "${attribute.name}"? '
          'Existing time entries with this attribute will retain their data.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<CustomAttributesCubit>().deleteAttribute(attribute.id);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
