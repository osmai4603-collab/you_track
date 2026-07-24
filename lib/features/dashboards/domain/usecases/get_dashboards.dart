import 'package:fpdart/fpdart.dart';
import 'package:issues_tracking/core/errors/failure.dart';
import 'package:issues_tracking/core/usecase/usecase.dart';
import 'package:issues_tracking/features/dashboards/domain/entities/dashboard.dart';
import 'package:issues_tracking/features/dashboards/domain/repositories/dashboard_repository.dart';

class GetDashboards implements UseCase<List<Dashboard>, NoParams> {
  final DashboardRepository repository;

  GetDashboards(this.repository);

  @override
  Future<Either<Failure, List<Dashboard>>> call({
    NoParams params = const NoParams(),
  }) async {
    return await repository.getDashboards();
  }
}
