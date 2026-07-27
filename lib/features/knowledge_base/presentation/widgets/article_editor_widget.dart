import 'package:flutter/material.dart';
import 'package:fleather/fleather.dart';

class ArticleEditorWidget extends StatefulWidget {
  final FleatherController controller;

  const ArticleEditorWidget({
    super.key,
    required this.controller,
  });

  @override
  State<ArticleEditorWidget> createState() => _ArticleEditorWidgetState();
}

class _ArticleEditorWidgetState extends State<ArticleEditorWidget> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FleatherToolbar.basic(controller: widget.controller),
        const Divider(height: 1),
        Expanded(
          child: FleatherEditor(
            controller: widget.controller,
            focusNode: _focusNode,
          ),
        ),
      ],
    );
  }
}
