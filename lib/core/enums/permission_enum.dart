import 'package:issues_tracking/core/enums/app_enum.dart';
import 'package:issues_tracking/core/enums/entity_enum.dart';
import 'package:issues_tracking/core/enums/module_enum.dart';
import 'package:issues_tracking/core/enums/operation_enum.dart';
import 'package:issues_tracking/core/localization/app_localizations.dart';

sealed class Permission extends AppEnum {
  const Permission();

  Module get module;
  Entity get entity;
  Operation get operation;

  // ── Project ──
  static const projectReadProjectBasic = ProjectReadProjectBasic._();
  static const projectCreateProject = ProjectCreateProject._();
  static const projectReadProjectFull = ProjectReadProjectFull._();
  static const projectUpdateProject = ProjectUpdateProject._();
  static const projectDeleteProject = ProjectDeleteProject._();

  // ── Organization ──
  static const organizationReadOrganization = OrganizationReadOrganization._();
  static const organizationUpdateOrganization =
      OrganizationUpdateOrganization._();
  static const organizationCreateOrganization =
      OrganizationCreateOrganization._();
  static const organizationDeleteOrganization =
      OrganizationDeleteOrganization._();

  // ── User Profile ──
  static const userProfileUpdateSelf = UserProfileUpdateSelf._();

  // ── User ──
  static const userReadUserBasic = UserReadUserBasic._();
  static const userReadUserDetails = UserReadUserDetails._();
  static const userUpdateUser = UserUpdateUser._();
  static const userCreateUser = UserCreateUser._();
  static const userDeleteUser = UserDeleteUser._();

  // ── System ──
  static const systemLowLevelAdminRead = SystemLowLevelAdminRead._();
  static const systemLowLevelAdminWrite = SystemLowLevelAdminWrite._();

  // ── Issue ──
  static const issueReadIssue = IssueReadIssue._();
  static const issueReadIssuePrivateFields = IssueReadIssuePrivateFields._();
  static const issueUpdateIssue = IssueUpdateIssue._();
  static const issueCreateIssue = IssueCreateIssue._();
  static const issueDeleteIssue = IssueDeleteIssue._();
  static const issueLinkIssues = IssueLinkIssues._();
  static const issueUpdateIssuePrivateFields =
      IssueUpdateIssuePrivateFields._();
  static const issueApplyCommandsSilently = IssueApplyCommandsSilently._();
  static const issueViewWatchers = IssueViewWatchers._();
  static const issueUpdateWatchers = IssueUpdateWatchers._();
  static const issueViewVoters = IssueViewVoters._();

  // ── Attachment ──
  static const attachmentAddAttachment = AttachmentAddAttachment._();
  static const attachmentUpdateAttachment = AttachmentUpdateAttachment._();
  static const attachmentDeleteAttachment = AttachmentDeleteAttachment._();

  // ── Comment ──
  static const commentCreateIssueComment = CommentCreateIssueComment._();
  static const commentReadIssueComment = CommentReadIssueComment._();
  static const commentUpdateIssueComment = CommentUpdateIssueComment._();
  static const commentDeleteIssueComment = CommentDeleteIssueComment._();
  static const commentUpdateNotOwnIssueComment =
      CommentUpdateNotOwnIssueComment._();
  static const commentDeleteNotOwnCommentAndPermanentCommentDelete =
      CommentDeleteNotOwnCommentAndPermanentCommentDelete._();
  static const commentReadArticleComment = CommentReadArticleComment._();
  static const commentCreateArticleComment = CommentCreateArticleComment._();
  static const commentUpdateArticleComment = CommentUpdateArticleComment._();
  static const commentDeleteArticleComment = CommentDeleteArticleComment._();

  // ── Visibility ──
  static const visibilityOverrideVisibilityRestrictions =
      VisibilityOverrideVisibilityRestrictions._();

