import 'app_enum.dart';
import 'package:issues_tracking/core/localization/app_localizations.dart';

sealed class ServerType extends AppEnum {
  const ServerType();

  static const github = GitHubServerType._();
  static const gitlab = GitLabServerType._();
  static const bitbucket = BitbucketServerType._();
  static const bitbucketServer = BitbucketServerServerType._();
  static const gogs = GogsServerType._();
  static const gitea = GiteaServerType._();
  static const space = SpaceServerType._();
  static const generice = GenericeServerType._();
  static const azureRepos = AzureReposServerType._();

  static List<ServerType> get values => [
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

  static ServerType of(String name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw ArgumentError('Unknown ServerType: $name'),
    );
  }
}

final class GitHubServerType extends ServerType {
  const GitHubServerType._();

  @override
  String get name => 'github';

  @override
  int get index => 0;

  @override
  String displayName(AppLocalizations localization) => localization.serverTypeGithub;
}

final class GitLabServerType extends ServerType {
  const GitLabServerType._();

  @override
  String get name => 'gitlab';

  @override
  int get index => 1;

  @override
  String displayName(AppLocalizations localization) => localization.serverTypeGitlab;
}

final class BitbucketServerType extends ServerType {
  const BitbucketServerType._();

  @override
  String get name => 'bitbucket';

  @override
  int get index => 2;

  @override
  String displayName(AppLocalizations localization) => localization.serverTypeBitbucket;
}

final class BitbucketServerServerType extends ServerType {
  const BitbucketServerServerType._();

  @override
  String get name => 'bitbucket-server';

  @override
  int get index => 3;

  @override
  String displayName(AppLocalizations localization) => localization.serverTypeBitbucketServer;
}

final class GogsServerType extends ServerType {
  const GogsServerType._();

  @override
  String get name => 'gogs';

  @override
  int get index => 4;

  @override
  String displayName(AppLocalizations localization) => localization.serverTypeGogs;
}

final class GiteaServerType extends ServerType {
  const GiteaServerType._();

  @override
  String get name => 'gitea';

  @override
  int get index => 5;

  @override
  String displayName(AppLocalizations localization) => localization.serverTypeGitea;
}

final class SpaceServerType extends ServerType {
  const SpaceServerType._();

  @override
  String get name => 'space';

  @override
  int get index => 6;

  @override
  String displayName(AppLocalizations localization) => localization.serverTypeSpace;
}

final class GenericeServerType extends ServerType {
  const GenericeServerType._();

  @override
  String get name => 'generice';

  @override
  int get index => 7;

  @override
  String displayName(AppLocalizations localization) => localization.serverTypeGenerice;
}

final class AzureReposServerType extends ServerType {
  const AzureReposServerType._();

  @override
  String get name => 'azure-repos';

  @override
  int get index => 8;

  @override
  String displayName(AppLocalizations localization) => localization.serverTypeAzureRepos;
}
