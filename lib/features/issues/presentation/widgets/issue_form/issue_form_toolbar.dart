import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fleather/fleather.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue_attachment.dart';
import 'package:issues_tracking/features/issues/presentation/cubits/issue_form_cubit.dart';
import 'package:issues_tracking/features/issues/presentation/cubits/issue_form_state.dart';

class IssueFormToolbar extends StatelessWidget {
  final FleatherController controller;

  const IssueFormToolbar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IssueFormCubit, IssueFormState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Row(
            children: [
              Expanded(child: FleatherToolbar.basic(controller: controller)),
              Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border(left: BorderSide(color: Colors.grey.shade300)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _FormatToggle(
                      label: 'Visual',
                      isSelected:
                          state.descriptionFormat == DescriptionFormat.visual,
                      onTap: () => context
                          .read<IssueFormCubit>()
                          .updateDescriptionFormat(DescriptionFormat.visual),
                    ),
                    _FormatToggle(
                      label: 'Markdown',
                      isSelected:
                          state.descriptionFormat == DescriptionFormat.markdown,
                      onTap: () => context
                          .read<IssueFormCubit>()
                          .updateDescriptionFormat(DescriptionFormat.markdown),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FormatToggle extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FormatToggle({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.blue.withValues(alpha: 0.1)
              : Colors.transparent,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? Colors.blue : Colors.grey,
          ),
        ),
      ),
    );
  }
}