  // ── Issue Work Item ──
  static const issueWorkItemReadWorkItem = IssueWorkItemReadWorkItem._();
  static const issueWorkItemUpdateWorkItem = IssueWorkItemUpdateWorkItem._();
  static const issueWorkItemUpdateNotOwnWorkItem =
      IssueWorkItemUpdateNotOwnWorkItem._();
  static const issueWorkItemCreateWorkItem = IssueWorkItemCreateWorkItem._();
  static const issueWorkItemCreateNotOwnWorkItem =
      IssueWorkItemCreateNotOwnWorkItem._();

  // ── Article ──
  static const articleReadArticle = ArticleReadArticle._();
  static const articleCreateArticle = ArticleCreateArticle._();
  static const articleUpdateArticle = ArticleUpdateArticle._();
  static const articleDeleteArticle = ArticleDeleteArticle._();

  // ── App ──
  static const appReadAppContent = AppReadAppContent._();
  static const appUpdateAppContent = AppUpdateAppContent._();

  static List<Permission> get values => [
        projectReadProjectBasic,
        projectCreateProject,
        projectReadProjectFull,
        projectUpdateProject,
        projectDeleteProject,
        organizationReadOrganization,
        organizationUpdateOrganization,
        organizationCreateOrganization,
        organizationDeleteOrganization,
        userProfileUpdateSelf,
        userReadUserBasic,
        userReadUserDetails,
        userUpdateUser,
        userCreateUser,
        userDeleteUser,
        systemLowLevelAdminRead,
        systemLowLevelAdminWrite,
        issueReadIssue,
        issueReadIssuePrivateFields,
        issueUpdateIssue,
        issueCreateIssue,
        issueDeleteIssue,
        issueLinkIssues,
        issueUpdateIssuePrivateFields,
        issueApplyCommandsSilently,
        issueViewWatchers,
        issueUpdateWatchers,
        issueViewVoters,
        attachmentAddAttachment,
        attachmentUpdateAttachment,
        attachmentDeleteAttachment,
        commentCreateIssueComment,
        commentReadIssueComment,
        commentUpdateIssueComment,
        commentDeleteIssueComment,
        commentUpdateNotOwnIssueComment,
        commentDeleteNotOwnCommentAndPermanentCommentDelete,
        commentReadArticleComment,
        commentCreateArticleComment,
        commentUpdateArticleComment,
        commentDeleteArticleComment,
        visibilityOverrideVisibilityRestrictions,
        issueWorkItemReadWorkItem,
        issueWorkItemUpdateWorkItem,
        issueWorkItemUpdateNotOwnWorkItem,
        issueWorkItemCreateWorkItem,
        issueWorkItemCreateNotOwnWorkItem,
        articleReadArticle,
        articleCreateArticle,
        articleUpdateArticle,
        articleDeleteArticle,
        appReadAppContent,
        appUpdateAppContent,
      ];

  static Permission of(String name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw ArgumentError('Unknown Permission: $name'),
    );
  }
}

// ═══════════════════════════════════════════════
//  Project
// ═══════════════════════════════════════════════

final class ProjectReadProjectBasic extends Permission {
  const ProjectReadProjectBasic._();
  @override
  String get name => 'project-read-project-basic';
  @override
  int get index => 0;
  @override
  Module get module => Module.project;
  @override
  Entity get entity => Entity.project;
  @override
  Operation get operation => Operation.read;
  @override
  String displayName(AppLocalizations localization) =>
      localization.permissionProjectReadProjectBasic;
}

final class ProjectCreateProject extends Permission {
  const ProjectCreateProject._();
  @override
  String get name => 'project-create-project';
  @override
  int get index => 1;
  @override
  Module get module => Module.project;
  @override
  Entity get entity => Entity.project;
  @override
  Operation get operation => Operation.create;
  @override
  String displayName(AppLocalizations localization) =>
      localization.permissionProjectCreateProject;
}

