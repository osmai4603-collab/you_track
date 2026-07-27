import 'package:equatable/equatable.dart';

abstract class ArticleEditorEvent extends Equatable {
  const ArticleEditorEvent();
  @override
  List<Object?> get props => [];
}

class CreateNewArticle extends ArticleEditorEvent {
  final String projectId;
  final String createdBy;
  final String? parentId;
  const CreateNewArticle({required this.projectId, required this.createdBy, this.parentId});
  @override
  List<Object?> get props => [projectId, createdBy, parentId];
}

class UpdateArticleTitle extends ArticleEditorEvent {
  final String title;
  const UpdateArticleTitle(this.title);
  @override
  List<Object?> get props => [title];
}

class UpdateArticleContent extends ArticleEditorEvent {
  final String content;
  const UpdateArticleContent(this.content);
  @override
  List<Object?> get props => [content];
}

class PublishCurrentArticle extends ArticleEditorEvent {
  const PublishCurrentArticle();
}

class AutosaveDraft extends ArticleEditorEvent {
  const AutosaveDraft();
}

class LoadDraft extends ArticleEditorEvent {
  final String articleId;
  const LoadDraft(this.articleId);
  @override
  List<Object?> get props => [articleId];
}

class LoadArticleForEdit extends ArticleEditorEvent {
  final String articleId;
  const LoadArticleForEdit(this.articleId);
  @override
  List<Object?> get props => [articleId];
}
