import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:issues_tracking/core/constants/app_route_keys.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/core/constants/app_radius.dart';

class DashboardSidebar extends StatefulWidget {
  const DashboardSidebar({super.key});

  @override
  State<DashboardSidebar> createState() => _DashboardSidebarState();
}

class _DashboardSidebarState extends State<DashboardSidebar> {
  bool _isCollapsed = false;

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).uri.toString();

    // الألوان المستوحاة من التصميم المرفق
    final selectedBgColor = Color.fromARGB(
      255,
      232,
      233,
      246,
    ).withValues(alpha: 0.15); // لون خلفية العنصر المحدد
    const textColor = Color(0xFFC0C1C7); // لون النصوص غير المحددة
    const selectedTextColor = Colors.white; // لون النصوص المحددة

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: _isCollapsed ? 80 : 240,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 1, 4, 26),
            Color.fromARGB(255, 9, 13, 41), // Dark at the top
            Color.fromARGB(
              255,
              23,
              71,
              193,
            ), // Subtle blue/indigo tint in the middle
            Color.fromARGB(
              255,
              2,
              7,
              32,
            ), // Subtle blue/indigo tint in the middle
            Color.fromARGB(255, 2, 5, 28), // Very dark at the bottom
          ],
          stops: [0.0, 0.45, 0.5, 0.60, 1.0],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Header (YouTrack Logo) ───────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: _isCollapsed ? AppSpacing.small : AppSpacing.medium,
              vertical: AppSpacing.large,
            ),
            child: Row(
              mainAxisAlignment: _isCollapsed
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                // الشعار (مربع بنفسجي/وردي مع YT)
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE91E63),
                    borderRadius: BorderRadius.circular(8),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFE91E63), Color(0xFF9C27B0)],
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'YT',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                if (!_isCollapsed) ...[
                  const SizedBox(width: AppSpacing.small),
                  const Expanded(
                    child: Text(
                      'YouTrack',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // ── القائمة العلوية ─────────────────────────────────────
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.small),
              children: [
                _buildNavItem(
                  context: context,
                  icon: Icons.check_circle_outline,
                  label: 'Issues',
                  route: AppRouteKeys.issues,
                  currentRoute: currentRoute,
                  textColor: textColor,
                  selectedTextColor: selectedTextColor,
                  selectedBgColor: selectedBgColor,
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.pie_chart_outline,
                  label: 'Dashboards',
                  route: AppRouteKeys.dashboard,
                  currentRoute: currentRoute,
                  textColor: textColor,
                  selectedTextColor: selectedTextColor,
                  selectedBgColor: selectedBgColor,
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.view_kanban_outlined,
                  label: 'Agile Boards',
                  route: AppRouteKeys.agileBoards, // مؤقت حتى يتم تعريفه
                  currentRoute: currentRoute,
                  textColor: textColor,
                  selectedTextColor: selectedTextColor,
                  selectedBgColor: selectedBgColor,
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.show_chart,
                  label: 'Reports',
                  route: AppRouteKeys.reports,
                  currentRoute: currentRoute,
                  textColor: textColor,
                  selectedTextColor: selectedTextColor,
                  selectedBgColor: selectedBgColor,
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.grid_view,
                  label: 'Projects',
                  route: AppRouteKeys.projects,
                  currentRoute: currentRoute,
                  textColor: textColor,
                  selectedTextColor: selectedTextColor,
                  selectedBgColor: selectedBgColor,
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.more_horiz,
                  label: 'More',
                  route: '/more',
                  currentRoute: currentRoute,
                  textColor: textColor,
                  selectedTextColor: selectedTextColor,
                  selectedBgColor: selectedBgColor,
                ),
              ],
            ),
          ),

          // ── القائمة السفلية ─────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.small),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // زر Create المخصص
                Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: AppSpacing.small,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E3139),
                    borderRadius: AppRadius.smallBorderRadius,
                  ),
                  child: InkWell(
                    borderRadius: AppRadius.smallBorderRadius,
                    onTap: () {},
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: _isCollapsed ? 0 : AppSpacing.medium,
                        vertical: AppSpacing.small,
                      ),
                      child: Row(
                        mainAxisAlignment: _isCollapsed
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.start,
                        children: [
                          Icon(Icons.add, size: 20, color: textColor),
                          if (!_isCollapsed) ...[
                            const SizedBox(width: AppSpacing.medium),
                            Expanded(
                              child: Text(
                                'Create',
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 14,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),

                _buildNavItem(
                  context: context,
                  icon: Icons.settings_outlined,
                  label: 'Administration',
                  route: '/admin',
                  currentRoute: currentRoute,
                  textColor: textColor,
                  selectedTextColor: selectedTextColor,
                  selectedBgColor: selectedBgColor,
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.help_outline,
                  label: 'Help',
                  route: '/help',
                  currentRoute: currentRoute,
                  textColor: textColor,
                  selectedTextColor: selectedTextColor,
                  selectedBgColor: selectedBgColor,
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.notifications_outlined,
                  label: 'Notifications',
                  route: '/notifications',
                  currentRoute: currentRoute,
                  textColor: textColor,
                  selectedTextColor: selectedTextColor,
                  selectedBgColor: selectedBgColor,
                  trailing: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.small),

                // الملف الشخصي
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.small,
                    vertical: AppSpacing.small,
                  ),
                  child: Row(
                    mainAxisAlignment: _isCollapsed
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        radius: 14,
                        backgroundColor: Color(0xFF4CAF50),
                        child: Text(
                          'AD',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (!_isCollapsed) ...[
                        const SizedBox(width: AppSpacing.medium),
                        Expanded(
                          child: Text(
                            'admin',
                            style: TextStyle(color: textColor, fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // زر Collapse
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: AppSpacing.medium,
                    top: AppSpacing.small,
                  ),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _isCollapsed = !_isCollapsed;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.small,
                        vertical: AppSpacing.small,
                      ),
                      child: Row(
                        mainAxisAlignment: _isCollapsed
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.start,
                        children: [
                          Icon(
                            _isCollapsed
                                ? Icons.keyboard_double_arrow_right
                                : Icons.keyboard_double_arrow_left,
                            size: 20,
                            color: textColor,
                          ),
                          if (!_isCollapsed) ...[
                            const SizedBox(width: AppSpacing.medium),
                            Expanded(
                              child: Text(
                                'Collapse',
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 14,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String route,
    required String currentRoute,
    required Color textColor,
    required Color selectedTextColor,
    required Color selectedBgColor,
    Widget? trailing,
  }) {
    // التأكد من أن المسار الحالي يتطابق مع العنصر
    final isSelected = currentRoute == route;

    return Material(
      color: Colors.transparent,
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: .circular(4.0)),
        selected: isSelected,
        selectedColor: selectedTextColor,
        selectedTileColor: selectedBgColor,
        hoverColor: textColor.withValues(alpha: 0.10),
        onTap: () => context.go(route),
        leading: _isCollapsed ? null : Icon(icon, size: 22),
        title: _isCollapsed
            ? Icon(icon, size: 22)
            : Text(
                label,
                style: isSelected ? null : TextStyle(color: textColor),
              ),
        dense: true,
        minTileHeight: 40,
        contentPadding: .all(4.0),
      ),
    );
  }
}
