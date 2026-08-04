import 'package:issues_tracking/core/errors/exceptions.dart';
import 'package:issues_tracking/core/services/sqlite/sqlite_database_sync.dart';
import 'package:issues_tracking/core/services/sqlite/tables/project_members_table.dart';
import 'package:issues_tracking/core/services/sqlite/tables/project_templates_table.dart';
import 'package:issues_tracking/core/services/sqlite/tables/projects_table.dart';
import 'package:issues_tracking/features/projects/data/datasources/projects_remote_data_source.dart';
import 'package:issues_tracking/features/projects/data/models/project_member_model.dart';
import 'package:issues_tracking/features/projects/data/models/project_model.dart';
import 'package:issues_tracking/features/projects/data/models/project_template_model.dart';
import 'package:issues_tracking/core/init_dependencies.dart';
import 'package:issues_tracking/features/projects/data/models/subsystem_model.dart';
import 'package:issues_tracking/features/users/domain/usecases/user_session.dart';

class ProjectsSqliteDataSourceImpl implements ProjectsRemoteDataSource {
  final SqliteDatabaseSync _sqlite;
  final ProjectsTable _projectsTable = const ProjectsTable();
  final ProjectMembersTable _membersTable = const ProjectMembersTable();
  final ProjectTemplatesTable _templatesTable = const ProjectTemplatesTable();

  ProjectsSqliteDataSourceImpl(this._sqlite);

  @override
  Future<ProjectMemberModel> addProjectMember(ProjectMemberModel member) async {
    final json = member.toJson();
    if (json['id'] == null || json['id'].toString().isEmpty) {
      json['id'] = DateTime.now().millisecondsSinceEpoch.toString();
    }

    if (json.containsKey('is_owner') && json['is_owner'] is bool) {
      json['is_owner'] = json['is_owner'] ? 1 : 0;
    }

    _sqlite.insert(table: _membersTable.tableName, data: json);

    // Convert back to model
    json['is_owner'] = json['is_owner'] == 1;
    return ProjectMemberModel.fromJson(json);
  }

  @override
  Future<void> updateStartingNumber(String projectId, int startingNumber) async {
    _sqlite.execute(
      'UPDATE ${_projectsTable.tableName} SET ${_projectsTable.startingNumber} = ? WHERE ${_projectsTable.id} = ?',
      [startingNumber, projectId],
    );
  }

  @override
  Future<void> updateFavorite(String projectId, bool isFavorite) async {
    _sqlite.execute(
      'UPDATE ${_projectsTable.tableName} SET ${_projectsTable.isFavorite} = ? WHERE ${_projectsTable.id} = ?',
      [isFavorite ? 1 : 0, projectId],
    );
  }

  @override
  Future<void> archiveProject(String id) async {
    _sqlite.execute(
      'UPDATE ${_projectsTable.tableName} SET ${_projectsTable.isArchived} = 1 WHERE ${_projectsTable.id} = ?',
      [id],
    );
  }

  @override
  Future<ProjectModel> createProject(ProjectModel project) async {
    final json = project.toJson()
      ..remove('members')
      ..remove('is_template');

    if (json['id'] == null || json['id'].toString().isEmpty) {
      json['id'] = DateTime.now().millisecondsSinceEpoch.toString();
    }

    final userSession = get_it<UserSession>();
    if (userSession.currentUser != null) {
      json['owner_id'] = userSession.currentUser!.id;
    }

    if (json.containsKey('is_archived') && json['is_archived'] is bool) {
      json['is_archived'] = json['is_archived'] ? 1 : 0;
    }
    if (json.containsKey('is_favorite') && json['is_favorite'] is bool) {
      json['is_favorite'] = json['is_favorite'] ? 1 : 0;
    }

    _sqlite.insert(table: _projectsTable.tableName, data: json);
    return getProjectById(json['id'].toString());
  }

  @override
  Future<void> deleteProject(String id) async {
    _sqlite.execute(
      'DELETE FROM ${_projectsTable.tableName} WHERE ${_projectsTable.id} = ?',
      [id],
    );
    _sqlite.execute(
      'DELETE FROM ${_membersTable.tableName} WHERE ${_membersTable.projectId} = ?',
      [id],
    );
  }