final class ProjectReadProjectFull extends Permission {
  const ProjectReadProjectFull._();
  @override
  String get name => 'project-read-project-full';
  @override
  int get index => 2;
  @override
  Module get module => Module.project;
  @override
  Entity get entity => Entity.project;
  @override
  Operation get operation => Operation.read;
  @override
  String displayName(AppLocalizations localization) =>
      localization.permissionProjectReadProjectFull;
}

final class ProjectUpdateProject extends Permission {
  const ProjectUpdateProject._();
  @override
  String get name => 'project-update-project';
  @override
  int get index => 3;
  @override
  Module get module => Module.project;
  @override
  Entity get entity => Entity.project;
  @override
  Operation get operation => Operation.update;
  @override
  String displayName(AppLocalizations localization) =>
      localization.permissionProjectUpdateProject;
}

final class ProjectDeleteProject extends Permission {
  const ProjectDeleteProject._();
  @override
  String get name => 'project-delete-project';
  @override
  int get index => 4;
  @override
  Module get module => Module.project;
  @override
  Entity get entity => Entity.project;
  @override
  Operation get operation => Operation.delete;
  @override
  String displayName(AppLocalizations localization) =>
      localization.permissionProjectDeleteProject;
}

// ═══════════════════════════════════════════════
//  Organization
// ═══════════════════════════════════════════════

final class OrganizationReadOrganization extends Permission {
  const OrganizationReadOrganization._();
  @override
  String get name => 'organization-read-organization';
  @override
  int get index => 5;
  @override
  Module get module => Module.organization;
  @override
  Entity get entity => Entity.organization;
  @override
  Operation get operation => Operation.read;
  @override
  String displayName(AppLocalizations localization) =>
      localization.permissionOrganizationReadOrganization;
}

final class OrganizationUpdateOrganization extends Permission {
  const OrganizationUpdateOrganization._();
  @override
  String get name => 'organization-update-organization';
  @override
  int get index => 6;
  @override
  Module get module => Module.organization;
  @override
  Entity get entity => Entity.organization;
  @override
  Operation get operation => Operation.update;
  @override
  String displayName(AppLocalizations localization) =>
      localization.permissionOrganizationUpdateOrganization;
}

final class OrganizationCreateOrganization extends Permission {
  const OrganizationCreateOrganization._();
  @override
  String get name => 'organization-create-organization';
  @override
  int get index => 7;
  @override
  Module get module => Module.organization;
  @override
  Entity get entity => Entity.organization;
  @override
  Operation get operation => Operation.create;
  @override
  String displayName(AppLocalizations localization) =>
      localization.permissionOrganizationCreateOrganization;
}

final class OrganizationDeleteOrganization extends Permission {
  const OrganizationDeleteOrganization._();
  @override
  String get name => 'organization-delete-organization';
  @override
  int get index => 8;
  @override
  Module get module => Module.organization;
  @override
  Entity get entity => Entity.organization;
  @override
  Operation get operation => Operation.delete;
  @override
  String displayName(AppLocalizations localization) =>
      localization.permissionOrganizationDeleteOrganization;
}

// ═══════════════════════════════════════════════
//  User Profile
// ═══════════════════════════════════════════════

final class UserProfileUpdateSelf extends Permission {
  const UserProfileUpdateSelf._();
  @override
  String get name => 'user-profile-update-self';
  @override
  int get index => 9;
  @override
  Module get module => Module.user;
  @override
  Entity get entity => Entity.user;
  @override
  Operation get operation => Operation.update;
  @override
  String displayName(AppLocalizations localization) =>
      localization.permissionUserProfileUpdateSelf;
}

// ═══════════════════════════════════════════════
//  User
// ═══════════════════════════════════════════════

final class UserReadUserBasic extends Permission {
  const UserReadUserBasic._();
  @override
  String get name => 'user-read-user-basic';
  @override
  int get index => 10;
  @override
  Module get module => Module.user;
  @override
  Entity get entity => Entity.user;
  @override
  Operation get operation => Operation.read;
  @override
  String displayName(AppLocalizations localization) =>
      localization.permissionUserReadUserBasic;
}

