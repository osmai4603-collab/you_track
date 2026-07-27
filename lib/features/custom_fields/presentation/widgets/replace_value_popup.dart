import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import '../../domain/entities/custom_field_entity.dart';
import '../cubits/custom_fields_cubit.dart';

class ReplaceValuePopup extends StatefulWidget {
  final CustomFieldEntity field;

  const ReplaceValuePopup({
    super.key,
    required this.field,
  });

  @override
  State<ReplaceValuePopup> createState() => _ReplaceValuePopupState();
}

class _ReplaceValuePopupState extends State<ReplaceValuePopup> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final availableValues = widget.field.fieldType.availableValues;

    final filteredValues = _searchQuery.isEmpty
        ? availableValues
        : availableValues
            .where((v) => v.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 500),
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
                      'Replace values in ${widget.field.name}',
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
            Padding(
              padding: const EdgeInsets.all(AppSpacing.medium),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search values to replace...',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  isDense: true,
                  border: const OutlineInputBorder(),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 16),
                          onPressed: () {
                            _searchController.clear();
                          },
                        )
                      : null,
                ),
              ),
            ),
            Expanded(
              child: filteredValues.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.medium),
                        child: Text(
                          _searchQuery.isNotEmpty
                              ? 'No values match "$_searchQuery"'
                              : 'No available values for this field',
                          style: textTheme.bodySmall?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredValues.length,
                      itemBuilder: (context, index) {
                        final value = filteredValues[index];
                        return ListTile(
                          dense: true,
                          title: Text(value),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.edit_outlined,
                              size: 18,
                              color: colors.primary,
                            ),
                            onPressed: () {
                              _showReplaceInputDialog(context, value);
                            },
                          ),
                          onTap: () {
                            _showReplaceInputDialog(context, value);
                          },
                        );
                      },
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showReplaceInputDialog(BuildContext context, String originalValue) {
    final newController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Replace "$originalValue"'),
          content: SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Replace all instances of "$originalValue" with:',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: AppSpacing.medium),
                TextField(
                  controller: newController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: 'New value',
                    isDense: true,
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final newValue = newController.text.trim();
                if (newValue.isNotEmpty) {
                  context.read<CustomFieldsCubit>().replaceFieldValue(
                        fieldId: widget.field.id,
                        oldValue: originalValue,
                        newValue: newValue,
                      );
                  Navigator.of(dialogContext).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Replacing "$originalValue" with "$newValue"',
                      ),
                    ),
                  );
                }
              },
              child: const Text('Replace'),
            ),
          ],
        );
      },
    );
  }
}
