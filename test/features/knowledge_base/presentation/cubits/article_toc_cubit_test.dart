import 'package:flutter_test/flutter_test.dart';
import 'package:issues_tracking/features/knowledge_base/presentation/cubits/article_toc_cubit.dart';

void main() {
  group('ArticleTocCubit', () {
    late ArticleTocCubit cubit;

    setUp(() {
      cubit = ArticleTocCubit();
    });

    tearDown(() => cubit.close());

    test('initial state is TocInitial', () {
      expect(cubit.state, isA<TocInitial>());
    });

    group('extractHeadings', () {
      test('emits TocLoaded with headings when markdown has headings', () {
        const markdown = '''
# Introduction
Some text here.
## Getting Started
More text.
### Advanced Topics
Final text.
''';

        cubit.extractHeadings(markdown);

        expect(cubit.state, isA<TocLoaded>());
        final loaded = cubit.state as TocLoaded;
        expect(loaded.headings.length, 3);
        expect(loaded.headings[0], '# Introduction');
        expect(loaded.headings[1], '## Getting Started');
        expect(loaded.headings[2], '### Advanced Topics');
      });

      test('emits TocEmpty when markdown has no headings', () {
        cubit.extractHeadings('Just some plain text without headings.');

        expect(cubit.state, isA<TocEmpty>());
      });

      test('emits TocEmpty for empty markdown', () {
        cubit.extractHeadings('');

        expect(cubit.state, isA<TocEmpty>());
      });
    });
  });
}
