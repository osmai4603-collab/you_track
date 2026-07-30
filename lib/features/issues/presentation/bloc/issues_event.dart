import 'package:equatable/equatable.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue_filter.dart';
import 'package:issues_tracking/features/issues/presentation/bloc/issues_state.dart';

abstract class IssuesEvent extends Equatable {
  const IssuesEvent();

  @override
  List<Object?> get props => [];
}

class LoadIssues extends IssuesEvent {
  const LoadIssues();
}

class ChangeSeachType extends IssuesEvent {
  final IssueSearchType type;
  const ChangeSeachType({required this.type});
}

class ChangeLayoutType extends IssuesEvent {
  final IssueLayoutType type;
  const ChangeLayoutType({required this.type});
}

class ChangeStructureType extends IssuesEvent {
  final IssueStructureType type;
  const ChangeStructureType({required this.type});
}

class ChangePreviewType extends IssuesEvent {
  final IssuePreviewType? type;
  const ChangePreviewType({required this.type});
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

class IssuesStreamUpdated extends IssuesEvent {
  final dynamic result; // Either<Failure, List<Issue>>
  const IssuesStreamUpdated(this.result);

  @override
  List<Object?> get props => [result];
}
