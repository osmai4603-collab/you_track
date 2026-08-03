import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
// import 'package:issues_tracking/core/init_dependencies.dart';
import 'package:issues_tracking/features/projects/domain/usecases/get_subsystems_use_case.dart';

void main() {
  late GetIt getIt;

  setUp(() {
    getIt = GetIt.instance;
    getIt.reset();
  });

  test('registers subsystem use cases for the projects feature', () {
    // registerProjectsFeatureDependencies(getIt, isOffline: false);

    expect(getIt.isRegistered<AddSubsystemUseCase>(), isTrue);
    expect(getIt.isRegistered<GetSubsystemsUseCase>(), isTrue);
  });
}
