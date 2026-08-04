import 'package:issues_tracking/features/users/data/models/notification_settings_model.dart';
import 'package:issues_tracking/features/users/data/models/saved_search_model.dart';
import 'package:issues_tracking/features/users/data/models/user_preferences_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class UserProfileRemoteDataSource {
  Future<UserPreferencesModel> getUserPreferences(String userId);
  Future<UserPreferencesModel> saveUserPreferences(Map<String, dynamic> data);
  Future<NotificationSettingsModel> getNotificationSettings(String userId);
  Future<NotificationSettingsModel> saveNotificationSettings(
    Map<String, dynamic> data,
  );
  Future<List<SavedSearchModel>> getSavedSearches(String userId);
  Future<SavedSearchModel> createSavedSearch(Map<String, dynamic> data);
  Future<void> deleteSavedSearch(String searchId);
  Future<List<Map<String, dynamic>>> getUserTags(String userId);
  Future<void> changePassword(String newPassword);
  Future<void> revokeRefreshToken();
}

class UserProfileRemoteDataSourceImpl implements UserProfileRemoteDataSource {
  final SupabaseClient _supabase;

  UserProfileRemoteDataSourceImpl(this._supabase);

  // ── تفضيلات الواجهة ──

  @override
  Future<UserPreferencesModel> getUserPreferences(String userId) async {
    final response = await _supabase
        .from('user_preferences')
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    if (response == null) {
      // إنشاء سجل افتراضي إذا لم يكن موجوداً
      final defaultData = {
        'user_id': userId,
        'theme': 'dark',
        'links_panel_position': 'below_description',
        'show_recent_issues': true,
      };
      final created = await _supabase
          .from('user_preferences')
          .upsert(defaultData, onConflict: 'user_id')
          .select()
          .single();
      return UserPreferencesModel.fromJson(created);
    }
    return UserPreferencesModel.fromJson(response);
  }

  @override
  Future<UserPreferencesModel> saveUserPreferences(
    Map<String, dynamic> data,
  ) async {
    // استخدام upsert لأن السجل قد يكون موجوداً أو لا
    final response = await _supabase
        .from('user_preferences')
        .upsert(data, onConflict: 'user_id')
        .select()
        .single();
    return UserPreferencesModel.fromJson(response);
  }

  // ── إعدادات الإشعارات ──

  @override
  Future<NotificationSettingsModel> getNotificationSettings(
    String userId,
  ) async {
    final response = await _supabase
        .from('user_notification_settings')
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    if (response == null) {
      final defaultData = {'user_id': userId};
      final created = await _supabase
          .from('user_notification_settings')
          .upsert(defaultData, onConflict: 'user_id')
          .select()
          .single();
      return NotificationSettingsModel.fromJson(created);
    }
    return NotificationSettingsModel.fromJson(response);
  }

  @override
  Future<NotificationSettingsModel> saveNotificationSettings(
    Map<String, dynamic> data,
  ) async {
    final response = await _supabase
        .from('user_notification_settings')
        .upsert(data, onConflict: 'user_id')
        .select()
        .single();
    return NotificationSettingsModel.fromJson(response);
  }

  // ── البحث المحفوظ ──

  @override
  Future<List<SavedSearchModel>> getSavedSearches(String userId) async {
    final response = await _supabase
        .from('saved_searches')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    return (response as List)
        .map((e) => SavedSearchModel.fromJson(e))
        .toList();
  }

  @override
  Future<SavedSearchModel> createSavedSearch(
    Map<String, dynamic> data,
  ) async {
    final response = await _supabase
        .from('saved_searches')
        .insert(data)
        .select()
        .single();
    return SavedSearchModel.fromJson(response);
  }

  @override
  Future<void> deleteSavedSearch(String searchId) async {
    await _supabase.from('saved_searches').delete().eq('id', searchId);
  }

  // ── Tags ──

  @override
  Future<List<Map<String, dynamic>>> getUserTags(String userId) async {
    // جلب Tags التي أنشأها المستخدم أو المشتركة
    final response = await _supabase
        .from('tags')
        .select('*, tag_subscriptions(*)')
        .or('created_by.eq.$userId,shared.eq.true')
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  // ── أمان الحساب ──

  @override
  Future<void> changePassword(String newPassword) async {
    await _supabase.auth.updateUser(
      UserAttributes(password: newPassword),
    );
  }

  @override
  Future<void> revokeRefreshToken() async {
    await _supabase.auth.signOut(scope: SignOutScope.others);
  }
}