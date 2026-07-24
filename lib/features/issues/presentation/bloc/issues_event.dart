import 'package:equatable/equatable.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue_filter.dart';

enum IssueViewMode { table, list, tree }

abstract class IssuesEvent extends Equatable {
  const IssuesEvent();

  @override
  List<Object?> get props => [];
}

class LoadIssues extends IssuesEvent {
  const LoadIssues();
}

class SelectIssue extends IssuesEvent {
  final String? issueId;
  const SelectIssue(this.issueId);

  @override
  List<Object?> get props => [issueId];
}

class UpdateFilter extends IssuesEvent {
  final IssueFilter filter;
  const UpdateFilter(this.filter);

  @override
  List<Object?> get props => [filter];
}

class ChangeSort extends IssuesEvent {
  final IssueSortField sortField;
  const ChangeSort(this.sortField);

  @override
  List<Object?> get props => [sortField];
}

class ChangeViewMode extends IssuesEvent {
  final IssueViewMode viewMode;
  const ChangeViewMode(this.viewMode);

  @override
  List<Object?> get props => [viewMode];
}

class ToggleStarIssue extends IssuesEvent {
  final String issueId;
  const ToggleStarIssue(this.issueId);

  @override
  List<Object?> get props => [issueId];
}

class ToggleIssueSelection extends IssuesEvent {
  final String issueId;
  const ToggleIssueSelection(this.issueId);

  @override
  List<Object?> get props => [issueId];
}

class SelectAllIssues extends IssuesEvent {
  const SelectAllIssues();
}

class DeselectAllIssues extends IssuesEvent {
  const DeselectAllIssues();
}
