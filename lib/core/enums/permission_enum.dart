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
  List<Permission> get dependents => [];
  List<Permission> get implies => [];

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
  static const updateIssue = IssueUpdateIssue._();
  static const createIssue = IssueCreateIssue._();
  static const deleteIssue = IssueDeleteIssue._();
  static const issueLinkIssues = IssueLinkIssues._();
  static const issueUpdateIssuePrivateFields =
      IssueUpdateIssuePrivateFields._();
  static const issueApplyCommandsSilently = IssueApplyCommandsSilently._();
  static const issueViewWatchers = IssueViewWatchers._();
  static const issueUpdateWatchers = IssueUpdateWatchers._();
  static const issueViewVoters = IssueViewVoters._();

  // ── Attachment ──
  static const addAttachment = AttachmentAddAttachment._();
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
    updateIssue,
    createIssue,
    deleteIssue,
    issueLinkIssues,
    issueUpdateIssuePrivateFields,
    issueApplyCommandsSilently,
    issueViewWatchers,
    issueUpdateWatchers,
    issueViewVoters,
    addAttachment,
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

  /// Resolves a set of permissions to their effective set, including all implied permissions.
  static Set<Permission> resolveEffective(Iterable<Permission> permissions) {
    final effective = <Permission>{};
    final queue = List<Permission>.from(permissions);

    while (queue.isNotEmpty) {
      final p = queue.removeLast();
      if (effective.add(p)) {
        queue.addAll(p.implies);
      }
    }
    return effective;
  }

  /// Checks if all prerequisites (dependents) are met for the given permission
  /// within the context of the effective permissions set.
  bool arePrerequisitesMet(Set<Permission> effectivePermissions) {
    // If this permission is in the effective set, we check if its ancestors are also there.
    // In this model, 'dependents' are those that depend on THIS.
    // So we need to find what THIS depends ON.
    // Wait, the current model has 'dependents' listing permissions that depend on the current one.
    // So if I am 'projectReadProjectFull', I depend on 'projectReadProjectBasic'.
    // In projectReadProjectBasic.dependents, we see projectReadProjectFull.
    // This means projectReadProjectFull's prerequisite is projectReadProjectBasic.

    // To check if 'projectReadProjectFull' is valid, we must ensure its prerequisites are met.
    // We can find prerequisites by searching which permissions have THIS in their 'dependents' list.
    final prerequisites = values.where((p) => p.dependents.contains(this));
    for (final prereq in prerequisites) {
      if (!effectivePermissions.contains(prereq)) {
        return false;
      }
    }
    return true;
  }
}

// ═══════════════════════════════════════════════
//  Project
// ═══════════════════════════════════════════════

final class ProjectReadProjectBasic extends Permission {
  const ProjectReadProjectBasic._();
  @override
  String get name => 'read-project-basic';
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

  @override
  List<Permission> get dependents => [
    Permission.projectReadProjectFull,
    Permission.issueReadIssue,
    Permission.issueReadIssuePrivateFields,
    Permission.createIssue,
    Permission.issueViewWatchers,
    Permission.issueViewVoters,
    Permission.articleReadArticle,
    Permission.articleCreateArticle,
    Permission.articleUpdateArticle,
    Permission.articleDeleteArticle,
    Permission.commentReadArticleComment,
    Permission.commentCreateArticleComment,
    Permission.commentUpdateArticleComment,
    Permission.commentDeleteArticleComment,
    Permission.issueUpdateIssuePrivateFields,
    Permission.visibilityOverrideVisibilityRestrictions,
    Permission.projectUpdateProject,
    Permission.projectDeleteProject,
  ];
}

final class ProjectCreateProject extends Permission {
  const ProjectCreateProject._();
  @override
  String get name => 'create-project';
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
  String get name => 'read-project-full';
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

  @override
  List<Permission> get implies => [Permission.projectReadProjectBasic];

  @override
  List<Permission> get dependents => [
    Permission.projectUpdateProject,
    Permission.projectDeleteProject,
  ];
}

final class ProjectUpdateProject extends Permission {
  const ProjectUpdateProject._();
  @override
  String get name => 'update-project';
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

  @override
  List<Permission> get implies => [
    Permission.projectReadProjectFull,
    Permission.projectReadProjectBasic,
  ];
}

