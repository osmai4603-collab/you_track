import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/features/knowledge_base/presentation/cubits/article_toc_cubit.dart';

class ArticleTocPanel extends StatelessWidget {
  const ArticleTocPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 1024) {
          return const SizedBox.shrink();
        }

        return BlocBuilder<ArticleTocCubit, ArticleTocState>(
          builder: (context, state) {
            if (state is! TocLoaded) {
              return const SizedBox.shrink();
            }

            return Container(
              width: 220,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'On this page',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.headings.length,
                      itemBuilder: (context, index) {
                        final heading = state.headings[index];
                        final depth = _getHeadingDepth(heading);

                        return InkWell(
                          onTap: () {
                            context
                                .read<ArticleTocCubit>()
                                .scrollToHeading(index);
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: depth * 12.0,
                              top: 6,
                              bottom: 6,
                            ),
                            child: Text(
                              _cleanHeading(heading),
                              style: TextStyle(
                                fontSize: 13 - depth * 0.5,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  int _getHeadingDepth(String heading) {
    int depth = 0;
    for (final char in heading.runes) {
      if (char == 0x23) {
        depth++;
      } else {
        break;
      }
    }
    return depth - 1;
  }

  String _cleanHeading(String heading) {
    return heading.replaceFirst(RegExp(r'^#+\s*'), '');
  }
}
