import 'app_enum.dart';
import 'package:issues_tracking/core/localization/app_localizations.dart';

sealed class IssueStateEnum extends AppEnum {
  const IssueStateEnum();

  static const toDo = ToDoState._();
  static const inProgress = InProgressState._();
  static const done = DoneState._();

  static List<IssueStateEnum> get values => [toDo, inProgress, done];

  static IssueStateEnum of(String name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw ArgumentError('Unknown IssueStateEnum: $name'),
    );
  }
}

final class ToDoState extends IssueStateEnum {
  const ToDoState._();

  @override
  String get name => 'to-do';

  @override
  int get index => 0;

  @override
  String displayName(AppLocalizations localization) => localization.stateToDo;
}

final class InProgressState extends IssueStateEnum {
  const InProgressState._();

  @override
  String get name => 'in-progress';

  @override
  int get index => 1;

  @override
  String displayName(AppLocalizations localization) =>
      localization.stateInProgress;
}

final class DoneState extends IssueStateEnum {
  const DoneState._();

  @override
  String get name => 'done';

  @override
  int get index => 2;

  @override
  String displayName(AppLocalizations localization) => localization.stateDone;
}
