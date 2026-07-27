import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/features/knowledge_base/domain/usecases/search_articles.dart';

abstract class ArticleSearchState extends Equatable {
  const ArticleSearchState();
  @override
  List<Object?> get props => [];
}

class ArticleSearchInitial extends ArticleSearchState {}

class ArticleSearchLoading extends ArticleSearchState {}

class ArticleSearchLoaded extends ArticleSearchState {
  final List<dynamic> articles;
  final String query;

  const ArticleSearchLoaded({required this.articles, required this.query});

  @override
  List<Object?> get props => [articles, query];
}

class ArticleSearchEmpty extends ArticleSearchState {
  final String query;
  const ArticleSearchEmpty(this.query);

  @override
  List<Object?> get props => [query];
}

class ArticleSearchError extends ArticleSearchState {
  final String message;
  const ArticleSearchError(this.message);

  @override
  List<Object?> get props => [message];
}

class ArticleSearchCubit extends Cubit<ArticleSearchState> {
  final SearchArticles searchArticles;

  ArticleSearchCubit({required this.searchArticles})
      : super(ArticleSearchInitial());

  Future<void> search(String projectId, String query) async {
    if (query.trim().isEmpty) {
      emit(ArticleSearchInitial());
      return;
    }

    emit(ArticleSearchLoading());
    final result = await searchArticles(
      params: SearchArticlesParams(projectId: projectId, query: query),
    );
    result.fold(
      (failure) => emit(ArticleSearchError(failure.message)),
      (articles) {
        if (articles.isEmpty) {
          emit(ArticleSearchEmpty(query));
        } else {
          emit(ArticleSearchLoaded(articles: articles, query: query));
        }
      },
    );
  }

  void clearSearch() {
    emit(ArticleSearchInitial());
  }
}
