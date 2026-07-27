import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fleather/fleather.dart';
import 'package:issues_tracking/features/knowledge_base/presentation/bloc/article_editor_bloc.dart';
import 'package:issues_tracking/features/knowledge_base/presentation/bloc/article_editor_event.dart';
import 'package:issues_tracking/features/knowledge_base/presentation/bloc/article_editor_state.dart';
import 'package:issues_tracking/features/knowledge_base/presentation/bloc/article_tree_bloc.dart';
import 'package:issues_tracking/features/knowledge_base/presentation/bloc/article_tree_state.dart';
import 'package:issues_tracking/features/knowledge_base/presentation/widgets/article_editor_widget.dart';

class ArticleEditorPage extends StatefulWidget {
  final String? articleId;
  final String? projectId;
  final String? createdBy;
  final String? parentId;

  const ArticleEditorPage({
    super.key,
    this.articleId,
    this.projectId,
    this.createdBy,
    this.parentId,
  });

  @override
  State<ArticleEditorPage> createState() => _ArticleEditorPageState();
}

class _ArticleEditorPageState extends State<ArticleEditorPage> {
  late ArticleEditorBloc _editorBloc;
  late FleatherController _controller;
  late TextEditingController _titleController;
  String _selectedVisibility = 'admin';
  String? _selectedParentId;

  @override
  void initState() {
    super.initState();
    _editorBloc = ArticleEditorBloc();
    _controller = FleatherController();
    _titleController = TextEditingController();

    _controller.addListener(_onEditorChanged);

    if (widget.articleId != null) {
      _editorBloc.add(LoadArticleForEdit(widget.articleId!));
    } else if (widget.projectId != null) {
      _editorBloc.add(
        CreateNewArticle(
          projectId: widget.projectId!,
          createdBy: widget.createdBy ?? '',
          parentId: widget.parentId,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onEditorChanged);
    _controller.dispose();
    _titleController.dispose();
    _editorBloc.close();
    super.dispose();
  }

  void _onEditorChanged() {
    final plainText = _controller.document.toPlainText();
    _editorBloc.add(UpdateArticleContent(plainText));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _editorBloc,
      child: BlocConsumer<ArticleEditorBloc, ArticleEditorState>(
        listener: _onStateChange,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                state is ArticleEditorLoaded && !state.isNewArticle
                    ? 'Edit Article'
                    : 'New Article',
              ),
              actions: [
                if (state is ArticleEditorLoaded && state.isSaving)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                if (state is ArticleEditorLoaded && state.isSaved)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Icon(Icons.check, color: Colors.green),
                  ),
              ],
            ),
            body: state is ArticleEditorLoading
                ? const Center(child: CircularProgressIndicator())
                : state is ArticleEditorError
                ? Center(child: Text(state.message))
                : _buildEditorBody(state),
          );
        },
      ),
    );
  }

  Widget _buildEditorBody(ArticleEditorState state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              hintText: 'Article Title',
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 8),
            ),
            style: Theme.of(context).textTheme.headlineSmall,
            onChanged: (value) {
              _editorBloc.add(UpdateArticleTitle(value));
            },
          ),
          const Divider(),
          _buildParentArticleSelector(),
          const SizedBox(height: 8),
          _buildVisibilitySelector(),
          const SizedBox(height: 8),
          Expanded(
            child: ArticleEditorWidget(
              controller: _controller,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParentArticleSelector() {
    return BlocBuilder<ArticleTreeBloc, ArticleTreeState>(
      builder: (context, treeState) {
        if (treeState is! ArticleTreeLoaded) {
          return const SizedBox.shrink();
        }

        final currentArticleId = widget.articleId;
        final publishedArticles = treeState.articles
            .where((a) => a.status == 'published' && a.id != currentArticleId)
            .toList();

        final items = <DropdownMenuItem<String>>[
          const DropdownMenuItem(
            value: null,
            child: Text('None (Root)'),
          ),
          ...publishedArticles.map((article) {
            return DropdownMenuItem(
              value: article.id,
              child: Text(
                article.title.isEmpty ? 'Untitled' : article.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }),
        ];

        return DropdownButtonFormField<String>(
          initialValue: _selectedParentId,
          decoration: const InputDecoration(
            labelText: 'Parent Article',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          items: items,
          onChanged: (value) {
            setState(() => _selectedParentId = value);
          },
        );
      },
    );
  }

  Widget _buildVisibilitySelector() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedVisibility,
      decoration: const InputDecoration(
        labelText: 'Visibility',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: const [
        DropdownMenuItem(value: 'admin', child: Text('Admin Only')),
        DropdownMenuItem(value: 'developer', child: Text('Developers')),
        DropdownMenuItem(value: 'visitor', child: Text('All Visitors')),
      ],
      onChanged: (value) {
        if (value != null) {
          setState(() => _selectedVisibility = value);
        }
      },
    );
  }

  void _onStateChange(BuildContext context, ArticleEditorState state) {
    if (state is ArticleEditorLoaded && state.article != null) {
      if (_titleController.text.isEmpty) {
        _titleController.text = state.title;
      }
    }
  }
}