final class ProjectDeleteProject extends Permission {
  const ProjectDeleteProject._();
  @override
  String get name => 'delete-project';
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

  @override
  List<Permission> get implies => [
    Permission.projectReadProjectFull,
    Permission.projectReadProjectBasic,
  ];
}

// ═══════════════════════════════════════════════
//  Organization
// ═══════════════════════════════════════════════

final class OrganizationReadOrganization extends Permission {
  const OrganizationReadOrganization._();
  @override
  String get name => 'read-organization';
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

  @override
  List<Permission> get dependents => [
    Permission.organizationUpdateOrganization,
    Permission.organizationDeleteOrganization,
  ];
}

final class OrganizationUpdateOrganization extends Permission {
  const OrganizationUpdateOrganization._();
  @override
  String get name => 'update-organization';
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

  @override
  List<Permission> get implies => [Permission.organizationReadOrganization];
}

final class OrganizationCreateOrganization extends Permission {
  const OrganizationCreateOrganization._();
  @override
  String get name => 'create-organization';
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
  String get name => 'delete-organization';
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

  @override
  List<Permission> get implies => [Permission.organizationReadOrganization];
}

// ═══════════════════════════════════════════════
//  User Profile
// ═══════════════════════════════════════════════

final class UserProfileUpdateSelf extends Permission {
  const UserProfileUpdateSelf._();
  @override
  String get name => 'update-self';
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

  @override
  List<Permission> get dependents => [Permission.userUpdateUser];
}

// ═══════════════════════════════════════════════
//  User
// ═══════════════════════════════════════════════

final class UserReadUserBasic extends Permission {
  const UserReadUserBasic._();
  @override
  String get name => 'read-user-basic';
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

  @override
  List<Permission> get dependents => [
    Permission.userReadUserDetails,
    Permission.userUpdateUser,
    Permission.userDeleteUser,
  ];
}

final class UserReadUserDetails extends Permission {
  const UserReadUserDetails._();
  @override
  String get name => 'read-user-details';
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

  @override
  List<Permission> get implies => [Permission.userReadUserBasic];

  @override
  List<Permission> get dependents => [
    Permission.userUpdateUser,
    Permission.userDeleteUser,
  ];
}

final class UserUpdateUser extends Permission {
  const UserUpdateUser._();
  @override
  String get name => 'update-user';
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

  @override
  List<Permission> get implies => [
    Permission.userReadUserDetails,
    Permission.userProfileUpdateSelf,
    Permission.userReadUserBasic,
  ];
}

final class UserCreateUser extends Permission {
  const UserCreateUser._();
  @override
  String get name => 'create-user';
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
  String get name => 'delete-user';
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

  @override
  List<Permission> get implies => [
    Permission.userReadUserDetails,
    Permission.userReadUserBasic,
  ];
}

// ═══════════════════════════════════════════════
//  System
// ═══════════════════════════════════════════════

final class SystemLowLevelAdminRead extends Permission {
  const SystemLowLevelAdminRead._();
  @override
  String get name => 'low-level-admin-read';
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

  @override
  List<Permission> get dependents => [Permission.systemLowLevelAdminWrite];
}

final class SystemLowLevelAdminWrite extends Permission {
  const SystemLowLevelAdminWrite._();
  @override
  String get name => 'low-level-admin-write';
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

  @override
  List<Permission> get implies => [Permission.systemLowLevelAdminRead];
}

// ═══════════════════════════════════════════════
//  Issue
// ═══════════════════════════════════════════════

final class IssueReadIssue extends Permission {
  const IssueReadIssue._();
  @override
  String get name => 'read-issue';
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

  @override
  List<Permission> get implies => [Permission.projectReadProjectBasic];
}

final class IssueReadIssuePrivateFields extends Permission {
  const IssueReadIssuePrivateFields._();
  @override
  String get name => 'read-issue-private-fields';
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

  @override
  List<Permission> get implies => [Permission.projectReadProjectBasic];

  @override
  List<Permission> get dependents => [
    Permission.issueUpdateIssuePrivateFields,
    Permission.visibilityOverrideVisibilityRestrictions,
  ];
}

final class IssueUpdateIssue extends Permission {
  const IssueUpdateIssue._();
  @override
  String get name => 'update-issue';
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

