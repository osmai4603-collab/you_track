import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/enums/custom_field_type_enum.dart';
import 'package:issues_tracking/features/custom_fields/presentation/widgets/panel_overlay.dart';
import 'package:issues_tracking/features/custom_fields/presentation/widgets/sliding_panel.dart';
import 'package:issues_tracking/features/custom_fields/presentation/widgets/field_table_header.dart';
import 'package:issues_tracking/features/custom_fields/presentation/widgets/field_table_row.dart';
import 'package:issues_tracking/features/custom_fields/presentation/widgets/replace_value_popup.dart';
import 'package:issues_tracking/features/custom_fields/presentation/widgets/make_private_dialog.dart';
import 'package:reorderables/reorderables.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/core/widgets/shimmer_loading.dart';
import 'package:issues_tracking/features/projects/presentation/cubits/project_details_cubit.dart';
import 'package:issues_tracking/features/custom_fields/presentation/widgets/custom_field_details_panel.dart';
import 'package:issues_tracking/features/custom_fields/presentation/widgets/advanced_field_settings_dialog.dart';
import '../../domain/entities/custom_field_entity.dart';
import '../cubits/custom_fields_cubit.dart';

class ProjectSettingCustomFieldsSection extends StatefulWidget {
  const ProjectSettingCustomFieldsSection({super.key});

  @override
  State<ProjectSettingCustomFieldsSection> createState() =>
      _ProjectSettingCustomFieldsSectionState();
}

