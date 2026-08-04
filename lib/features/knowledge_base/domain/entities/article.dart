import 'package:issues_tracking/core/entities/entity.dart';

class Article extends Entity {
  final String id;
  final String projectId;
  final String? parentId;
  final String title;
  final String contentMarkdown;
  final String status;
  final List<String> visibility;
  final int sortOrder;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Article({
    required this.id,
    required this.projectId,
    this.parentId,
    required this.title,
    this.contentMarkdown = '',
    this.status = 'draft',
    this.visibility = const ['admin', 'developer', 'visitor'],
    this.sortOrder = 0,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  Article copyWith({
    String? id,
    String? projectKey,
    String? parentId,
    bool clearParentId = false,
    String? title,
    String? contentMarkdown,
    String? status,
    List<String>? visibility,
    int? sortOrder,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Article(
      id: id ?? this.id,
      projectId: projectKey ?? this.projectId,
      parentId: clearParentId ? null : (parentId ?? this.parentId),
      title: title ?? this.title,
      contentMarkdown: contentMarkdown ?? this.contentMarkdown,
      status: status ?? this.status,
      visibility: visibility ?? this.visibility,
      sortOrder: sortOrder ?? this.sortOrder,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    projectId,
    parentId,
    title,
    contentMarkdown,
    status,
    visibility,
    sortOrder,
    createdBy,
    createdAt,
    updatedAt,
  ];
}
