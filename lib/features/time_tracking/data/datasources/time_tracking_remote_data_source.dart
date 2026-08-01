import 'package:issues_tracking/core/utils/printing.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/time_tracking_config_model.dart';
import '../models/work_type_model.dart';
import '../models/custom_work_item_attribute_model.dart';
import '../models/work_item_attribute_model.dart';
import '../models/attribute_value_model.dart';

abstract class TimeTrackingRemoteDataSource {
  Future<TimeTrackingConfigModel?> getTimeTrackingConfig(String projectId);
  Future<TimeTrackingConfigModel> saveTimeTrackingConfig(
    TimeTrackingConfigModel config,
  );

  Future<List<WorkTypeModel>> getWorkTypes(String projectId);
  Future<WorkTypeModel> addWorkType(WorkTypeModel workType);
  Future<WorkTypeModel> updateWorkType(WorkTypeModel workType);
  Future<void> deleteWorkType(String workTypeId);
  Future<void> reorderWorkTypes(List<Map<String, dynamic>> orderUpdates);

  Future<List<CustomWorkItemAttributeModel>> getCustomAttributes(
    String projectId,
  );
  Future<CustomWorkItemAttributeModel> addCustomAttribute(
    CustomWorkItemAttributeModel attribute,
  );
  Future<CustomWorkItemAttributeModel> updateCustomAttribute(
    CustomWorkItemAttributeModel attribute,
  );
  Future<void> deleteCustomAttribute(String attributeId);

  Future<List<WorkItemAttributeModel>> getWorkItemAttributes(String projectId);
  Future<WorkItemAttributeModel> addWorkItemAttribute(
    WorkItemAttributeModel attribute,
  );
  Future<WorkItemAttributeModel> updateWorkItemAttribute(
    WorkItemAttributeModel attribute,
  );
  Future<void> deleteWorkItemAttribute(String attributeId);

  Future<List<AttributeValueModel>> getAttributeValues(String attributeId);
  Future<AttributeValueModel> addAttributeValue(AttributeValueModel value);
  Future<AttributeValueModel> updateAttributeValue(AttributeValueModel value);
  Future<void> deleteAttributeValue(String valueId);
}

class TimeTrackingRemoteDataSourceImpl implements TimeTrackingRemoteDataSource {
  final SupabaseClient supabase;

  TimeTrackingRemoteDataSourceImpl(this.supabase);

  @override
  Future<TimeTrackingConfigModel?> getTimeTrackingConfig(
    String projectId,
  ) async {
    final response = await supabase
        .from('time_tracking_configs')
        .select()
        .eq('project_id', projectId)
        .maybeSingle();
    if (response == null) return null;
    return TimeTrackingConfigModel.fromJson(response);
  }

  @override
  Future<TimeTrackingConfigModel> saveTimeTrackingConfig(
    TimeTrackingConfigModel config,
  ) async {
    final existing = await getTimeTrackingConfig(config.projectId);
    if (existing == null) {
      final response = await supabase
          .from('time_tracking_configs')
          .insert(config.toJson())
          .select()
          .single();
      return TimeTrackingConfigModel.fromJson(response);
    } else {
      final response = await supabase
          .from('time_tracking_configs')
          .update(config.toJson())
          .eq('project_id', config.projectId)
          .select()
          .single();
      return TimeTrackingConfigModel.fromJson(response);
    }
  }

  @override
  Future<List<WorkTypeModel>> getWorkTypes(String projectId) async {
    final response = await supabase
        .from('work_types')
        .select()
        .eq('project_id', projectId)
        .order('sort_order', ascending: true);
    return (response as List).map((e) => WorkTypeModel.fromJson(e)).toList();
  }

  @override
  Future<WorkTypeModel> addWorkType(WorkTypeModel workType) async {
    final response = await supabase
        .from('work_types')
        .insert(workType.toInsertJson())
        .select()
        .single();
    return WorkTypeModel.fromJson(response);
  }

  @override
  Future<WorkTypeModel> updateWorkType(WorkTypeModel workType) async {
    final response = await supabase
        .from('work_types')
        .update(workType.toJson())
        .eq('id', workType.id)
        .select()
        .single();
    return WorkTypeModel.fromJson(response);
  }

  @override
  Future<void> deleteWorkType(String workTypeId) async {
    await supabase.from('work_types').delete().eq('id', workTypeId);
  }

  @override
  Future<void> reorderWorkTypes(List<Map<String, dynamic>> orderUpdates) async {
    for (final update in orderUpdates) {
      await supabase
          .from('work_types')
          .update({'sort_order': update['sort_order']})
          .eq('id', update['id']);
    }
  }