class _ProjectSettingCustomFieldsSectionState
    extends State<ProjectSettingCustomFieldsSection> {
  final Set<String> _selectedFieldIds = {};
  bool _isPanelOpen = false;
  bool _isDetailsPanelOpen = false;
  bool _showDetails = true;
  final _fieldNameController = TextEditingController();
  final _defaultValueController = TextEditingController();
  final _emptyValueController = TextEditingController();
  final _aliasesController = TextEditingController();
  CustomFieldEnumType _selectedType = CustomFieldEnumType.string;
  bool _canBeEmpty = true;
  String _valueMode = 'single';
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final projectId = context.read<ProjectDetailsCubit>().state.project?.id;
    if (projectId != null) {
      context.read<CustomFieldsCubit>().loadFields(projectId);
    }
  }

  void _refresh() {
    final projectId = context.read<ProjectDetailsCubit>().state.project?.id;
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
              content: SelectableText(state.message),
              backgroundColor: colors.error,
            ),
          );
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.large),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildToolbar(colors, textTheme, state),
              const SizedBox(height: AppSpacing.medium),
              Expanded(
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_selectedFieldIds.isNotEmpty)
                          _buildSelectionBar(colors, textTheme),
                        if (_selectedFieldIds.isNotEmpty)
                          const SizedBox(height: AppSpacing.medium),
                        Expanded(
                          child: _buildContent(state, colors, textTheme),
                        ),
                      ],
                    ),
                    // Overlay
                    PanelOverlay(
                      isVisible:
                          _isPanelOpen ||
                          (_isDetailsPanelOpen &&
                              _selectedFieldIds.length == 1),
                      onTap: () {
                        _closePanel();
                        _closeDetailsPanel();
                      },
                    ),
                    // Sliding panel
                    SlidingPanel(
                      isOpen: _isPanelOpen,
                      child: _buildAddFieldPanel(colors, textTheme),
                    ),
                    // Details Sliding panel
                    if (state is CustomFieldsLoaded)
                      SlidingPanel(
                        isOpen:
                            _isDetailsPanelOpen &&
                            _selectedFieldIds.length == 1,
                        child: _buildDetailsPanel(state),
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
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailsPanel(CustomFieldsLoaded state) {
    final fields = state.fields;
    if (fields.isEmpty) return const SizedBox.shrink();

    CustomFieldEntity? field;
    final selectedId = _selectedFieldIds.isNotEmpty
        ? _selectedFieldIds.first
        : null;
    if (selectedId == null) {
      field = fields.first;
    } else {
      for (final f in fields) {
        if (f.id == selectedId) {
          field = f;
          break;
        }
      }
    }
    if (field == null) return const SizedBox.shrink();

    return CustomFieldDetailsPanel(
      field: field,
      onClose: _closeDetailsPanel,
      onEdit: _editSelectedField,
    );
  }

  Widget _buildToolbar(
    ColorScheme colors,
    TextTheme textTheme,
    CustomFieldsState state,
  ) {
    final hasSelection = _selectedFieldIds.isNotEmpty;
    final canEdit = _selectedFieldIds.length == 1;

    return Row(
      children: [
        FilledButton.icon(
          onPressed: _openPanel,
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Add field to project ...'),
        ),
        const SizedBox(width: AppSpacing.small),
        IconButton(
          onPressed: canEdit ? _editSelectedField : null,
          icon: const Icon(Icons.edit_outlined, size: 20),
          tooltip: 'Edit',
        ),
        IconButton(
          onPressed: hasSelection
              ? () => _confirmDeleteSelected(context)
              : null,
          icon: Icon(
            Icons.delete_outline,
            size: 20,
            color: hasSelection ? colors.error : null,
          ),
          tooltip: 'Delete',
        ),
        const SizedBox(width: AppSpacing.small),
        OutlinedButton(
          onPressed: hasSelection && _selectedFieldIds.length == 1
              ? _showReplacePopup
              : null,
          child: const Text('Replace'),
        ),
        const SizedBox(width: AppSpacing.small),
        OutlinedButton(
          onPressed: hasSelection && _selectedFieldIds.length == 1
              ? _showMakePrivateDialog
              : null,
          child: const Text('Make private'),
        ),
        const SizedBox(width: AppSpacing.small),
        FilledButton(
          onPressed: hasSelection && _selectedFieldIds.length == 1
              ? _makeFieldPublic
              : null,
          child: const Text('Make public'),
        ),
        const SizedBox(width: AppSpacing.small),
        OutlinedButton.icon(
          onPressed: hasSelection && _selectedFieldIds.length == 1
              ? _showAdvancedSettings
              : null,
          icon: const Icon(Icons.settings_outlined, size: 18),
          label: const Text('Advanced'),
        ),
        const Spacer(),
        TextButton.icon(
          onPressed: canEdit
              ? () {
                  setState(() {
                    _isDetailsPanelOpen = !_isDetailsPanelOpen;
                  });
                }
              : () {
                  setState(() {
                    _showDetails = !_showDetails;
                  });
                },
          icon: Icon(
            canEdit
                ? (_isDetailsPanelOpen
                      ? Icons.visibility_off
                      : Icons.visibility)
                : (_showDetails ? Icons.visibility_off : Icons.visibility),
            size: 18,
          ),
          label: Text(
            canEdit
                ? (_isDetailsPanelOpen ? 'Hide details' : 'Show details')
                : (_showDetails ? 'Hide columns' : 'Show columns'),
          ),
        ),
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
            style: textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w500),
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
            label: Text('Delete', style: TextStyle(color: colors.error)),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    CustomFieldsState state,
    ColorScheme colors,
    TextTheme textTheme,
  ) {
    if (state is CustomFieldsInitial || state is CustomFieldsLoading) {
      return Center(
        key: const ValueKey('custom-fields-loading'),
        child: SizedBox(width: 480, child: ShimmerLoading.list(itemCount: 6)),
      );
    }

    if (state is CustomFieldsError && state is! CustomFieldsLoaded) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: colors.error),
            const SizedBox(height: AppSpacing.medium),
            Text('Failed to load custom fields', style: textTheme.bodyMedium),
            const SizedBox(height: AppSpacing.small),
            SelectableText(
              state.message,
              style: textTheme.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.medium),
            FilledButton(onPressed: _refresh, child: const Text('Retry')),
          ],
        ),
      );
    }

    final fields = (state as CustomFieldsLoaded).fields;

    if (fields.isEmpty) {
      return _buildEmptyState(colors, textTheme);
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FieldTableHeader(
            selectedCount: _selectedFieldIds.length,
            totalCount: fields.length,
            onSelectAll: _toggleSelectAll,
            showDetails: _showDetails,
          ),
          const Divider(height: 1),
          _buildTableBody(fields, colors, textTheme),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ColorScheme colors, TextTheme textTheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.list_alt_outlined,
            size: 64,
            color: colors.onSurfaceVariant.withValues(alpha: 0.4),
          ),
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
            label: const Text('Add field to project ...'),
          ),
        ],
      ),
    );
  }

  Widget _buildTableBody(
    List<CustomFieldEntity> fields,
    ColorScheme colors,
    TextTheme textTheme,
  ) {
    return ReorderableColumn(
      onReorder: (int oldIndex, int newIndex) {
        final projectId = context.read<ProjectDetailsCubit>().state.project?.id;
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
        return FieldTableRow(
          key: ValueKey(field.id),
          field: field,
          index: index,
          isSelected: _selectedFieldIds.contains(field.id),
          showDetails: _showDetails,
          onCheckboxChanged: (checked) {
            setState(() {
              if (checked == true) {
                _selectedFieldIds.add(field.id);
                if (_selectedFieldIds.length > 1) {
                  _isDetailsPanelOpen = false;
                }
              } else {
                _selectedFieldIds.remove(field.id);
                if (_selectedFieldIds.isEmpty) {
                  _isDetailsPanelOpen = false;
                }
              }
            });
          },
          onNameTap: () {
            setState(() {
              _selectedFieldIds.clear();
              _selectedFieldIds.add(field.id);
              _isDetailsPanelOpen = true;
            });
          },
          onVisibilityTap: (newVisibility) {
            context.read<CustomFieldsCubit>().updateVisibility(
              fieldId: field.id,
              visibility: newVisibility,
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildAddFieldPanel(ColorScheme colors, TextTheme textTheme) {
    return Container(
      color: colors.surface,
      child: Column(
        children: [
          // Header
          Padding(
            padding: AppSpacing.paddingAllMedium,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Add Custom Field',
                  style: textTheme.titleLarge?.copyWith(
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
              padding: AppSpacing.paddingAllMedium,
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
                  const SizedBox(height: AppSpacing.medium),
                  TextField(
                    controller: _emptyValueController,
                    decoration: const InputDecoration(
                      labelText: 'Empty value (optional)',
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  SwitchListTile(
                    value: _canBeEmpty,
                    onChanged: (value) {
                      setState(() => _canBeEmpty = value);
                    },
                    title: const Text('Can be empty'),
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  DropdownButtonFormField<String>(
                    initialValue: _valueMode,
                    decoration: const InputDecoration(
                      labelText: 'Value mode',
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'single', child: Text('Single')),
                      DropdownMenuItem(value: 'multi', child: Text('Multi')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _valueMode = value);
                      }
                    },
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  TextField(
                    controller: _aliasesController,
                    decoration: const InputDecoration(
                      labelText: 'Aliases (optional, comma-separated)',
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
            padding: AppSpacing.paddingAllMedium,
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
    );
  }

  String _typeDisplayName(CustomFieldEnumType type) {
    switch (type) {
      case CustomFieldEnumType.build:
        return 'build (single)';
      case CustomFieldEnumType.enumField:
        return 'enum (single)';
      case CustomFieldEnumType.group:
        return 'group (single)';
      case CustomFieldEnumType.ownedField:
        return 'ownedField (single)';
      case CustomFieldEnumType.state:
        return 'state (single)';
      case CustomFieldEnumType.user:
        return 'user (single)';
      case CustomFieldEnumType.version:
        return 'version (multi)';
      case CustomFieldEnumType.date:
        return 'date';
      case CustomFieldEnumType.dateTime:
        return 'date time';
      case CustomFieldEnumType.float:
        return 'float';
      case CustomFieldEnumType.integer:
        return 'integer';
      case CustomFieldEnumType.string:
        return 'string';
      case CustomFieldEnumType.text:
        return 'text';
      case CustomFieldEnumType.period:
        return 'period';
      default:
        return 'period';
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

  CustomFieldEntity? _findSelectedField(CustomFieldsLoaded state) {
    if (_selectedFieldIds.isEmpty) return null;
    final selectedId = _selectedFieldIds.first;
    for (final f in state.fields) {
      if (f.id == selectedId) return f;
    }
    return null;
  }

  void _editSelectedField() {
    if (_selectedFieldIds.length != 1) return;
    final state = context.read<CustomFieldsCubit>().state;
    if (state is CustomFieldsLoaded) {
      final field = _findSelectedField(state);
      if (field == null) return;
      _showEditFieldDialog(context, field);
    }
  }

  void _showEditFieldDialog(BuildContext context, CustomFieldEntity field) {
    final nameController = TextEditingController(text: field.name);
    final emptyValueController = TextEditingController(
      text: field.emptyValue ?? '',
    );
    final aliasesController = TextEditingController(
      text: field.aliases?.join(', ') ?? '',
    );
    CustomFieldEnumType selectedType = field.fieldType;
    String? selectedDefault = field.defaultValue;
    bool canBeEmpty = field.canBeEmpty;
    String valueMode = field.valueMode;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Edit Custom Field'),
              content: SizedBox(
                width: 400,
                child: SingleChildScrollView(
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
                            return DropdownMenuItem(value: v, child: Text(v));
                          }),
                        ],
                        onChanged: (value) {
                          setDialogState(() => selectedDefault = value);
                        },
                      ),
                      const SizedBox(height: AppSpacing.medium),
                      TextField(
                        controller: emptyValueController,
                        decoration: const InputDecoration(
                          labelText: 'Empty value (optional)',
                          isDense: true,
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.medium),
                      SwitchListTile(
                        value: canBeEmpty,
                        onChanged: (value) {
                          setDialogState(() => canBeEmpty = value);
                        },
                        title: const Text('Can be empty'),
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      const SizedBox(height: AppSpacing.medium),
                      DropdownButtonFormField<String>(
                        initialValue: valueMode,
                        decoration: const InputDecoration(
                          labelText: 'Value mode',
                          isDense: true,
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'single',
                            child: Text('Single'),
                          ),
                          DropdownMenuItem(
                            value: 'multi',
                            child: Text('Multi'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setDialogState(() => valueMode = value);
                          }
                        },
                      ),
                      const SizedBox(height: AppSpacing.medium),
                      TextField(
                        controller: aliasesController,
                        decoration: const InputDecoration(
                          labelText: 'Aliases (optional, comma-separated)',
                          isDense: true,
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
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
                        const SnackBar(content: Text('Field name is required')),
                      );
                      return;
                    }
                    context.read<CustomFieldsCubit>().updateField(
                      fieldId: field.id,
                      name: name,
                      fieldType: selectedType,
                      defaultValue: selectedDefault,
                      emptyValue: emptyValueController.text.trim().isEmpty
                          ? null
                          : emptyValueController.text.trim(),
                      canBeEmpty: canBeEmpty,
                      valueMode: valueMode,
                      aliases: aliasesController.text.trim().isEmpty
                          ? null
                          : aliasesController.text
                                .split(',')
                                .map((e) => e.trim())
                                .where((e) => e.isNotEmpty)
                                .toList(),
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
                context.read<CustomFieldsCubit>().deleteFields(
                  _selectedFieldIds.toList(),
                );
                setState(() {
                  _selectedFieldIds.clear();
                  _isDetailsPanelOpen = false;
                });
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showReplacePopup() {
    if (_selectedFieldIds.length != 1) return;
    final state = context.read<CustomFieldsCubit>().state;
    if (state is CustomFieldsLoaded) {
      final field = _findSelectedField(state);
      if (field == null) return;
      showDialog(
        context: context,
        builder: (context) => ReplaceValuePopup(field: field),
      );
    }
  }

  void _showMakePrivateDialog() {
    if (_selectedFieldIds.length != 1) return;
    final state = context.read<CustomFieldsCubit>().state;
    if (state is CustomFieldsLoaded) {
      final field = _findSelectedField(state);
      if (field == null) return;
      showDialog(
        context: context,
        builder: (context) => MakePrivateDialog(field: field),
      );
    }
  }

  void _makeFieldPublic() {
    if (_selectedFieldIds.length != 1) return;
    final state = context.read<CustomFieldsCubit>().state;
    if (state is CustomFieldsLoaded) {
      final field = _findSelectedField(state);
      if (field == null) return;
      context.read<CustomFieldsCubit>().updateAccessControl(
        fieldId: field.id,
        accessControl: const {'type': 'everyone'},
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Field is now visible to everyone')),
      );
    }
  }

  void _showAdvancedSettings() {
    if (_selectedFieldIds.length != 1) return;
    final state = context.read<CustomFieldsCubit>().state;
    if (state is CustomFieldsLoaded) {
      final field = _findSelectedField(state);
      if (field == null) return;
      showDialog(
        context: context,
        builder: (context) => AdvancedFieldSettingsDialog(field: field),
      );
    }
  }

  void _closePanel() {
    setState(() {
      _isPanelOpen = false;
    });
  }

  void _closeDetailsPanel() {
    setState(() {
      _isDetailsPanelOpen = false;
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Field name is required')));
      return;
    }
    final projectId = context.read<ProjectDetailsCubit>().state.project?.id;
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
        emptyValue: _emptyValueController.text.trim().isEmpty
            ? null
            : _emptyValueController.text.trim(),
        canBeEmpty: _canBeEmpty,
        valueMode: _valueMode,
        aliases: _aliasesController.text.trim().isEmpty
            ? null
            : _aliasesController.text
                  .split(',')
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty)
                  .toList(),
      );
      _fieldNameController.clear();
      _defaultValueController.clear();
      _emptyValueController.clear();
      _aliasesController.clear();
      setState(() {
        _selectedType = CustomFieldEnumType.string;
        _canBeEmpty = true;
        _valueMode = 'single';
        _isSubmitting = false;
        _isPanelOpen = false;
      });
    }
  }

  @override
  void dispose() {
    _fieldNameController.dispose();
    _defaultValueController.dispose();
    _emptyValueController.dispose();
    _aliasesController.dispose();
    super.dispose();
  }
}
