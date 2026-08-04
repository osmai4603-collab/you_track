import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/features/issues/domain/entities/tag.dart';
import 'package:issues_tracking/features/users/domain/entities/saved_search_entity.dart';
import 'package:issues_tracking/features/users/domain/usecases/create_saved_search.dart';
import 'package:issues_tracking/features/users/domain/usecases/delete_saved_search.dart';
import 'package:issues_tracking/features/users/domain/usecases/get_saved_searches.dart';
import 'package:issues_tracking/features/users/domain/usecases/get_user_tags.dart';

// ── State ──
enum TagsStatus { initial, loading, loaded, saving, error }

class UserTagsState extends Equatable {
  final List<Tag> tags;
  final List<SavedSearchEntity> savedSearches;
  final String filterMode; // 'all' | 'created_by_me'
  final String searchQuery;
  final String? selectedId;
  final TagsStatus status;
  final String? errorMessage;

  const UserTagsState({
    this.tags = const [],
    this.savedSearches = const [],
    this.filterMode = 'all',
    this.searchQuery = '',
    this.selectedId,
    this.status = TagsStatus.initial,
    this.errorMessage,
  });

  UserTagsState copyWith({
    List<Tag>? tags,
    List<SavedSearchEntity>? savedSearches,
    String? filterMode,
    String? searchQuery,
    String? selectedId,
    TagsStatus? status,
    String? errorMessage,
  }) {
    return UserTagsState(
      tags: tags ?? this.tags,
      savedSearches: savedSearches ?? this.savedSearches,
      filterMode: filterMode ?? this.filterMode,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedId: selectedId,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        tags,
        savedSearches,
        filterMode,
        searchQuery,
        selectedId,
        status,
        errorMessage,
      ];
}

// ── Cubit ──
class UserTagsCubit extends Cubit<UserTagsState> {
  final GetUserTagsUseCase _getUserTags;
  final GetSavedSearchesUseCase _getSavedSearches;
  final CreateSavedSearchUseCase _createSavedSearch;
  final DeleteSavedSearchUseCase _deleteSavedSearch;

  String _userId = '';

  UserTagsCubit({
    required GetUserTagsUseCase getUserTags,
    required GetSavedSearchesUseCase getSavedSearches,
    required CreateSavedSearchUseCase createSavedSearch,
    required DeleteSavedSearchUseCase deleteSavedSearch,
  })  : _getUserTags = getUserTags,
        _getSavedSearches = getSavedSearches,
        _createSavedSearch = createSavedSearch,
        _deleteSavedSearch = deleteSavedSearch,
        super(const UserTagsState());

  Future<void> loadData(String userId) async {
    _userId = userId;
    emit(state.copyWith(status: TagsStatus.loading));

    final tagsResult = await _getUserTags(
      params: GetUserTagsParams(userId: userId),
    );
    final searchesResult = await _getSavedSearches(
      params: GetSavedSearchesParams(userId: userId),
    );

    String? errorMessage;
    List<Tag> tags = const [];
    List<SavedSearchEntity> savedSearches = const [];

    tagsResult.fold(
      (f) => errorMessage ??= f.message,
      (value) => tags = value,
    );
    searchesResult.fold(
      (f) => errorMessage ??= f.message,
      (value) => savedSearches = value,
    );

    if (errorMessage != null) {
      emit(state.copyWith(status: TagsStatus.error, errorMessage: errorMessage));
      return;
    }

    emit(
      state.copyWith(
        status: TagsStatus.loaded,
        tags: tags,
        savedSearches: savedSearches,
      ),
    );
  }

  Future<void> createSavedSearch({
    required String name,
    required String query,
  }) async {
    final result = await _createSavedSearch(
      params: CreateSavedSearchParams(
        search: SavedSearchEntity(
          id: '',
          userId: _userId,
          name: name,
          query: query,
        ),
      ),
    );

    result.fold(
      (f) => emit(state.copyWith(status: TagsStatus.error, errorMessage: f.message)),
      (created) => emit(
        state.copyWith(
          status: TagsStatus.loaded,
          savedSearches: [created, ...state.savedSearches],
          selectedId: created.id,
        ),
      ),
    );
  }

  Future<void> deleteSelected() async {
    final id = state.selectedId;
    if (id == null) return;

    final result = await _deleteSavedSearch(
      params: DeleteSavedSearchParams(searchId: id),
    );

    result.fold(
      (f) => emit(state.copyWith(status: TagsStatus.error, errorMessage: f.message)),
      (_) => emit(
        state.copyWith(
          status: TagsStatus.loaded,
          savedSearches: state.savedSearches
              .where((s) => s.id != id)
              .toList(),
          selectedId: null,
        ),
      ),
    );
  }

  void setFilter(String mode) {
    emit(state.copyWith(filterMode: mode));
  }

  void setSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  void selectItem(String? id) {
    emit(state.copyWith(selectedId: id));
  }

  bool isOwner(Tag tag) =>
      tag.ownerId == _userId || tag.createdBy == _userId;

  List<Tag> get filteredTags {
    var result = state.tags;
    if (state.filterMode == 'created_by_me') {
      result = result.where(isOwner).toList();
    }
    if (state.searchQuery.trim().isNotEmpty) {
      final q = state.searchQuery.trim().toLowerCase();
      result = result.where((t) => t.name.toLowerCase().contains(q)).toList();
    }
    return result;
  }

  List<SavedSearchEntity> get filteredSavedSearches {
    var result = state.savedSearches;
    if (state.searchQuery.trim().isNotEmpty) {
      final q = state.searchQuery.trim().toLowerCase();
      result = result
          .where((s) => s.name.toLowerCase().contains(q))
          .toList();
    }
    return result;
  }
}