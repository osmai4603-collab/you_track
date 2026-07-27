part of 'vcs_integrations_cubit.dart';

abstract class VcsIntegrationsState extends Equatable {
  const VcsIntegrationsState();

  @override
  List<Object?> get props => [];
}

class VcsIntegrationsInitial extends VcsIntegrationsState {
  const VcsIntegrationsInitial();
}

class VcsIntegrationsLoading extends VcsIntegrationsState {
  const VcsIntegrationsLoading();
}

class VcsIntegrationsLoaded extends VcsIntegrationsState {
  final List<VcsIntegrationEntity> integrations;

  const VcsIntegrationsLoaded(this.integrations);

  @override
  List<Object?> get props => [integrations];
}

class VcsIntegrationsError extends VcsIntegrationsState {
  final String message;

  const VcsIntegrationsError(this.message);

  @override
  List<Object?> get props => [message];
}
