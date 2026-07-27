import 'app_enum.dart';
import 'package:issues_tracking/core/localization/app_localizations.dart';

sealed class VcsProviderType extends AppEnum {
  const VcsProviderType();

  static const github = GitHubServerType._();
  static const gitlab = GitLabServerType._();
  static const bitbucket = BitbucketServerType._();
  static const bitbucketServer = BitbucketServerServerType._();
  static const gogs = GogsServerType._();
  static const gitea = GiteaServerType._();
  static const space = SpaceServerType._();
  static const generice = GenericeServerType._();
  static const azureRepos = AzureReposServerType._();

  static List<VcsProviderType> get values => [
    github,
    gitlab,
    bitbucket,
    bitbucketServer,
    gogs,
    gitea,
    space,
    generice,
    azureRepos,
  ];

  static VcsProviderType of(String name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw ArgumentError('Unknown ServerType: $name'),
    );
  }

  bool get isSelfHosted =>
      this == bitbucketServer || this == gitea || this == github;

  bool get supportsOAuth =>
      this == github || this == gitlab || this == bitbucketServer;
}

final class GitHubServerType extends VcsProviderType {
  const GitHubServerType._();

  @override
  String get name => 'github';

  @override
  int get index => 0;

  @override
  String displayName(AppLocalizations localization) =>
      localization.serverTypeGithub;
}

final class GitLabServerType extends VcsProviderType {
  const GitLabServerType._();

  @override
  String get name => 'gitlab';

  @override
  int get index => 1;

  @override
  String displayName(AppLocalizations localization) =>
      localization.serverTypeGitlab;
}

final class BitbucketServerType extends VcsProviderType {
  const BitbucketServerType._();

  @override
  String get name => 'bitbucket';

  @override
  int get index => 2;

  @override
  String displayName(AppLocalizations localization) =>
      localization.serverTypeBitbucket;
}

final class BitbucketServerServerType extends VcsProviderType {
  const BitbucketServerServerType._();

  @override
  String get name => 'bitbucket-server';

  @override
  int get index => 3;

  @override
  String displayName(AppLocalizations localization) =>
      localization.serverTypeBitbucketServer;
}

final class GogsServerType extends VcsProviderType {
  const GogsServerType._();

  @override
  String get name => 'gogs';

  @override
  int get index => 4;

  @override
  String displayName(AppLocalizations localization) =>
      localization.serverTypeGogs;
}

final class GiteaServerType extends VcsProviderType {
  const GiteaServerType._();

  @override
  String get name => 'gitea';

  @override
  int get index => 5;

  @override
  String displayName(AppLocalizations localization) =>
      localization.serverTypeGitea;
}

final class SpaceServerType extends VcsProviderType {
  const SpaceServerType._();

  @override
  String get name => 'space';

  @override
  int get index => 6;

  @override
  String displayName(AppLocalizations localization) =>
      localization.serverTypeSpace;
}

final class GenericeServerType extends VcsProviderType {
  const GenericeServerType._();

  @override
  String get name => 'generice';

  @override
  int get index => 7;

  @override
  String displayName(AppLocalizations localization) =>
      localization.serverTypeGenerice;
}

final class AzureReposServerType extends VcsProviderType {
  const AzureReposServerType._();

  @override
  String get name => 'azure-repos';

  @override
  int get index => 8;

  @override
  String displayName(AppLocalizations localization) =>
      localization.serverTypeAzureRepos;
}
