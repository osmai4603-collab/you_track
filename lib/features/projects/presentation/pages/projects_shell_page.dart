import 'package:flutter/material.dart';
import 'package:issues_tracking/features/projects/presentation/widgets/projects_breadcrumb_header.dart';

class ProjectsShellScope extends InheritedWidget {
  final ProjectsShellState shellState;

  const ProjectsShellScope({
    super.key,
    required this.shellState,
    required super.child,
  });

  static ProjectsShellState of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<ProjectsShellScope>();
    assert(scope != null, 'ProjectsShellScope not found');
    return scope!.shellState;
  }

  @override
  bool updateShouldNotify(ProjectsShellScope oldWidget) => false;
}

class ProjectsShellPage extends StatefulWidget {
  final Widget child;

  const ProjectsShellPage({super.key, required this.child});

  @override
  State<ProjectsShellPage> createState() => ProjectsShellState();
}

class ProjectsShellState extends State<ProjectsShellPage> {
  List<BreadcrumbItem> _breadcrumbs = [];
  Widget? _trailing;

  void updateHeader({
    required List<BreadcrumbItem> breadcrumbs,
    Widget? trailing,
  }) {
    if (!mounted) return;
    setState(() {
      _breadcrumbs = breadcrumbs;
      _trailing = trailing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ProjectsShellScope(
      shellState: this,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProjectsBreadcrumbHeader(
            breadcrumbs: _breadcrumbs,
            trailing: _trailing,
          ),
          Expanded(child: widget.child),
        ],
      ),
    );
  }
}

class ProjectsHeader extends StatefulWidget {
  final List<BreadcrumbItem> breadcrumbs;
  final Widget? trailing;

  const ProjectsHeader({
    super.key,
    required this.breadcrumbs,
    this.trailing,
  });

  @override
  State<ProjectsHeader> createState() => _ProjectsHeaderState();
}

class _ProjectsHeaderState extends State<ProjectsHeader> {
  List<BreadcrumbItem>? _lastBreadcrumbs;
  Widget? _lastTrailing;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scheduleUpdateIfNeeded();
  }

  @override
  void didUpdateWidget(ProjectsHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    _scheduleUpdateIfNeeded();
  }

  void _scheduleUpdateIfNeeded() {
    if (!mounted) return;
    final sameBreadcrumbs = _listEquals(_lastBreadcrumbs, widget.breadcrumbs);
    final sameTrailing = _lastTrailing == widget.trailing;
    if (sameBreadcrumbs && sameTrailing) return;

    _lastBreadcrumbs = List.from(widget.breadcrumbs);
    _lastTrailing = widget.trailing;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final shell = ProjectsShellScope.of(context);
      shell.updateHeader(
        breadcrumbs: widget.breadcrumbs,
        trailing: widget.trailing,
      );
    });
  }

  bool _listEquals(List<BreadcrumbItem>? a, List<BreadcrumbItem>? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i].title != b[i].title || a[i].onTap != b[i].onTap) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
