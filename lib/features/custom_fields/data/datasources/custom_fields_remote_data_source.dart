import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/custom_field_model.dart';

abstract class CustomFieldsRemoteDataSource {
  Future<List<CustomFieldModel>> getFields(String projectId);

  Future<CustomFieldModel> addField(CustomFieldModel field);

  Future<CustomFieldModel> updateField(CustomFieldModel field);

  Future<void> deleteFields(List<String> fieldIds);

  Future<void> reorderFields(
      String projectId, List<Map<String, dynamic>> orderUpdates);
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
}
