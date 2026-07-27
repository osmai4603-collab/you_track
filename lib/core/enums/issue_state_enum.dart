import 'app_enum.dart';
import 'package:issues_tracking/core/localization/app_localizations.dart';

sealed class IssueStateEnum extends AppEnum {
  const IssueStateEnum();

  static const toDo = ToDoState._();
  static const inProgress = InProgressState._();
  static const done = DoneState._();

  static List<IssueStateEnum> get values => [toDo, inProgress, done];

  int get color;

  static IssueStateEnum of(String name) {
    return values.firstWhere((e) => e.name == name, orElse: () => toDo);
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

  @override
  int get color => 0xFF546E7A;
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

  @override
  int get color => 0xFFFFAB40;
}

final class DoneState extends IssueStateEnum {
  const DoneState._();

  @override
  String get name => 'done';

  @override
  int get index => 2;

  @override
  String displayName(AppLocalizations localization) => localization.stateDone;

  @override
  int get color => 0xFF388E3C;
}
