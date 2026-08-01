import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/features/custom_fields/domain/entities/custom_field_entity.dart';
import '../cubits/time_tracking_config_cubit.dart';

class FieldConfigurationSection extends StatelessWidget {
  final List<CustomFieldEntity> availableFields;

  const FieldConfigurationSection({super.key, required this.availableFields});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimeTrackingConfigCubit, TimeTrackingConfigState>(
      builder: (context, state) {
        if (state is! TimeTrackingConfigLoaded) {
          return const SizedBox.shrink();
        }

        final config = state.config;
        // final hasFields = availableFields.isNotEmpty;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Field Configuration',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            // if (!hasFields)
            //   Padding(
            //     padding: const EdgeInsets.only(bottom: 12),
            //     child: _buildNoFieldsMessage(context),
            //   ),
            SizedBox(
              width: 200,
              child: _buildEstimationFieldDropdown(
                context,
                config,
                availableFields,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 200,
              child: _buildSpentTimeFieldDropdown(context, config, availableFields),
            ),
            if (config.estimationFieldId != null &&
                config.spentTimeFieldId != null &&
                config.estimationFieldId == config.spentTimeFieldId)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'Estimation and Spent Time fields must be different',
                  style: TextStyle(color: Colors.orange, fontSize: 12),
                ),
              ),
          ],
        );
      },
    );
  }

  // Widget _buildNoFieldsMessage(BuildContext context) {
  //   return Container(
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: Theme.of(context).colorScheme.surfaceContainerHighest,
  //       borderRadius: BorderRadius.circular(8),
  //     ),
  //     child: Row(
  //       children: [
  //         const Icon(Icons.info_outline, size: 20),
  //         const SizedBox(width: 12),
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               const Text(
  //                 'No Period-type custom fields found',
  //                 style: TextStyle(fontWeight: FontWeight.w500),
  //               ),
  //               const SizedBox(height: 4),
  //               Text(
  //                 'Create a Period-type custom field first to configure time tracking.',
  //                 style: Theme.of(context).textTheme.bodySmall,
  //               ),
  //             ],
  //           ),
  //         ),
  //         TextButton(
  //           onPressed: () {
  //             // Navigate to custom fields settings
  //           },
  //           child: const Text('Add Field'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildEstimationFieldDropdown(
    BuildContext context,
    dynamic config,
    List<CustomFieldEntity> fields,
  ) {
    return DropdownButtonFormField<String>(
      initialValue: config.estimationFieldId,
      decoration: const InputDecoration(
        labelText: 'Estimation Field',
        border: OutlineInputBorder(),
      ),
      items: [
        const DropdownMenuItem<String>(value: null, child: Text('None')),
        ...fields.map(
          (field) => DropdownMenuItem<String>(
            value: field.id,
            child: Text(field.name),
          ),
        ),
      ],
      onChanged: (value) {
        context.read<TimeTrackingConfigCubit>().setEstimationField(value);
      },
    );
  }

  Widget _buildSpentTimeFieldDropdown(
    BuildContext context,
    dynamic config,
    List<CustomFieldEntity> fields,
  ) {
    return DropdownButtonFormField<String>(
      initialValue: config.spentTimeFieldId,
      decoration: const InputDecoration(
        labelText: 'Spent Time Field',
        border: OutlineInputBorder(),
      ),
      items: [
        const DropdownMenuItem<String>(value: null, child: Text('None')),
        ...fields.map(
          (field) => DropdownMenuItem<String>(
            value: field.id,
            child: Text(field.name),
          ),
        ),
      ],
      onChanged: (value) {
        context.read<TimeTrackingConfigCubit>().setSpentTimeField(value);
      },
    );
  }
}
