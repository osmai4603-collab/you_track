import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fleather/fleather.dart';
import 'package:issues_tracking/core/localization/app_localizations.dart';
import 'package:issues_tracking/core/widgets/hover_widget.dart';
import 'package:issues_tracking/core/widgets/issue_priority_chip.dart';
import 'package:issues_tracking/core/widgets/text_hover_widget.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue_link.dart';
import 'package:issues_tracking/features/issues/presentation/cubits/issue_form_cubit.dart';
import 'package:issues_tracking/features/issues/presentation/cubits/issue_form_state.dart';
import 'package:issues_tracking/features/issues/presentation/widgets/issue_form_top_bar.dart';
import 'package:issues_tracking/features/issues/presentation/widgets/issue_form_toolbar.dart';
import 'package:issues_tracking/features/issues/presentation/widgets/issue_form_attachment_zone.dart';
import 'package:issues_tracking/features/issues/presentation/widgets/issue_form_sidebar.dart';
import 'package:issues_tracking/features/issues/presentation/widgets/issue_form_action_bar.dart';

// ---------- Design Tokens ----------
class YTColors {
  static const Color mainColor = Color.fromRGBO(51, 105, 214, 1);
  static const Color mainHover = Color.fromRGBO(49, 95, 189, 1);
  static const Color textColor = Color.fromRGBO(39, 40, 46, 1);
  static const Color secondaryText = Color.fromRGBO(108, 112, 126, 1);
  static const Color disabledText = Color.fromRGBO(168, 173, 189, 1);
  static const Color borderColor = Color.fromRGBO(211, 213, 219, 1);
  static const Color iconColor = Color.fromRGBO(108, 112, 126, 1);
  static const Color whiteText = Color.fromRGBO(255, 255, 255, 1);
  static const Color background = Color.fromRGBO(255, 255, 255, 1);
  static const Color hoverBg = Color.fromRGBO(237, 243, 255, 1);
  static const Color selectedBg = Color.fromRGBO(212, 226, 255, 1);
  static const Color linkColor = Color.fromRGBO(49, 95, 189, 1);
  static const Color errorColor = Color.fromRGBO(204, 54, 69, 1);
  static const Color warningColor = Color.fromRGBO(229, 109, 23, 1);
  static const Color successColor = Color.fromRGBO(31, 117, 54, 1);
}

class YTDimens {
  static const double unit = 8.0;
  static const double fontSize = 14.0;
  static const double fontSizeSmall = 12.0;
  static const double lineHeight = 20.0;
  static const double borderRadius = 4.0;
  static const double compactAvatarSize = 16.0;
  static const double fieldHeight = 32.0;
  static const double fieldMinWidth = 120.0;
}

class CompactFieldWidget extends StatelessWidget {
  final String label;
  final String value;
  final Widget? leading;
  final VoidCallback? onTap;