final class UserReadUserDetails extends Permission {
  const UserReadUserDetails._();
  @override
  String get name => 'user-read-user-details';
  @override
  int get index => 11;
  @override
  Module get module => Module.user;
  @override
  Entity get entity => Entity.user;
  @override
  Operation get operation => Operation.read;
  @override
  String displayName(AppLocalizations localization) =>
      localization.permissionUserReadUserDetails;
}

final class UserUpdateUser extends Permission {
  const UserUpdateUser._();
  @override
  String get name => 'user-update-user';
  @override
  int get index => 12;
  @override
  Module get module => Module.user;
  @override
  Entity get entity => Entity.user;
  @override
  Operation get operation => Operation.update;
  @override
  String displayName(AppLocalizations localization) =>
      localization.permissionUserUpdateUser;
}

final class UserCreateUser extends Permission {
  const UserCreateUser._();
  @override
  String get name => 'user-create-user';
  @override
  int get index => 13;
  @override
  Module get module => Module.user;
  @override
  Entity get entity => Entity.user;
  @override
  Operation get operation => Operation.create;
  @override
  String displayName(AppLocalizations localization) =>
      localization.permissionUserCreateUser;
}

final class UserDeleteUser extends Permission {
  const UserDeleteUser._();
  @override
  String get name => 'user-delete-user';
  @override
  int get index => 14;
  @override
  Module get module => Module.user;
  @override
  Entity get entity => Entity.user;
  @override
  Operation get operation => Operation.delete;
  @override
  String displayName(AppLocalizations localization) =>
      localization.permissionUserDeleteUser;
}

// ═══════════════════════════════════════════════
//  System
// ═══════════════════════════════════════════════

final class SystemLowLevelAdminRead extends Permission {
  const SystemLowLevelAdminRead._();
  @override
  String get name => 'system-low-level-admin-read';
  @override
  int get index => 15;
  @override
  Module get module => Module.system;
  @override
  Entity get entity => Entity.system;
  @override
  Operation get operation => Operation.read;
  @override
  String displayName(AppLocalizations localization) =>
      localization.permissionSystemLowLevelAdminRead;
}

final class SystemLowLevelAdminWrite extends Permission {
  const SystemLowLevelAdminWrite._();
  @override
  String get name => 'system-low-level-admin-write';
  @override
  int get index => 16;
  @override
  Module get module => Module.system;
  @override
  Entity get entity => Entity.system;
  @override
  Operation get operation => Operation.update;
  @override
  String displayName(AppLocalizations localization) =>
      localization.permissionSystemLowLevelAdminWrite;
}

// ═══════════════════════════════════════════════
//  Issue
// ═══════════════════════════════════════════════

final class IssueReadIssue extends Permission {
  const IssueReadIssue._();
  @override
  String get name => 'issue-read-issue';
  @override
  int get index => 17;
  @override
  Module get module => Module.issue;
  @override
  Entity get entity => Entity.issue;
  @override
  Operation get operation => Operation.read;
  @override
  String displayName(AppLocalizations localization) =>
      localization.permissionIssueReadIssue;
}

final class IssueReadIssuePrivateFields extends Permission {
  const IssueReadIssuePrivateFields._();
  @override
  String get name => 'issue-read-issue-private-fields';
  @override
  int get index => 18;
  @override
  Module get module => Module.issue;
  @override
  Entity get entity => Entity.issue;
  @override
  Operation get operation => Operation.read;
  @override
  String displayName(AppLocalizations localization) =>
      localization.permissionIssueReadIssuePrivateFields;
}

final class IssueUpdateIssue extends Permission {
  const IssueUpdateIssue._();
  @override
  String get name => 'issue-update-issue';
  @override
  int get index => 19;
  @override
  Module get module => Module.issue;
  @override
  Entity get entity => Entity.issue;
  @override
  Operation get operation => Operation.update;
  @override
  String displayName(AppLocalizations localization) =>
      localization.permissionIssueUpdateIssue;
}

