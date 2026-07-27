import 'package:equatable/equatable.dart';
import 'package:issues_tracking/core/enums/server_type_enum.dart';
import 'package:issues_tracking/core/enums/vcs_auth_mode_enum.dart';
import 'package:issues_tracking/core/enums/vcs_connection_status_enum.dart';

class VcsIntegrationEntity extends Equatable {
  final String id;
  final String projectId;
  final String integrationName;
  final VcsProviderType providerType;
  final String? serverUrl;
  final VcsAuthMode authMode;
  final String? encryptedToken;
  final String? sshPrivateKey;
  final String? passphrase;
  final String organizationOwner;
  final String repositoryName;
  final String branchSpecification;
  final bool parseCommitsForCommands;
  final bool silentProcessing;
  final bool pullRequestAutomation;
  final List<String>? commandExecutorsGroups;
  final List<String> visibleToRoles;
  final bool automaticUserMapping;
  final VcsConnectionStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const VcsIntegrationEntity({
    required this.id,
    required this.projectId,
    required this.integrationName,
    required this.providerType,
    this.serverUrl,
    required this.authMode,
    this.encryptedToken,
    this.sshPrivateKey,
    this.passphrase,
    required this.organizationOwner,
    required this.repositoryName,
    this.branchSpecification = '+:*',
    this.parseCommitsForCommands = false,
    this.silentProcessing = false,
    this.pullRequestAutomation = false,
    this.commandExecutorsGroups,
    this.visibleToRoles = const [],
    this.automaticUserMapping = true,
    this.status = VcsConnectionStatus.connected,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isServerUrlRequired => providerType.isSelfHosted;

  VcsIntegrationEntity copyWith({
    String? id,
    String? projectId,
    String? integrationName,
    VcsProviderType? providerType,
    String? serverUrl,
    bool clearServerUrl = false,
    VcsAuthMode? authMode,
    String? encryptedToken,
    bool clearEncryptedToken = false,
    String? sshPrivateKey,
    bool clearSshPrivateKey = false,
    String? passphrase,
    bool clearPassphrase = false,
    String? organizationOwner,
    String? repositoryName,
    String? branchSpecification,
    bool? parseCommitsForCommands,
    bool? silentProcessing,
    bool? pullRequestAutomation,
    List<String>? commandExecutorsGroups,
    bool clearCommandExecutorsGroups = false,
    List<String>? visibleToRoles,
    bool? automaticUserMapping,
    VcsConnectionStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return VcsIntegrationEntity(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      integrationName: integrationName ?? this.integrationName,
      providerType: providerType ?? this.providerType,
      serverUrl: clearServerUrl ? null : (serverUrl ?? this.serverUrl),
      authMode: authMode ?? this.authMode,
      encryptedToken: clearEncryptedToken
          ? null
          : (encryptedToken ?? this.encryptedToken),
      sshPrivateKey: clearSshPrivateKey
          ? null
          : (sshPrivateKey ?? this.sshPrivateKey),
      passphrase: clearPassphrase ? null : (passphrase ?? this.passphrase),
      organizationOwner: organizationOwner ?? this.organizationOwner,
      repositoryName: repositoryName ?? this.repositoryName,
      branchSpecification: branchSpecification ?? this.branchSpecification,
      parseCommitsForCommands:
          parseCommitsForCommands ?? this.parseCommitsForCommands,
      silentProcessing: silentProcessing ?? this.silentProcessing,
      pullRequestAutomation:
          pullRequestAutomation ?? this.pullRequestAutomation,
      commandExecutorsGroups: clearCommandExecutorsGroups
          ? null
          : (commandExecutorsGroups ?? this.commandExecutorsGroups),
      visibleToRoles: visibleToRoles ?? this.visibleToRoles,
      automaticUserMapping: automaticUserMapping ?? this.automaticUserMapping,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    projectId,
    integrationName,
    providerType,
    serverUrl,
    authMode,
    encryptedToken,
    sshPrivateKey,
    passphrase,
    organizationOwner,
    repositoryName,
    branchSpecification,
    parseCommitsForCommands,
    silentProcessing,
    pullRequestAutomation,
    commandExecutorsGroups,
    visibleToRoles,
    automaticUserMapping,
    status,
    createdAt,
    updatedAt,
  ];
}
