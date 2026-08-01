import 'package:flutter/material.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/features/groups/presentation/pages/groups_page.dart';
import 'package:issues_tracking/features/roles/presentation/pages/roles_page.dart';

class UserProfilePage extends StatefulWidget {
  final String userId;

  const UserProfilePage({super.key, required this.userId});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: .start,
          // labelColor: Colors.white,
          unselectedLabelColor: colors.onSurfaceVariant,
          // indicatorColor: Colors.white,
          indicatorWeight: 2,
          tabs: const [
            Tab(text: 'General'),
            Tab(text: 'Workspace'),
            Tab(text: 'Tags and Saved Searches'),
            Tab(text: 'Notifications'),
            Tab(text: 'Groups'),
            Tab(text: 'Roles'),
            Tab(text: 'Account Security'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 16),
          //   child:
          // ),
          const Divider(height: 1),
          Expanded(
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: [
                _GeneralTab(colors: colors, textTheme: textTheme),
                _WorkspaceTab(colors: colors, textTheme: textTheme),
                // _AIFeaturesTab(colors: colors, textTheme: textTheme),
                _TagsAndSearchesTab(colors: colors, textTheme: textTheme),
                _NotificationsTab(colors: colors, textTheme: textTheme),
                GroupsPage(userId: widget.userId),
                RolesPage(userId: widget.userId),
                //_GroupsTab(colors: colors, textTheme: textTheme),
                // _RolesTab(colors: colors, textTheme: textTheme),
                _AccountSecurityTab(colors: colors, textTheme: textTheme),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {},
        backgroundColor: colors.primary,
        child: const Icon(Icons.help_outline, color: Colors.white),
      ),
    );
  }
}

// ── General Tab ─────────────────────────────────────────────
class _GeneralTab extends StatelessWidget {
  final ColorScheme colors;
  final TextTheme textTheme;

  const _GeneralTab({required this.colors, required this.textTheme});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.large),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildField('Full name', 'admin'),
          const SizedBox(height: AppSpacing.medium),
          _buildField('Username', 'admin'),
          const SizedBox(height: AppSpacing.medium),
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xFF4CAF50),
                child: const Text(
                  'AD',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.medium),
              Text(
                'Avatar',
                style: textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.medium),
          Row(
            children: [
              Expanded(
                child: _buildField('Email', 'osmflutterdeveloper@gmail.com'),
              ),
              const SizedBox(width: 8),
              Icon(Icons.check_circle, color: Colors.green, size: 20),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Test message sent to email')),
                  );
                },
                child: const Text('Send test message'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.medium),
          _buildMultilineField(
            'VCS usernames',
            'admin\nosmflutterdeveloper@gmail.com',
          ),
          const SizedBox(height: 4),
          Text(
            'Adding personal identifiers from integrated version control systems (VCS) lets YouTrack add links to issues referenced in your code commits.',
            style: textTheme.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: AppSpacing.medium),
          _buildDisplayField('Registration date', 'Jul 24, 2026 3:13:15 AM'),
          const SizedBox(height: AppSpacing.medium),
          Row(
            children: [
              Text(
                'Personal data',
                style: textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 16),
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Downloading personal data as CSV...'),
                    ),
                  );
                },
                child: const Text('Download in CSV format'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.medium),
          _buildTimezoneSection(context, colors, textTheme),
        ],
      ),
    );
  }

  Widget _buildField(String label, String value) {
    return Row(
      spacing: 40,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: colors.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          width: 400,
          child: TextField(
            controller: TextEditingController(text: value),
            // decoration: InputDecoration(
            //   isDense: true,
            //   border: OutlineInputBorder(
            //     borderRadius: BorderRadius.circular(6),
            //     borderSide: BorderSide(color: colors.outlineVariant),
            //   ),
            // ),
          ),
        ),
      ],
    );
  }

  Widget _buildMultilineField(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 40,
      children: [
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: colors.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          width: 400,
          child: TextField(
            controller: TextEditingController(text: value),
            maxLines: 3,
          ),
        ),
      ],
    );
  }

  Widget _buildDisplayField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: colors.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: textTheme.bodyMedium?.copyWith(color: colors.onSurface),
        ),
      ],
    );
  }

  Widget _buildTimezoneSection(
    BuildContext context,
    ColorScheme colors,
    TextTheme textTheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Local time zone',
          style: textTheme.bodySmall?.copyWith(
            color: colors.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            DropdownButton<String>(
              value: 'Etc',
              items: const [DropdownMenuItem(value: 'Etc', child: Text('Etc'))],
              onChanged: null,
              underline: const SizedBox(),
            ),
            const SizedBox(width: 8),
            DropdownButton<String>(
              value: 'UTC',
              items: const [DropdownMenuItem(value: 'UTC', child: Text('UTC'))],
              onChanged: null,
              underline: const SizedBox(),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              'UTC/GMT 0 hours',
              style: textTheme.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Time zone guessed: UTC (based on IP address)',
                    ),
                  ),
                );
              },
              child: const Text('Guess time zone'),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Workspace Tab ───────────────────────────────────────────
