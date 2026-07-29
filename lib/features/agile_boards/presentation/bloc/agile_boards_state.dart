import 'package:equatable/equatable.dart';
import 'package:issues_tracking/features/agile_boards/domain/entities/agile_board.dart';

abstract class AgileBoardsState extends Equatable {
  const AgileBoardsState();

  @override
  List<Object?> get props => [];
}

class AgileBoardsInitial extends AgileBoardsState {}

class AgileBoardsLoading extends AgileBoardsState {}

class AgileBoardsLoaded extends AgileBoardsState {
  final AgileBoard board;

  const AgileBoardsLoaded({required this.board});

  @override
  List<Object?> get props => [board];
}

class AgileBoardsError extends AgileBoardsState {
  final String message;

  const AgileBoardsError({required this.message});

  @override
  List<Object?> get props => [message];
}
