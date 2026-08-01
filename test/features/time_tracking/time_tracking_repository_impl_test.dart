import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:issues_tracking/features/time_tracking/data/datasources/time_tracking_remote_data_source.dart';
import 'package:issues_tracking/features/time_tracking/data/repositories/time_tracking_repository_impl.dart';

class MockTimeTrackingRemoteDataSource extends Mock
    implements TimeTrackingRemoteDataSource {}

void main() {
  late MockTimeTrackingRemoteDataSource mockRemoteDataSource;
  late TimeTrackingRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockTimeTrackingRemoteDataSource();
    repository = TimeTrackingRepositoryImpl(mockRemoteDataSource);
  });

  test('returns a default config when the Supabase table is missing', () async {
    when(() => mockRemoteDataSource.getTimeTrackingConfig('project-1'))
        .thenThrow(
      const PostgrestException(
        message: 'Could not find the table \'public.time_tracking_configs\' in the schema cache',
        code: 'PGRST205',
        details: null,
        hint: null,
      ),
    );

    final result = await repository.getTimeTrackingConfig('project-1');

    expect(result.isRight(), isTrue);
    result.fold(
      (failure) => fail('Expected a default config, got failure: ${failure.message}'),
      (config) {
        expect(config.projectId, 'project-1');
        expect(config.enabled, isFalse);
      },
    );
  });
}