class _WorkspaceTab extends StatefulWidget {
  final ColorScheme colors;
  final TextTheme textTheme;

  const _WorkspaceTab({required this.colors, required this.textTheme});

  @override
  State<_WorkspaceTab> createState() => _WorkspaceTabState();
}

class _WorkspaceTabState extends State<_WorkspaceTab> {
  String _theme = 'dark';
  String _linksPosition = 'below_description';
  bool _showRecent = true;

  @override
  Widget build(BuildContext context) {
    final colors = widget.colors;
    final textTheme = widget.textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.large),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Theme',
            style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'light', label: Text('Light')),
              ButtonSegment(value: 'dark', label: Text('Dark')),
              ButtonSegment(value: 'sync', label: Text('Sync with OS')),
            ],
            selected: {_theme},
            onSelectionChanged: (value) {
              setState(() => _theme = value.first);
            },
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _ThemeCard(
                color: Colors.grey.shade200,
                isSelected: _theme == 'light',
              ),
              const SizedBox(width: 8),
              _ThemeCard(
                color: const Color(0xFF1E1E20),
                isSelected: _theme == 'dark',
              ),
              const SizedBox(width: 8),
              _ThemeCard(
                color: Colors.grey.shade400,
                isSelected: _theme == 'sync',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.large),
          Text(
            'Links panel position',
            style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(
                value: 'below_summary',
                label: Text('Below the summary'),
              ),
              ButtonSegment(
                value: 'below_description',
                label: Text('Below the description'),
              ),
            ],
            selected: {_linksPosition},
            onSelectionChanged: (value) {
              setState(() => _linksPosition = value.first);
            },
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _PositionCard(isActive: _linksPosition == 'below_summary'),
              const SizedBox(width: 8),
              _PositionCard(isActive: _linksPosition == 'below_description'),
            ],
          ),
          const SizedBox(height: AppSpacing.large),
          Row(
            children: [
              Text(
                'Show recent issues and articles',
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Switch(
                value: _showRecent,
                onChanged: (value) {
                  setState(() => _showRecent = value);
                },
              ),
            ],
          ),
          Text(
            'A panel that lets you navigate to recently viewed content is shown below the header.',
            style: textTheme.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),

          Container(
            height: 40,
            decoration: BoxDecoration(
              color: colors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: List.generate(
                5,
                (i) => Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemeCard extends StatelessWidget {
  final Color color;
  final bool isSelected;

  const _ThemeCard({required this.color, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 70,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: isSelected
            ? Border.all(color: Colors.blue, width: 2)
            : Border.all(color: Colors.grey.shade700),
      ),
    );
  }
}

class _PositionCard extends StatelessWidget {
  final bool isActive;

  const _PositionCard({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFF2E2E32),
        borderRadius: BorderRadius.circular(8),
        border: isActive
            ? Border.all(color: Colors.blue, width: 2)
            : Border.all(color: Colors.grey.shade700),
      ),
    );
  }
}

// ── Tags and Saved Searches Tab ─────────────────────────────
class _TagsAndSearchesTab extends StatelessWidget {
  final ColorScheme colors;
  final TextTheme textTheme;

  const _TagsAndSearchesTab({required this.colors, required this.textTheme});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 360,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.small),
                child: Row(
                  children: [
                    FilledButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('New tag or saved search'),
                            content: const TextField(
                              decoration: InputDecoration(
                                hintText: 'Enter tag name...',
                                isDense: true,
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: const Text('Cancel'),
                              ),
                              FilledButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: const Text('Create'),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('New tag or saved search'),
                      style: FilledButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('No tags selected to delete'),
                          ),
                        );
                      },
                      child: const Text('Delete'),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search tags and searches',
                          isDense: true,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: Icon(
                              Icons.search,
                              size: 18,
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Showing all tags')),
                        );
                      },
                      child: const Text('All'),
                    ),
                    TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Showing tags created by me'),
                          ),
                        );
                      },
                      child: const Text('Created by me'),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.visibility_off, size: 18),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Visibility toggled')),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              _buildTagListHeader(colors, textTheme),
              const Divider(height: 1),
              Expanded(
                child: ListView(
                  children: [
                    _TagItem(
                      icon: Icons.star,
                      iconColor: Colors.orange,
                      name: 'Star',
                      subtitle: 'has: Star',
                      isActive: true,
                    ),
                    _TagItem(
                      icon: Icons.tag,
                      iconColor: Colors.green,
                      name: 'productivity',
                      subtitle: 'tag: productivity',
                    ),
                    _TagItem(
                      icon: Icons.tag,
                      iconColor: Colors.pink,
                      name: 'tip',
                      subtitle: 'tag: tip',
                    ),
                    _TagItem(
                      icon: Icons.star,
                      iconColor: Colors.orange,
                      name: 'Demo project Overview Backlog',
                      subtitle:
                          'project: DEMO has: -{Board Demo project Overview}...',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        VerticalDivider(width: 1),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.medium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tag: Star',
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.medium),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: TextEditingController(text: 'Star'),
                        decoration: const InputDecoration(isDense: true),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.star, color: Colors.orange, size: 24),
                  ],
                ),
                const SizedBox(height: AppSpacing.medium),
                Row(
                  children: [
                    Checkbox(value: false, onChanged: null),
                    const Text('Remove on resolution'),
                    IconButton(
                      icon: const Icon(Icons.help_outline, size: 16),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Remove tag on issue resolution'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(value: true, onChanged: null),
                    const Text('Mark as favorite for all viewers'),
                  ],
                ),
                const SizedBox(height: AppSpacing.medium),
                Text(
                  'Notification events:',
                  style: textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          _NotificationCheckbox(
                            label: 'Issue or article creation',
                            checked: true,
                          ),
                          _NotificationCheckbox(
                            label: 'Issue resolved',
                            checked: true,
                          ),
                          _NotificationCheckbox(label: 'Votes', checked: true),
                          _NotificationCheckbox(
                            label: 'Tag removed',
                            checked: true,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          _NotificationCheckbox(
                            label: 'Issue and article updates',
                            checked: true,
                          ),
                          _NotificationCheckbox(
                            label: 'Issue and article comments',
                            checked: true,
                          ),
                          _NotificationCheckbox(
                            label: 'Tag added',
                            checked: true,
                          ),
                          _NotificationCheckbox(
                            label: 'Spent time',
                            checked: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTagListHeader(ColorScheme colors, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Name',
              style: textTheme.labelMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ),
          Text(
            'Remove on Resolution',
            style: textTheme.labelMedium?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _TagItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String name;
  final String subtitle;
  final bool isActive;

  const _TagItem({
    required this.icon,
    required this.iconColor,
    required this.name,
    required this.subtitle,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? colors.primaryContainer.withValues(alpha: 0.2) : null,
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: iconColor),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 13)),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationCheckbox extends StatefulWidget {
  final String label;
  final bool checked;

  const _NotificationCheckbox({required this.label, required this.checked});

  @override
  State<_NotificationCheckbox> createState() => _NotificationCheckboxState();
}

class _NotificationCheckboxState extends State<_NotificationCheckbox> {
  late bool _checked;

  @override
  void initState() {
    super.initState();
    _checked = widget.checked;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: _checked,
          onChanged: (value) => setState(() => _checked = value!),
          visualDensity: VisualDensity.compact,
        ),
        Expanded(
          child: Text(widget.label, style: const TextStyle(fontSize: 12)),
        ),
      ],
    );
  }
}

// ── Notifications Tab ───────────────────────────────────────
class _NotificationsTab extends StatefulWidget {
  final ColorScheme colors;
  final TextTheme textTheme;

  const _NotificationsTab({required this.colors, required this.textTheme});

  @override
  State<_NotificationsTab> createState() => _NotificationsTabState();
}

class _NotificationsTabState extends State<_NotificationsTab> {
  bool _emailEnabled = true;
  bool _telegramEnabled = true;

  @override
  Widget build(BuildContext context) {
    final textTheme = widget.textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.large),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Send notifications to:',
            style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Checkbox(
                value: _emailEnabled,
                onChanged: (value) => setState(() => _emailEnabled = value!),
              ),
              const Text('Email'),
              const SizedBox(width: 12),
              _ToggleButton(label: 'HTML', isSelected: true),
              const SizedBox(width: 4),
              _ToggleButton(label: 'Plain text', isSelected: false),
            ],
          ),
          Row(
            children: [
              Checkbox(
                value: _telegramEnabled,
                onChanged: (value) => setState(() => _telegramEnabled = value!),
              ),
              const Text('YouTrack bot for Telegram'),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Telegram bot connection page opened'),
                    ),
                  );
                },
                child: const Text('Connect my account'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.large),
          Text(
            'Notification events:',
            style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          ..._notificationEvents.map((e) => _NotificationRow(label: e)),
          const SizedBox(height: AppSpacing.large),
          Text(
            'Star automatically when:',
            style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          ..._starEvents.map((e) => _NotificationRow(label: e, checked: true)),
        ],
      ),
    );
  }
}

