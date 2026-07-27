import 'package:equatable/equatable.dart';
import 'package:issues_tracking/features/knowledge_base/domain/entities/article.dart';

abstract class ArticleEditorState extends Equatable {
  const ArticleEditorState();

  @override
  List<Object?> get props => [];
}

class ArticleEditorInitial extends ArticleEditorState {}

class ArticleEditorLoading extends ArticleEditorState {}

class ArticleEditorLoaded extends ArticleEditorState {
  final Article? article;
  final String title;
  final String content;
  final bool isSaving;
  final bool isSaved;

  const ArticleEditorLoaded({
    this.article,
    this.title = '',
    this.content = '',
    this.isSaving = false,
    this.isSaved = false,
  });

  bool get isNewArticle => article == null;

  ArticleEditorLoaded copyWith({
    Article? article,
    bool clearArticle = false,
    String? title,
    String? content,
    bool? isSaving,
    bool? isSaved,
  }) {
    return ArticleEditorLoaded(
      article: clearArticle ? null : (article ?? this.article),
      title: title ?? this.title,
      content: content ?? this.content,
      isSaving: isSaving ?? this.isSaving,
      isSaved: isSaved ?? this.isSaved,
    );
  }

  @override
  List<Object?> get props => [article, title, content, isSaving, isSaved];
}

class ArticleEditorError extends ArticleEditorState {
  final String message;

  const ArticleEditorError(this.message);

  @override
  List<Object?> get props => [message];
}
