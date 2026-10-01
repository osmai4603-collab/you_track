import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String fullName;
  final String username;
  final String email;
  final String? avatarUrl;
  final DateTime? createdAt;
  final bool isBanned;
  final List<String> groups;
  final List<String> projects;
  final String initials;

  String get userKey {
    return (username).length >= 2 ? '${username[0]}${username[1]}' : '';
  }

  const UserModel({
    required this.id,
    required this.fullName,
    required this.username,
    required this.email,
    this.avatarUrl,
    this.createdAt,
    this.isBanned = false,
    this.groups = const [],
    this.projects = const [],
    this.initials = '',
  });

  static UserModel? tryParseFromJson(Map<String, dynamic>? data) {
    if (data == null) return null;
    return UserModel.fromJson(data);
  }

  factory UserModel.fromJson(Map<String, dynamic> data) {
    List<String> parsedGroups = [];
    List<String> parsedProjects = [];

    final rawGroupMembers = data['group_members'];
    if (rawGroupMembers is List) {
      for (final rawMembership in rawGroupMembers) {
        if (rawMembership is! Map) continue;
        final membership = Map<String, dynamic>.from(rawMembership);
        final rawGroup = membership['groups'];
        if (rawGroup is! Map) continue;
        final group = Map<String, dynamic>.from(rawGroup);
        final groupName = group['name']?.toString();
        if (groupName != null) parsedGroups.add(groupName);

        final rawGroupProjects = group['group_projects'];
        if (rawGroupProjects is! List) continue;
        for (final rawGroupProject in rawGroupProjects) {
          if (rawGroupProject is! Map) continue;
          final rawProject = rawGroupProject['projects'];
          if (rawProject is! Map) continue;
          final projectName = rawProject['name']?.toString();
          if (projectName != null && !parsedProjects.contains(projectName)) {
            parsedProjects.add(projectName);
          }
        }
      }
    }

    // Support direct array format (e.g. from sqlite JSON parse)
    if (data['groups'] != null && data['groups'] is List) {
      parsedGroups = (data['groups'] as List).map((e) => e.toString()).toList();
    }
    if (data['projects'] != null && data['projects'] is List) {
      parsedProjects = (data['projects'] as List)
          .map((e) => e.toString())
          .toList();
    }

    return UserModel(
      id: _pickString(data, const ['id']),
      fullName: _pickString(data, const ['fullName', 'full_name', 'name']),
      username: _pickString(data, const [
        'login',
        'user_name',
        'username',
        'userKey',
      ]),
      email: _pickString(data, const ['email']),
      avatarUrl: _pickNullableString(data, const ['avatarUrl', 'avatar_url']),
      createdAt: DateTime.tryParse(
        _pickString(data, const ['created_at']).isEmpty
            ? ''
            : _pickString(data, const ['created_at']),
      ),
      isBanned: _pickBool(data, const ['banned', 'is_banned']),
      groups: parsedGroups,
      projects: parsedProjects,
      initials: _pickString(data, const ['initials']).isNotEmpty
          ? _pickString(data, const ['initials'])
          : _computeInitials(
              _pickString(data, const ['fullName', 'full_name', 'name']),
            ),
    );
  }

  /// Reads the first present key so the model works against both the
  /// canonical camelCase payload and the legacy snake_case aliases.
  static Object? _pick(Map<String, dynamic> data, List<String> keys) {
    for (final key in keys) {
      final value = data[key];
      if (value != null) return value;
    }
    return null;
  }

  static String _pickString(Map<String, dynamic> data, List<String> keys) {
    final value = _pick(data, keys);
    return value?.toString() ?? '';
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

  static String _computeInitials(String fullName) {
    final names = fullName
        .trim()
        .split(RegExp(r'\s+'))
        .where((name) => name.isNotEmpty)
        .toList(growable: false);
    if (names.isEmpty) return '';
    String firstRune(String value) =>
        String.fromCharCode(value.runes.first).toUpperCase();

    if (names.length == 1) return firstRune(names.first);
    return '${firstRune(names.first)}${firstRune(names.last)}';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'user_name': username,
      'email': email,
      'avatar_url': avatarUrl,
      'created_at': createdAt?.toIso8601String(),
      'is_banned': isBanned,
      // 'groups': groups,
      // 'projects': projects,
    };
  }

  @override
  List<Object?> get props => [
    id,
    fullName,
    username,
    email,
    avatarUrl,
    createdAt,
    isBanned,
    groups,
    projects,
  ];
}