  @override
  Future<List<CustomWorkItemAttributeModel>> getCustomAttributes(
    String projectId,
  ) async {
    final response = await supabase
        .from('custom_work_item_attributes')
        .select()
        .eq('project_id', projectId)
        .order('sort_order', ascending: true);
    return (response as List)
        .map((e) => CustomWorkItemAttributeModel.fromJson(e))
        .toList();
  }

  @override
  Future<CustomWorkItemAttributeModel> addCustomAttribute(
    CustomWorkItemAttributeModel attribute,
  ) async {
    final response = await supabase
        .from('custom_work_item_attributes')
        .insert(attribute.toInsertJson())
        .select()
        .single();
    return CustomWorkItemAttributeModel.fromJson(response);
  }

  @override
  Future<CustomWorkItemAttributeModel> updateCustomAttribute(
    CustomWorkItemAttributeModel attribute,
  ) async {
    final response = await supabase
        .from('custom_work_item_attributes')
        .update(attribute.toJson())
        .eq('id', attribute.id)
        .select()
        .single();
    return CustomWorkItemAttributeModel.fromJson(response);
  }

  @override
  Future<void> deleteCustomAttribute(String attributeId) async {
    await supabase
        .from('custom_work_item_attributes')
        .delete()
        .eq('id', attributeId);
  }

  @override
  Future<List<WorkItemAttributeModel>> getWorkItemAttributes(
    String projectId,
  ) async {
    final response = await supabase
        .from('work_item_attributes')
        .select()
        .eq('project_id', projectId)
        .order('created_at', ascending: true);

    final attributes = (response as List)
        .map((e) => WorkItemAttributeModel.fromJson(e))
        .toList();

    for (final attribute in attributes) {
      attribute.values.addAll(await getAttributeValues(attribute.id));
    }

    return attributes;
  }

  @override
  Future<WorkItemAttributeModel> addWorkItemAttribute(
    WorkItemAttributeModel attribute,
  ) async {
    final response = await supabase
        .from('work_item_attributes')
        .insert(attribute.toInsertJson())
        .select()
        .maybeSingle();
    if (response == null) {
      throw Exception('Failed to add work item attribute');
    }
    final created = WorkItemAttributeModel.fromJson(response);
    final List<AttributeValueModel> attributeValues = [];
    for (final value in attribute.values) {
      final result = await addAttributeValue(
        AttributeValueModel.fromEntity(value.copyWith(attributeId: created.id, id: '')),
      );
      attributeValues.add(result);
    }
    return created.copyWith(values: attributeValues);
  }

  @override
  Future<WorkItemAttributeModel> updateWorkItemAttribute(
    WorkItemAttributeModel attribute,
  ) async {
    final response = await supabase
        .from('work_item_attributes')
        .update(attribute.toJson())
        .eq('id', attribute.id)
        .select()
        .single();
    final updated = WorkItemAttributeModel.fromJson(response);
    await Future.wait(
      attribute.values.map((value) async {
        if (value.id.isEmpty) {
          await addAttributeValue(
            AttributeValueModel.fromEntity(value.copyWith(attributeId: updated.id)),
          );
        } else {
          await updateAttributeValue(
            AttributeValueModel.fromEntity(value.copyWith(attributeId: updated.id)),
          );
        }
      }),
    );
    updated.values.addAll(await getAttributeValues(updated.id));
    return updated;
  }

  @override
  Future<void> deleteWorkItemAttribute(String attributeId) async {
    await supabase
        .from('attribute_values')
        .delete()
        .eq('attribute_id', attributeId);
    await supabase.from('work_item_attributes').delete().eq('id', attributeId);
  }

  @override
  Future<List<AttributeValueModel>> getAttributeValues(
    String attributeId,
  ) async {
    final response = await supabase
        .from('attribute_values')
        .select()
        .eq('attribute_id', attributeId)
        .order('created_at', ascending: true);
    return (response as List)
        .map((e) => AttributeValueModel.fromJson(e))
        .toList();
  }

  @override
  Future<AttributeValueModel> addAttributeValue(
    AttributeValueModel value,
  ) async {
    printMap(title: 'Adding Attribute Value', data: value.toJson());
    final response = await supabase
        .from('attribute_values')
        .insert(value.toJson())
        .select()
        .single();
    return AttributeValueModel.fromJson(response);
  }

  @override
  Future<AttributeValueModel> updateAttributeValue(
    AttributeValueModel value,
  ) async {
    final response = await supabase
        .from('attribute_values')
        .update(value.toJson())
        .eq('id', value.id)
        .select()
        .single();
    return AttributeValueModel.fromJson(response);
  }

  @override
  Future<void> deleteAttributeValue(String valueId) async {
    await supabase.from('attribute_values').delete().eq('id', valueId);
  }
}
