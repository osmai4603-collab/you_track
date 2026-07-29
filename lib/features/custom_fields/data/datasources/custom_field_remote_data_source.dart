import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/simple_custom_field_model.dart';

abstract class CustomFieldRemoteDataSource {
  Future<List<SimpleCustomFieldModel>> getFieldsByProject(String projectId);

  Future<SimpleCustomFieldModel> createField(SimpleCustomFieldModel field);

  Future<SimpleCustomFieldModel> updateField(SimpleCustomFieldModel field);

  Future<void> deleteField(String fieldId);

  Future<bool> isFieldNameUnique(String projectId, String name);

  Future<SimpleCustomFieldModel> getFieldById(String fieldId);
}

class CustomFieldRemoteDataSourceImpl implements CustomFieldRemoteDataSource {
  final SupabaseClient supabase;

  CustomFieldRemoteDataSourceImpl(this.supabase);

  @override
  Future<List<SimpleCustomFieldModel>> getFieldsByProject(String projectId) async {
    final response = await supabase
        .from('custom_fields')
        .select()
        .eq('project_id', projectId)
        .order('created_at', ascending: true);
    return (response as List)
        .map((e) => SimpleCustomFieldModel.fromJson(e))
        .toList();
  }

  @override
  Future<SimpleCustomFieldModel> createField(SimpleCustomFieldModel field) async {
    final response = await supabase
        .from('custom_fields')
        .insert(field.toInsertJson())
        .select()
        .single();
    return SimpleCustomFieldModel.fromJson(response);
  }

  @override
  Future<SimpleCustomFieldModel> updateField(SimpleCustomFieldModel field) async {
    final response = await supabase
        .from('custom_fields')
        .update(field.toJson())
        .eq('id', field.id)
        .select()
        .single();
    return SimpleCustomFieldModel.fromJson(response);
  }

  @override
  Future<void> deleteField(String fieldId) async {
    await supabase.from('custom_fields').delete().eq('id', fieldId);
  }

  @override
  Future<bool> isFieldNameUnique(String projectId, String name) async {
    final response = await supabase
        .from('custom_fields')
        .select('id')
        .eq('project_id', projectId)
        .eq('name', name)
        .limit(1);
    return (response as List).isEmpty;
  }

  @override
  Future<SimpleCustomFieldModel> getFieldById(String fieldId) async {
    final response = await supabase
        .from('custom_fields')
        .select()
        .eq('id', fieldId)
        .single();
    return SimpleCustomFieldModel.fromJson(response);
  }
}