import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:issues_tracking/features/dashboards/data/models/dashboard_model.dart';
import 'package:issues_tracking/features/dashboards/data/models/dashboard_widget_model.dart';

abstract class DashboardRemoteDataSource {
  Future<List<DashboardModel>> getDashboards();
  Future<DashboardModel> createDashboard(String name);
  Future<DashboardModel> updateDashboard(DashboardModel dashboard);
  Future<void> deleteDashboard(String id);

  Future<List<DashboardWidgetModel>> getWidgets(String dashboardId);
  Future<DashboardWidgetModel> addWidget(DashboardWidgetModel widget);
  Future<DashboardWidgetModel> updateWidget(DashboardWidgetModel widget);
  Future<void> removeWidget(String widgetId);
  Future<void> updateWidgetsPositions(List<DashboardWidgetModel> widgets);
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final SupabaseClient supabase;

  DashboardRemoteDataSourceImpl(this.supabase);

  @override
  Future<List<DashboardModel>> getDashboards() async {
    final response = await supabase
        .from('dashboards')
        .select()
        .order('created_at', ascending: false);
    return (response as List).map((e) => DashboardModel.fromJson(e)).toList();
  }

  @override
  Future<DashboardModel> createDashboard(String name) async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    final response = await supabase.from('dashboards').insert({
      'name': name,
      'owner_id': user.id,
    }).select().single();
    
    return DashboardModel.fromJson(response);
  }

  @override
  Future<DashboardModel> updateDashboard(DashboardModel dashboard) async {
    final response = await supabase
        .from('dashboards')
        .update(dashboard.toJson())
        .eq('id', dashboard.id)
        .select()
        .single();
    return DashboardModel.fromJson(response);
  }

  @override
  Future<void> deleteDashboard(String id) async {
    await supabase.from('dashboards').delete().eq('id', id);
  }

  @override
  Future<List<DashboardWidgetModel>> getWidgets(String dashboardId) async {
    final response = await supabase
        .from('dashboard_widgets')
        .select()
        .eq('dashboard_id', dashboardId)
        .order('position_y', ascending: true)
        .order('position_x', ascending: true);
    return (response as List).map((e) => DashboardWidgetModel.fromJson(e)).toList();
  }

  @override
  Future<DashboardWidgetModel> addWidget(DashboardWidgetModel widget) async {
    // Remove id to let DB generate UUID if we want, or keep it if we generate on client
    final map = widget.toJson();
    if (map['id'] == '') map.remove('id'); 
    
    final response = await supabase.from('dashboard_widgets').insert(map).select().single();
    return DashboardWidgetModel.fromJson(response);
  }

  @override
  Future<DashboardWidgetModel> updateWidget(DashboardWidgetModel widget) async {
    final response = await supabase
        .from('dashboard_widgets')
        .update(widget.toJson())
        .eq('id', widget.id)
        .select()
        .single();
    return DashboardWidgetModel.fromJson(response);
  }

  @override
  Future<void> removeWidget(String widgetId) async {
    await supabase.from('dashboard_widgets').delete().eq('id', widgetId);
  }

  @override
  Future<void> updateWidgetsPositions(List<DashboardWidgetModel> widgets) async {
    // Using upsert or individual updates
    for (var widget in widgets) {
      await supabase.from('dashboard_widgets').update({
        'position_x': widget.positionX,
        'position_y': widget.positionY,
      }).eq('id', widget.id);
    }
  }
}
