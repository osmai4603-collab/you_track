import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/enums/tag_subscription_event_enum.dart';
import 'package:issues_tracking/core/localization/app_localizations.dart';
import '../cubits/new_tag_cubit.dart';
import '../cubits/new_tag_state.dart';

class TagSubscriptionsSection extends StatelessWidget {
  const TagSubscriptionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return BlocBuilder<NewTagCubit, NewTagState>(
      builder: (context, state) {
        return Column(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                title: Text(
                  localization.subscriptionsTitle,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                tilePadding: EdgeInsets.zero,
                children: [
                  Wrap(
                    spacing: 8,
                    children: TagSubscriptionEvent.values.map((event) {
                      final isSelected = state.subscriptions.contains(event);
                      return FilterChip(
                        label: Text(event.displayName(localization)),
                        selected: isSelected,
                        onSelected: (selected) {
                          context.read<NewTagCubit>().toggleSubscription(event);
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
