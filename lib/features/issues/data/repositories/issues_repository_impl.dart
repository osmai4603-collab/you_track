import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue_filter.dart';
import 'package:issues_tracking/features/issues/data/datasources/issues_mock_data_source.dart';
import 'package:issues_tracking/features/issues/domain/repositories/issues_repository.dart';

class IssuesRepositoryImpl implements IssuesRepository {
  final IssuesMockDataSource dataSource;

  IssuesRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<Issue>>> getIssues(IssueFilter filter) async {
    try {
      var issues = await dataSource.getIssues();
      return Right(_applyFilter(issues, filter));
    } catch (e) {
      return Left(LocalDatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Issue>> getIssueById(String id) async {
    try {
      var issue = await dataSource.getIssueById(id);
      if (issue == null) {
        return const Left(ServerFailure('Issue not found'));
      }
      return Right(issue);
    } catch (e) {
      return Left(LocalDatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getAllTags() async {
    try {
      final tags = await dataSource.getAllTags();
      return Right(tags);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  List<Issue> _applyFilter(List<Issue> issues, IssueFilter filter) {
    var result = List<Issue>.from(issues);

    if (filter.searchQuery.isNotEmpty) {
      final query = filter.searchQuery.toLowerCase();
      result = result.where((issue) {
        return issue.title.toLowerCase().contains(query) ||
            issue.fullId.toLowerCase().contains(query) ||
            issue.description.toLowerCase().contains(query) ||
            issue.tags.any((tag) => tag.toLowerCase().contains(query));
      }).toList();
    }

    if (filter.stateFilter != null) {
      result = result.where((i) => i.state == filter.stateFilter).toList();
    }

    if (filter.priorityFilter != null) {
      result = result
          .where((i) => i.priority == filter.priorityFilter)
          .toList();
    }

    if (filter.typeFilter != null) {
      result = result.where((i) => i.issueType == filter.typeFilter).toList();
    }

    if (filter.assigneeFilter != null) {
      result = result
          .where((i) => i.assigneeName == filter.assigneeFilter)
          .toList();
    }

    if (filter.tagFilter != null) {
      result = result.where((i) => i.tags.contains(filter.tagFilter)).toList();
    }

    if (filter.projectFilter != null) {
      result = result
          .where((i) => i.projectKey == filter.projectFilter)
          .toList();
    }

    result.sort((a, b) {
      int cmp;
      switch (filter.sortField) {
        case IssueSortField.updated:
          cmp = a.updatedAt.compareTo(b.updatedAt);
        case IssueSortField.created:
          cmp = a.createdAt.compareTo(b.createdAt);
        case IssueSortField.priority:
          cmp = a.priority.index.compareTo(b.priority.index);
        case IssueSortField.votes:
          cmp = a.votes.compareTo(b.votes);
        case IssueSortField.summary:
          cmp = a.title.compareTo(b.title);
      }
      return filter.sortAscending ? cmp : -cmp;
    });

    return result;
  }
}
