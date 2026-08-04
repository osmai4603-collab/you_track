import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/entities/issue_data.dart';
import 'package:issues_tracking/core/widgets/animated_content_switcher.dart';
import 'package:issues_tracking/core/widgets/shimmer_loading.dart';
import 'package:issues_tracking/core/widgets/text_hover_widget.dart';
import 'package:issues_tracking/features/issues/data/datasources/issues_remote_data_source.dart';
import 'package:issues_tracking/features/projects/presentation/cubits/project_details_cubit.dart';
import 'package:get_it/get_it.dart';

class ProjectNotificationsSettingsSection extends StatefulWidget {
  const ProjectNotificationsSettingsSection({super.key});

  @override
  State<ProjectNotificationsSettingsSection> createState() =>
      _ProjectNotificationsSettingsSectionState();
}

class TemplateData {
  final String name;
  final String type;
  final bool isExpanded;
  final Color? backgroundColor;
  final List<TemplateData>? children;
  final String? id;

  TemplateData({
    required this.name,
    required this.type,
    required this.isExpanded,
    this.backgroundColor,
    this.children,
    this.id,
  });
}

class _ProjectNotificationsSettingsSectionState
    extends State<ProjectNotificationsSettingsSection> {
  IssueData? _selectedTemplate;
  bool _showDetailsPanel = false;
  bool _isLoadingIssues = false;
  String? _loadedProjectId;
  List<IssueData> _issues = [];

  final List<TemplateData> _templates = [
    TemplateData(
      name: 'Issue Change',
      type: 'category',
      isExpanded: true,
      children: [
        TemplateData(
          name: 'Issue digest',
          type: 'template',
          id: 'issueDigest',
          isExpanded: false,
        ),
      ],
    ),
    TemplateData(
      name: 'Article Change',
      type: 'category',
      isExpanded: true,
      children: [
        TemplateData(
          name: 'article_header.ftl',
          type: 'template',
          id: 'articleHeader',
          isExpanded: false,
        ),
        TemplateData(
          name: 'article_overview_email.ftl',
          type: 'template',
          id: 'articleOverviewEmail',
          isExpanded: false,
        ),
        TemplateData(
          name: 'article_overview_jabber.ftl',
          type: 'template',
          id: 'articleOverviewJabber',
          isExpanded: false,
        ),
      ],
    ),
    TemplateData(
      name: 'Template Components',
      type: 'category',
      isExpanded: true,
      backgroundColor: const Color(0xFFE3F2FD),
      children: [
        TemplateData(
          name: 'email_footer.ftl',
          type: 'template',
          id: 'emailFooter',
          isExpanded: false,
        ),
        TemplateData(
          name: 'notification_header.ftl',
          type: 'template',
          id: 'notificationHeader',
          isExpanded: false,
        ),
        TemplateData(
          name: 'tracking_button.ftl',
          type: 'template',
          id: 'trackingButton',
          isExpanded: false,
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadProjectDetails();
  }

  void _loadProjectDetails() {
    final projectId = context.read<ProjectDetailsCubit>().state.project?.id;
    if (projectId != null) {
      context.read<ProjectDetailsCubit>().loadProject(projectId);
      _loadIssuesForProject(projectId);
    }
  }

  Future<void> _loadIssuesForProject(String projectId) async {
    if (_isLoadingIssues && _loadedProjectId == projectId) {
      return;
    }

    if (!mounted) return;

    setState(() {
      _isLoadingIssues = true;
      _loadedProjectId = projectId;
    });

    try {
      final dataSource = GetIt.instance<IssuesRemoteDataSource>();
      final issues = await dataSource.getProjectIssues(projectId);

      if (!mounted) return;

      setState(() {
        _issues = issues
            .map(
              (issue) => IssueData(
                id: issue.id,
                summary: issue.summary,
                issueKey: issue.issueKey,
              ),
            )
            .toList();
        _selectedTemplate = _issues.isNotEmpty
            ? (_issues.any((issue) => issue.id == _selectedTemplate?.id)
                  ? _issues.firstWhere(
                      (issue) => issue.id == _selectedTemplate!.id,
                    )
                  : _issues.first)
            : null;
        _isLoadingIssues = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _issues = [];
        _selectedTemplate = null;
        _isLoadingIssues = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<ProjectDetailsCubit, ProjectDetailsState>(
      builder: (context, state) {
        final projectId = state.project?.id;
        if (projectId != null && projectId != _loadedProjectId) {
          _loadIssuesForProject(projectId);
        }

        Widget content;
        if (state.status == ProjectDetailsStatus.loading) {
          content = Center(
            key: const ValueKey('project-notifications-loading'),
            child: ShimmerLoading.list(itemCount: 9),
          );
        } else {
          content = Stack(
            key: const ValueKey('project-notifications-loaded'),
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSenderSettingsSection(colors, textTheme),
                    const SizedBox(height: 24),
                    _buildTemplatesToolbar(colors, textTheme),
                    const SizedBox(height: 24),
                    _buildTemplatesTreeTable(colors, textTheme),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
              Positioned(
                bottom: 24,
                right: 24,
                child: FloatingActionButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Help action triggered')),
                    );
                  },
                  backgroundColor: colors.primary,
                  child: const Icon(Icons.lightbulb, color: Colors.white),
                ),
              ),
            ],
          );
        }

        return AnimatedContentSwitcher(child: content);
      },
    );
  }

  Widget _buildSenderSettingsSection(ColorScheme colors, TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 10,
            children: [
              SizedBox(
                width: 120,
                child: Text(
                  'Sender name',
                  style: textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                width: 250,
                child: TextField(
                  decoration: InputDecoration(hintText: 'osmai'),
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.info_outline, size: 16, color: Colors.grey),
            ],
          ),
          Row(
            spacing: 10,
            children: [
              SizedBox(
                width: 120,
                child: Text(
                  'Reply-To address',
                  style: textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                width: 250,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'osmflutterdeveloper@gmail.com',
                  ),
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.info_outline, size: 16, color: Colors.grey),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTemplatesToolbar(ColorScheme colors, TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: .centerStart,
            child: Text(
              'Notification templates',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            spacing: 10,
            children: [
              Text(
                'Issue selected for preview:',
                style: textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ),
              SizedBox(
                width: 180,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<IssueData>(
                    menuWidth: 180,
                    value: _getSelectedIssue(),
                    isDense: true,
                    hint: TextHoverWidget(
                      text: 'no selected',
                      style: const TextStyle(fontSize: 14),
                      styleHover: TextStyle(
                        fontSize: 14,
                        color: colors.secondary,
                      ),
                    ),
                    onChanged: (IssueData? newValue) {
                      setState(() {
                        _selectedTemplate = newValue;
                      });
                    },
                    items: _issues.map((IssueData issue) {
                      return DropdownMenuItem<IssueData>(
                        value: issue,
                        child: Text(
                          issue.issueKey.isNotEmpty
                              ? issue.issueKey
                              : issue.summary,
                          style: const TextStyle(fontSize: 14),
                        ),
                      );
                    }).toList(),
                    alignment: .bottomCenter,
                    selectedItemBuilder: (context) => _issues.map((issue) {
                      return Align(
                        child: Text(
                          issue.issueKey.isNotEmpty
                              ? issue.issueKey
                              : issue.summary,
                          style: const TextStyle(fontSize: 14),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const SizedBox(height: 16),
          Row(
            spacing: 12,
            mainAxisAlignment: .spaceBetween,
            children: [
              OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('All templates reset to global'),
                    ),
                  );
                },
                child: const Text('Reset all to global'),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _showDetailsPanel = !_showDetailsPanel;
                  });
                },
                icon: const Icon(Icons.visibility, size: 18),
                label: const Text('< Show details'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IssueData? _getSelectedIssue() {
    if (_selectedTemplate != null &&
        _issues.any((issue) => issue.id == _selectedTemplate!.id)) {
      return _issues.firstWhere((issue) => issue.id == _selectedTemplate!.id);
    }

    if (_issues.isNotEmpty) {
      return _issues.first;
    }

    return null;
  }

  Widget _buildTemplatesTreeTable(ColorScheme colors, TextTheme textTheme) {
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.surfaceContainerHighest,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
              border: Border.all(color: colors.outlineVariant),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Name',
                    style: textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    'Send notification when... / Description',
                    style: textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Reference ID for workflows',
                    style: textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ..._buildTemplateTree(colors, textTheme),
        ],
      ),
    );
  }

  List<Widget> _buildTemplateTree(ColorScheme colors, TextTheme textTheme) {
    List<Widget> widgets = [];

    for (final template in _templates) {
      if (template.type == 'category') {
        widgets.add(_buildCategoryItem(template, colors, textTheme));
      } else {
        widgets.add(_buildTemplateItem(template, colors, textTheme));
      }
    }

    return widgets;
  }

  Widget _buildCategoryItem(
    TemplateData category,
    ColorScheme colors,
    TextTheme textTheme,
  ) {
    final isExpanded = category.isExpanded;
    final backgroundColor = category.backgroundColor ?? colors.surface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          color: backgroundColor,
          child: Row(
            children: [
              Icon(
                isExpanded ? Icons.expand_more : Icons.chevron_right,
                size: 20,
                color: colors.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Text(
                category.name,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        if (isExpanded) ...[
          for (final child in category.children ?? []) ...[
            _buildCategoryItem(
              TemplateData(
                name: child.name,
                type: child.type,
                isExpanded: false,
              ),
              colors,
              textTheme,
            ),
          ],
        ],
      ],
    );
  }

  Widget _buildTemplateItem(
    TemplateData template,
    ColorScheme colors,
    TextTheme textTheme,
  ) {
    final backgroundColor = _getTemplateBackgroundColor(template.name);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(bottom: BorderSide(color: colors.outlineVariant)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                const Icon(
                  Icons.insert_drive_file,
                  size: 16,
                  color: Colors.grey,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(template.name, style: textTheme.bodyMedium),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              _getTemplateDescription(template.name),
              style: textTheme.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              _getTemplateReferenceId(template.id),
              style: textTheme.bodySmall?.copyWith(color: colors.primary),
            ),
          ),
        ],
      ),
    );
  }

  String _getTemplateReferenceId(String? id) {
    if (id == null) return 'N/A';
    final referenceIds = {
      'issueDigest': 'issueDigest',
      'articleHeader': 'articleDigest',
      'articleOverviewEmail': 'articleDigest',
      'articleOverviewJabber': 'articleDigest',
      'emailFooter': 'clusterDigest',
      'notificationHeader': 'clusterDigest',
      'trackingButton': 'clusterDigest',
    };
    return referenceIds[id] ?? 'N/A';
  }

  String _getTemplateDescription(String name) {
    final descriptions = {
      'Issue digest':
          'Send notification when an issue changes status or comment.',
      'article_header.ftl': 'Header for article notifications.',
      'article_overview_email.ftl': 'Email overview for article changes.',
      'article_overview_jabber.ftl': 'Jabber overview for article changes.',
      'email_footer.ftl': 'Footer for all email notifications.',
      'notification_header.ftl': 'Header for all notifications.',
      'tracking_button.ftl': 'Button to track issues from notifications.',
    };
    return descriptions[name] ?? 'Template description not available.';
  }

  Color _getTemplateBackgroundColor(String name) {
    if (name.startsWith('article_') || name.startsWith('notification_')) {
      return const Color(0xFFE3F2FD);
    }
    return Colors.white;
  }
}