final class IssueCreateIssue extends Permission {
  const IssueCreateIssue._();
  @override
  String get name => 'issue-create-issue';
  @override
  int get index => 20;
  @override
  Module get module => Module.issue;
  @override
  Entity get entity => Entity.issue;
  @override
  Operation get operation => Operation.create;
  @override
  String displayName(AppLocalizations localization) =>
      localization.permissionIssueCreateIssue;
}

final class IssueDeleteIssue extends Permission {
  const IssueDeleteIssue._();
  @override
  String get name => 'issue-delete-issue';
  @override
  int get index => 21;
  @override
  Module get module => Module.issue;
  @override
  Entity get entity => Entity.issue;
  @override
  Operation get operation => Operation.delete;
  @override
  String displayName(AppLocalizations localization) =>
      localization.permissionIssueDeleteIssue;
}

final class IssueLinkIssues extends Permission {
  const IssueLinkIssues._();
  @override
  String get name => 'issue-link-issues';
  @override
  int get index => 22;
  @override
  Module get module => Module.issue;
  @override
  Entity get entity => Entity.issue;
  @override
  Operation get operation => Operation.link;
  @override
  String displayName(AppLocalizations localization) =>
      localization.permissionIssueLinkIssues;
}

final class IssueUpdateIssuePrivateFields extends Permission {
  const IssueUpdateIssuePrivateFields._();
  @override
  String get name => 'issue-update-issue-private-fields';
  @override
  int get index => 23;
  @override
  Module get module => Module.issue;
  @override
  Entity get entity => Entity.issue;
  @override
  Operation get operation => Operation.update;
  @override
  String displayName(AppLocalizations localization) =>
      localization.permissionIssueUpdateIssuePrivateFields;
}

final class IssueApplyCommandsSilently extends Permission {
  const IssueApplyCommandsSilently._();
  @override
  String get name => 'issue-apply-commands-silently';
  @override
  int get index => 24;
  @override
  Module get module => Module.issue;
  @override
  Entity get entity => Entity.issue;
  @override
  Operation get operation => Operation.apply;
  @override
  String displayName(AppLocalizations localization) =>
      localization.permissionIssueApplyCommandsSilently;
}

final class IssueViewWatchers extends Permission {
  const IssueViewWatchers._();
  @override
  String get name => 'issue-view-watchers';
  @override
  int get index => 25;
  @override
  Module get module => Module.issue;
  @override
  Entity get entity => Entity.issue;
  @override
  Operation get operation => Operation.read;
  @override
  String displayName(AppLocalizations localization) =>
      localization.permissionIssueViewWatchers;
}

final class IssueUpdateWatchers extends Permission {
  const IssueUpdateWatchers._();
  @override
  String get name => 'issue-update-watchers';
  @override
  int get index => 26;
  @override
  Module get module => Module.issue;
  @override
  Entity get entity => Entity.issue;
  @override
  Operation get operation => Operation.update;
  @override
  String displayName(AppLocalizations localization) =>
      localization.permissionIssueUpdateWatchers;
}

final class IssueViewVoters extends Permission {
  const IssueViewVoters._();
  @override
  String get name => 'issue-view-voters';
  @override
  int get index => 27;
  @override
  Module get module => Module.issue;
  @override
  Entity get entity => Entity.issue;
  @override
  Operation get operation => Operation.read;
  @override
  String displayName(AppLocalizations localization) =>
      localization.permissionIssueViewVoters;
}

// ═══════════════════════════════════════════════
//  Attachment
// ═══════════════════════════════════════════════

final class AttachmentAddAttachment extends Permission {
  const AttachmentAddAttachment._();
  @override
  String get name => 'attachment-add-attachment';
  @override
  int get index => 28;
  @override
  Module get module => Module.attachment;
  @override
  Entity get entity => Entity.attachment;
  @override
  Operation get operation => Operation.create;
  @override
  String displayName(AppLocalizations localization) =>
      localization.permissionAttachmentAddAttachment;
}

