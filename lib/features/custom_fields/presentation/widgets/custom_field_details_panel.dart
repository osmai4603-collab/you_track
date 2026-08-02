import 'package:flutter/material.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/features/custom_fields/domain/entities/custom_field_entity.dart';

class CustomFieldDetailsPanel extends StatelessWidget {
  final CustomFieldEntity field;
  final VoidCallback onClose;
  final VoidCallback onEdit;

  const CustomFieldDetailsPanel({
    super.key,
    required this.field,
    required this.onClose,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      color: colors.surface,
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(AppSpacing.medium),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Field Details',
                  style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onClose,
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.medium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('General', textTheme, colors),
              _buildDetailRow('Name', field.name, textTheme, colors),
              _buildDetailRow('Type', field.fieldType.name, textTheme, colors),
              _buildDetailRow('Field Mode', field.fieldMode, textTheme, colors),
              _buildDetailRow('Value Mode', field.valueMode, textTheme, colors),
              const SizedBox(height: AppSpacing.medium),
              _buildSectionTitle('Values', textTheme, colors),
              _buildDetailRow('Default Value', field.defaultValue ?? 'None', textTheme, colors),
              _buildDetailRow('Empty Value', field.emptyValue ?? 'None', textTheme, colors),
              _buildDetailRow('Can Be Empty', field.canBeEmpty ? 'Yes' : 'No', textTheme, colors),
              const SizedBox(height: AppSpacing.medium),
              _buildSectionTitle('Access', textTheme, colors),
              _buildDetailRow('Visibility', field.visibility, textTheme, colors),
              _buildDetailRow(
                'Access Control',
                field.accessControl['type']?.toString() ?? 'Everyone',
                textTheme,
                colors,
              ),
              _buildDetailRow('Visible To', field.visibleTo?.join(', ') ?? 'Everyone', textTheme, colors),
              _buildDetailRow('Updatable By', field.updatableBy?.join(', ') ?? 'Everyone', textTheme, colors),
              const SizedBox(height: AppSpacing.medium),
              _buildSectionTitle('Advanced', textTheme, colors),
              _buildDetailRow('Aliases', field.aliases?.join(', ') ?? 'None', textTheme, colors),
              _buildDetailRow('Show Only When', field.showOnlyWhen ?? 'Always', textTheme, colors),
              _buildDetailRow('Filter Values Based On', field.filterValuesBasedOn ?? 'None', textTheme, colors),
              const SizedBox(height: AppSpacing.medium),
              _buildSectionTitle('System', textTheme, colors),
              _buildDetailRow('Order Index', field.orderIndex.toString(), textTheme, colors),
              _buildDetailRow('Created At', field.createdAt.toLocal().toString().split('.')[0], textTheme, colors),
              _buildDetailRow('Updated At', field.updatedAt.toLocal().toString().split('.')[0], textTheme, colors),
            ],
          ),
            ),
          ),
          // Actions
          Padding(
            padding: const EdgeInsets.all(AppSpacing.medium),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onEdit,
                icon: const Icon(Icons.edit, size: 18),
                label: const Text('Edit Field'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, TextTheme textTheme, ColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.small),
      child: Text(
        title,
        style: textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: colors.primary,
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, TextTheme textTheme, ColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.medium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: textTheme.labelMedium?.copyWith(
              color: colors.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