  const CompactFieldWidget({
    super.key,
    required this.label,
    required this.value,
    this.leading,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(YTDimens.borderRadius),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.transparent),
          borderRadius: BorderRadius.circular(YTDimens.borderRadius),
        ),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text(label, style: TextStyle(fontSize: 13)),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (leading != null) ...[leading!, const SizedBox(width: 6)],
                TextHoverWidget(
                  text: value,
                  style: TextStyle(
                    fontSize: 14,
                    color: ColorScheme.of(context).primary,
                    fontWeight: FontWeight.w400,
                  ),
                  styleHover: TextStyle(
                    fontSize: 14,
                    color: ColorScheme.of(context).secondary,
                    fontWeight: FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(width: 4),
                Icon(Icons.arrow_drop_down, color: YTColors.iconColor),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ColorBadge extends StatelessWidget {
  final String letter;
  final Color backgroundColor;
  final Color foregroundColor;
  final double size;

  const ColorBadge({
    super.key,
    required this.letter,
    required this.backgroundColor,
    required this.foregroundColor,
    this.size = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        letter,
        style: TextStyle(
          color: foregroundColor,
          fontSize: size * 0.65,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// ---------- Issue Form Page ----------

class IssueForm extends StatefulWidget {
  final String? issueId;
  final String projectKey;

  const IssueForm({super.key, this.issueId, this.projectKey = 'DEM'});

  @override
  State<IssueForm> createState() => _IssueFormState();
}

class _IssueFormState extends State<IssueForm> {
  late FleatherController _editorController;
  late FocusNode _editorFocusNode;
  List<IssueLink> links = [];
  List<Issue> issuesLinked = [];

  @override
  void initState() {
    super.initState();
    _editorController = FleatherController();
    _editorFocusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<IssueFormCubit>();
      if (widget.issueId != null) {
        // TODO: Load issue from repository and call initWithIssue
      } else {
        cubit.initWithProject(widget.projectKey);
      }
    });
  }

  @override
  void dispose() {
    _editorController.dispose();
    _editorFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          return BlocListener<IssueFormCubit, IssueFormState>(
            listenWhen: (prev, curr) =>
                prev.isSubmitting &&
                !curr.isSubmitting &&
                curr.errorMessage == null,
            listener: (context, state) {
              if (!state.isEditing && state.issueId != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Issue created successfully')),
                );
                Navigator.pop(context);
              } else if (state.isEditing) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Issue updated successfully')),
                );
              }
            },
            child: BlocListener<IssueFormCubit, IssueFormState>(
              listenWhen: (prev, curr) => curr.errorMessage != null,
              listener: (context, state) {
                if (state.errorMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.errorMessage!),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  spacing: 16,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            IssueFormTopBar(),
                            Expanded(child: _buildMainContent(context)),
                          ],
                        ),
                      ),
                    ),
                    const IssueFormSidebar(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    final colors = ColorScheme.of(context);
    final textTheme = TextTheme.of(context);
    final localization = AppLocalizations.of(context)!;
    return BlocBuilder<IssueFormCubit, IssueFormState>(
      builder: (context, state) {
        return Column(
          children: [
            Container(
              height: 500,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: .circular(4),
                  side: BorderSide(width: 0.50, color: colors.outline),
                ),
                color: ColorScheme.of(context).surfaceContainer,
              ),
              child: Column(
                children: [
                  IssueFormToolbar(controller: _editorController),
                  Expanded(
                    child: FleatherEditor(
                      controller: _editorController,
                      focusNode: _editorFocusNode,
                      padding: const EdgeInsets.all(16),
                      // placeholder: 'Type or paste a description...',
                    ),
                  ),
                ],
              ),
            ),
            if (links.isNotEmpty) ...[
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: links.map((link) => link.linkType).toSet().map((
                        linkType,
                      ) {
                        return Padding(
                          padding: .directional(end: 16),
                          child: Row(
                            spacing: 4,
                            children: [
                              Text(
                                linkType.displayName(localization),
                                style: textTheme.bodyMedium,
                              ),
                              Text(
                                links
                                    .where((link) => link.linkType == linkType)
                                    .length
                                    .toString(),
                                style: textTheme.bodySmall,
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              Divider(height: 8),
              ...links.map((link) => link.linkType).toSet().map((linkType) {
                return Container(
                  child: Column(
                    spacing: 8,
                    children: [
                      Row(
                        children: [
                          Text(linkType.displayName(localization)),
                          IconButton(
                            icon: Icon(Icons.navigate_next),
                            iconSize: 14,
                            onPressed: () {},
                          ),
                        ],
                      ),
                      ...links.where((link) => link.linkType == linkType).map((
                        link,
                      ) {
                        final issue = issuesLinked.firstWhere(
                          (iss) => iss.id == link.issueId,
                        );
                        return HoverWidget(
                          builder: (context, isHovered) {
                            return ListTile(
                              leading: HoverWidget(
                                builder: (_, isHovered) {
                                  return InkWell(
                                    child: Icon(
                                      issue.isStarred
                                          ? Icons.star_rounded
                                          : Icons.star_outline,
                                      color: isHovered
                                          ? colors.secondary
                                          : null,
                                    ),
                                    onTap: () {},
                                  );
                                },
                              ),
                              title: Row(
                                spacing: 8,
                                children: [
                                  IssuePriorityChip(
                                    type: issue.priority,
                                    textTheme: textTheme,
                                    colors: colors,
                                    localization: localization,
                                  ),
                                  Text(issue.issueKey),
                                  const SizedBox(width: 8),
                                  Text(issue.summary),
                                ],
                              ),
                              trailing: !isHovered
                                  ? null
                                  : FilledButton(
                                      child: Text('Remove link'),
                                      onPressed: () {},
                                    ),
                              tileColor: isHovered
                                  ? colors.primary.withValues(alpha: 020)
                                  : null,
                            );
                          },
                        );
                      }),
                    ],
                  ),
                );
              }),
            ],

            IssueFormActionBar(),
            const Padding(
              padding: EdgeInsets.all(16),
              child: IssueFormAttachmentZone(),
            ),
          ],
        );
      },
    );
  }
}
