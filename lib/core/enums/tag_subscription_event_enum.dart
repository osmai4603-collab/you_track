import 'app_enum.dart';
import 'package:issues_tracking/core/localization/app_localizations.dart';

sealed class TagSubscriptionEvent extends AppEnum {
  const TagSubscriptionEvent();

  static const updates = TagUpdatesEvent._();
  static const comments = TagCommentsEvent._();
  static const tagAdded = TagAddedEvent._();
  static const spentTime = TagSpentTimeEvent._();
  static const issueResolved = TagIssueResolvedEvent._();
  static const votes = TagVotesEvent._();
  static const tagRemoved = TagRemovedEvent._();

  static List<TagSubscriptionEvent> get values => [
        updates,
        comments,
        tagAdded,
        spentTime,
        issueResolved,
        votes,
        tagRemoved,
      ];

  static TagSubscriptionEvent of(String name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => updates,
    );
  }
}

final class TagUpdatesEvent extends TagSubscriptionEvent {
  const TagUpdatesEvent._();

  @override
  String get name => 'updates';

  @override
  int get index => 0;

  @override
  String displayName(AppLocalizations localization) => localization.tagEventUpdates;
}

final class TagCommentsEvent extends TagSubscriptionEvent {
  const TagCommentsEvent._();

  @override
  String get name => 'comments';

  @override
  int get index => 1;

  @override
  String displayName(AppLocalizations localization) => localization.tagEventComments;
}

final class TagAddedEvent extends TagSubscriptionEvent {
  const TagAddedEvent._();

  @override
  String get name => 'tag_added';

  @override
  int get index => 2;

  @override
  String displayName(AppLocalizations localization) => localization.tagEventTagAdded;
}

final class TagSpentTimeEvent extends TagSubscriptionEvent {
  const TagSpentTimeEvent._();

  @override
  String get name => 'spent_time';

  @override
  int get index => 3;

  @override
  String displayName(AppLocalizations localization) => localization.tagEventSpentTime;
}

final class TagIssueResolvedEvent extends TagSubscriptionEvent {
  const TagIssueResolvedEvent._();

  @override
  String get name => 'issue_resolved';

  @override
  int get index => 4;

  @override
  String displayName(AppLocalizations localization) => localization.tagEventIssueResolved;
}

final class TagVotesEvent extends TagSubscriptionEvent {
  const TagVotesEvent._();

  @override
  String get name => 'votes';

  @override
  int get index => 5;

  @override
  String displayName(AppLocalizations localization) => localization.tagEventVotes;
}

final class TagRemovedEvent extends TagSubscriptionEvent {
  const TagRemovedEvent._();

  @override
  String get name => 'tag_removed';

  @override
  int get index => 6;

  @override
  String displayName(AppLocalizations localization) => localization.tagEventTagRemoved;
}
