import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/core/init_dependencies.dart';
import 'package:issues_tracking/core/localization/app_localizations.dart';
import 'package:issues_tracking/features/app/presentation/cubit/app_cubit.dart';
import 'package:issues_tracking/features/groups/presentation/pages/groups_page.dart';
import 'package:issues_tracking/features/issues/domain/entities/tag.dart';
import 'package:issues_tracking/features/roles/presentation/pages/roles_page.dart';
import 'package:issues_tracking/features/users/domain/entities/saved_search_entity.dart';
import 'package:issues_tracking/features/users/domain/usecases/user_session.dart';
import 'package:issues_tracking/features/users/presentation/bloc/cubits/account_security_cubit.dart';
import 'package:issues_tracking/features/users/presentation/bloc/cubits/notification_settings_cubit.dart';
import 'package:issues_tracking/features/users/presentation/bloc/cubits/user_preferences_cubit.dart';
import 'package:issues_tracking/features/users/presentation/bloc/cubits/user_profile_cubit.dart';
import 'package:issues_tracking/features/users/presentation/bloc/cubits/user_tags_cubit.dart';

class UserProfilePage extends StatelessWidget {
  final String userId;

  const UserProfilePage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => get_it<UserProfileCubit>()..loadUser(userId),
        ),
        BlocProvider(
          create: (_) => get_it<UserPreferencesCubit>()..loadPreferences(userId),
        ),
        BlocProvider(
          create: (_) => get_it<NotificationSettingsCubit>()..loadSettings(userId),
        ),
        BlocProvider(
          create: (_) => get_it<UserTagsCubit>()..loadData(userId),
        ),
        BlocProvider(create: (_) => get_it<AccountSecurityCubit>()),
      ],
      child: _UserProfileView(userId: userId),
    );
  }
}

class _UserProfileView extends StatefulWidget {
  final String userId;

  const _UserProfileView({required this.userId});