final class AttachmentUpdateAttachment extends Permission {
  const AttachmentUpdateAttachment._();
  @override
  String get name => 'attachment-update-attachment';
  @override
  int get index => 29;
  @override
  Module get module => Module.attachment;
  @override
  Entity get entity => Entity.attachment;
  @override
  Operation get operation => Operation.update;
  @override
  String displayName(AppLocalizations localization) =>
      localization.permissionAttachmentUpdateAttachment;
}

final class AttachmentDeleteAttachment extends Permission {
  const AttachmentDeleteAttachment._();
  @override
  String get name => 'attachment-delete-attachment';
  @override
  int get index => 30;
  @override
  Module get module => Module.attachment;
  @override
  Entity get entity => Entity.attachment;
  @override
  Operation get operation => Operation.delete;
  @override
  String displayName(AppLocalizations localization) =>
      localization.permissionAttachmentDeleteAttachment;
}

// ═══════════════════════════════════════════════
//  Comment
// ═══════════════════════════════════════════════

final class CommentCreateIssueComment extends Permission {
  const CommentCreateIssueComment._();
  @override
  String get name => 'comment-create-issue-comment';
  @override
  int get index => 31;
  @override
  Module get module => Module.comment;
  @override
  Entity get entity => Entity.comment;
  @override
  Operation get operation => Operation.create;
  @override
  String displayName(AppLocalizations localization) =>
      localization.permissionCommentCreateIssueComment;
}

final class CommentReadIssueComment extends Permission {
  const CommentReadIssueComment._();
  @override
  String get name => 'comment-read-issue-comment';
  @override
  int get index => 32;
  @override
  Module get module => Module.comment;
  @override
  Entity get entity => Entity.comment;
  @override
  Operation get operation => Operation.read;
  @override
  String displayName(AppLocalizations localization) =>
      localization.permissionCommentReadIssueComment;
}

final class CommentUpdateIssueComment extends Permission {
  const CommentUpdateIssueComment._();
  @override
  String get name => 'comment-update-issue-comment';
  @override
  int get index => 33;
  @override
  Module get module => Module.comment;
  @override
  Entity get entity => Entity.comment;
  @override
  Operation get operation => Operation.update;
  @override
  String displayName(AppLocalizations localization) =>
      localization.permissionCommentUpdateIssueComment;
}

final class CommentDeleteIssueComment extends Permission {
  const CommentDeleteIssueComment._();
  @override
  String get name => 'comment-delete-issue-comment';
  @override
  int get index => 34;
  @override
  Module get module => Module.comment;
  @override
  Entity get entity => Entity.comment;
  @override
  Operation get operation => Operation.delete;
  @override
  String displayName(AppLocalizations localization) =>
      localization.permissionCommentDeleteIssueComment;
}

final class CommentUpdateNotOwnIssueComment extends Permission {
  const CommentUpdateNotOwnIssueComment._();
  @override
  String get name => 'comment-update-not-own-issue-comment';
  @override
  int get index => 35;
  @override
  Module get module => Module.comment;
  @override
  Entity get entity => Entity.comment;
  @override
  Operation get operation => Operation.update;
  @override
  String displayName(AppLocalizations localization) =>
      localization.permissionCommentUpdateNotOwnIssueComment;
}

final class CommentDeleteNotOwnCommentAndPermanentCommentDelete
    extends Permission {
  const CommentDeleteNotOwnCommentAndPermanentCommentDelete._();
  @override
  String get name =>
      'comment-delete-not-own-comment-and-permanent-comment-delete';
  @override
  int get index => 36;
  @override
  Module get module => Module.comment;
  @override
  Entity get entity => Entity.comment;
  @override
  Operation get operation => Operation.delete;
  @override
  String displayName(AppLocalizations localization) =>
      localization.permissionCommentDeleteNotOwnCommentAndPermanentCommentDelete;
}

