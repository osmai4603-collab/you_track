import 'package:flutter_test/flutter_test.dart';
import 'package:issues_tracking/features/custom_fields/presentation/cubits/cubits/tab_selection_cubit.dart';
import 'package:issues_tracking/features/custom_field/domain/entities/field_type.dart';

void main() {
  group('TabSelectionCubit', () {
    test('initial state should be FieldType.build', () {
      final cubit = TabSelectionCubit();
      expect(cubit.state.selectedType, FieldType.build);
      cubit.close();
    });

    test('selectType should update selectedType', () {
      final cubit = TabSelectionCubit();
      cubit.selectType(FieldType.enumField);
      expect(cubit.state.selectedType, FieldType.enumField);
      cubit.close();
    });
  });
}