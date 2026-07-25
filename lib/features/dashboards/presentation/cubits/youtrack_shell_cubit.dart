import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class YouTrackShellState extends Equatable {
  final String currentPath;
  final String searchQuery;

  const YouTrackShellState({
    this.currentPath = '',
    this.searchQuery = '',
  });

  @override
  List<Object?> get props => [currentPath, searchQuery];

  YouTrackShellState copyWith({
    String? currentPath,
    String? searchQuery,
  }) {
    return YouTrackShellState(
      currentPath: currentPath ?? this.currentPath,
      searchQuery: searchQuery ?? this.searchQuery,
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
}