final class CommentReadArticleComment extends Permission {
  const CommentReadArticleComment._();
  @override
  String get name => 'comment-read-article-comment';
  @override
  int get index => 37;
  @override
  Module get module => Module.comment;
  @override
  Entity get entity => Entity.comment;
  @override
  Operation get operation => Operation.read;
  @override
  String displayName(AppLocalizations localization) =>
      localization.permissionCommentReadArticleComment;
}

final class CommentCreateArticleComment extends Permission {
  const CommentCreateArticleComment._();
  @override
  String get name => 'comment-create-article-comment';
  @override
  int get index => 38;
  @override
  Module get module => Module.comment;
  @override
  Entity get entity => Entity.comment;
  @override
  Operation get operation => Operation.create;
  @override
  String displayName(AppLocalizations localization) =>
      localization.permissionCommentCreateArticleComment;
}

final class CommentUpdateArticleComment extends Permission {
  const CommentUpdateArticleComment._();
  @override
  String get name => 'comment-update-article-comment';
  @override
  int get index => 39;
  @override
  Module get module => Module.comment;
  @override
  Entity get entity => Entity.comment;
  @override
  Operation get operation => Operation.update;
  @override
  String displayName(AppLocalizations localization) =>
      localization.permissionCommentUpdateArticleComment;
}

final class CommentDeleteArticleComment extends Permission {
  const CommentDeleteArticleComment._();
  @override
  String get name => 'comment-delete-article-comment';
  @override
  int get index => 40;
  @override
  Module get module => Module.comment;
  @override
  Entity get entity => Entity.comment;
  @override
  Operation get operation => Operation.delete;
  @override
  String displayName(AppLocalizations localization) =>
      localization.permissionCommentDeleteArticleComment;
}

// ═══════════════════════════════════════════════
//  Visibility
// ═══════════════════════════════════════════════

final class VisibilityOverrideVisibilityRestrictions extends Permission {
  const VisibilityOverrideVisibilityRestrictions._();
  @override
  String get name => 'visibility-override-visibility-restrictions';
  @override
  int get index => 41;
  @override
  Module get module => Module.visibility;
  @override
  Entity get entity => Entity.issue;
  @override
  Operation get operation => Operation.override;
  @override
  String displayName(AppLocalizations localization) =>
      localization.permissionVisibilityOverrideVisibilityRestrictions;
}

// ═══════════════════════════════════════════════
//  Issue Work Item
// ═══════════════════════════════════════════════

final class IssueWorkItemReadWorkItem extends Permission {
  const IssueWorkItemReadWorkItem._();
  @override
  String get name => 'issue-work-item-read-work-item';
  @override
  int get index => 42;
  @override
  Module get module => Module.issueWorkItem;
  @override
  Entity get entity => Entity.issueWorkItem;
  @override
  Operation get operation => Operation.read;
  @override
  String displayName(AppLocalizations localization) =>
      localization.permissionIssueWorkItemReadWorkItem;
}

final class IssueWorkItemUpdateWorkItem extends Permission {
  const IssueWorkItemUpdateWorkItem._();
  @override
  String get name => 'issue-work-item-update-work-item';
  @override
  int get index => 43;
  @override
  Module get module => Module.issueWorkItem;
  @override
  Entity get entity => Entity.issueWorkItem;
  @override
  Operation get operation => Operation.update;
  @override
  String displayName(AppLocalizations localization) =>
      localization.permissionIssueWorkItemUpdateWorkItem;
}

final class IssueWorkItemUpdateNotOwnWorkItem extends Permission {
  const IssueWorkItemUpdateNotOwnWorkItem._();
  @override
  String get name => 'issue-work-item-update-not-own-work-item';
  @override
  int get index => 44;
  @override
  Module get module => Module.issueWorkItem;
  @override
  Entity get entity => Entity.issueWorkItem;
  @override
  Operation get operation => Operation.update;
  @override
  String displayName(AppLocalizations localization) =>
      localization.permissionIssueWorkItemUpdateNotOwnWorkItem;
}

