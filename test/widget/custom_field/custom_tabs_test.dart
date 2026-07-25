import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:issues_tracking/features/custom_fields/presentation/widgets/custom_tab_bar.dart';
import 'package:issues_tracking/features/custom_field/domain/entities/field_type.dart';

void main() {
  group('CustomTabBar', () {
    testWidgets('should display all field type tabs', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: CustomTabBar(
            selectedType: FieldType.build,
            onTypeSelected: (_) {},
          ),
        ),
      ));

      // Expect to find tabs for each FieldType
      for (final type in FieldType.values) {
        expect(find.text(type.value), findsOneWidget);
      }
    });

    testWidgets('should call onTypeSelected when tab tapped', (WidgetTester tester) async {
      FieldType? selectedType;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: CustomTabBar(
            selectedType: FieldType.build,
            onTypeSelected: (type) => selectedType = type,
          ),
        ),
      ));

      // Tap on enum tab
      await tester.tap(find.text('enum'));
      await tester.pumpAndSettle();
      expect(selectedType, FieldType.enumField);
    });
  });
}