  @override
  List<Permission> get dependents => [Permission.issueUpdateIssuePrivateFields];
}

final class IssueCreateIssue extends Permission {
  const IssueCreateIssue._();
  @override
  String get name => 'create-issue';
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

  @override
  List<Permission> get implies => [Permission.projectReadProjectBasic];
}

final class IssueDeleteIssue extends Permission {
  const IssueDeleteIssue._();
  @override
  String get name => 'delete-issue';
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
  String get name => 'link-issues';
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
  String get name => 'update-issue-private-fields';
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

  @override
  List<Permission> get implies => [
    Permission.issueReadIssuePrivateFields,
    Permission.updateIssue,
    Permission.projectReadProjectBasic,
  ];
}

final class IssueApplyCommandsSilently extends Permission {
  const IssueApplyCommandsSilently._();
  @override
  String get name => 'apply-commands-silently';
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
  String get name => 'view-watchers';
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

  @override
  List<Permission> get implies => [Permission.projectReadProjectBasic];
}

final class IssueUpdateWatchers extends Permission {
  const IssueUpdateWatchers._();
  @override
  String get name => 'update-watchers';
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
  String get name => 'view-voters';
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

  @override
  List<Permission> get implies => [Permission.projectReadProjectBasic];
}

// ═══════════════════════════════════════════════
//  Attachment
// ═══════════════════════════════════════════════

final class AttachmentAddAttachment extends Permission {
  const AttachmentAddAttachment._();
  @override
  String get name => 'add-attachment';
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
  String get name => 'update-attachment';
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
  String get name => 'delete-attachment';
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
  String get name => 'create-issue-comment';
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
  String get name => 'read-issue-comment';
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

  @override
  List<Permission> get dependents => [
    Permission.commentUpdateNotOwnIssueComment,
    Permission.commentDeleteNotOwnCommentAndPermanentCommentDelete,
  ];
}

final class CommentUpdateIssueComment extends Permission {
  const CommentUpdateIssueComment._();
  @override
  String get name => 'update-issue-comment';
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
  String get name => 'delete-issue-comment';
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
  String get name => 'update-not-own-issue-comment';
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

  @override
  List<Permission> get implies => [Permission.commentReadIssueComment];
}

final class CommentDeleteNotOwnCommentAndPermanentCommentDelete
    extends Permission {
  const CommentDeleteNotOwnCommentAndPermanentCommentDelete._();
  @override
  String get name => 'delete-not-own-comment-and-permanent-comment-delete';
  @override
  int get index => 36;
  @override
  Module get module => Module.comment;
  @override
  Entity get entity => Entity.comment;
  @override
  Operation get operation => Operation.delete;
  @override
  String displayName(AppLocalizations localization) => localization
      .permissionCommentDeleteNotOwnCommentAndPermanentCommentDelete;

  @override
  List<Permission> get implies => [Permission.commentReadIssueComment];
}

final class CommentReadArticleComment extends Permission {
  const CommentReadArticleComment._();
  @override
  String get name => 'read-article-comment';
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

  @override
  List<Permission> get implies => [
    Permission.articleReadArticle,
    Permission.projectReadProjectBasic,
  ];

  @override
  List<Permission> get dependents => [
    Permission.commentCreateArticleComment,
    Permission.commentUpdateArticleComment,
    Permission.commentDeleteArticleComment,
  ];
}

final class CommentCreateArticleComment extends Permission {
  const CommentCreateArticleComment._();
  @override
  String get name => 'create-article-comment';
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

  @override
  List<Permission> get implies => [
    Permission.commentReadArticleComment,
    Permission.articleReadArticle,
    Permission.projectReadProjectBasic,
  ];
}

final class CommentUpdateArticleComment extends Permission {
  const CommentUpdateArticleComment._();
  @override
  String get name => 'update-article-comment';
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

  @override
  List<Permission> get implies => [
    Permission.commentReadArticleComment,
    Permission.articleReadArticle,
    Permission.projectReadProjectBasic,
  ];
}

final class CommentDeleteArticleComment extends Permission {
  const CommentDeleteArticleComment._();
  @override
  String get name => 'delete-article-comment';
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

