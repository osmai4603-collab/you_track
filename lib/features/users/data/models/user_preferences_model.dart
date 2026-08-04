import 'package:issues_tracking/features/users/domain/entities/user_preferences_entity.dart';

class UserPreferencesModel extends UserPreferencesEntity {
  const UserPreferencesModel({
    required super.id,
    required super.userId,
    super.theme,
    super.linksPanelPosition,
    super.showRecentIssues,
  });

  factory UserPreferencesModel.fromEntity(UserPreferencesEntity entity) {
    return UserPreferencesModel(
      id: entity.id,
      userId: entity.userId,
      theme: entity.theme,
      linksPanelPosition: entity.linksPanelPosition,
      showRecentIssues: entity.showRecentIssues,
    );
  }

  factory UserPreferencesModel.fromJson(Map<String, dynamic> json) {
    return UserPreferencesModel(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      theme: json['theme'] ?? 'dark',
      linksPanelPosition: json['links_panel_position'] ?? 'below_description',
      showRecentIssues: json['show_recent_issues'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'theme': theme,
      'links_panel_position': linksPanelPosition,
      'show_recent_issues': showRecentIssues,
    };
  }

  /// يُستخدم للـ upsert — بدون id لأن DB يولده تلقائياً
  Map<String, dynamic> toUpsertJson() {
    return {
      'user_id': userId,
      'theme': theme,
      'links_panel_position': linksPanelPosition,
      'show_recent_issues': showRecentIssues,
      'updated_at': DateTime.now().toIso8601String(),
    };
  }
}