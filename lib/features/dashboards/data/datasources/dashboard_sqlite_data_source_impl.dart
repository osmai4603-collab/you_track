import 'dart:convert';
import 'package:issues_tracking/core/services/sqlite/sqlite_database_sync.dart';
import 'package:issues_tracking/core/services/sqlite/tables/dashboard_widgets_table.dart';
import 'package:issues_tracking/core/services/sqlite/tables/dashboards_table.dart';
import 'package:issues_tracking/features/dashboards/data/datasources/dashboard_remote_data_source.dart';
import 'package:issues_tracking/features/dashboards/data/models/dashboard_model.dart';
import 'package:issues_tracking/features/dashboards/data/models/dashboard_widget_model.dart';
import 'package:issues_tracking/core/init_dependencies.dart';
import 'package:issues_tracking/features/auth/domain/usecases/user_session.dart';

class DashboardSqliteDataSourceImpl implements DashboardRemoteDataSource {
  final SqliteDatabaseSync _sqlite;
  final DashboardsTable _dashboardsTable = const DashboardsTable();
  final DashboardWidgetsTable _widgetsTable = const DashboardWidgetsTable();

  DashboardSqliteDataSourceImpl(this._sqlite);

  @override
  Future<DashboardWidgetModel> addWidget(DashboardWidgetModel widget) async {
    final json = widget.toJson();
    if (json['id'] == null || json['id'].toString().isEmpty) {
      json['id'] = DateTime.now().millisecondsSinceEpoch.toString();
    }
    
    if (json['config'] != null) {
      json['config'] = jsonEncode(json['config']);
    }

    _sqlite.insert(table: _widgetsTable.tableName, data: json);
    
    final row = _sqlite.fetchFirst(
      tableName: _widgetsTable.tableName,
      where: '${_widgetsTable.id} = ?',
      whereArgs: [json['id']],
    );
    
    return _parseWidgetRow(row!);
  }

  @override
  Future<DashboardModel> createDashboard(String name) async {
    final userSession = get_it<UserSession>();
    final ownerId = userSession.currentUser?.id ?? 'unknown_user';
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    
    final json = {
      'id': id,
      'name': name,
      'owner_id': ownerId,
      'is_default': 0,
      'is_favorite': 0,
      'layout_config': '{}',
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };

    _sqlite.insert(table: _dashboardsTable.tableName, data: json);
    
    final row = _sqlite.fetchFirst(
      tableName: _dashboardsTable.tableName,
      where: '${_dashboardsTable.id} = ?',
      whereArgs: [id],
    );
    
    return _parseDashboardRow(row!);
  }

  @override
  Future<void> deleteDashboard(String id) async {
    _sqlite.execute('DELETE FROM ${_dashboardsTable.tableName} WHERE ${_dashboardsTable.id} = ?', [id]);
    _sqlite.execute('DELETE FROM ${_widgetsTable.tableName} WHERE ${_widgetsTable.dashboardId} = ?', [id]);
  }

  @override
  Future<List<DashboardModel>> getDashboards() async {
    final rows = _sqlite.query(
      table: _dashboardsTable.tableName,
      orderBy: 'created_at DESC',
    );
    return rows.map((e) => _parseDashboardRow(e)).toList();
  }

  @override
  Future<List<DashboardWidgetModel>> getWidgets(String dashboardId) async {
    final rows = _sqlite.query(
      table: _widgetsTable.tableName,
      where: '${_widgetsTable.dashboardId} = ?',
      whereArgs: [dashboardId],
      orderBy: 'position_y ASC, position_x ASC',
    );
    return rows.map((e) => _parseWidgetRow(e)).toList();
  }

  @override
  Future<void> removeWidget(String widgetId) async {
    _sqlite.execute('DELETE FROM ${_widgetsTable.tableName} WHERE ${_widgetsTable.id} = ?', [widgetId]);
  }

  @override
  Future<DashboardModel> updateDashboard(DashboardModel dashboard) async {
    final json = dashboard.toJson();
    final id = json['id'].toString();
    
    if (json.containsKey('is_default') && json['is_default'] is bool) {
      json['is_default'] = json['is_default'] ? 1 : 0;
    }
    if (json.containsKey('is_favorite') && json['is_favorite'] is bool) {
      json['is_favorite'] = json['is_favorite'] ? 1 : 0;
    }
    if (json['layout_config'] != null) {
      json['layout_config'] = jsonEncode(json['layout_config']);
    }
    json.remove('id');
    json['updated_at'] = DateTime.now().toIso8601String();

    final setClause = json.keys.map((k) => '$k = ?').join(', ');
    _sqlite.execute(
      'UPDATE ${_dashboardsTable.tableName} SET $setClause WHERE ${_dashboardsTable.id} = ?',
      [...json.values, id],
    );
    
    final row = _sqlite.fetchFirst(
      tableName: _dashboardsTable.tableName,
      where: '${_dashboardsTable.id} = ?',
      whereArgs: [id],
    );
    return _parseDashboardRow(row!);
  }

  @override
  Future<DashboardWidgetModel> updateWidget(DashboardWidgetModel widget) async {
    final json = widget.toJson();
    final id = json['id'].toString();
    
    if (json['config'] != null) {
      json['config'] = jsonEncode(json['config']);
    }
    json.remove('id');
    json['updated_at'] = DateTime.now().toIso8601String();

    final setClause = json.keys.map((k) => '$k = ?').join(', ');
    _sqlite.execute(
      'UPDATE ${_widgetsTable.tableName} SET $setClause WHERE ${_widgetsTable.id} = ?',
      [...json.values, id],
    );
    
    final row = _sqlite.fetchFirst(
      tableName: _widgetsTable.tableName,
      where: '${_widgetsTable.id} = ?',
      whereArgs: [id],
    );
    return _parseWidgetRow(row!);
  }

  @override
  Future<void> updateWidgetsPositions(List<DashboardWidgetModel> widgets) async {
    for (var widget in widgets) {
      _sqlite.execute(
        'UPDATE ${_widgetsTable.tableName} SET ${_widgetsTable.positionX} = ?, ${_widgetsTable.positionY} = ? WHERE ${_widgetsTable.id} = ?',
        [widget.positionX, widget.positionY, widget.id],
      );
    }
  }

  DashboardModel _parseDashboardRow(Map<String, dynamic> row) {
    final parsed = Map<String, dynamic>.from(row);
    parsed['is_default'] = parsed['is_default'] == 1;
    parsed['is_favorite'] = parsed['is_favorite'] == 1;
    
    if (parsed['layout_config'] != null && parsed['layout_config'] is String) {
      try {
        parsed['layout_config'] = jsonDecode(parsed['layout_config']);
      } catch (_) {
        parsed['layout_config'] = {};
      }
    }
    return DashboardModel.fromJson(parsed);
  }

  DashboardWidgetModel _parseWidgetRow(Map<String, dynamic> row) {
    final parsed = Map<String, dynamic>.from(row);
    if (parsed['config'] != null && parsed['config'] is String) {
      try {
        parsed['config'] = jsonDecode(parsed['config']);
      } catch (_) {
        parsed['config'] = {};
      }
    }
    return DashboardWidgetModel.fromJson(parsed);
  }
}
