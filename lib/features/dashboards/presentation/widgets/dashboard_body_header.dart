import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:issues_tracking/core/constants/app_route_keys.dart';
import 'package:issues_tracking/features/dashboards/presentation/cubits/youtrack_shell_cubit.dart';
import 'package:issues_tracking/features/dashboards/presentation/widgets/breadcrumbs.dart';
import 'package:issues_tracking/features/issues/presentation/bloc/issues_bloc.dart';
import 'package:issues_tracking/features/issues/presentation/bloc/issues_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_spacing.dart';

class YouTrackContentHeader extends StatelessWidget {
  const YouTrackContentHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final shellState = context.watch<YouTrackShellCubit>().state;
    final currentPath = shellState.currentPath;
    
    final isVisible = currentPath.contains('projects') || currentPath.contains('issues');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isVisible) _SectionOne(),
        _SectionTwo(currentPath: currentPath),
        Divider(thickness: 1,),
      ],
    );
  }
}

class _SectionOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final issuesState = context.watch<IssuesBloc>().state;
    final currentUserId = Supabase.instance.client.auth.currentUser?.id;

    if (issuesState is! IssuesLoaded || currentUserId == null) {
      return const SizedBox.shrink();
    }

    // Filter issues reported by current user
    final userIssues = issuesState.issues
        .where((issue) => issue.reporterId == currentUserId)
        .toList();

    if (userIssues.isEmpty) return const SizedBox.shrink();

    final displayIssues = userIssues.take(5).toList();
    final remainingIssues = userIssues.skip(5).toList();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              children: displayIssues.map((issue) {
                return Chip(
                  label: Text(
                    issue.fullId, 
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.blueAccent)
                  ),
                  backgroundColor: Colors.blue.shade50,
                  side: BorderSide.none,
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                );
              }).toList(),
            ),
          ),
          if (remainingIssues.isNotEmpty)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_horiz, size: 20, color: Colors.grey),
              tooltip: 'More issues',
              onSelected: (value) {
                // Navigate to issue details if needed
              },
              itemBuilder: (context) => remainingIssues.map((issue) {
                return PopupMenuItem(
                  value: issue.id,
                  child: Text(issue.fullId, style: const TextStyle(fontSize: 13)),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}

class _SectionTwo extends StatelessWidget {
  final String currentPath;

  const _SectionTwo({required this.currentPath});

  @override
  Widget build(BuildContext context) {
    final isIssues = currentPath.contains('issues');
    final isPeople = currentPath.contains('people');
    final isProjects = currentPath.contains('projects') && !isIssues && !isPeople;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(child: Breadcrumbs(path: currentPath)),
          if (!isProjects) const Spacer(),
          if (isProjects) const SizedBox(width: 16),
          if (isProjects) ...[
            _SearchField(hint: 'Filter projects by name or ID'),
            const SizedBox(width: 16),
            _ActionButton(
              onPressed: () => context.go(AppRouteKeys.projectTemplates),
              icon: Icons.add,
              label: 'Create Project',
            ),
          ],
          if (isPeople) ...[
            _ActionButton(
              onPressed: () {},
              icon: Icons.person_add,
              label: 'Add People',
            ),
          ],
          if (isIssues && !isProjects) ...[
            _ActionButton(
              onPressed: () {},
              icon: Icons.add,
              label: 'New Issue',
            ),
          ],
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;

  const _ActionButton({
    required this.onPressed,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      // icon: Icon(icon, size: 16),
      child: Text(label),

    );
  }
}

class _SearchField extends StatefulWidget {
  final String hint;

  const _SearchField({required this.hint});

  @override
  State<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<_SearchField> with SingleTickerProviderStateMixin {
  final FocusNode _focusNode = FocusNode();
  late AnimationController _controller;
  late Animation<double> _widthAnimation;

  static const double _unfocusedWidth = 220;
  static const double _focusedWidth = 320;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _widthAnimation = Tween<double>(begin: _unfocusedWidth, end: _focusedWidth).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _widthAnimation,
      builder: (context, child) {
        return SizedBox(
          height: 32,
          width: _widthAnimation.value,
          child: child,
        );
      },
      child: TextField(
        focusNode: _focusNode,
        cursorHeight: 18,
        style: TextTheme.of(context).bodyMedium,
        decoration: InputDecoration(
          hintText: widget.hint,
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.extraSmall,
          ),
        ),
      ),
    );
  }
}
