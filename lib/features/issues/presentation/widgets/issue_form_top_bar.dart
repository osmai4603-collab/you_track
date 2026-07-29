import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/widgets/app_popup_menu_item.dart';
import 'package:issues_tracking/features/issues/presentation/cubits/issue_form_cubit.dart';
import 'package:issues_tracking/features/issues/presentation/cubits/issue_form_state.dart';
import 'package:issues_tracking/features/issues/presentation/widgets/add_link_dialog.dart';

class IssueFormTopBar extends StatelessWidget {
  final TextEditingController? summaryController;
  final VoidCallback? onPaperclipTap;
  final VoidCallback? onMentionTap;
  final VoidCallback? onMenuTap;
  final VoidCallback? onStarTap;

  const IssueFormTopBar({
    super.key,
    this.summaryController,
    this.onPaperclipTap,
    this.onMentionTap,
    this.onMenuTap,
    this.onStarTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    final colors = ColorScheme.of(context);
    return BlocBuilder<IssueFormCubit, IssueFormState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            spacing: 4,
            children: [
              Expanded(
                child: TextField(
                  controller: summaryController,
                  maxLength: 255,
                  buildCounter: _buildCounterField,
                  decoration: InputDecoration(
                    hintText: 'Enter a summary',
                    hintStyle: textTheme.headlineMedium?.copyWith(
                      fontWeight: .bold,
                      color: colors.onSurfaceVariant.withValues(alpha: 0.50),
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(width: 0.30),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 0.30),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 2, color: colors.primary),
                    ),
                    counterText: '',
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.tag_rounded),
                tooltip: 'Add Tag',
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.link_rounded),
                tooltip: 'Add Link',
                padding: .all(2),
                onPressed: () {
                  AddLinkDialog.show(
                    context,
                    currentIssueId: state.issueId,
                    onSave: (link) {
                      context.read<IssueFormCubit>().addLink(link);
                    },
                  );
                },
              ),
              PopupMenuButton<String>(
                borderRadius: .circular(4),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: const Icon(Icons.more_horiz_rounded, size: 20),
                ),
                onSelected: (value) {
                  switch (value) {
                    case 'copy_link':
                      // TODO: Copy issue link
                      break;
                    case 'export_md':
                      // TODO: Export as markdown
                      break;
                    case 'create_sub':
                      // TODO: Create sub-issue
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const AppPopupMenuItem(
                    value: 'copy_link',
                    child: Text('Open command dialog'),
                  ),
                  const AppPopupMenuItem(
                    value: 'export_md',
                    child: Text('Repeat last commnad'),
                  ),
                  const AppPopupMenuItem(
                    value: 'attach_files',
                    child: Text('Attach files'),
                  ),
                  const AppPopupMenuItem(
                    value: 'attach_files_private',
                    child: Text('Attach files privately'),
                  ),
                  const AppPopupMenuItem(
                    value: 'copy_issues',
                    child: Text('Copy issues temples URL'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget? _buildCounterField(
    BuildContext context, {
    required int currentLength,
    required bool isFocused,
    required int? maxLength,
  }) => currentLength > 200
      ? Text(
          '$currentLength/$maxLength',
          style: TextStyle(
            fontSize: 12,
            color: currentLength >= 255 ? Colors.red : Colors.grey,
          ),
        )
      : null;

  void _onFavoritePressed() {}
}
