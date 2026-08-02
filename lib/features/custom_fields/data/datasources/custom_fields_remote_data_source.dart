import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/custom_field_model.dart';

abstract class CustomFieldsRemoteDataSource {
  Future<List<CustomFieldModel>> getFields(String projectId);

  Future<CustomFieldModel> addField(CustomFieldModel field);

  Future<CustomFieldModel> updateField(CustomFieldModel field);

  Future<void> deleteFields(List<String> fieldIds);

  Future<void> reorderFields(
      String projectId, List<Map<String, dynamic>> orderUpdates);

  Future<CustomFieldModel> updateVisibility({
    required String fieldId,
    required String visibility,
  });

  Future<CustomFieldModel> updateAccessControl({
    required String fieldId,
    required Map<String, dynamic> accessControl,
  });

  Future<void> replaceFieldValue({
    required String fieldId,
    required String oldValue,
    required String newValue,
  });

  Future<CustomFieldModel> updateAdvancedSettings({
    required String fieldId,
    List<String>? visibleTo,
    List<String>? updatableBy,
    String? showOnlyWhen,
    String? filterValuesBasedOn,
  });
}

class CustomFieldsRemoteDataSourceImpl implements CustomFieldsRemoteDataSource {
  final SupabaseClient supabase;

  CustomFieldsRemoteDataSourceImpl(this.supabase);

  @override
  Future<List<CustomFieldModel>> getFields(String projectId) async {
    final response = await supabase
        .from('custom_fields')
        .select()
        .eq('project_id', projectId)
        .order('order_index', ascending: true);
    return (response as List)
        .map((e) => CustomFieldModel.fromJson(e))
        .toList();
  }

  @override
  Future<CustomFieldModel> addField(CustomFieldModel field) async {
    final response = await supabase
        .from('custom_fields')
        .insert(field.toInsertJson())
        .select()
        .single();
    return CustomFieldModel.fromJson(response);
  }

  @override
  Future<CustomFieldModel> updateField(CustomFieldModel field) async {
    final response = await supabase
        .from('custom_fields')
        .update(field.toJson())
        .eq('id', field.id)
        .select()
        .single();
    return CustomFieldModel.fromJson(response);
  }

  @override
  Future<void> deleteFields(List<String> fieldIds) async {
    await supabase.from('custom_fields').delete().inFilter('id', fieldIds);
  }

  @override
  Future<void> reorderFields(
      String projectId, List<Map<String, dynamic>> orderUpdates) async {
    for (final update in orderUpdates) {
      await supabase
          .from('custom_fields')
          .update({'order_index': update['order_index']})
          .eq('id', update['id']);
    }
  }

  @override
  Future<CustomFieldModel> updateVisibility({
    required String fieldId,
    required String visibility,
  }) async {
    final response = await supabase
        .from('custom_fields')
        .update({'visibility': visibility})
        .eq('id', fieldId)
        .select()
        .single();
    return CustomFieldModel.fromJson(response);
  }

  @override
  Future<CustomFieldModel> updateAccessControl({
    required String fieldId,
    required Map<String, dynamic> accessControl,
  }) async {
    final response = await supabase
        .from('custom_fields')
        .update({'access_control': accessControl})
        .eq('id', fieldId)
        .select()
        .single();
    return CustomFieldModel.fromJson(response);
  }

  @override
  Future<void> replaceFieldValue({
    required String fieldId,
    required String oldValue,
    required String newValue,
  }) async {
    final response = await supabase
        .from('custom_fields')
        .select('available_values')
        .eq('id', fieldId)
        .single();

    final availableValues = List<String>.from(response['available_values'] ?? []);
    final updatedValues = availableValues.map((v) => v == oldValue ? newValue : v).toList();

    await supabase
        .from('custom_fields')
        .update({'available_values': updatedValues})
        .eq('id', fieldId);
  }

  @override
  Future<CustomFieldModel> updateAdvancedSettings({
    required String fieldId,
    List<String>? visibleTo,
    List<String>? updatableBy,
    String? showOnlyWhen,
    String? filterValuesBasedOn,
  }) async {
    final payload = <String, dynamic>{
      'visible_to': ?visibleTo,
      'updatable_by': ?updatableBy,
      'show_only_when': ?showOnlyWhen,
      'filter_values_based_on': ?filterValuesBasedOn,
    };
    final response = await supabase
        .from('custom_fields')
        .update(payload)
        .eq('id', fieldId)
        .select()
        .single();
    return CustomFieldModel.fromJson(response);
  }
}
