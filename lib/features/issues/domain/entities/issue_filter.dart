import 'package:equatable/equatable.dart';
import 'package:issues_tracking/core/enums/issue_type_enum.dart';
import 'package:issues_tracking/core/enums/issue_priority_type_enum.dart';
import 'package:issues_tracking/core/enums/issue_state_enum.dart';

enum IssueSortField {
  updated,
  created,
  priority,
  votes,
  summary;

  String get label {
    switch (this) {
      case IssueSortField.updated:
        return 'Updated';
      case IssueSortField.created:
        return 'Created';
      case IssueSortField.priority:
        return 'Priority';
      case IssueSortField.votes:
        return 'Votes';
      case IssueSortField.summary:
        return 'Summary';
    }
  }
}

class IssueFilter extends Equatable {
  final String searchQuery;
  final IssueStateEnum? stateFilter;
  final IssuePriorityTypeEnum? priorityFilter;
  final IssueTypeEnum? typeFilter;
  final String? assigneeFilter;
  final String? tagFilter;
  final String? projectFilter;
  final IssueSortField sortField;
  final bool sortAscending;

  const IssueFilter({
    this.searchQuery = '',
    this.stateFilter,
    this.priorityFilter,
    this.typeFilter,
    this.assigneeFilter,
    this.tagFilter,
    this.projectFilter,
    this.sortField = IssueSortField.updated,
    this.sortAscending = false,
  });

  IssueFilter copyWith({
    String? searchQuery,
    bool clearSearchQuery = false,
    IssueStateEnum? stateFilter,
    bool clearStateFilter = false,
    IssuePriorityTypeEnum? priorityFilter,
    bool clearPriorityFilter = false,
    IssueTypeEnum? typeFilter,
    bool clearTypeFilter = false,
    String? assigneeFilter,
    bool clearAssigneeFilter = false,
    String? tagFilter,
    bool clearTagFilter = false,
    String? projectFilter,
    bool clearProjectFilter = false,
    IssueSortField? sortField,
    bool? sortAscending,
  }) {
    return IssueFilter(
      searchQuery: clearSearchQuery ? '' : (searchQuery ?? this.searchQuery),
      stateFilter: clearStateFilter ? null : (stateFilter ?? this.stateFilter),
      priorityFilter: clearPriorityFilter
          ? null
          : (priorityFilter ?? this.priorityFilter),
      typeFilter: clearTypeFilter ? null : (typeFilter ?? this.typeFilter),
      assigneeFilter: clearAssigneeFilter
          ? null
          : (assigneeFilter ?? this.assigneeFilter),
      tagFilter: clearTagFilter ? null : (tagFilter ?? this.tagFilter),
      projectFilter: clearProjectFilter
          ? null
          : (projectFilter ?? this.projectFilter),
      sortField: sortField ?? this.sortField,
      sortAscending: sortAscending ?? this.sortAscending,
    );
  }

  @override
  List<Object?> get props => [
    searchQuery,
    stateFilter,
    priorityFilter,
    typeFilter,
    assigneeFilter,
    tagFilter,
    projectFilter,
    sortField,
    sortAscending,
  ];
}
