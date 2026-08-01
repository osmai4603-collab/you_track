import 'package:issues_tracking/core/enums/server_type_enum.dart';
import 'package:issues_tracking/core/enums/vcs_auth_mode_enum.dart';
import 'package:issues_tracking/core/enums/vcs_connection_status_enum.dart';
import 'package:issues_tracking/features/version_control/domain/entities/vcs_integration_entity.dart';
import 'package:issues_tracking/core/utils/printing.dart';

class VcsIntegrationModel extends VcsIntegrationEntity {
  const VcsIntegrationModel({
    required super.id,
    required super.projectId,
    required super.integrationName,
    required super.providerType,
    super.serverUrl,
    required super.authMode,
    super.encryptedToken,
    super.sshPrivateKey,
    super.passphrase,
    required super.organizationOwner,
    required super.repositoryName,
    super.branchSpecification,
    super.parseCommitsForCommands,
    super.silentProcessing,
    super.pullRequestAutomation,
    super.commandExecutorsGroups,
    super.visibleToRoles,
    super.automaticUserMapping,
    super.status,
    required super.createdAt,
    required super.updatedAt,
  });

  factory VcsIntegrationModel.fromEntity(VcsIntegrationEntity entity) {
    return VcsIntegrationModel(
      id: entity.id,
      projectId: entity.projectId,
      integrationName: entity.integrationName,
      providerType: entity.providerType,
      serverUrl: entity.serverUrl,
      authMode: entity.authMode,
      encryptedToken: entity.encryptedToken,
      sshPrivateKey: entity.sshPrivateKey,
      passphrase: entity.passphrase,
      organizationOwner: entity.organizationOwner,
      repositoryName: entity.repositoryName,
      branchSpecification: entity.branchSpecification,
      parseCommitsForCommands: entity.parseCommitsForCommands,
      silentProcessing: entity.silentProcessing,
      pullRequestAutomation: entity.pullRequestAutomation,
      commandExecutorsGroups: entity.commandExecutorsGroups,
      visibleToRoles: entity.visibleToRoles,
      automaticUserMapping: entity.automaticUserMapping,
      status: entity.status,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  factory VcsIntegrationModel.fromJson(Map<String, dynamic> json) {
    printMap(title: 'VcsIntegration', data: json);
    return VcsIntegrationModel(
      id: (json['id'] ?? '').toString(),
      projectId: (json['project_id'] ?? '').toString(),
      integrationName: (json['integration_name'] ?? '').toString(),
      providerType: VcsProviderType.of(json['provider_type']?.toString() ?? ''),
      serverUrl: json['server_url']?.toString(),
      authMode: VcsAuthMode.fromValue(json['auth_mode']?.toString() ?? ''),
      encryptedToken: json['encrypted_token']?.toString(),
      sshPrivateKey: json['ssh_private_key']?.toString(),
      passphrase: json['passphrase']?.toString(),
      organizationOwner: (json['organization_owner'] ?? '').toString(),
      repositoryName: (json['repository_name'] ?? '').toString(),
      branchSpecification: (json['branch_specification'] ?? '+:*').toString(),
      parseCommitsForCommands:
          json['parse_commits_for_commands'] as bool? ?? false,
      silentProcessing: json['silent_processing'] as bool? ?? false,
      pullRequestAutomation: json['pull_request_automation'] as bool? ?? false,
      commandExecutorsGroups: _parseStringList(
        json['command_executors_groups'],
      ),
      visibleToRoles: _parseStringList(json['visible_to_roles']) ?? [],
      automaticUserMapping: json['automatic_user_mapping'] as bool? ?? true,
      status: VcsConnectionStatus.fromValue(
        json['status']?.toString() ?? 'connected',
      ),
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'project_id': projectId,
      'integration_name': integrationName,
      'provider_type': providerType.name,
      'server_url': serverUrl,
      'auth_mode': authMode.value,
      'encrypted_token': encryptedToken,
      'ssh_private_key': sshPrivateKey,
      'passphrase': passphrase,
      'organization_owner': organizationOwner,
      'repository_name': repositoryName,
      'branch_specification': branchSpecification,
      'parse_commits_for_commands': parseCommitsForCommands,
      'silent_processing': silentProcessing,
      'pull_request_automation': pullRequestAutomation,
      'command_executors_groups': commandExecutorsGroups,
      'visible_to_roles': visibleToRoles,
      'automatic_user_mapping': automaticUserMapping,
      'status': status.value,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toInsertJson() {
    return {
      'project_id': projectId,
      'integration_name': integrationName,
      'provider_type': providerType.name,
      'server_url': serverUrl,
      'auth_mode': authMode.value,
      'encrypted_token': encryptedToken,
      'ssh_private_key': sshPrivateKey,
      'passphrase': passphrase,
      'organization_owner': organizationOwner,
      'repository_name': repositoryName,
      'branch_specification': branchSpecification,
      'parse_commits_for_commands': parseCommitsForCommands,
      'silent_processing': silentProcessing,
      'pull_request_automation': pullRequestAutomation,
      'command_executors_groups': commandExecutorsGroups,
      'visible_to_roles': visibleToRoles,
      'automatic_user_mapping': automaticUserMapping,
      'status': status.value,
    };
  }

  static DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.now();
    try {
      return DateTime.parse(value.toString());
    } catch (_) {
      return DateTime.now();
    }
  }

  static List<String>? _parseStringList(dynamic value) {
    if (value == null) return null;
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return null;
  }
}