final class IssueWorkItemCreateWorkItem extends Permission {
  const IssueWorkItemCreateWorkItem._();
  @override
  String get name => 'issue-work-item-create-work-item';
  @override
  int get index => 45;
  @override
  Module get module => Module.issueWorkItem;
  @override
  Entity get entity => Entity.issueWorkItem;
  @override
  Operation get operation => Operation.create;
  @override
  String displayName(AppLocalizations localization) =>
      localization.permissionIssueWorkItemCreateWorkItem;
}

final class IssueWorkItemCreateNotOwnWorkItem extends Permission {
  const IssueWorkItemCreateNotOwnWorkItem._();
  @override
  String get name => 'issue-work-item-create-not-own-work-item';
  @override
  int get index => 46;
  @override
  Module get module => Module.issueWorkItem;
  @override
  Entity get entity => Entity.issueWorkItem;
  @override
  Operation get operation => Operation.create;
  @override
  String displayName(AppLocalizations localization) =>
      localization.permissionIssueWorkItemCreateNotOwnWorkItem;
}

// ═══════════════════════════════════════════════
//  Article
// ═══════════════════════════════════════════════

final class ArticleReadArticle extends Permission {
  const ArticleReadArticle._();
  @override
  String get name => 'article-read-article';
  @override
  int get index => 47;
  @override
  Module get module => Module.article;
  @override
  Entity get entity => Entity.article;
  @override
  Operation get operation => Operation.read;
  @override
  String displayName(AppLocalizations localization) =>
      localization.permissionArticleReadArticle;
}

final class ArticleCreateArticle extends Permission {
  const ArticleCreateArticle._();
  @override
  String get name => 'article-create-article';
  @override
  int get index => 48;
  @override
  Module get module => Module.article;
  @override
  Entity get entity => Entity.article;
  @override
  Operation get operation => Operation.create;
  @override
  String displayName(AppLocalizations localization) =>
      localization.permissionArticleCreateArticle;
}

final class ArticleUpdateArticle extends Permission {
  const ArticleUpdateArticle._();
  @override
  String get name => 'article-update-article';
  @override
  int get index => 49;
  @override
  Module get module => Module.article;
  @override
  Entity get entity => Entity.article;
  @override
  Operation get operation => Operation.update;
  @override
  String displayName(AppLocalizations localization) =>
      localization.permissionArticleUpdateArticle;
}

final class ArticleDeleteArticle extends Permission {
  const ArticleDeleteArticle._();
  @override
  String get name => 'article-delete-article';
  @override
  int get index => 50;
  @override
  Module get module => Module.article;
  @override
  Entity get entity => Entity.article;
  @override
  Operation get operation => Operation.delete;
  @override
  String displayName(AppLocalizations localization) =>
      localization.permissionArticleDeleteArticle;
}

// ═══════════════════════════════════════════════
//  App
// ═══════════════════════════════════════════════

final class AppReadAppContent extends Permission {
  const AppReadAppContent._();
  @override
  String get name => 'app-read-app-content';
  @override
  int get index => 51;
  @override
  Module get module => Module.app;
  @override
  Entity get entity => Entity.appContent;
  @override
  Operation get operation => Operation.read;
  @override
  String displayName(AppLocalizations localization) =>
      localization.permissionAppReadAppContent;
}

final class AppUpdateAppContent extends Permission {
  const AppUpdateAppContent._();
  @override
  String get name => 'app-update-app-content';
  @override
  int get index => 52;
  @override
  Module get module => Module.app;
  @override
  Entity get entity => Entity.appContent;
  @override
  Operation get operation => Operation.update;
  @override
  String displayName(AppLocalizations localization) =>
      localization.permissionAppUpdateAppContent;
}
