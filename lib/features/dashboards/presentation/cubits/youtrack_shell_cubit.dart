import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue.dart';

class YouTrackShellState extends Equatable {
  final String currentPath;
  final String searchQuery;
  final List<Issue> issues;
  final Issue? currentIssue;

  const YouTrackShellState({
    this.currentPath = '',
    this.searchQuery = '',
    this.issues = const [],
    this.currentIssue,
  });

  @override
  List<Object?> get props => [currentPath, searchQuery, issues, currentIssue];

  YouTrackShellState copyWith({
    String? currentPath,
    String? searchQuery,
    List<Issue>? issues,
    bool clearCurrentIssue = false,
    Issue? currentIssue,
  }) {
    return YouTrackShellState(
      currentPath: currentPath ?? this.currentPath,
      searchQuery: searchQuery ?? this.searchQuery,
      issues: issues ?? this.issues,
      currentIssue: clearCurrentIssue
          ? null
          : (currentIssue ?? this.currentIssue),
    );
  }
}

class YouTrackShellCubit extends Cubit<YouTrackShellState> {
  YouTrackShellCubit() : super(const YouTrackShellState());

  void updatePath(String path) {
    if (state.currentPath != path) {
      emit(state.copyWith(currentPath: path));
    }
  }

  void updateSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  void setCurrentIssue(Issue issue) {
    emit(state.copyWith(currentIssue: issue));
  }

  void clearCurrentIssue() {
    emit(state.copyWith(clearCurrentIssue: true));
  }
}
