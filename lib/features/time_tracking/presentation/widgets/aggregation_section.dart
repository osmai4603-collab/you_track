import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/time_tracking_config_cubit.dart';

class AggregationSection extends StatelessWidget {
  const AggregationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimeTrackingConfigCubit, TimeTrackingConfigState>(
      builder: (context, state) {
        if (state is! TimeTrackingConfigLoaded) {
          return const SizedBox.shrink();
        }

        final config = state.config;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Subtask Aggregation',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              title: const Text('Aggregate Spent Time from Subtasks'),
              subtitle: const Text(
                'Sum up time entries from all subtasks and add to parent task',
              ),
              value: config.aggregateSpentTime,
              onChanged: (value) {
                context
                    .read<TimeTrackingConfigCubit>()
                    .setAggregateSpentTime(value);
              },
            ),
            SwitchListTile(
              title: const Text('Aggregate Estimation from Subtasks'),
              subtitle: const Text(
                'Sum up estimations from all subtasks and add to parent task',
              ),
              value: config.aggregateEstimation,
              onChanged: (value) {
                context
                    .read<TimeTrackingConfigCubit>()
                    .setAggregateEstimation(value);
              },
            ),
          ],
        );
      },
    );
  }
}
