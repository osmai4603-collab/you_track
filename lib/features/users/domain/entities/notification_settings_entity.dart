import 'package:issues_tracking/core/entities/entity.dart';

class NotificationSettingsEntity extends Entity {
  final String id;
  final String userId;
  // قنوات الإشعار
  final bool emailEnabled;
  final String emailFormat; // 'html' | 'plain_text'
  final bool telegramEnabled;
  final bool telegramConnected;
  // أحداث الإشعارات
  final bool notifyChangesByMe;
  final bool notifyMentions;
  final bool notifyDuplicateChanges;
  final bool notifyEmailCreated;
  final bool notifyVcsUpdates;
  final bool notifyVcsFailedCommands;
  // أحداث Star التلقائي
  final bool starOnComment;
  final bool starOnCreate;
  final bool starOnUpdate;
  final bool starOnAssigned;
  final bool starOnVote;

  const NotificationSettingsEntity({
    required this.id,
    required this.userId,
    this.emailEnabled = true,
    this.emailFormat = 'html',
    this.telegramEnabled = false,
    this.telegramConnected = false,
    this.notifyChangesByMe = false,
    this.notifyMentions = false,
    this.notifyDuplicateChanges = false,
    this.notifyEmailCreated = false,
    this.notifyVcsUpdates = false,
    this.notifyVcsFailedCommands = false,
    this.starOnComment = true,
    this.starOnCreate = true,
    this.starOnUpdate = true,
    this.starOnAssigned = true,
    this.starOnVote = true,
  });

  @override
  NotificationSettingsEntity copyWith({
    String? id,
    String? userId,
    bool? emailEnabled,
    String? emailFormat,
    bool? telegramEnabled,
    bool? telegramConnected,
    bool? notifyChangesByMe,
    bool? notifyMentions,
    bool? notifyDuplicateChanges,
    bool? notifyEmailCreated,
    bool? notifyVcsUpdates,
    bool? notifyVcsFailedCommands,
    bool? starOnComment,
    bool? starOnCreate,
    bool? starOnUpdate,
    bool? starOnAssigned,
    bool? starOnVote,
  }) {
    return NotificationSettingsEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      emailEnabled: emailEnabled ?? this.emailEnabled,
      emailFormat: emailFormat ?? this.emailFormat,
      telegramEnabled: telegramEnabled ?? this.telegramEnabled,
      telegramConnected: telegramConnected ?? this.telegramConnected,
      notifyChangesByMe: notifyChangesByMe ?? this.notifyChangesByMe,
      notifyMentions: notifyMentions ?? this.notifyMentions,
      notifyDuplicateChanges:
          notifyDuplicateChanges ?? this.notifyDuplicateChanges,
      notifyEmailCreated: notifyEmailCreated ?? this.notifyEmailCreated,
      notifyVcsUpdates: notifyVcsUpdates ?? this.notifyVcsUpdates,
      notifyVcsFailedCommands:
          notifyVcsFailedCommands ?? this.notifyVcsFailedCommands,
      starOnComment: starOnComment ?? this.starOnComment,
      starOnCreate: starOnCreate ?? this.starOnCreate,
      starOnUpdate: starOnUpdate ?? this.starOnUpdate,
      starOnAssigned: starOnAssigned ?? this.starOnAssigned,
      starOnVote: starOnVote ?? this.starOnVote,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        emailEnabled,
        emailFormat,
        telegramEnabled,
        telegramConnected,
        notifyChangesByMe,
        notifyMentions,
        notifyDuplicateChanges,
        notifyEmailCreated,
        notifyVcsUpdates,
        notifyVcsFailedCommands,
        starOnComment,
        starOnCreate,
        starOnUpdate,
        starOnAssigned,
        starOnVote,
      ];
}