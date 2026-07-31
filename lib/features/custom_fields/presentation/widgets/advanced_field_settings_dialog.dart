import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import '../../domain/entities/custom_field_entity.dart';
import '../cubits/custom_fields_cubit.dart';

class AdvancedFieldSettingsDialog extends StatefulWidget {
  final CustomFieldEntity field;

  const AdvancedFieldSettingsDialog({
    super.key,
    required this.field,
  });

  @override
  State<AdvancedFieldSettingsDialog> createState() =>
      _AdvancedFieldSettingsDialogState();
}

class _AdvancedFieldSettingsDialogState
    extends State<AdvancedFieldSettingsDialog> {
  late final TextEditingController _visibleToController;
  late final TextEditingController _updatableByController;
  late final TextEditingController _showOnlyWhenController;
  late final TextEditingController _filterValuesBasedOnController;

  @override
  void initState() {
    super.initState();
    _visibleToController = TextEditingController(
      text: widget.field.visibleTo?.join(', ') ?? '',
    );
    _updatableByController = TextEditingController(
      text: widget.field.updatableBy?.join(', ') ?? '',
    );
    _showOnlyWhenController = TextEditingController(
      text: widget.field.showOnlyWhen ?? '',
    );
    _filterValuesBasedOnController = TextEditingController(
      text: widget.field.filterValuesBasedOn ?? '',
    );
  }

  @override
  void dispose() {
    _visibleToController.dispose();
    _updatableByController.dispose();
    _showOnlyWhenController.dispose();
    _filterValuesBasedOnController.dispose();
    super.dispose();
  }

  List<String>? _parseList(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return null;
    return trimmed
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  String? _nullIfEmpty(String text) {
    final trimmed = text.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  void _save() {
    context.read<CustomFieldsCubit>().updateAdvancedSettings(
      fieldId: widget.field.id,
      visibleTo: _parseList(_visibleToController.text),
      updatableBy: _parseList(_updatableByController.text),
      showOnlyWhen: _nullIfEmpty(_showOnlyWhenController.text),
      filterValuesBasedOn: _nullIfEmpty(_filterValuesBasedOnController.text),
    );
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Advanced settings updated')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.medium),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Advanced Settings: ${widget.field.name}',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.medium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Visible To',
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.small),
                    TextField(
                      controller: _visibleToController,
                      decoration: const InputDecoration(
                        hintText: 'e.g. Developers, QA Team',
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.medium),
                    Text(
                      'Updatable By',
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.small),
                    TextField(
                      controller: _updatableByController,
                      decoration: const InputDecoration(
                        hintText: 'e.g. Admins, Project Leads',
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.medium),
                    Text(
                      'Show Only When',
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.small),
                    TextField(
                      controller: _showOnlyWhenController,
                      decoration: const InputDecoration(
                        hintText: 'e.g. status = "In Progress"',
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.medium),
                    Text(
                      'Filter Values Based On',
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.small),
                    TextField(
                      controller: _filterValuesBasedOnController,
                      decoration: const InputDecoration(
                        hintText: 'e.g. parent_field_id',
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.medium),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: AppSpacing.small),
                  FilledButton(
                    onPressed: _save,
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
