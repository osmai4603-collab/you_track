import 'package:issues_tracking/features/users/domain/entities/notification_settings_entity.dart';

class NotificationSettingsModel extends NotificationSettingsEntity {
  const NotificationSettingsModel({
    required super.id,
    required super.userId,
    super.emailEnabled,
    super.emailFormat,
    super.telegramEnabled,
    super.telegramConnected,
    super.notifyChangesByMe,
    super.notifyMentions,
    super.notifyDuplicateChanges,
    super.notifyEmailCreated,
    super.notifyVcsUpdates,
    super.notifyVcsFailedCommands,
    super.starOnComment,
    super.starOnCreate,
    super.starOnUpdate,
    super.starOnAssigned,
    super.starOnVote,
  });

  factory NotificationSettingsModel.fromEntity(
    NotificationSettingsEntity entity,
  ) {
    return NotificationSettingsModel(
      id: entity.id,
      userId: entity.userId,
      emailEnabled: entity.emailEnabled,
      emailFormat: entity.emailFormat,
      telegramEnabled: entity.telegramEnabled,
      telegramConnected: entity.telegramConnected,
      notifyChangesByMe: entity.notifyChangesByMe,
      notifyMentions: entity.notifyMentions,
      notifyDuplicateChanges: entity.notifyDuplicateChanges,
      notifyEmailCreated: entity.notifyEmailCreated,
      notifyVcsUpdates: entity.notifyVcsUpdates,
      notifyVcsFailedCommands: entity.notifyVcsFailedCommands,
      starOnComment: entity.starOnComment,
      starOnCreate: entity.starOnCreate,
      starOnUpdate: entity.starOnUpdate,
      starOnAssigned: entity.starOnAssigned,
      starOnVote: entity.starOnVote,
    );
  }

  factory NotificationSettingsModel.fromJson(Map<String, dynamic> json) {
    return NotificationSettingsModel(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      emailEnabled: json['email_enabled'] ?? true,
      emailFormat: json['email_format'] ?? 'html',
      telegramEnabled: json['telegram_enabled'] ?? false,
      telegramConnected: json['telegram_connected'] ?? false,
      notifyChangesByMe: json['notify_changes_by_me'] ?? false,
      notifyMentions: json['notify_mentions'] ?? false,
      notifyDuplicateChanges: json['notify_duplicate_changes'] ?? false,
      notifyEmailCreated: json['notify_email_created'] ?? false,
      notifyVcsUpdates: json['notify_vcs_updates'] ?? false,
      notifyVcsFailedCommands: json['notify_vcs_failed_commands'] ?? false,
      starOnComment: json['star_on_comment'] ?? true,
      starOnCreate: json['star_on_create'] ?? true,
      starOnUpdate: json['star_on_update'] ?? true,
      starOnAssigned: json['star_on_assigned'] ?? true,
      starOnVote: json['star_on_vote'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'email_enabled': emailEnabled,
      'email_format': emailFormat,
      'telegram_enabled': telegramEnabled,
      'telegram_connected': telegramConnected,
      'notify_changes_by_me': notifyChangesByMe,
      'notify_mentions': notifyMentions,
      'notify_duplicate_changes': notifyDuplicateChanges,
      'notify_email_created': notifyEmailCreated,
      'notify_vcs_updates': notifyVcsUpdates,
      'notify_vcs_failed_commands': notifyVcsFailedCommands,
      'star_on_comment': starOnComment,
      'star_on_create': starOnCreate,
      'star_on_update': starOnUpdate,
      'star_on_assigned': starOnAssigned,
      'star_on_vote': starOnVote,
    };
  }

  Map<String, dynamic> toUpsertJson() {
    return {
      'user_id': userId,
      'email_enabled': emailEnabled,
      'email_format': emailFormat,
      'telegram_enabled': telegramEnabled,
      'telegram_connected': telegramConnected,
      'notify_changes_by_me': notifyChangesByMe,
      'notify_mentions': notifyMentions,
      'notify_duplicate_changes': notifyDuplicateChanges,
      'notify_email_created': notifyEmailCreated,
      'notify_vcs_updates': notifyVcsUpdates,
      'notify_vcs_failed_commands': notifyVcsFailedCommands,
      'star_on_comment': starOnComment,
      'star_on_create': starOnCreate,
      'star_on_update': starOnUpdate,
      'star_on_assigned': starOnAssigned,
      'star_on_vote': starOnVote,
      'updated_at': DateTime.now().toIso8601String(),
    };
  }
}