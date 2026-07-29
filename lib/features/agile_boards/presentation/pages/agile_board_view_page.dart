import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:issues_tracking/core/constants/app_route_keys.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/core/enums/issue_state_enum.dart';
import 'package:issues_tracking/core/enums/issue_subsystem_enum.dart';
import 'package:issues_tracking/core/init_dependencies.dart';
import 'package:issues_tracking/core/theme/app_text_theme.dart';
import 'package:issues_tracking/core/widgets/youtrack_state.dart';
import 'package:issues_tracking/features/agile_boards/domain/entities/agile_board.dart';
import 'package:issues_tracking/features/agile_boards/presentation/bloc/agile_boards_bloc.dart';
import 'package:issues_tracking/features/agile_boards/presentation/bloc/agile_boards_event.dart';
import 'package:issues_tracking/features/agile_boards/presentation/bloc/agile_boards_state.dart';
import 'package:issues_tracking/features/agile_boards/presentation/widgets/board_column_widget.dart';

class AgileBoardViewPage extends StatefulWidget {
  final String projectId;
  final String projectName;

  const AgileBoardViewPage({
    super.key,
    required this.projectId,
    required this.projectName,
  });

  @override
  State<AgileBoardViewPage> createState() => _AgileBoardViewPageState();
}

class _AgileBoardViewPageState extends YouTrackState<AgileBoardViewPage> {
  late AgileBoardsBloc _bloc;
  String? _selectedSprintId;

  @override
  void initState() {
    super.initState();
    _bloc = get_it<AgileBoardsBloc>();
    _loadBoard();
  }

  void _loadBoard() {
    _bloc.add(
      LoadBoardDetailsEvent(
        projectId: widget.projectId,
        sprintId: _selectedSprintId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text(
        //     '${widget.projectName} Agile Board',
        //     style: AppTextTheme.light.titleLarge,
        //   ),
        //   actions: [
        //     TextButton.icon(
        //       onPressed: () {
        //         // Future: Handle Exit TV mode logic if needed, or simply pop
        //         Navigator.of(context).pop();
        //       },
        //       icon: const Icon(Icons.close),
        //       label: const Text('Exit TV mode'),
        //     ),
        //   ],
        // ),
        body: BlocBuilder<AgileBoardsBloc, AgileBoardsState>(
          builder: (context, state) {
            if (state is AgileBoardsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AgileBoardsError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SelectableText('Error: ${state.message}'),
                    ElevatedButton(
                      onPressed: _loadBoard,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else if (state is AgileBoardsLoaded) {
              final board = state.board;

              return Column(
                children: [
                  // Kanban Grid
                  _bildHeaders(colors, board),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: board.swimlanes.map((swimlane) {
                          return Theme(
                            data: Theme.of(
                              context,
                            ).copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              title: Row(
                                children: [
                                  Text(
                                    swimlane.subsystem.name,
                                    style: AppTextTheme.light.titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: AppSpacing.small),
                                  Text(
                                    '${swimlane.columns.fold(0, (sum, col) => sum + col.cards.length)} cards',
                                    style: AppTextTheme.light.labelMedium
                                        ?.copyWith(
                                          color: colors.onSurfaceVariant,
                                        ),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    icon: const Icon(Icons.add, size: 20),
                                    onPressed: () {
                                      // Default to To Do state when adding at swimlane level
                                      _navigateToAddIssue(
                                        swimlane.subsystem,
                                        IssueStateEnum.toDo,
                                      );
                                    },
                                  ),
                                ],
                              ),
                              initiallyExpanded: true,
                              children: [
                                IntrinsicHeight(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSpacing.medium,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: swimlane.columns.map((column) {
                                        return Expanded(
                                          child: BoardColumnWidget(
                                            column: column,
                                            onCardDropped: (card, newColumn) {
                                              _bloc.add(
                                                MoveCardEvent(
                                                  issueId: card.id,
                                                  newState: newColumn.state,
                                                  oldState: card.state,
                                                ),
                                              );
                                            },
                                            onAddPressed: () {
                                              _navigateToAddIssue(
                                                swimlane.subsystem,
                                                column.state,
                                              );
                                            },
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.large),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Container _bildHeaders(ColorScheme colors, AgileBoard board) {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: colors.outlineVariant.withOpacity(0.5)),
        ),
      ),
      child: Row(
        children: board.headers.map((headerState) {
          final count = board.columnCounts[headerState] ?? 0;
          return Expanded(
            child: Padding(
              padding: AppSpacing.paddingAllMedium,
              child: Text(
                '${headerState.displayName(localization)} ($count)',
                style: AppTextTheme.light.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _navigateToAddIssue(IssueSubsystemEnum subsystem, IssueStateEnum state) {
    // In the future this should navigate to IssueFormPage with initial subsystem and state.
    // For now we just show a snackbar or navigate to the form.
    context.push(AppRouteKeys.createIssue);
  }
}