  @override
  State<_UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<_UserProfileView>
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
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          unselectedLabelColor: colors.onSurfaceVariant,
          indicatorWeight: 2,
          tabs: [
            Tab(text: localization.userProfileGeneral),
            Tab(text: localization.userProfileWorkspace),
            Tab(text: localization.userProfileTagsAndSearches),
            Tab(text: localization.userProfileNotifications),
            const Tab(text: 'Groups'),
            const Tab(text: 'Roles'),
            Tab(text: localization.userProfileAccountSecurity),
          ],
        ),
      ),
      body: Column(
        children: [
          const Divider(height: 1),
          Expanded(
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: [
                const _GeneralTab(),
                const _WorkspaceTab(),
                const _TagsAndSearchesTab(),
                const _NotificationsTab(),
                GroupsPage(userId: widget.userId),
                RolesPage(userId: widget.userId),
                const _AccountSecurityTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── General Tab ─────────────────────────────────────────────
class _GeneralTab extends StatelessWidget {
  const _GeneralTab();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final localization = AppLocalizations.of(context)!;
    final cubit = context.read<UserProfileCubit>();

    return BlocBuilder<UserProfileCubit, UserProfileState>(
      builder: (context, state) {
        if (state.status == UserProfileStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = state.user;
        if (user == null) {
          return Center(
            child: Text(
              state.errorMessage != null
                  ? localization.profileLoadError(state.errorMessage!)
                  : localization.profileLoadError(''),
              style: TextStyle(color: colors.error),
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.large),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    localization.fullName,
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.large + AppSpacing.medium),
                  SizedBox(
                    width: 400,
                    child: TextField(
                      controller: cubit.fullNameController,
                      onChanged: (_) => cubit.markAsChanged(),
                      decoration: const InputDecoration(isDense: true),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.medium),
              Row(
                children: [
                  Text(
                    localization.username,
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.large + AppSpacing.medium),
                  SizedBox(
                    width: 400,
                    child: TextField(
                      controller: cubit.usernameController,
                      onChanged: (_) => cubit.markAsChanged(),
                      decoration: const InputDecoration(isDense: true),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.medium),
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: colors.primaryContainer,
                    foregroundImage: user.avatarUrl != null &&
                            user.avatarUrl!.isNotEmpty
                        ? NetworkImage(user.avatarUrl!)
                        : null,
                    child: Text(
                      user.initials.isNotEmpty
                          ? user.initials
                          : user.userKey,
                      style: TextStyle(
                        color: colors.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.medium),
                  Text(
                    localization.avatar,
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
                    child: Row(
                      children: [
                        Text(
                          localization.email,
                          style: textTheme.bodySmall?.copyWith(
                            color: colors.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.large),
                        Expanded(
                          child: TextField(
                            controller: cubit.emailController,
                            onChanged: (_) => cubit.markAsChanged(),
                            decoration: const InputDecoration(isDense: true),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.small),
                  Icon(Icons.check_circle, color: colors.primary, size: 20),
                  const SizedBox(width: AppSpacing.small),
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(localization.testMessageSent)),
                      );
                    },
                    child: Text(localization.sendTestMessage),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.medium),
              Row(
                children: [
                  Text(
                    localization.vcsUsernames,
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.large + AppSpacing.medium),
                  SizedBox(
                    width: 400,
                    child: TextField(
                      controller: cubit.vcsUsernamesController,
                      maxLines: 3,
                      decoration: const InputDecoration(isDense: true),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.extraSmall),
              Text(
                localization.vcsUsernamesHint,
                style: textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: AppSpacing.medium),
              Text(
                localization.registrationDate,
                style: textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: AppSpacing.extraSmall),
              Text(
                user.createdAt != null
                    ? DateFormat('MMM d, y h:mm:ss a').format(user.createdAt!)
                    : '—',
                style: textTheme.bodyMedium?.copyWith(color: colors.onSurface),
              ),
              const SizedBox(height: AppSpacing.medium),
              Row(
                children: [
                  Text(
                    localization.personalData,
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.medium),
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(localization.downloadCsvStarted)),
                      );
                    },
                    child: Text(localization.downloadCsv),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.medium),
              _buildTimezoneSection(context, colors, textTheme, localization),
              const SizedBox(height: AppSpacing.large),
              Row(
                children: [
                  FilledButton.icon(
                    onPressed: state.hasUnsavedChanges
                        ? () async {
                            await cubit.saveChanges();
                            if (!context.mounted) return;
                            if (cubit.state.status == UserProfileStatus.saved) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    localization.changesSavedSuccess,
                                  ),
                                ),
                              );
                              cubit.clearSavedStatus();
                            } else if (cubit.state.status ==
                                UserProfileStatus.error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    cubit.state.errorMessage ??
                                        localization.profileLoadError(''),
                                  ),
                                ),
                              );
                            }
                          }
                        : null,
                    icon: const Icon(Icons.save, size: 16),
                    label: Text(localization.saveChanges),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimezoneSection(
    BuildContext context,
    ColorScheme colors,
    TextTheme textTheme,
    AppLocalizations localization,
  ) {
    final cubit = context.read<UserProfileCubit>();
    final region = _regionForZone(cubit.timezone);
    final zones = _tzZones[region] ?? const ['UTC'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localization.localTimezone,
          style: textTheme.bodySmall?.copyWith(
            color: colors.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppSpacing.small),
        Row(
          children: [
            DropdownButton<String>(
              value: zones.contains(cubit.timezone) ? region : _tzRegions.first,
              items: _tzRegions
                  .map(
                    (r) => DropdownMenuItem(value: r, child: Text(r)),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  final firstZone = (_tzZones[value] ?? const ['UTC']).first;
                  cubit.setTimezone(firstZone);
                  cubit.markAsChanged();
                }
              },
              underline: const SizedBox(),
            ),
            const SizedBox(width: AppSpacing.small),
            DropdownButton<String>(
              value: zones.contains(cubit.timezone) ? cubit.timezone : zones.first,
              items: zones
                  .map((z) => DropdownMenuItem(value: z, child: Text(z)))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  cubit.setTimezone(value);
                  cubit.markAsChanged();
                }
              },
              underline: const SizedBox(),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.extraSmall),
        Row(
          children: [
            Text(
              'UTC/GMT ${DateTime.now().timeZoneOffset.inHours >= 0 ? '+' : ''}${DateTime.now().timeZoneOffset.inHours} hours',
              style: textTheme.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: AppSpacing.small),
            TextButton(
              onPressed: () {
                final zone = DateTime.now().timeZoneName;
                cubit.setTimezone(zone == 'GMT' ? 'UTC' : zone);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      localization.timezoneGuessed(cubit.timezone),
                    ),
                  ),
                );
              },
              child: Text(localization.guessTimezone),
            ),
          ],
        ),
      ],
    );
  }
}

const _tzRegions = [
  'UTC',
  'Etc',
  'Africa',
  'America',
  'Asia',
  'Australia',
  'Europe',
  'Pacific',
];

const _tzZones = <String, List<String>>{
  'UTC': ['UTC'],
  'Etc': ['Etc/UTC', 'Etc/GMT', 'Etc/GMT+1', 'Etc/GMT-1', 'Etc/GMT+2', 'Etc/GMT-2'],
  'Africa': [
    'Africa/Cairo',
    'Africa/Casablanca',
    'Africa/Johannesburg',
    'Africa/Lagos',
    'Africa/Nairobi',
  ],
  'America': [
    'America/New_York',
    'America/Chicago',
    'America/Denver',
    'America/Los_Angeles',
    'America/Sao_Paulo',
    'America/Mexico_City',
    'America/Toronto',
  ],
  'Asia': [
    'Asia/Amman',
    'Asia/Baghdad',
    'Asia/Beirut',
    'Asia/Dubai',
    'Asia/Jerusalem',
    'Asia/Karachi',
    'Asia/Kolkata',
    'Asia/Riyadh',
    'Asia/Tokyo',
    'Asia/Shanghai',
  ],
  'Australia': [
    'Australia/Perth',
    'Australia/Darwin',
    'Australia/Brisbane',
    'Australia/Adelaide',
    'Australia/Sydney',
  ],
  'Europe': [
    'Europe/Amsterdam',
    'Europe/Berlin',
    'Europe/Istanbul',
    'Europe/London',
    'Europe/Madrid',
    'Europe/Moscow',
    'Europe/Paris',
    'Europe/Rome',
  ],
  'Pacific': ['Pacific/Auckland', 'Pacific/Honolulu', 'Pacific/Guam'],
};

String _regionForZone(String zone) {
  if (zone == 'UTC') return 'UTC';
  if (zone.startsWith('Etc/')) return 'Etc';
  final parts = zone.split('/');
  return parts.length > 1 ? parts.first : 'UTC';
}

// ── Workspace Tab ───────────────────────────────────────────
class _WorkspaceTab extends StatelessWidget {
  const _WorkspaceTab();

  ThemeMode _mapTheme(String theme) {
    switch (theme) {
      case 'light':
        return ThemeMode.light;
      case 'sync':
        return ThemeMode.system;
      default:
        return ThemeMode.dark;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final localization = AppLocalizations.of(context)!;
    final cubit = context.read<UserPreferencesCubit>();

    return BlocBuilder<UserPreferencesCubit, UserPreferencesState>(
      builder: (context, state) {
        if (state.status == PreferencesStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        final prefs = state.preferences;
        final theme = prefs?.theme ?? 'dark';
        final linksPosition = prefs?.linksPanelPosition ?? 'below_description';
        final showRecent = prefs?.showRecentIssues ?? true;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.large),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localization.theme,
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.medium),
              SegmentedButton<String>(
                segments: [
                  ButtonSegment(
                    value: 'light',
                    label: Text(localization.themeLight),
                  ),
                  ButtonSegment(
                    value: 'dark',
                    label: Text(localization.themeDark),
                  ),
                  ButtonSegment(
                    value: 'sync',
                    label: Text(localization.themeSyncOs),
                  ),
                ],
                selected: {theme},
                onSelectionChanged: (value) {
                  final newTheme = value.first;
                  cubit.updateTheme(newTheme);
                  context.read<AppCubit>().setThemeMode(_mapTheme(newTheme));
                },
              ),
              const SizedBox(height: AppSpacing.medium),
              Row(
                children: [
                  _ThemeCard(
                    color: colors.surfaceContainerHighest,
                    isSelected: theme == 'light',
                  ),
                  const SizedBox(width: AppSpacing.small),
                  _ThemeCard(
                    color: colors.surfaceContainerLowest,
                    isSelected: theme == 'dark',
                  ),
                  const SizedBox(width: AppSpacing.small),
                  _ThemeCard(
                    color: colors.surfaceContainerHigh,
                    isSelected: theme == 'sync',
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.large),
              Text(
                localization.linksPanelPosition,
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.medium),
              SegmentedButton<String>(
                segments: [
                  ButtonSegment(
                    value: 'below_summary',
                    label: Text(localization.belowSummary),
                  ),
                  ButtonSegment(
                    value: 'below_description',
                    label: Text(localization.belowDescription),
                  ),
                ],
                selected: {linksPosition},
                onSelectionChanged: (value) {
                  cubit.updateLinksPanelPosition(value.first);
                },
              ),
              const SizedBox(height: AppSpacing.medium),
              Row(
                children: [
                  _PositionCard(isActive: linksPosition == 'below_summary'),
                  const SizedBox(width: AppSpacing.small),
                  _PositionCard(isActive: linksPosition == 'below_description'),
                ],
              ),
              const SizedBox(height: AppSpacing.large),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      localization.showRecentIssues,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Switch(
                    value: showRecent,
                    onChanged: (value) => cubit.updateShowRecent(value),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.small),
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
      },
    );
  }
}

class _ThemeCard extends StatelessWidget {
  final Color color;
  final bool isSelected;

  const _ThemeCard({required this.color, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: 100,
      height: 70,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppSpacing.small),
        border: Border.all(
          color: isSelected ? colors.primary : colors.outlineVariant,
          width: isSelected ? 2 : 1,
        ),
      ),
    );
  }
}

class _PositionCard extends StatelessWidget {
  final bool isActive;

  const _PositionCard({required this.isActive});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: 180,
      height: 60,
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(AppSpacing.small),
        border: Border.all(
          color: isActive ? colors.primary : colors.outlineVariant,
          width: isActive ? 2 : 1,
        ),
      ),
    );
  }
}

// ── Tags and Saved Searches Tab ─────────────────────────────
class _TagsAndSearchesTab extends StatelessWidget {
  const _TagsAndSearchesTab();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final localization = AppLocalizations.of(context)!;
    final cubit = context.read<UserTagsCubit>();

    return BlocBuilder<UserTagsCubit, UserTagsState>(
      builder: (context, state) {
        if (state.status == TagsStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        final tags = cubit.filteredTags;
        final savedSearches = cubit.filteredSavedSearches;

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
                            _showNewSavedSearchDialog(context, cubit);
                          },
                          icon: const Icon(Icons.add, size: 16),
                          label: Text(localization.newTagOrSearch),
                          style: FilledButton.styleFrom(
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.small),
                        TextButton(
                          onPressed: () {
                            final selectedIsSearch =
                                state.selectedId != null &&
                                    savedSearches.any(
                                      (s) => s.id == state.selectedId,
                                    );
                            if (state.selectedId == null || !selectedIsSearch) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(localization.noTagSelected),
                                ),
                              );
                              return;
                            }
                            cubit.deleteSelected();
                          },
                          child: Text(localization.delete),
                        ),
                        const SizedBox(width: AppSpacing.medium),
                        Expanded(
                          child: TextField(
                            onChanged: (value) =>
                                cubit.setSearchQuery(value),
                            decoration: InputDecoration(
                              hintText: localization.searchTagsAndSearches,
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
                          onPressed: () => cubit.setFilter('all'),
                          style: state.filterMode == 'all'
                              ? TextButton.styleFrom(
                                  foregroundColor: colors.primary,
                                )
                              : null,
                          child: Text(localization.all),
                        ),
                        TextButton(
                          onPressed: () => cubit.setFilter('created_by_me'),
                          style: state.filterMode == 'created_by_me'
                              ? TextButton.styleFrom(
                                  foregroundColor: colors.primary,
                                )
                              : null,
                          child: Text(localization.createdByMe),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.visibility_off, size: 18),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  _buildTagListHeader(colors, textTheme, localization),
                  const Divider(height: 1),
                  Expanded(
                    child: ListView(
                      children: [
                        for (final tag in tags)
                          _TagItem(
                            icon: Icons.tag,
                            iconColor: colors.tertiary,
                            name: tag.name,
                            subtitle: 'tag: ${tag.name}',
                            isActive: state.selectedId == tag.id,
                            onTap: () => cubit.selectItem(tag.id),
                          ),
                        for (final search in savedSearches)
                          _TagItem(
                            icon: Icons.save_alt,
                            iconColor: colors.primary,
                            name: search.name,
                            subtitle: '${localization.searchSavedSearchType}: '
                                '${search.query}',
                            isActive: state.selectedId == search.id,
                            onTap: () => cubit.selectItem(search.id),
                          ),
                        if (tags.isEmpty && savedSearches.isEmpty)
                          Padding(
                            padding: const EdgeInsets.all(AppSpacing.large),
                            child: Text(
                              localization.noTagSelected,
                              style: TextStyle(
                                color: colors.onSurfaceVariant,
                              ),
                            ),
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
                child: _buildDetailPanel(
                  context,
                  colors,
                  textTheme,
                  localization,
                  state,
                  tags,
                  savedSearches,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showNewSavedSearchDialog(
    BuildContext context,
    UserTagsCubit cubit,
  ) {
    final localization = AppLocalizations.of(context)!;
    final nameController = TextEditingController();
    final queryController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(localization.newTagOrSearch),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: localization.enterTagName,
                isDense: true,
              ),
            ),
            const SizedBox(height: AppSpacing.small),
            TextField(
              controller: queryController,
              decoration: InputDecoration(
                hintText: localization.enterSearchQuery,
                isDense: true,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              nameController.dispose();
              queryController.dispose();
              Navigator.pop(ctx);
            },
            child: Text(localization.cancelButton),
          ),
          FilledButton(
            onPressed: () {
              final name = nameController.text.trim();
              final query = queryController.text.trim();
              nameController.dispose();
              queryController.dispose();
              Navigator.pop(ctx);
              if (name.isEmpty || query.isEmpty) return;
              cubit.createSavedSearch(name: name, query: query);
            },
            child: Text(localization.createButton),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailPanel(
    BuildContext context,
    ColorScheme colors,
    TextTheme textTheme,
    AppLocalizations localization,
    UserTagsState state,
    List<Tag> tags,
    List<SavedSearchEntity> savedSearches,
  ) {
    final selectedTag = tags.where((t) => t.id == state.selectedId).firstOrNull;
    final selectedSearch =
        savedSearches.where((s) => s.id == state.selectedId).firstOrNull;

    if (selectedTag == null && selectedSearch == null) {
      return Center(
        child: Text(
          localization.noTagSelected,
          style: TextStyle(color: colors.onSurfaceVariant),
        ),
      );
    }

    if (selectedTag != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${localization.newTagOrSearch}: ${selectedTag.name}',
            style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSpacing.medium),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: TextEditingController(text: selectedTag.name),
                  decoration: const InputDecoration(isDense: true),
                ),
              ),
              const SizedBox(width: AppSpacing.small),
              Icon(Icons.tag, color: colors.tertiary, size: 24),
            ],
          ),
          const SizedBox(height: AppSpacing.medium),
          Row(
            children: [
              Checkbox(
                value: selectedTag.removeOnResolution,
                onChanged: null,
              ),
              Expanded(child: Text(localization.removeOnResolution)),
            ],
          ),
          Row(
            children: [
              Checkbox(value: selectedTag.favorite, onChanged: null),
              Expanded(child: Text(localization.markAsFavorite)),
            ],
          ),
          const SizedBox(height: AppSpacing.medium),
          Text(
            localization.notificationEvents,
            style: textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSpacing.small),
          Wrap(
            spacing: AppSpacing.medium,
            children: [
              for (final subscription in selectedTag.subscriptions)
                Text(
                  subscription.eventType.displayName(localization),
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ],
      );
    }

    final search = selectedSearch;
    if (search == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${localization.searchSavedSearchType}: ${search.name}',
          style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppSpacing.medium),
        TextField(
          controller: TextEditingController(text: search.name),
          decoration: const InputDecoration(isDense: true),
        ),
        const SizedBox(height: AppSpacing.medium),
        TextField(
          controller: TextEditingController(text: search.query),
          maxLines: 3,
          decoration: const InputDecoration(isDense: true),
        ),
        const SizedBox(height: AppSpacing.medium),
        Row(
          children: [
            Checkbox(value: search.isFavorite, onChanged: null),
            Expanded(child: Text(localization.markAsFavorite)),
          ],
        ),
      ],
    );
  }

  Widget _buildTagListHeader(
    ColorScheme colors,
    TextTheme textTheme,
    AppLocalizations localization,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              localization.fullName,
              style: textTheme.labelMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ),
          Text(
            localization.removeOnResolution,
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
  final VoidCallback onTap;

  const _TagItem({
    required this.icon,
    required this.iconColor,
    required this.name,
    required this.subtitle,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? colors.primaryContainer.withValues(alpha: 0.2) : null,
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: iconColor),
            const SizedBox(width: AppSpacing.small),
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
      ),
    );
  }
}

// ── Notifications Tab ───────────────────────────────────────
class _NotificationsTab extends StatelessWidget {
  const _NotificationsTab();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final localization = AppLocalizations.of(context)!;
    final cubit = context.read<NotificationSettingsCubit>();

    return BlocBuilder<NotificationSettingsCubit, NotificationSettingsState>(
      builder: (context, state) {
        if (state.status == NotificationSettingsStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        final settings = state.settings;
        if (settings == null) {
          return const SizedBox.shrink();
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.large),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localization.sendNotificationsTo,
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.medium),
              Row(
                children: [
                  Checkbox(
                    value: settings.emailEnabled,
                    onChanged: (value) =>
                        cubit.toggleEmailEnabled(value ?? false),
                  ),
                  Text(localization.emailChannel),
                  const SizedBox(width: AppSpacing.medium),
                  SegmentedButton<String>(
                    segments: [
                      ButtonSegment(value: 'html', label: Text('HTML')),
                      ButtonSegment(
                        value: 'plain_text',
                        label: Text('Plain text'),
                      ),
                    ],
                    selected: {settings.emailFormat},
                    onSelectionChanged: (value) =>
                        cubit.updateEmailFormat(value.first),
                  ),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: settings.telegramEnabled,
                    onChanged: (value) =>
                        cubit.toggleTelegramEnabled(value ?? false),
                  ),
                  Text(localization.telegramChannel),
                  const SizedBox(width: AppSpacing.small),
                  TextButton(
                    onPressed: () {
                      cubit.toggleTelegramConnected(true);
                    },
                    child: Text(localization.connectTelegramAccount),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.large),
              Text(
                localization.notificationEvents,
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.medium),
              _NotificationRow(
                label: localization.changesByMe,
                checked: settings.notifyChangesByMe,
                onChanged: (value) =>
                    cubit.toggleNotifyEvent('notifyChangesByMe', value),
              ),
              _NotificationRow(
                label: localization.mentionsMyUsername,
                checked: settings.notifyMentions,
                onChanged: (value) =>
                    cubit.toggleNotifyEvent('notifyMentions', value),
              ),
              _NotificationRow(
                label: localization.changesInDuplicateCluster,
                checked: settings.notifyDuplicateChanges,
                onChanged: (value) =>
                    cubit.toggleNotifyEvent('notifyDuplicateChanges', value),
              ),
              _NotificationRow(
                label: localization.issuesFromEmails,
                checked: settings.notifyEmailCreated,
                onChanged: (value) =>
                    cubit.toggleNotifyEvent('notifyEmailCreated', value),
              ),
              _NotificationRow(
                label: localization.vcsBuildUpdates,
                checked: settings.notifyVcsUpdates,
                onChanged: (value) =>
                    cubit.toggleNotifyEvent('notifyVcsUpdates', value),
              ),
              _NotificationRow(
                label: localization.failedVcsCommands,
                checked: settings.notifyVcsFailedCommands,
                onChanged: (value) =>
                    cubit.toggleNotifyEvent('notifyVcsFailedCommands', value),
              ),
              const SizedBox(height: AppSpacing.large),
              Text(
                localization.starAutomaticallyWhen,
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.medium),
              _NotificationRow(
                label: localization.starOnComment,
                checked: settings.starOnComment,
                onChanged: (value) =>
                    cubit.toggleStarEvent('starOnComment', value),
              ),
              _NotificationRow(
                label: localization.starOnCreate,
                checked: settings.starOnCreate,
                onChanged: (value) => cubit.toggleStarEvent('starOnCreate', value),
              ),
              _NotificationRow(
                label: localization.starOnUpdate,
                checked: settings.starOnUpdate,
                onChanged: (value) => cubit.toggleStarEvent('starOnUpdate', value),
              ),
              _NotificationRow(
                label: localization.starOnAssigned,
                checked: settings.starOnAssigned,
                onChanged: (value) =>
                    cubit.toggleStarEvent('starOnAssigned', value),
              ),
              _NotificationRow(
                label: localization.starOnVote,
                checked: settings.starOnVote,
                onChanged: (value) => cubit.toggleStarEvent('starOnVote', value),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _NotificationRow extends StatelessWidget {
  final String label;
  final bool checked;
  final ValueChanged<bool> onChanged;

  const _NotificationRow({
    required this.label,
    required this.checked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: checked,
          onChanged: (value) => onChanged(value ?? false),
        ),
        Expanded(
          child: Text(label, style: const TextStyle(fontSize: 13)),
        ),
      ],
    );
  }
}

// ── Account Security Tab ────────────────────────────────────
class _AccountSecurityTab extends StatelessWidget {
  const _AccountSecurityTab();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final localization = AppLocalizations.of(context)!;
    final cubit = context.read<AccountSecurityCubit>();
    final currentUser = get_it<UserSession>().currentUser;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.large),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionCard(
            colors: colors,
            textTheme: textTheme,
            title: localization.twoFactorAuth,
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
                    label: Text(localization.pairWithApp),
                  ),
                  const SizedBox(width: AppSpacing.medium),
                  OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Pair with hardware token started'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.security, size: 16),
                    label: Text(localization.pairWithHardwareToken),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.medium),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.medium,
                  vertical: AppSpacing.small,
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
                    const SizedBox(width: AppSpacing.small),
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
            title: localization.credentials,
            children: [
              FilledButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Add credentials form opened')),
                  );
                },
                icon: const Icon(Icons.add, size: 16),
                label: Text(localization.addCredentials),
              ),
              const SizedBox(height: AppSpacing.medium),
              Container(
                padding: const EdgeInsets.all(AppSpacing.medium),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppSpacing.small),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${localization.username}: ${currentUser?.username ?? '—'} | '
                          '${localization.email}: ${currentUser?.email ?? '—'}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.small),
                    Text(
                      'Most recent login: —',
                      style: TextStyle(
                        fontSize: 11,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.medium),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            _showChangePasswordDialog(
                              context,
                              cubit,
                              localization,
                            );
                          },
                          child: Text(localization.changePassword),
                        ),
                        TextButton(
                          onPressed: () {
                            _showConfirmDialog(
                              context,
                              localization.revokeRefreshToken,
                              'This will invalidate all active sessions using this token.',
                              onConfirm: () async {
                                await cubit.revokeRefreshToken();
                                if (!context.mounted) return;
                                if (cubit.state.status ==
                                    AccountSecurityStatus.success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        localization.sessionsRevokedSuccess,
                                      ),
                                    ),
                                  );
                                } else if (cubit.state.status ==
                                    AccountSecurityStatus.error) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        localization.sessionsRevokeFailed(
                                          cubit.state.errorMessage ?? '',
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                cubit.reset();
                              },
                            );
                          },
                          child: Text(localization.revokeRefreshToken),
                        ),
                        TextButton(
                          onPressed: () {
                            _showConfirmDialog(
                              context,
                              localization.deleteCredentials,
                              'This action cannot be undone. All credentials will be permanently removed.',
                              onConfirm: () {},
                            );
                          },
                          child: Text(
                            localization.deleteCredentials,
                            style: TextStyle(color: colors.error),
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
            title: localization.tokens,
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
                    label: Text(localization.newToken),
                  ),
                  const SizedBox(width: AppSpacing.medium),
                  OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('New password creation form opened'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.vpn_key, size: 16),
                    label: Text(localization.newPasswordButton),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.medium),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.medium,
                  vertical: AppSpacing.medium,
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
                    const SizedBox(height: AppSpacing.small),
                    Text(
                      'There are no authentication tokens for your account.',
                      style: TextStyle(color: colors.onSurfaceVariant),
                    ),
                    const SizedBox(height: AppSpacing.extraSmall),
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

  void _showChangePasswordDialog(
    BuildContext context,
    AccountSecurityCubit cubit,
    AppLocalizations localization,
  ) {
    final currentController = TextEditingController();
    final newController = TextEditingController();
    final confirmController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(localization.changePassword),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: localization.currentPassword,
                isDense: true,
              ),
            ),
            const SizedBox(height: AppSpacing.small),
            TextField(
              controller: newController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: localization.newPassword,
                isDense: true,
              ),
            ),
            const SizedBox(height: AppSpacing.small),
            TextField(
              controller: confirmController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: localization.confirmPassword,
                isDense: true,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              currentController.dispose();
              newController.dispose();
              confirmController.dispose();
              Navigator.pop(ctx);
            },
            child: Text(localization.cancelButton),
          ),
          FilledButton(
            onPressed: () async {
              final current = currentController.text;
              final newPass = newController.text;
              final confirm = confirmController.text;

              if (newPass != confirm) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(localization.passwordMismatch)),
                );
                return;
              }

              currentController.dispose();
              newController.dispose();
              confirmController.dispose();
              Navigator.pop(ctx);

              await cubit.changePassword(
                currentPassword: current,
                newPassword: newPass,
              );

              if (!context.mounted) return;
              if (cubit.state.status == AccountSecurityStatus.success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(localization.passwordChangedSuccess)),
                );
              } else if (cubit.state.status == AccountSecurityStatus.error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      localization.passwordChangeFailed(
                        cubit.state.errorMessage ?? '',
                      ),
                    ),
                  ),
                );
              }
              cubit.reset();
            },
            child: Text(localization.saveButton),
          ),
        ],
      ),
    );
  }

  void _showConfirmDialog(
    BuildContext context,
    String title,
    String message, {
    required VoidCallback onConfirm,
  }) {
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
              onConfirm();
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
        borderRadius: BorderRadius.circular(AppSpacing.small),
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
            const SizedBox(height: AppSpacing.small),
            Text(
              description!,
              style: TextStyle(fontSize: 12, color: colors.onSurfaceVariant),
            ),
          ],
          const SizedBox(height: AppSpacing.medium),
          ...children,
        ],
      ),
    );
  }
}
