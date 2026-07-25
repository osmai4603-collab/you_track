import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/enums/custom_field_type_enum.dart';
import 'package:issues_tracking/features/custom_fields/presentation/widgets/panel_overlay.dart';
import 'package:issues_tracking/features/custom_fields/presentation/widgets/sliding_panel.dart';
import 'package:reorderables/reorderables.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/features/projects/presentation/cubits/project_details_cubit.dart';
import '../../domain/entities/custom_field_entity.dart';
import '../cubits/custom_fields_cubit.dart';

class CustomFieldsSettingsSection extends StatefulWidget {
  const CustomFieldsSettingsSection({super.key});

  @override
  State<CustomFieldsSettingsSection> createState() =>
      _CustomFieldsSettingsSectionState();
}

class _CustomFieldsSettingsSectionState
    extends State<CustomFieldsSettingsSection> {
  final Set<String> _selectedFieldIds = {};
  bool _isPanelOpen = false;
  final _fieldNameController = TextEditingController();
  final _defaultValueController = TextEditingController();
  CustomFieldEnumType _selectedType = CustomFieldEnumType.string;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final projectId =
        context.read<ProjectDetailsCubit>().state.project?.id;
    if (projectId != null) {
      context.read<CustomFieldsCubit>().loadFields(projectId);
    }
  }

  void _refresh() {
    final projectId =
        context.read<ProjectDetailsCubit>().state.project?.id;
    if (projectId != null) {
      context.read<CustomFieldsCubit>().loadFields(projectId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocConsumer<CustomFieldsCubit, CustomFieldsState>(
      listener: (context, state) {
        if (state is CustomFieldsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: colors.error,
            ),
          );
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.large),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(colors, textTheme, state),
                  const SizedBox(height: AppSpacing.medium),
                  if (_selectedFieldIds.isNotEmpty)
                    _buildSelectionBar(colors, textTheme),
                  const SizedBox(height: AppSpacing.medium),
                  Expanded(
                    child: _buildContent(state, colors, textTheme),
                  ),
                ],
              ),
            ),
            // Overlay
            PanelOverlay(
              isVisible: _isPanelOpen,
              onTap: _closePanel,
            ),
            // Sliding panel
            SlidingPanel(
              isOpen: _isPanelOpen,
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Add Custom Field',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: _closePanel,
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    // Form content
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: _fieldNameController,
                              decoration: const InputDecoration(
                                labelText: 'Field name',
                                hintText: 'e.g. Priority',
                                isDense: true,
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.medium),
                            DropdownButtonFormField<CustomFieldEnumType>(
                              initialValue: _selectedType,
                              decoration: const InputDecoration(
                                labelText: 'Type',
                                isDense: true,
                                border: OutlineInputBorder(),
                              ),
                              items: CustomFieldEnumType.values.map((type) {
                                return DropdownMenuItem(
                                  value: type,
                                  child: Text(_typeDisplayName(type)),
                                );
                              }).toList(),
                              onChanged: (type) {
                                if (type != null) {
                                  setState(() {
                                    _selectedType = type;
                                  });
                                }
                              },
                            ),
                            const SizedBox(height: AppSpacing.medium),
                            TextField(
                              controller: _defaultValueController,
                              decoration: const InputDecoration(
                                labelText: 'Default value (optional)',
                                isDense: true,
                                border: OutlineInputBorder(),
                              ),
                            ),
                            if (_isSubmitting) ...[
                              const SizedBox(height: AppSpacing.medium),
                              const LinearProgressIndicator(),
                            ],
                          ],
                        ),
                      ),
                    ),
                    // Action buttons
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: _isSubmitting ? null : _closePanel,
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: AppSpacing.small),
                          FilledButton(
                            onPressed: _isSubmitting ? null : _submitAddField,
                            child: const Text('Add'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (state is CustomFieldsLoaded && state.isSaving)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: LinearProgressIndicator(
                  backgroundColor: colors.surfaceContainerLow,
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildHeader(ColorScheme colors, TextTheme textTheme,
      CustomFieldsState state) {
    return Row(
      children: [
        Text(
          'Custom Fields',
          style:
              textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        if (state is CustomFieldsLoaded) ...[
          FilledButton.icon(
            onPressed: _openPanel,
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add field'),
          ),
          const SizedBox(width: AppSpacing.small),
          IconButton(
            onPressed: _refresh,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ],
    );
  }

  Widget _buildSelectionBar(ColorScheme colors, TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.medium,
        vertical: AppSpacing.small,
      ),
      decoration: BoxDecoration(
        color: colors.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Text(
            '${_selectedFieldIds.length} selected',
            style: textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: () {
              setState(() => _selectedFieldIds.clear());
            },
            icon: const Icon(Icons.deselect, size: 16),
            label: const Text('Deselect'),
          ),
          const SizedBox(width: AppSpacing.small),
          TextButton.icon(
            onPressed: () => _confirmDeleteSelected(context),
            icon: Icon(Icons.delete_outline, size: 16, color: colors.error),
            label: Text(
              'Delete',
              style: TextStyle(color: colors.error),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
      CustomFieldsState state, ColorScheme colors, TextTheme textTheme) {
    if (state is CustomFieldsInitial || state is CustomFieldsLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is CustomFieldsError && state is! CustomFieldsLoaded) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: colors.error),
            const SizedBox(height: AppSpacing.medium),
            Text(
              'Failed to load custom fields',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.small),
            Text(
              state.message,
              style: textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.medium),
            FilledButton(
              onPressed: _refresh,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final fields = (state as CustomFieldsLoaded).fields;

    if (fields.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.list_alt_outlined, size: 64, color: colors.onSurfaceVariant.withValues(alpha: 0.4)),
            const SizedBox(height: AppSpacing.medium),
            Text(
              'No custom fields yet',
              style: textTheme.titleMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.small),
            Text(
              'Add your first custom field to start capturing\nproject-specific data on issues.',
              style: textTheme.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.large),
            FilledButton.icon(
              onPressed: _openPanel,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add field'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTableHeader(colors, textTheme),
          const Divider(height: 1),
          _buildTableBody(fields, colors, textTheme),
        ],
      ),
    );
  }

  Widget _buildTableHeader(ColorScheme colors, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.small),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Checkbox(
              value: _selectedFieldIds.length ==
                      (context.read<CustomFieldsCubit>().state
                              is CustomFieldsLoaded
                          ? (context.read<CustomFieldsCubit>().state
                                  as CustomFieldsLoaded)
                              .fields
                              .length
                          : 0) &&
                  _selectedFieldIds.isNotEmpty,
              tristate: true,
              onChanged: _toggleSelectAll,
            ),
          ),
          const SizedBox(width: 8),
          const SizedBox(width: 32),
          Expanded(
            flex: 3,
            child: Text(
              'Name',
              style:
                  textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Type',
              style:
                  textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Default Value',
              style:
                  textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableBody(List<CustomFieldEntity> fields,
      ColorScheme colors, TextTheme textTheme) {
    return ReorderableColumn(
      onReorder: (int oldIndex, int newIndex) {
        final projectId =
            context.read<ProjectDetailsCubit>().state.project?.id;
        if (projectId != null) {
          context.read<CustomFieldsCubit>().reorderField(
                projectId: projectId,
                oldIndex: oldIndex,
                newIndex: newIndex,
              );
        }
      },
      children: fields.asMap().entries.map((entry) {
        final index = entry.key;
        final field = entry.value;
        return _buildFieldRow(
          field,
          index,
          colors,
          textTheme,
        );
      }).toList(),
    );
  }

  Widget _buildFieldRow(CustomFieldEntity field, int index,
      ColorScheme colors, TextTheme textTheme) {
    final isSelected = _selectedFieldIds.contains(field.id);

    return Material(
      key: ValueKey(field.id),
      type: MaterialType.transparency,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.small),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              child: Checkbox(
                value: isSelected,
                onChanged: (checked) {
                  setState(() {
                    if (checked == true) {
                      _selectedFieldIds.add(field.id);
                    } else {
                      _selectedFieldIds.remove(field.id);
                    }
                  });
                },
              ),
            ),
            ReorderableDragStartListener(
              index: index,
              child: const Icon(Icons.drag_handle),
            ),
            const SizedBox(width: AppSpacing.small),
            Expanded(
              flex: 3,
              child: GestureDetector(
                onTap: () => _showEditFieldDialog(context, field),
                child: Text(
                  field.name,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: _buildTypeChip(field.fieldType, colors, textTheme),
            ),
            Expanded(
              flex: 2,
              child: Text(
                field.defaultValue ?? '—',
                style: textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeChip(
      CustomFieldEnumType type, ColorScheme colors, TextTheme textTheme) {
    final label = _typeDisplayName(type);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.small,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Text(
        label,
        style: textTheme.labelSmall?.copyWith(fontSize: 11),
      ),
    );
  }

  String _typeDisplayName(CustomFieldEnumType type) {
    switch (type) {
      case CustomFieldEnumType.build:
        return 'Build';
      case CustomFieldEnumType.enumField:
        return 'Enum';
      case CustomFieldEnumType.group:
        return 'Group';
      case CustomFieldEnumType.ownedField:
        return 'Owned Field';
      case CustomFieldEnumType.state:
        return 'State';
      case CustomFieldEnumType.user:
        return 'User';
      case CustomFieldEnumType.version:
        return 'Version';
      case CustomFieldEnumType.date:
        return 'Date';
      case CustomFieldEnumType.dateTime:
        return 'Date Time';
      case CustomFieldEnumType.float:
        return 'Float';
      case CustomFieldEnumType.integer:
        return 'Integer';
      case CustomFieldEnumType.string:
        return 'String';
      case CustomFieldEnumType.text:
        return 'Text';
      case CustomFieldEnumType.period:
        return 'Period';
        default:
        return 'Period';
    }
  }

  void _toggleSelectAll(bool? value) {
    final state = context.read<CustomFieldsCubit>().state;
    if (state is CustomFieldsLoaded) {
      setState(() {
        if (value == true) {
          _selectedFieldIds.addAll(state.fields.map((f) => f.id));
        } else {
          _selectedFieldIds.clear();
        }
      });
    }
  }

  void _showEditFieldDialog(BuildContext context, CustomFieldEntity field) {
    final nameController = TextEditingController(text: field.name);
    CustomFieldEnumType selectedType = field.fieldType;
    String? selectedDefault = field.defaultValue;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Edit Custom Field'),
              content: SizedBox(
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Field name',
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.medium),
                    DropdownButtonFormField<CustomFieldEnumType>(
                      initialValue: selectedType,
                      decoration: const InputDecoration(
                        labelText: 'Type',
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                      items: CustomFieldEnumType.values.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(_typeDisplayName(type)),
                        );
                      }).toList(),
                      onChanged: (type) {
                        if (type != null && type != selectedType) {
                          setDialogState(() {
                            selectedType = type;
                            // selectedDefault =
                            //     type.firstAvailableOrDefault(null);
                          });
                        }
                      },
                    ),
                    const SizedBox(height: AppSpacing.medium),
                    DropdownButtonFormField<String>(
                      initialValue: selectedDefault,
                      decoration: const InputDecoration(
                        labelText: 'Default value (optional)',
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        const DropdownMenuItem(
                          value: null,
                          child: Text('None'),
                        ),
                        ...selectedType.availableValues.map((v) {
                          return DropdownMenuItem(
                            value: v,
                            child: Text(v),
                          );
                        }),
                      ],
                      onChanged: (value) {
                        setDialogState(() => selectedDefault = value);
                      },
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
                    final name = nameController.text.trim();
                    if (name.isEmpty) {
                      ScaffoldMessenger.of(dialogContext).showSnackBar(
                        const SnackBar(
                          content: Text('Field name is required'),
                        ),
                      );
                      return;
                    }
                    context.read<CustomFieldsCubit>().updateField(
                          fieldId: field.id,
                          name: name,
                          fieldType: selectedType,
                          defaultValue: selectedDefault,
                        );
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmDeleteSelected(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Custom Fields'),
          content: Text(
            'Are you sure you want to delete ${_selectedFieldIds.length} custom field(s)? '
            'Existing issue data for these fields will be preserved.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              onPressed: () {
                context
                    .read<CustomFieldsCubit>()
                    .deleteFields(_selectedFieldIds.toList());
                setState(() => _selectedFieldIds.clear());
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
  
  void _closePanel() {
    setState(() {
      _isPanelOpen = false;
    });
  }

  void _openPanel() {
    setState(() {
      _isPanelOpen = true;
    });
  }

  void _submitAddField() {
    final name = _fieldNameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Field name is required'),
        ),
      );
      return;
    }
    final projectId =
        context.read<ProjectDetailsCubit>().state.project?.id;
    if (projectId != null) {
      setState(() {
        _isSubmitting = true;
      });
      context.read<CustomFieldsCubit>().addField(
            projectId: projectId,
            name: name,
            fieldType: _selectedType,
            defaultValue: _defaultValueController.text.trim().isEmpty
                ? null
                : _defaultValueController.text.trim(),
          );
      _fieldNameController.clear();
      _defaultValueController.clear();
      setState(() {
        _selectedType = CustomFieldEnumType.string;
        _isSubmitting = false;
        _isPanelOpen = false;
      });
    }
  }

  @override
  void dispose() {
    _fieldNameController.dispose();
    _defaultValueController.dispose();
    super.dispose();
  }
}
