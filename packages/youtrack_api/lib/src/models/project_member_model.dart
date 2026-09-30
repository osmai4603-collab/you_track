import 'package:equatable/equatable.dart';
import 'package:youtrack_api/src/models/user_model.dart';

class ProjectMemberModel extends Equatable {
  final String id;
  final String projectId;
  final List<String> roles;
  final bool isOwner;
  final String userId;
  final UserModel? userData;

  const ProjectMemberModel({
    required this.id,
    required this.projectId,
    required this.roles,
    required this.isOwner,
    required this.userId,
    required this.userData,
  });

  factory ProjectMemberModel.fromJson(Map<String, dynamic> data) {
    final user = data['user'];
    final flattenedUserId = _pickString(data, const ['userId', 'user_id']);

    return ProjectMemberModel(
      id: _pickString(data, const ['id']),
      projectId: _pickString(data, const ['projectId', 'project_id']),
      roles: _pickRoles(data),
      isOwner: _pickBool(data, const ['isOwner', 'is_owner']),
      userId: flattenedUserId.isNotEmpty
          ? flattenedUserId
          : _pickString(user, const ['id']),
      userData: user == null ? null : UserModel.fromJson(data['user']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'projectId': projectId,
      'roles': roles,
      'isOwner': isOwner,
      'userId': userId,
      'userData': userData?.toJson(),
    };
  }

  static List<String> _pickRoles(Map<String, dynamic> data) {
    final names = <String>[];

    final list = _pick(data, const ['roles']);
    if (list is List) {
      for (final entry in list) {
        if (entry is Map) {
          final name = _pickString(Map<String, dynamic>.from(entry), const [
            'name',
            'id',
          ]);
          if (name.isNotEmpty) names.add(name);
        } else if (entry != null) {
          names.add(entry.toString());
        }
      }
    }

    if (names.isEmpty) {
      final single = _pick(data, const ['role']);
      if (single is Map) {
        final name = _pickString(Map<String, dynamic>.from(single), const [
          'name',
          'id',
        ]);
        if (name.isNotEmpty) names.add(name);
      } else if (single != null) {
        names.add(single.toString());
      }
    }

    return names;
  }

  static Object? _pick(Map<String, dynamic>? data, List<String> keys) {
    if (data == null) return null;
    for (final key in keys) {
      final value = data[key];
      if (value != null) return value;
    }
    return null;
  }

  static String _pickString(Map<String, dynamic>? data, List<String> keys) {
    return _pick(data, keys)?.toString() ?? '';
  }

  static Map<String, dynamic>? _pickMap(
    Map<String, dynamic>? data,
    List<String> keys,
  ) {
    final value = _pick(data, keys);
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }

  static bool _pickBool(Map<String, dynamic>? data, List<String> keys) {
    final value = _pick(data, keys);
    if (value is bool) return value;
    if (value is String) return value.toLowerCase() == 'true';
    return false;
  }

  @override
  List<Object?> get props => [id, projectId, roles, isOwner, userId, userData];
}
