import 'package:equatable/equatable.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue_filter.dart';
import 'package:issues_tracking/features/issues/domain/entities/tag.dart';

enum IssueSearchType { simple, advanced }

enum IssueLayoutType { table, list, tree }

enum IssueStructureType { flat, hierarchical }

enum IssuePreviewType { sidebar, inline }

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
  final List<Tag> allTags;
  final IssueSearchType searchType;
  final IssueLayoutType layoutType;
  final IssueStructureType structureType;
  final bool isCollapsed;
  final IssuePreviewType? previewType;

  const IssuesLoaded({
    this.searchType = .simple,
    this.layoutType = .table,
    this.structureType = .hierarchical,
    required this.issues,
    required this.filteredIssues,
    this.filter = const IssueFilter(),
    this.selectedIssueId,
    this.selectedIssueIds = const {},
    this.allTags = const [],
    this.isCollapsed = false,
    this.previewType,
  });

  bool get hasSelection => selectedIssueIds.isNotEmpty;

  IssuesLoaded copyWith({
    List<Issue>? issues,
    List<Issue>? filteredIssues,
    IssueFilter? filter,
    String? selectedIssueId,
    bool clearSelectedIssue = false,
    Set<String>? selectedIssueIds,
    List<Tag>? allTags,
    IssueSearchType? searchType,
    IssueLayoutType? layoutType,
    IssueStructureType? structureType,
    bool? isCollapsed,
    IssuePreviewType? previewType,
  }) {
    return IssuesLoaded(
      issues: issues ?? this.issues,
      filteredIssues: filteredIssues ?? this.filteredIssues,
      filter: filter ?? this.filter,
      selectedIssueId: clearSelectedIssue
          ? null
          : (selectedIssueId ?? this.selectedIssueId),
      selectedIssueIds: selectedIssueIds ?? this.selectedIssueIds,
      allTags: allTags ?? this.allTags,
      searchType: searchType ?? this.searchType,
      layoutType: layoutType ?? this.layoutType,
      structureType: structureType ?? this.structureType,
      isCollapsed: isCollapsed ?? this.isCollapsed,
      previewType: previewType ?? this.previewType,
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
    searchType,
    layoutType,
    structureType,
    isCollapsed,
    previewType,
  ];
}

class IssuesError extends IssuesState {
  final String message;
  const IssuesError(this.message);

  @override
  List<Object?> get props => [message];
}
