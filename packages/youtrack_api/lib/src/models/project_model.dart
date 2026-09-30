import 'package:equatable/equatable.dart';

/// A project as returned by `GET /projects/me`.
///
/// The listing endpoint resolves visibility server-side, so a payload only ever
/// contains projects the current identity may read. Parsing is deliberately
/// defensive: an unknown or missing field degrades to a safe default instead of
/// throwing, so a newer server can never break the projects screen.
class ProjectModel extends Equatable {
  final String id;
  final String name;

  /// The short name the server uses to build issue keys, e.g. `DEMO`.
  final String shortName;
  final String? description;
  final String? iconUrl;
  final String? issuesUrl;

  /// Empty when the project has no leader assigned.
  final String leaderId;
  final String teamId;
  final String organizationId;

  /// Raw template identifier, e.g. `scrum`. Kept as a String because the
  /// `ProjectTemplateType` enum lives in the app layer, which this package
  /// cannot import.
  final String projectTypeId;

  /// Creation time in milliseconds since the Unix epoch, as stored by the
  /// server. Zero means the server sent no usable value.
  final int creationTime;

  final bool pinned;
  final bool archived;
  final bool template;
  final bool restricted;
  final bool hasArticles;
  final bool isDemo;

  const ProjectModel({
    required this.id,
    required this.name,
    required this.shortName,
    this.description,
    this.iconUrl,
    this.issuesUrl,
    this.leaderId = '',
    this.teamId = '',
    this.organizationId = '',
    this.projectTypeId = '',
    this.creationTime = 0,
    this.pinned = false,
    this.archived = false,
    this.template = false,
    this.restricted = false,
    this.hasArticles = false,
    this.isDemo = false,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> data) {
    return ProjectModel(
      id: _pickString(data, const ['id']),
      name: _pickString(data, const ['name']),
      shortName: _pickString(data, const ['shortName', 'short_name']),
      description: _pickNullableString(data, const ['description']),
      iconUrl: _pickNullableString(data, const ['iconUrl', 'icon_url']),
      issuesUrl: _pickNullableString(data, const ['issuesUrl', 'issues_url']),
      leaderId: _pickString(data, const ['leaderId', 'leader_id']),
      teamId: _pickString(data, const ['teamId', 'team_id']),
      organizationId: _pickString(data, const [
        'organizationId',
        'organization_id',
      ]),
      projectTypeId: _pickString(data, const [
        'projectTypeId',
        'project_type_id',
      ]),
      creationTime: _pickInt(data, const [
        'creationTime',
        'creation_time',
        'createdAt',
        'created_at',
      ]),
      pinned: _pickBool(data, const ['pinned']),
      archived: _pickBool(data, const ['archived']),
      template: _pickBool(data, const ['template']),
      restricted: _pickBool(data, const ['restricted']),
      hasArticles: _pickBool(data, const ['hasArticles', 'has_articles']),
      isDemo: _pickBool(data, const ['isDemo', 'is_demo']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'shortName': shortName,
      'description': description,
      'iconUrl': iconUrl,
      'issuesUrl': issuesUrl,
      'leaderId': leaderId,
      'teamId': teamId,
      'organizationId': organizationId,
      'projectTypeId': projectTypeId,
      'creationTime': creationTime,
      'pinned': pinned,
      'archived': archived,
      'template': template,
      'restricted': restricted,
      'hasArticles': hasArticles,
      'isDemo': isDemo,
    };
  }

  static Object? _pick(Map<String, dynamic> data, List<String> keys) {
    for (final key in keys) {
      final value = data[key];
      if (value != null) return value;
    }
    return null;
  }

  static String _pickString(Map<String, dynamic> data, List<String> keys) {
    return _pick(data, keys)?.toString() ?? '';
  }

  static String? _pickNullableString(
    Map<String, dynamic> data,
    List<String> keys,
  ) {
    final value = _pick(data, keys);
    if (value == null) return null;
    final text = value.toString();
    return text.isEmpty ? null : text;
  }

  static bool _pickBool(Map<String, dynamic> data, List<String> keys) {
    final value = _pick(data, keys);
    if (value is bool) return value;
    if (value is String) return value.toLowerCase() == 'true';
    return false;
  }

  /// JSON numbers arrive as `int` for BIGINT columns but a decoder may hand
  /// back a `double` or a numeric string, so every shape is tolerated.
  static int _pickInt(Map<String, dynamic> data, List<String> keys) {
    final value = _pick(data, keys);
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  @override
  List<Object?> get props => [
    id,
    name,
    shortName,
    description,
    iconUrl,
    issuesUrl,
    leaderId,
    teamId,
    organizationId,
    projectTypeId,
    creationTime,
    pinned,
    archived,
    template,
    restricted,
    hasArticles,
    isDemo,
  ];
}
