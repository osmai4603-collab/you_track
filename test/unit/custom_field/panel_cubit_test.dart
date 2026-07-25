import 'package:flutter_test/flutter_test.dart';
import 'package:issues_tracking/features/custom_fields/presentation/cubits/cubits/custom_field_panel_cubit.dart';

void main() {
  group('CustomFieldPanelCubit', () {
    test('initial state should be panel closed', () {
      final cubit = CustomFieldPanelCubit();
      expect(cubit.state.isPanelOpen, false);
      cubit.close();
    });

    test('openPanel should set isPanelOpen to true', () async {
      final cubit = CustomFieldPanelCubit();
      cubit.openPanel();
      await Future.delayed(Duration(milliseconds: 350)); // Wait for animation
      expect(cubit.state.isPanelOpen, true);
      cubit.close();
    });

    test('closePanel should set isPanelOpen to false', () async {
      final cubit = CustomFieldPanelCubit();
      cubit.openPanel();
      await Future.delayed(Duration(milliseconds: 350));
      cubit.closePanel();
      await Future.delayed(Duration(milliseconds: 350));
      expect(cubit.state.isPanelOpen, false);
      cubit.close();
    });
  });
}