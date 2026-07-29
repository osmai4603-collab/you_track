import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:issues_tracking/core/constants/app_route_keys.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/core/constants/app_radius.dart';
import 'package:issues_tracking/core/widgets/user_icon_widget.dart';

class YouTrackSidebar extends StatefulWidget {
  const YouTrackSidebar({super.key});

  @override
  State<YouTrackSidebar> createState() => _YouTrackSidebarState();
}

class _YouTrackSidebarState extends State<YouTrackSidebar> {
  bool _isCollapsed = false;
  final MenuController _adminMenuController = MenuController();
  final MenuController _moreOptionController = MenuController();
  final MenuController _helpController = MenuController();
  final MenuController _createController = MenuController();

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
      width: _isCollapsed ? 80 : 200,
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

                _buildMoreOptionsWidget(
                  context,
                  currentRoute,
                  selectedTextColor,
                  selectedBgColor,
                  textColor,
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
                _buildCreateMore(
                  currentRoute,
                  selectedTextColor,
                  selectedBgColor,
                  textColor,
                ),

                _buildAdministration(
                  context,
                  currentRoute,
                  textColor,
                  selectedTextColor,
                  selectedBgColor,
                ),
                _buildHelpMenuWidget(
                  context,
                  textColor,
                  selectedBgColor,
                  selectedTextColor,
                ),
                _buildNotificationWidget(
                  context,
                  currentRoute,
                  textColor,
                  selectedTextColor,
                  selectedBgColor,
                ),
                const SizedBox(height: AppSpacing.small),

                // الملف الشخصي
                _buildAdminWidget(textColor),

                // زر Collapse
                _buildCollapsedWidget(textColor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  MenuAnchor _buildAdministration(
    BuildContext context,
    String currentRoute,
    Color textColor,
    Color selectedTextColor,
    Color selectedBgColor,
  ) {
    return MenuAnchor(
      controller: _adminMenuController,
      alignmentOffset: Offset(_isCollapsed ? 80 : 200, -40),
      menuChildren: _buildAdminMenu(context),
      style: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.blueGrey.shade900),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: AppRadius.smallBorderRadius),
        ),
      ),
      builder: (context, controller, child) {
        return _buildNavItem(
          context: context,
          icon: Icons.settings_outlined,
          label: 'Administration',
          route: '',
          currentRoute: currentRoute,
          textColor: textColor,
          selectedTextColor: selectedTextColor,
          selectedBgColor: selectedBgColor,
          onTap: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
        );
      },
    );
  }

  MenuAnchor _buildMoreOptionsWidget(
    BuildContext context,
    String currentRoute,
    Color selectedTextColor,
    Color selectedBgColor,
    Color textColor,
  ) {
    return MenuAnchor(
      controller: _moreOptionController,
      alignmentOffset: Offset(_isCollapsed ? 80 : 200, -40),
      menuChildren: [
        _menuItem(
          icon: Icons.grid_4x4_rounded,
          currentRoute: currentRoute,
          selectedTextColor: selectedTextColor,
          textColor: textColor,
          selectedBgColor: selectedBgColor,
          route: AppRouteKeys.knowldgeBase,
          label: 'Knowldge Base',
        ),
        _menuItem(
          icon: Icons.schedule_send_outlined,
          currentRoute: currentRoute,
          selectedTextColor: selectedTextColor,
          textColor: textColor,
          selectedBgColor: selectedBgColor,
          route: AppRouteKeys.timeSheets,
          label: 'Time Sheet',
        ),
        _menuItem(
          icon: Icons.chat_rounded,
          currentRoute: currentRoute,
          selectedTextColor: selectedTextColor,
          textColor: textColor,
          selectedBgColor: selectedBgColor,
          route: AppRouteKeys.ganttChart,
          label: 'Gantt Chart',
        ),
        _menuItem(
          icon: Icons.grid_view,
          label: 'White Boards',
          route: AppRouteKeys.whiteBoards,
          currentRoute: currentRoute,
          textColor: textColor,
          selectedTextColor: selectedTextColor,
          selectedBgColor: selectedBgColor,
        ),
      ],
      style: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(const Color(0xFF2E3139)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: AppRadius.smallBorderRadius),
        ),
      ),
      builder: (context, controller, child) {
        return _buildNavItem(
          context: context,
          icon: Icons.more_horiz_rounded,
          label: 'More',
          route: '/admin',
          currentRoute: currentRoute,
          textColor: textColor,
          selectedTextColor: selectedTextColor,
          selectedBgColor: selectedBgColor,
          onTap: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
        );
      },
    );
  }

  MenuAnchor _buildCreateMore(
    String currentRoute,
    Color selectedTextColor,
    Color selectedBgColor,
    Color textColor,
  ) {
    return MenuAnchor(
      controller: _createController,
      alignmentOffset: Offset(_isCollapsed ? 80 : 200, -40),
      menuChildren: [
        _menuItem(
          currentRoute: currentRoute,
          selectedTextColor: selectedTextColor,
          textColor: textColor,
          selectedBgColor: selectedBgColor,
          route: AppRouteKeys.createIssue,
          label: 'New Issue',
          icon: Icons.task_rounded,
          onTap: () {},
        ),

        _menuItem(
          currentRoute: currentRoute,
          selectedTextColor: selectedTextColor,
          textColor: textColor,
          selectedBgColor: selectedBgColor,
          route: AppRouteKeys.createIssue,
          label: 'New Article',
          icon: Icons.article_rounded,
          onTap: () {},
        ),
      ],
      style: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(const Color(0xFF2E3139)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: AppRadius.smallBorderRadius),
        ),
      ),
      builder: (context, controller, child) {
        return _menuItem(
          currentRoute: currentRoute,
          selectedTextColor: selectedTextColor,
          textColor: textColor,
          selectedBgColor: selectedBgColor,
          backColor: Colors.grey.shade800,
          route: '',
          canCollapse: _isCollapsed,
          label: _isCollapsed ? '' : 'Create',
          icon: Icons.add_rounded,
          iconSize: 22,
          onTap: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
        );
      },
    );
  }

  Padding _buildCollapsedWidget(Color textColor) {
    return Padding(
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
                    style: TextStyle(color: textColor, fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Padding _buildAdminWidget(Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.small,
        vertical: AppSpacing.small,
      ),
      child: Row(
        mainAxisAlignment: _isCollapsed
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: [
          UserIconWidget(),
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
    );
  }

  Widget _buildNotificationWidget(
    BuildContext context,
    String currentRoute,
    Color textColor,
    Color selectedTextColor,
    Color selectedBgColor,
  ) {
    return _buildNavItem(
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
    );
  }

  MenuAnchor _buildHelpMenuWidget(
    BuildContext context,
    Color textColor,
    Color selectedBgColor,
    Color selectedTextColor,
  ) {
    return MenuAnchor(
      alignmentOffset: Offset(_isCollapsed ? 80 : 200, -40),
      menuChildren: _buildHelpMenu(context),
      style: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(const Color(0xFF2E3139)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: AppRadius.smallBorderRadius),
        ),
      ),
      controller: _helpController,
      builder: (_, controller, child) {
        return _menuItem(
          icon: Icons.help_rounded,
          currentRoute: '',
          textColor: textColor,
          canCollapse: _isCollapsed,
          selectedBgColor: Colors.transparent,
          selectedTextColor: selectedTextColor,
          route: '',
          backColor: Colors.transparent,
          iconSize: 22,
          label: 'Help',
          onTap: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          
        );
      },
    );
  }

  Widget _menuItem({
    required String currentRoute,
    required Color selectedTextColor,
    required Color textColor,
    required Color selectedBgColor,
    required String route,
    required String label,
    required IconData icon,
    void Function()? onTap,
    bool canCollapse = false,
    double iconSize = 16,
    Color? backColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        tileColor: backColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        selected: currentRoute == route,
        selectedColor: selectedTextColor,
        selectedTileColor: selectedBgColor,
        hoverColor: textColor.withValues(alpha: 0.10),
        onTap: onTap ?? () => context.go(route),
        leading: canCollapse
            ? null
            : Icon(icon, color: textColor, size: iconSize),
        title: canCollapse
            ? Icon(icon, color: textColor, size: iconSize)
            : Text(label, style: TextStyle(color: textColor)),
        minTileHeight: 40,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
      ),
    );
  }

  List<Widget> _buildAdminMenu(BuildContext context) {
    const textColor = Color(0xFFC0C1C7);
    final itemStyle = ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(textColor),

      overlayColor: WidgetStatePropertyAll(Colors.white.withValues(alpha: 0.1)),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: AppRadius.smallBorderRadius),
      ),
    );
    return [
      MenuItemButton(
        style: itemStyle,
        onPressed: () {},
        child: const Text('Custom Fields'),
      ),
      MenuItemButton(
        style: itemStyle,
        onPressed: () {},
        child: const Text('Link Types'),
      ),
      MenuItemButton(
        style: itemStyle,
        onPressed: () {},
        child: const Text('Time Tracking'),
      ),
      MenuItemButton(
        style: itemStyle,
        onPressed: () {},
        child: const Text('Workflows'),
      ),
      MenuItemButton(
        style: itemStyle,
        onPressed: () {},
        child: const Text('Apps'),
      ),
      const Divider(color: Colors.white24, height: 1),
      SubmenuButton(
        style: itemStyle,
        menuStyle: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(const Color(0xFF2E3139)),
        ),
        menuChildren: [
          MenuItemButton(
            style: itemStyle,
            onPressed: () {},
            child: const Text('Users'),
          ),
          MenuItemButton(
            style: itemStyle,
            onPressed: () {},
            child: const Text('Organizations'),
          ),
          MenuItemButton(
            style: itemStyle,
            onPressed: () {},
            child: const Text('Groups'),
          ),
          MenuItemButton(
            style: itemStyle,
            onPressed: () {},
            child: const Text('Roles'),
          ),
          MenuItemButton(
            style: itemStyle,
            onPressed: () {},
            child: const Text('Auth Modules'),
          ),
          MenuItemButton(
            style: itemStyle,
            onPressed: () {},
            child: const Text('SAML 2.0'),
          ),
          MenuItemButton(
            style: itemStyle,
            onPressed: () {},
            child: const Text('OAuth Clients'),
          ),
        ],
        child: const Text('Access Management'),
      ),
      SubmenuButton(
        style: itemStyle,
        menuStyle: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(const Color(0xFF2E3139)),
        ),
        menuChildren: [
          MenuItemButton(
            style: itemStyle,
            onPressed: () {},
            child: const Text('imports'),
          ),
          MenuItemButton(
            style: itemStyle,
            onPressed: () {},
            child: const Text('Mailbox integrations'),
          ),
          MenuItemButton(
            style: itemStyle,
            onPressed: () {},
            child: const Text('Build server integrations'),
          ),
          MenuItemButton(
            style: itemStyle,
            onPressed: () {},
            child: const Text('VCS Integration'),
          ),
          MenuItemButton(
            style: itemStyle,
            onPressed: () {},
            child: const Text('Zendesk Integration'),
          ),
          MenuItemButton(
            style: itemStyle,
            onPressed: () {},
            child: const Text('Jetbrains AI'),
          ),
        ],
        child: const Text('Integrations'),
      ),
      SubmenuButton(
        style: itemStyle,
        menuStyle: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(const Color(0xFF2E3139)),
        ),
        menuChildren: [
          MenuItemButton(
            style: itemStyle,
            onPressed: () {},
            child: const Text('Global Settings'),
          ),
          MenuItemButton(
            style: itemStyle,
            onPressed: () {},
            child: const Text('user Agreement'),
          ),
          MenuItemButton(
            style: itemStyle,
            onPressed: () {},
            child: const Text('Database Export'),
          ),
          MenuItemButton(
            style: itemStyle,
            onPressed: () {},
            child: const Text('SSL Certificates'),
          ),
          MenuItemButton(
            style: itemStyle,
            onPressed: () {},
            child: const Text('SSL Keys'),
          ),
          MenuItemButton(
            style: itemStyle,
            onPressed: () {},
            child: const Text('Audit Events'),
          ),
        ],
        child: const Text('Server Settings'),
      ),
    ];
  }

  List<Widget> _buildHelpMenu(BuildContext context) {
    const textColor = Color(0xFFC0C1C7);
    final itemStyle = ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(textColor),

      overlayColor: WidgetStatePropertyAll(Colors.white.withValues(alpha: 0.1)),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: AppRadius.smallBorderRadius),
      ),
    );
    return [
      MenuItemButton(
        style: itemStyle,
        onPressed: () {},
        child: const Text('Feedback'),
      ),
      MenuItemButton(
        style: itemStyle,
        onPressed: () {},
        child: const Text('Markdown Reference'),
      ),
      MenuItemButton(
        style: itemStyle,
        onPressed: () {},
        child: const Text('FAQ'),
      ),
      MenuItemButton(
        style: itemStyle,
        onPressed: () {},
        child: const Text('Documentation'),
      ),
      MenuItemButton(
        style: itemStyle,
        onPressed: () {},
        child: const Text('Video Demos'),
      ),
      MenuItemButton(
        style: itemStyle,
        onPressed: () {},
        child: const Text('Service Status'),
      ),
      MenuItemButton(
        style: itemStyle,
        onPressed: () {},
        child: const Text('Maintainance Calendar'),
      ),
      MenuItemButton(
        style: itemStyle,
        onPressed: () {},
        child: const Text('Support'),
      ),
      MenuItemButton(
        style: itemStyle,
        onPressed: () {},
        child: const Text('About YoutTrack'),
      ),
      const Divider(color: Colors.white24, height: 1),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Text(
          'YouTrack — powerful project management\nfor all your teams by JetBrains\nBuild 2026.2.17765\nWednesday, July 15, 2026',
          style: TextTheme.of(context).bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.surfaceContainerHigh,
          ),
        ),
      ),
    ];
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
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    // التأكد من أن المسار الحالي يتطابق مع العنصر
    final isSelected = currentRoute == route;

    return Material(
      color: Colors.transparent,
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        selected: isSelected,
        selectedColor: selectedTextColor,
        selectedTileColor: selectedBgColor,
        hoverColor: textColor.withValues(alpha: 0.10),
        onTap: onTap ?? () => context.go(route),
        leading: _isCollapsed ? null : Icon(icon, size: 22),
        title: _isCollapsed
            ? Icon(icon, size: 22, color: textColor)
            : Text(
                label,
                style: isSelected
                    ? null
                    : TextStyle(color: textColor, fontSize: 15),
              ),
        dense: true,
        minTileHeight: 40,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
      ),
    );
  }
}
