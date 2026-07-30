import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/features/issues/domain/entities/tag.dart';
import 'package:issues_tracking/features/issues/domain/usecases/get_issues.dart';
import 'package:issues_tracking/features/issues/domain/usecases/stream_issues.dart';
import 'package:issues_tracking/features/issues/domain/repositories/issues_repository.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue_filter.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue.dart';
import 'package:fpdart/fpdart.dart';
import 'issues_event.dart';
import 'issues_state.dart';

class IssuesBloc extends Bloc<IssuesEvent, IssuesState> {
  final GetIssues getIssues;
  final StreamIssues streamIssues;
  final IssuesRepository repository;
  StreamSubscription<Issue>? _subscription;

  IssuesBloc({
    required this.getIssues,
    required this.streamIssues,
    required this.repository,
  }) : super(IssuesInitial()) {
    on<LoadIssues>(_onLoadIssues);
    on<SelectIssue>(_onSelectIssue);
    on<UpdateFilter>(_onUpdateFilter);
    on<ChangeSort>(_onChangeSort);
    on<ToggleStarIssue>(_onToggleStarIssue);
    on<ToggleIssueSelection>(_onToggleIssueSelection);
    on<SelectAllIssues>(_onSelectAllIssues);
    on<DeselectAllIssues>(_onDeselectAllIssues);
    on<ChangeSeachType>(_onSearchTypeChanged);
    on<ChangeLayoutType>(_onLayouyTypeChanged);
    on<ChangeStructureType>(_onStrcutureTypeChanged);
    on<ChangePreviewType>(_onPreviewTypeChnaged);
    on<IssuesStreamUpdated>(_onIssuesStreamUpdated);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  IssueFilter get _currentFilter {
    if (state is IssuesLoaded) {
      return (state as IssuesLoaded).filter;
    }
    return const IssueFilter();
  }

  Future<void> _onLoadIssues(
    LoadIssues event,
    Emitter<IssuesState> emit,
  ) async {
    emit(IssuesLoading());
    // final tagsResult = await repository.getAllTags();
    // final tags = tagsResult.fold((_) => <Tag>[], (t) => t);

    _subscription =
        streamIssues(params: GetIssuesParams(filter: _currentFilter)).listen((
          result,
        ) {
          add(IssuesStreamUpdated(result));
        });
  }

  Future<void> _onIssuesStreamUpdated(
    IssuesStreamUpdated event,
    Emitter<IssuesState> emit,
  ) async {
    final result = event.result as Either<Failure, List<Issue>>;
    final tagsResult = await repository.getAllTags();
    final tags = tagsResult.fold((_) => <Tag>[], (t) => t);

    result.fold((failure) => emit(IssuesError(failure.message)), (issues) {
      final currentState = state;
      emit(
        IssuesLoaded(
          issues: issues,
          filteredIssues: issues,
          allTags: tags,
          filter: currentState is IssuesLoaded
              ? currentState.filter
              : const IssueFilter(),
          selectedIssueId: currentState is IssuesLoaded
              ? currentState.selectedIssueId
              : null,
          selectedIssueIds: currentState is IssuesLoaded
              ? currentState.selectedIssueIds
              : {},
          searchType: currentState is IssuesLoaded
              ? currentState.searchType
              : IssueSearchType.simple,
          layoutType: currentState is IssuesLoaded
              ? currentState.layoutType
              : IssueLayoutType.list,
          structureType: currentState is IssuesLoaded
              ? currentState.structureType
              : IssueStructureType.flat,
          previewType: currentState is IssuesLoaded
              ? currentState.previewType
              : null,
        ),
      );
    });
  }

  Future<void> _onSelectIssue(
    SelectIssue event,
    Emitter<IssuesState> emit,
  ) async {
    if (state is IssuesLoaded) {
      final current = state as IssuesLoaded;
      emit(
        current.copyWith(
          selectedIssueId: event.issueId,
          clearSelectedIssue: event.issueId == null,
        ),
      );
    }
  }

  Future<void> _onUpdateFilter(
    UpdateFilter event,
    Emitter<IssuesState> emit,
  ) async {
    final current = state;
    emit(IssuesLoading());

    _subscription?.cancel();
    _subscription = streamIssues(params: GetIssuesParams(filter: event.filter))
        .listen((result) {
          add(IssuesStreamUpdated(result));
        });
  }

  Future<void> _onChangeSort(
    ChangeSort event,
    Emitter<IssuesState> emit,
  ) async {
    if (state is IssuesLoaded) {
      final current = state as IssuesLoaded;
      final newSortAscending = current.filter.sortField == event.sortField
          ? !current.filter.sortAscending
          : false;

      final newFilter = current.filter.copyWith(
        sortField: event.sortField,
        sortAscending: newSortAscending,
      );

      add(UpdateFilter(newFilter));
    }
  }

  Future<void> _onToggleStarIssue(
    ToggleStarIssue event,
    Emitter<IssuesState> emit,
  ) async {
    if (state is IssuesLoaded) {
      final current = state as IssuesLoaded;
      final updatedIssues = current.filteredIssues.map((issue) {
        if (issue.id == event.issueId) {
          return issue.copyWith(isStarred: !issue.isStarred);
        }
        return issue;
      }).toList();

      emit(current.copyWith(filteredIssues: updatedIssues));
    }
  }

  Future<void> _onToggleIssueSelection(
    ToggleIssueSelection event,
    Emitter<IssuesState> emit,
  ) async {
    if (state is IssuesLoaded) {
      final current = state as IssuesLoaded;
      final newSelection = Set<String>.from(current.selectedIssueIds);
      if (newSelection.contains(event.issueId)) {
        newSelection.remove(event.issueId);
      } else {
        newSelection.add(event.issueId);
      }
      emit(current.copyWith(selectedIssueIds: newSelection));
    }
  }

  Future<void> _onSelectAllIssues(
    SelectAllIssues event,
    Emitter<IssuesState> emit,
  ) async {
    if (state is IssuesLoaded) {
      final current = state as IssuesLoaded;
      final allIds = current.filteredIssues.map((i) => i.id).toSet();
      emit(current.copyWith(selectedIssueIds: allIds));
    }
  }

  Future<void> _onDeselectAllIssues(
    DeselectAllIssues event,
    Emitter<IssuesState> emit,
  ) async {
    if (state is IssuesLoaded) {
      final current = state as IssuesLoaded;
      emit(current.copyWith(selectedIssueIds: {}));
    }
  }

  FutureOr<void> _onSearchTypeChanged(
    ChangeSeachType event,
    Emitter<IssuesState> emit,
  ) {
    if (state is IssuesLoaded) {
      final current = state as IssuesLoaded;
      emit(current.copyWith(searchType: event.type));
    }
  }

  FutureOr<void> _onLayouyTypeChanged(
    ChangeLayoutType event,
    Emitter<IssuesState> emit,
  ) {
    if (state is IssuesLoaded) {
      final current = state as IssuesLoaded;
      emit(current.copyWith(layoutType: event.type));
    }
  }

  FutureOr<void> _onStrcutureTypeChanged(
    ChangeStructureType event,
    Emitter<IssuesState> emit,
  ) {
    if (state is IssuesLoaded) {
      final current = state as IssuesLoaded;
      emit(current.copyWith(structureType: event.type));
    }
  }

  FutureOr<void> _onPreviewTypeChnaged(
    ChangePreviewType event,
    Emitter<IssuesState> emit,
  ) {
    if (state is IssuesLoaded) {
      final current = state as IssuesLoaded;
      emit(current.copyWith(previewType: event.type));
    }
  }
}
