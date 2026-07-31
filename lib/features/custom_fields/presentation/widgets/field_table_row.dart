import 'package:flutter/material.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/core/enums/custom_field_type_enum.dart';
import '../../domain/entities/custom_field_entity.dart';

class FieldTableRow extends StatelessWidget {
  final CustomFieldEntity field;
  final int index;
  final bool isSelected;
  final bool showDetails;
  final ValueChanged<bool?>? onCheckboxChanged;
  final VoidCallback? onNameTap;
  final ValueChanged<String>? onVisibilityTap;

  const FieldTableRow({
    super.key,
    required this.field,
    required this.index,
    this.isSelected = false,
    this.showDetails = true,
    this.onCheckboxChanged,
    this.onNameTap,
    this.onVisibilityTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

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
                onChanged: onCheckboxChanged,
              ),
            ),
            ReorderableDragStartListener(
              index: index,
              child: Icon(
                Icons.drag_handle,
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: AppSpacing.small),
            Expanded(
              flex: 3,
              child: GestureDetector(
                onTap: onNameTap,
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
            if (showDetails) ...[
              Expanded(
                flex: 2,
                child: Text(
                  field.emptyValue ?? '—',
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Icon(
                  field.canBeEmpty ? Icons.check_circle : Icons.cancel,
                  size: 16,
                  color: field.canBeEmpty ? colors.primary : colors.error,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  field.valueMode == 'single' ? 'Single' : 'Multi',
                  style: textTheme.bodySmall,
                ),
              ),
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: onVisibilityTap != null
                      ? () => onVisibilityTap!(
                          field.visibility == 'show' ? 'hide' : 'show')
                      : null,
                  child: Text(
                    field.visibility == 'show' ? 'Show' : 'Hide',
                    style: textTheme.bodySmall?.copyWith(
                      color: field.visibility == 'show'
                          ? colors.primary
                          : colors.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
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
}
