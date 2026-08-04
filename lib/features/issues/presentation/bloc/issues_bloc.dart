import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/features/issues/domain/entities/tag.dart';
import 'package:issues_tracking/features/issues/domain/usecases/get_issues.dart';
import 'package:issues_tracking/features/issues/domain/usecases/stream_issues.dart';
import 'package:issues_tracking/features/issues/domain/usecases/update_issue_starred.dart';
import 'package:issues_tracking/features/issues/domain/repositories/issues_repository.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue_filter.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue.dart';
import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/features/issues/presentation/bloc/issues_event.dart';
import 'package:issues_tracking/features/issues/presentation/bloc/issues_state.dart';

class IssuesBloc extends Bloc<IssuesEvent, IssuesState> {
  final GetIssues getIssues;
  final StreamIssues streamIssues;
  final IssuesRepository repository;
  final UpdateIssueStarredUseCase updateIssueStarredUseCase;

  IssuesBloc({
    required this.getIssues,
    required this.streamIssues,
    required this.repository,
    required this.updateIssueStarredUseCase,
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
    on<ChangeLayoutType>(_onLayoutTypeChanged);
    on<ChangeStructureType>(_onStructureTypeChanged);
    on<ChangePreviewType>(_onPreviewTypeChanged);
    on<IssuesStreamUpdated>(_onIssuesStreamUpdated);
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
    final tagsResult = await repository.getAllTags();
    final tags = tagsResult.fold((_) => <Tag>[], (t) => t);

    final result = await getIssues(params: GetIssuesParams(filter: _currentFilter));

    result.fold(
        (failure) => emit(IssuesError(failure.message)),
        (issues) {
          emit(IssuesLoaded(
            issues: issues,
            filteredIssues: issues,
            allTags: tags,
            filter: _currentFilter,
            selectedIssueId: null,
            selectedIssueIds: {},
            searchType: IssueSearchType.simple,
            layoutType: IssueLayoutType.table,
            structureType: IssueStructureType.flat,
            previewType: null,
          ));
        }
    );


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
      final currentFilter = currentState is IssuesLoaded
          ? currentState.filter
          : const IssueFilter();
      final currentSelectedIssueId = currentState is IssuesLoaded
          ? currentState.selectedIssueId
          : null;
      final Set<String> currentSelectedIssueIds = currentState is IssuesLoaded
          ? currentState.selectedIssueIds
          : <String>{};
      final currentSearchType = currentState is IssuesLoaded
          ? currentState.searchType
          : IssueSearchType.simple;
      final currentLayoutType = currentState is IssuesLoaded
          ? currentState.layoutType
          : IssueLayoutType.list;
      final currentStructureType = currentState is IssuesLoaded
          ? currentState.structureType
          : IssueStructureType.flat;
      final currentPreviewType = currentState is IssuesLoaded
          ? currentState.previewType
          : null;

      emit(
        IssuesLoaded(
          issues: issues,
          filteredIssues: issues,
          allTags: tags,
          filter: currentFilter,
          selectedIssueId: currentSelectedIssueId,
          selectedIssueIds: currentSelectedIssueIds,
          searchType: currentSearchType,
          layoutType: currentLayoutType,
          structureType: currentStructureType,
          previewType: currentPreviewType,
        ),
      );
    });
  }

  Future<void> _onSelectIssue(
    SelectIssue event,
    Emitter<IssuesState> emit,
  ) async {
    if (state is IssuesLoaded) {
      emit(
        (state as IssuesLoaded).copyWith(
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
    final currentState = state;
    emit(IssuesLoading());

    final result = await getIssues(params: GetIssuesParams(filter: event.filter));
    final issues = result.getOrElse((f) => <Issue>[]);

    final List<Tag> tags;
    if (currentState is IssuesLoaded) {
      tags = currentState.allTags;
    } else {
      final tagsResult = await repository.getAllTags();
      tags = tagsResult.fold((_) => <Tag>[], (t) => t);
    }

    if (currentState is IssuesLoaded) {
      emit(currentState.copyWith(
        issues: issues,
        filteredIssues: issues,
        allTags: tags,
        filter: event.filter,
      ));
    } else {
      emit(IssuesLoaded(
        issues: issues,
        filteredIssues: issues,
        allTags: tags,
        filter: event.filter,
      ));
    }
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
      Issue? toggledIssue;
      final updatedIssues = current.issues.map((issue) {
        if (issue.id == event.issueId) {
          toggledIssue = issue.copyWith(isStarred: !issue.isStarred);
          return toggledIssue!;
        }
        return issue;
      }).toList();
      final updatedFilteredIssues = current.filteredIssues.map((issue) {
        if (issue.id == event.issueId) {
          return toggledIssue!;
        }
        return issue;
      }).toList();

      emit(current.copyWith(
        issues: updatedIssues,
        filteredIssues: updatedFilteredIssues,
      ));

      if (toggledIssue == null) return;
      final result = await updateIssueStarredUseCase(
        params: UpdateIssueStarredParams(
          issueId: toggledIssue!.id,
          isStarred: toggledIssue!.isStarred,
        ),
      );
      result.fold(
        (failure) {
          final revertedIssues = updatedIssues.map((issue) {
            if (issue.id == event.issueId) {
              return issue.copyWith(isStarred: !issue.isStarred);
            }
            return issue;
          }).toList();
          final revertedFiltered = updatedFilteredIssues.map((issue) {
            if (issue.id == event.issueId) {
              return issue.copyWith(isStarred: !issue.isStarred);
            }
            return issue;
          }).toList();
          emit(current.copyWith(
            issues: revertedIssues,
            filteredIssues: revertedFiltered,
          ));
        },
        (_) => null,
      );
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

  FutureOr<void> _onLayoutTypeChanged(
    ChangeLayoutType event,
    Emitter<IssuesState> emit,
  ) {
    if (state is IssuesLoaded) {
      final current = state as IssuesLoaded;
      emit(current.copyWith(layoutType: event.type));
    }
  }

  FutureOr<void> _onStructureTypeChanged(
    ChangeStructureType event,
    Emitter<IssuesState> emit,
  ) {
    if (state is IssuesLoaded) {
      final current = state as IssuesLoaded;
      emit(current.copyWith(structureType: event.type));
    }
  }

  FutureOr<void> _onPreviewTypeChanged(
    ChangePreviewType event,
    Emitter<IssuesState> emit,
  ) {
    if (state is IssuesLoaded) {
      final current = state as IssuesLoaded;
      emit(current.copyWith(previewType: event.type));
    }
  }
}