  @override
  List<Permission> get implies => [
    Permission.commentReadArticleComment,
    Permission.articleReadArticle,
    Permission.projectReadProjectBasic,
  ];
}

// ═══════════════════════════════════════════════
//  Visibility
// ═══════════════════════════════════════════════

final class VisibilityOverrideVisibilityRestrictions extends Permission {
  const VisibilityOverrideVisibilityRestrictions._();
  @override
  String get name => 'override-visibility-restrictions';
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

  @override
  List<Permission> get implies => [
    Permission.issueReadIssuePrivateFields,
    Permission.projectReadProjectBasic,
  ];
}

// ═══════════════════════════════════════════════
//  Issue Work Item
// ═══════════════════════════════════════════════

final class IssueWorkItemReadWorkItem extends Permission {
  const IssueWorkItemReadWorkItem._();
  @override
  String get name => 'read-work-item';
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

  @override
  List<Permission> get dependents => [
    Permission.issueWorkItemUpdateNotOwnWorkItem,
  ];
}

final class IssueWorkItemUpdateWorkItem extends Permission {
  const IssueWorkItemUpdateWorkItem._();
  @override
  String get name => 'update-work-item';
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

  @override
  List<Permission> get dependents => [
    Permission.issueWorkItemUpdateNotOwnWorkItem,
  ];
}

final class IssueWorkItemUpdateNotOwnWorkItem extends Permission {
  const IssueWorkItemUpdateNotOwnWorkItem._();
  @override
  String get name => 'update-not-own-work-item';
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

  @override
  List<Permission> get implies => [
    Permission.issueWorkItemReadWorkItem,
    Permission.issueWorkItemUpdateWorkItem,
  ];
}

final class IssueWorkItemCreateWorkItem extends Permission {
  const IssueWorkItemCreateWorkItem._();
  @override
  String get name => 'create-work-item';
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

  @override
  List<Permission> get dependents => [
    Permission.issueWorkItemCreateNotOwnWorkItem,
  ];
}

final class IssueWorkItemCreateNotOwnWorkItem extends Permission {
  const IssueWorkItemCreateNotOwnWorkItem._();
  @override
  String get name => 'create-not-own-work-item';
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

  @override
  List<Permission> get implies => [Permission.issueWorkItemCreateWorkItem];
}

// ═══════════════════════════════════════════════
//  Article
// ═══════════════════════════════════════════════

final class ArticleReadArticle extends Permission {
  const ArticleReadArticle._();
  @override
  String get name => 'read-article';
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

  @override
  List<Permission> get implies => [Permission.projectReadProjectBasic];

  @override
  List<Permission> get dependents => [
    Permission.articleCreateArticle,
    Permission.articleUpdateArticle,
    Permission.articleDeleteArticle,
    Permission.commentReadArticleComment,
    Permission.commentCreateArticleComment,
    Permission.commentUpdateArticleComment,
    Permission.commentDeleteArticleComment,
  ];
}

final class ArticleCreateArticle extends Permission {
  const ArticleCreateArticle._();
  @override
  String get name => 'create-article';
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

  @override
  List<Permission> get implies => [
    Permission.articleReadArticle,
    Permission.projectReadProjectBasic,
  ];
}

final class ArticleUpdateArticle extends Permission {
  const ArticleUpdateArticle._();
  @override
  String get name => 'update-article';
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

  @override
  List<Permission> get implies => [
    Permission.articleReadArticle,
    Permission.projectReadProjectBasic,
  ];
}

final class ArticleDeleteArticle extends Permission {
  const ArticleDeleteArticle._();
  @override
  String get name => 'delete-article';
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

  @override
  List<Permission> get implies => [
    Permission.articleReadArticle,
    Permission.projectReadProjectBasic,
  ];
}

// ═══════════════════════════════════════════════
//  App
// ═══════════════════════════════════════════════

final class AppReadAppContent extends Permission {
  const AppReadAppContent._();
  @override
  String get name => 'read-app-content';
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

  @override
  List<Permission> get dependents => [Permission.appUpdateAppContent];
}

final class AppUpdateAppContent extends Permission {
  const AppUpdateAppContent._();
  @override
  String get name => 'update-app-content';
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

  @override
  List<Permission> get implies => [Permission.appReadAppContent];
}