  @override
  Future<ProjectModel> getProjectById(String id) async {
    final row = _sqlite.fetchFirst(
      tableName: _projectsTable.tableName,
      where: '${_projectsTable.id} = ?',
      whereArgs: [id],
    );
    if (row == null) {
      throw DatabaseException('Project not found');
    }

    final parsed = Map<String, dynamic>.from(row);
    parsed['is_archived'] = parsed['is_archived'] == 1;
    parsed['is_favorite'] = parsed['is_favorite'] == 1;

    // Fetch members
    final members = await getProjectMembers(id);
    parsed['project_members'] = members.map((m) => m.toJson()).toList();

    return ProjectModel.fromJson(parsed);
  }

  @override
  Future<List<ProjectMemberModel>> getProjectMembers(String projectId) async {
    final rows = _sqlite.query(
      table: _membersTable.tableName,
      where: '${_membersTable.projectId} = ?',
      whereArgs: [projectId],
    );

    return rows.map((row) {
      final parsed = Map<String, dynamic>.from(row);
      parsed['is_owner'] = parsed['is_owner'] == 1;
      return ProjectMemberModel.fromJson(parsed);
    }).toList();
  }

  @override
  Future<List<ProjectTemplateModel>> getProjectTemplates() async {
    final rows = _sqlite.query(
      table: _templatesTable.tableName,
      orderBy: 'name ASC',
    );
    return rows.map((row) => ProjectTemplateModel.fromJson(row)).toList();
  }

  @override
  Future<List<ProjectModel>> getProjects() async {
    final rows = _sqlite.query(
      table: _projectsTable.tableName,
      orderBy: 'created_at DESC',
    );

    final List<ProjectModel> projects = [];
    for (var row in rows) {
      final parsed = Map<String, dynamic>.from(row);
      parsed['is_archived'] = parsed['is_archived'] == 1;
      parsed['is_favorite'] = parsed['is_favorite'] == 1;

      // Fetch members for each project
      final members = await getProjectMembers(parsed['id'].toString());
      parsed['project_members'] = members.map((m) => m.toJson()).toList();

      projects.add(ProjectModel.fromJson(parsed));
    }

    return projects;
  }

  @override
  Future<ProjectModel> updateProject(ProjectModel project) async {
    final json = project.toJson();

    if (json.containsKey('is_archived') && json['is_archived'] is bool) {
      json['is_archived'] = json['is_archived'] ? 1 : 0;
    }
    if (json.containsKey('is_favorite') && json['is_favorite'] is bool) {
      json['is_favorite'] = json['is_favorite'] ? 1 : 0;
    }
    json.remove('id');

    final setClause = json.keys.map((k) => '$k = ?').join(', ');
    _sqlite.execute(
      'UPDATE ${_projectsTable.tableName} SET $setClause WHERE ${_projectsTable.id} = ?',
      [...json.values, project.id],
    );

    return getProjectById(project.id);
  }

  @override
  Future<List<SubsystemModel>> getSubsystems(String projectId) async {
    final rows = _sqlite.query(
      table: 'issue_subsystems',
      where: 'project_id = ?',
      whereArgs: [projectId],
      orderBy: 'name ASC',
    );
    return rows.map((row) => SubsystemModel.fromJson(row)).toList();
  }

  @override
  Future<SubsystemModel> getSubsystemById(String id) async {
    final rows = _sqlite.query(
      table: 'issue_subsystems',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) {
      throw Exception('Subsystem not found with id: $id');
    }
    return SubsystemModel.fromJson(rows.first);
  }
  
  @override
  Future<SubsystemModel> createSubsystem(SubsystemModel model) async {
    final json = model.toJson();
    if (json['id'] == null || json['id'].toString().isEmpty) {
      json['id'] = DateTime.now().millisecondsSinceEpoch.toString();
    }

    _sqlite.insert(table: 'issue_subsystems', data: json);

    // Convert back to model
    return SubsystemModel.fromJson(json);
  }
  
  @override
  Future<SubsystemModel> addSubsystem(SubsystemModel model) async {
    final json = model.toJson();
    if (json['id'] == null || json['id'].toString().isEmpty) {
      json['id'] = DateTime.now().millisecondsSinceEpoch.toString();
    }

    _sqlite.insert(table: 'issue_subsystems', data: json);
    
    // Convert back to model
    return SubsystemModel.fromJson(json);
  }
}
