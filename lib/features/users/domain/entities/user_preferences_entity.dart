import 'package:issues_tracking/core/entities/entity.dart';

class UserPreferencesEntity extends Entity {
  final String id;
  final String userId;
  final String theme; // 'light' | 'dark' | 'sync'
  final String linksPanelPosition; // 'below_summary' | 'below_description'
  final bool showRecentIssues;

  const UserPreferencesEntity({
    required this.id,
    required this.userId,
    this.theme = 'dark',
    this.linksPanelPosition = 'below_description',
    this.showRecentIssues = true,
  });

  @override
  UserPreferencesEntity copyWith({
    String? id,
    String? userId,
    String? theme,
    String? linksPanelPosition,
    bool? showRecentIssues,
  }) {
    return UserPreferencesEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      theme: theme ?? this.theme,
      linksPanelPosition: linksPanelPosition ?? this.linksPanelPosition,
      showRecentIssues: showRecentIssues ?? this.showRecentIssues,
    );
  }

  @override
  List<Object?> get props => [id, userId, theme, linksPanelPosition, showRecentIssues];
}