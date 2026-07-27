import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/time_tracking_config_model.dart';
import '../models/work_type_model.dart';
import '../models/custom_work_item_attribute_model.dart';

abstract class TimeTrackingRemoteDataSource {
  Future<TimeTrackingConfigModel?> getTimeTrackingConfig(String projectId);
  Future<TimeTrackingConfigModel> saveTimeTrackingConfig(TimeTrackingConfigModel config);

  Future<List<WorkTypeModel>> getWorkTypes(String projectId);
  Future<WorkTypeModel> addWorkType(WorkTypeModel workType);
  Future<WorkTypeModel> updateWorkType(WorkTypeModel workType);
  Future<void> deleteWorkType(String workTypeId);
  Future<void> reorderWorkTypes(List<Map<String, dynamic>> orderUpdates);

  Future<List<CustomWorkItemAttributeModel>> getCustomAttributes(String projectId);
  Future<CustomWorkItemAttributeModel> addCustomAttribute(CustomWorkItemAttributeModel attribute);
  Future<CustomWorkItemAttributeModel> updateCustomAttribute(CustomWorkItemAttributeModel attribute);
  Future<void> deleteCustomAttribute(String attributeId);
}

class TimeTrackingRemoteDataSourceImpl implements TimeTrackingRemoteDataSource {
  final SupabaseClient supabase;

  TimeTrackingRemoteDataSourceImpl(this.supabase);

  @override
  Future<TimeTrackingConfigModel?> getTimeTrackingConfig(String projectId) async {
    final response = await supabase
        .from('time_tracking_configs')
        .select()
        .eq('project_id', projectId)
        .maybeSingle();
    if (response == null) return null;
    return TimeTrackingConfigModel.fromJson(response);
  }

  @override
  Future<TimeTrackingConfigModel> saveTimeTrackingConfig(TimeTrackingConfigModel config) async {
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
    return (response as List)
        .map((e) => WorkTypeModel.fromJson(e))
        .toList();
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
  Future<List<CustomWorkItemAttributeModel>> getCustomAttributes(String projectId) async {
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
  Future<CustomWorkItemAttributeModel> addCustomAttribute(CustomWorkItemAttributeModel attribute) async {
    final response = await supabase
        .from('custom_work_item_attributes')
        .insert(attribute.toInsertJson())
        .select()
        .single();
    return CustomWorkItemAttributeModel.fromJson(response);
  }

  @override
  Future<CustomWorkItemAttributeModel> updateCustomAttribute(CustomWorkItemAttributeModel attribute) async {
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
    await supabase.from('custom_work_item_attributes').delete().eq('id', attributeId);
  }
}
