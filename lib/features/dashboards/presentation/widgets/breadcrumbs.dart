import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Breadcrumbs extends StatelessWidget {
  final String path;

  const Breadcrumbs({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    final segments = path.split('/').where((s) => s.isNotEmpty).toList();
    
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          textDirection: TextDirection.ltr,
          children: [
            for (int i = 0; i < segments.length; i++) ...[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('/', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ),
              _BreadcrumbItem(
                label: _formatSegment(segments[i]),
                onTap: () {
                  final targetPath = '/${segments.sublist(0, i + 1).join('/')}';
                  context.go(targetPath);
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatSegment(String segment) {
    if (segment.isEmpty) return '';
    // Basic formatting: capitalize and replace dashes with spaces
    final formatted = segment.replaceAll('-', ' ');
    return formatted[0].toUpperCase() + formatted.substring(1);
  }
}

class _BreadcrumbItem extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _BreadcrumbItem({required this.label, required this.onTap});

  @override
  State<_BreadcrumbItem> createState() => _BreadcrumbItemState();
}

class _BreadcrumbItemState extends State<_BreadcrumbItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Text(
          widget.label,
          style: TextStyle(
            color: _isHovered ? Colors.red : Colors.grey[600],
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
