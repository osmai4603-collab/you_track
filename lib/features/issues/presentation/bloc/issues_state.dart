import 'package:equatable/equatable.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue_filter.dart';
import 'package:issues_tracking/features/issues/presentation/bloc/issues_event.dart';

abstract class IssuesState extends Equatable {
  const IssuesState();

  @override
  List<Object?> get props => [];
}

class IssuesInitial extends IssuesState {}

class IssuesLoading extends IssuesState {}

class IssuesLoaded extends IssuesState {
  final List<Issue> issues;
  final List<Issue> filteredIssues;
  final IssueFilter filter;
  final String? selectedIssueId;
  final Set<String> selectedIssueIds;
  final List<String> allTags;
  final IssueViewMode viewMode;

  const IssuesLoaded({
    required this.issues,
    required this.filteredIssues,
    this.filter = const IssueFilter(),
    this.selectedIssueId,
    this.selectedIssueIds = const {},
    this.allTags = const [],
    this.viewMode = IssueViewMode.table,
  });

  bool get hasSelection => selectedIssueIds.isNotEmpty;

  IssuesLoaded copyWith({
    List<Issue>? issues,
    List<Issue>? filteredIssues,
    IssueFilter? filter,
    String? selectedIssueId,
    bool clearSelectedIssue = false,
    Set<String>? selectedIssueIds,
    List<String>? allTags,
    IssueViewMode? viewMode,
  }) {
    return IssuesLoaded(
      issues: issues ?? this.issues,
      filteredIssues: filteredIssues ?? this.filteredIssues,
      filter: filter ?? this.filter,
      selectedIssueId:
          clearSelectedIssue ? null : (selectedIssueId ?? this.selectedIssueId),
      selectedIssueIds: selectedIssueIds ?? this.selectedIssueIds,
      allTags: allTags ?? this.allTags,
      viewMode: viewMode ?? this.viewMode,
    );
  }

  @override
  List<Object?> get props => [
    issues,
    filteredIssues,
    filter,
    selectedIssueId,
    selectedIssueIds,
    allTags,
    viewMode,
  ];
}

class IssuesError extends IssuesState {
  final String message;
  const IssuesError(this.message);

  @override
  List<Object?> get props => [message];
}
