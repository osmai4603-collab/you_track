import 'package:issues_tracking/core/entities/entity.dart';
import 'package:issues_tracking/core/enums/tag_subscription_event_enum.dart';

class TagSubscription extends Entity {
  final String id;
  final String tagId;
  final TagSubscriptionEvent eventType;

  const TagSubscription({
    required this.id,
    required this.tagId,
    required this.eventType,
  });

  @override
  TagSubscription copyWith({
    String? id,
    String? tagId,
    TagSubscriptionEvent? eventType,
  }) {
    return TagSubscription(
      id: id ?? this.id,
      tagId: tagId ?? this.tagId,
      eventType: eventType ?? this.eventType,
    );
  }

  @override
  List<Object?> get props => [id, tagId, eventType];
}