const _notificationEvents = [
  'Changes applied by me',
  '@mentions that reference my username',
  'Changes in a duplicate cluster',
  'Issues and comments created from my emails',
  'Updates applied by VCS and build server integrations',
  'Failed commands in commits processed by VCS and build server integrations',
];

const _starEvents = [
  'I post a comment to an issue or article',
  'I create an issue or article',
  'I update an issue or article',
  'I am made responsible for an issue',
  'I vote for an issue',
];

class _NotificationRow extends StatefulWidget {
  final String label;
  final bool checked;

  const _NotificationRow({required this.label, this.checked = false});

  @override
  State<_NotificationRow> createState() => _NotificationRowState();
}

class _NotificationRowState extends State<_NotificationRow> {
  late bool _checked;

  @override
  void initState() {
    super.initState();
    _checked = widget.checked;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: _checked,
          onChanged: (value) => setState(() => _checked = value!),
        ),
        Text(widget.label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}

class _ToggleButton extends StatefulWidget {
  final String label;
  final bool isSelected;

  const _ToggleButton({required this.label, required this.isSelected});

  @override
  State<_ToggleButton> createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<_ToggleButton> {
  late bool _isSelected;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.isSelected;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => setState(() => _isSelected = !_isSelected),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: _isSelected ? colors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: _isSelected ? colors.primary : colors.outlineVariant,
          ),
        ),
        child: Text(
          widget.label,
          style: TextStyle(
            fontSize: 12,
            color: _isSelected ? Colors.white : colors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

// ── Account Security Tab ────────────────────────────────────
class _AccountSecurityTab extends StatelessWidget {
  final ColorScheme colors;
  final TextTheme textTheme;

  const _AccountSecurityTab({required this.colors, required this.textTheme});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.large),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionCard(
            colors: colors,
            textTheme: textTheme,
            title: 'Two-factor Authentication',
            description:
                'Help protect your account from unauthorized access by requiring more than just a password to sign in.',
            children: [
              Row(
                children: [
                  FilledButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Pair with authenticator app started'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.mobile_screen_share, size: 16),
                    label: const Text('Pair with app ...'),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Pair with hardware token started'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.security, size: 16),
                    label: const Text('Pair with hardware token ...'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: colors.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'No 2nd factor',
                      style: TextStyle(color: colors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.medium),
          _SectionCard(
            colors: colors,
            textTheme: textTheme,
            title: 'Credentials',
            children: [
              FilledButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Add credentials form opened'),
                    ),
                  );
                },
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add credentials ...'),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(AppSpacing.medium),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Username: admin | Email: osmflutterdeveloper@gmail.com',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Most recent login: Jul 29, 2026 7:28:33 PM, IP: 134.35.0.110, Browser: Chrome 149.0.0.0, OS: Linux x86_64.',
                      style: TextStyle(
                        fontSize: 11,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            _showConfirmDialog(
                              context,
                              'Change password',
                              'Are you sure you want to change your password?',
                            );
                          },
                          child: const Text('Change password ...'),
                        ),
                        TextButton(
                          onPressed: () {
                            _showConfirmDialog(
                              context,
                              'Revoke refresh token',
                              'This will invalidate all active sessions using this token.',
                            );
                          },
                          child: const Text('Revoke refresh token'),
                        ),
                        TextButton(
                          onPressed: () {
                            _showConfirmDialog(
                              context,
                              'Delete credentials',
                              'This action cannot be undone. All credentials will be permanently removed.',
                            );
                          },
                          child: const Text(
                            'Delete credentials',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.medium),
          _SectionCard(
            colors: colors,
            textTheme: textTheme,
            title: 'Tokens',
            children: [
              Row(
                children: [
                  FilledButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('New token creation form opened'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('New token ...'),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('New password creation form opened'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.vpn_key, size: 16),
                    label: const Text('New password ...'),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Details expanded')),
                      );
                    },
                    icon: const Icon(Icons.unfold_more, size: 16),
                    label: const Text('Details'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 24,
                      color: colors.onSurfaceVariant,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'There are no authentication tokens for your account.',
                      style: TextStyle(color: colors.onSurfaceVariant),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'This page lists authentication tokens that grant access to the service. You can create your own permanent tokens that let you access the application with scripting.',
                      style: TextStyle(
                        fontSize: 11,
                        color: colors.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showConfirmDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('$title confirmed')));
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final ColorScheme colors;
  final TextTheme textTheme;
  final String title;
  final String? description;
  final List<Widget> children;

  const _SectionCard({
    required this.colors,
    required this.textTheme,
    required this.title,
    this.description,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.medium),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          if (description != null) ...[
            const SizedBox(height: 8),
            Text(
              description!,
              style: TextStyle(fontSize: 12, color: colors.onSurfaceVariant),
            ),
          ],
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}
