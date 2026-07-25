import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/custom_field_model.dart';

abstract class CustomFieldRemoteDataSource {
  Future<List<CustomFieldModel>> getFieldsByProject(String projectId);

  Future<CustomFieldModel> createField(CustomFieldModel field);

  Future<CustomFieldModel> updateField(CustomFieldModel field);

  Future<void> deleteField(String fieldId);

  Future<bool> isFieldNameUnique(String projectId, String name);

  Future<CustomFieldModel> getFieldById(String fieldId);
}

class CustomFieldRemoteDataSourceImpl implements CustomFieldRemoteDataSource {
  final SupabaseClient supabase;

  CustomFieldRemoteDataSourceImpl(this.supabase);

  @override
  Future<List<CustomFieldModel>> getFieldsByProject(String projectId) async {
    final response = await supabase
        .from('custom_fields')
        .select()
        .eq('project_id', projectId)
        .order('created_at', ascending: true);
    return (response as List)
        .map((e) => CustomFieldModel.fromJson(e))
        .toList();
  }

  @override
  Future<CustomFieldModel> createField(CustomFieldModel field) async {
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
  Future<CustomFieldModel> getFieldById(String fieldId) async {
    final response = await supabase
        .from('custom_fields')
        .select()
        .eq('id', fieldId)
        .single();
    return CustomFieldModel.fromJson(response);
  }
}