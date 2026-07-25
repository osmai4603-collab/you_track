import '../../../../core/entities/entity.dart';
import '../../../../core/enums/custom_field_type_enum.dart';

class CustomFieldEntity extends Entity {
  final String id;
  final String projectId;
  final String name;
  final CustomFieldTypeEnum fieldType;
  final String fieldMode;
  final String valueMode;
  final String? defaultValue;
  final String? emptyValue;
  final bool canBeEmpty;
  final List<String>? aliases;
  final List<String>? visibleTo;
  final List<String>? updatableBy;
  final String? showOnlyWhen;
  final String? filterValuesBasedOn;
  final int orderIndex;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CustomFieldEntity({
    required this.id,
    required this.projectId,
    required this.name,
    required this.fieldType,
    this.fieldMode = 'ownedField',
    this.valueMode = 'single',
    this.defaultValue,
    this.emptyValue,
    this.canBeEmpty = true,
    this.aliases,
    this.visibleTo,
    this.updatableBy,
    this.showOnlyWhen,
    this.filterValuesBasedOn,
    this.orderIndex = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  CustomFieldEntity copyWith({
    String? id,
    String? projectId,
    String? name,
    CustomFieldTypeEnum? fieldType,
    String? fieldMode,
    String? valueMode,
    String? defaultValue,
    String? emptyValue,
    bool? canBeEmpty,
    List<String>? aliases,
    List<String>? visibleTo,
    List<String>? updatableBy,
    String? showOnlyWhen,
    String? filterValuesBasedOn,
    int? orderIndex,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CustomFieldEntity(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      name: name ?? this.name,
      fieldType: fieldType ?? this.fieldType,
      fieldMode: fieldMode ?? this.fieldMode,
      valueMode: valueMode ?? this.valueMode,
      defaultValue: defaultValue ?? this.defaultValue,
      emptyValue: emptyValue ?? this.emptyValue,
      canBeEmpty: canBeEmpty ?? this.canBeEmpty,
      aliases: aliases ?? this.aliases,
      visibleTo: visibleTo ?? this.visibleTo,
      updatableBy: updatableBy ?? this.updatableBy,
      showOnlyWhen: showOnlyWhen ?? this.showOnlyWhen,
      filterValuesBasedOn: filterValuesBasedOn ?? this.filterValuesBasedOn,
      orderIndex: orderIndex ?? this.orderIndex,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        projectId,
        name,
        fieldType,
        fieldMode,
        valueMode,
        defaultValue,
        emptyValue,
        canBeEmpty,
        aliases,
        visibleTo,
        updatableBy,
        showOnlyWhen,
        filterValuesBasedOn,
        orderIndex,
        createdAt,
        updatedAt,
      ];
}
