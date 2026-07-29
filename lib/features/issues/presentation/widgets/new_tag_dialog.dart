import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/localization/app_localizations.dart';
import 'package:get_it/get_it.dart';
import '../../domain/entities/tag.dart';
import '../cubits/new_tag_cubit.dart';
import '../cubits/new_tag_state.dart';
import 'new_tag_form.dart';

class NewTagDialog extends StatelessWidget {
  final String projectId;
  final String? currentIssueId;

  const NewTagDialog({
    super.key,
    required this.projectId,
    this.currentIssueId,
  });

  static Future<Tag?> show(
    BuildContext context, {
    required String projectId,
    String? currentIssueId,
  }) {
    return showDialog<Tag>(
      context: context,
      barrierDismissible: true,
      builder: (context) => NewTagDialog(
        projectId: projectId,
        currentIssueId: currentIssueId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (context) => GetIt.I<NewTagCubit>(),
      child: BlocConsumer<NewTagCubit, NewTagState>(
        listener: (context, state) {
          if (state.status == NewTagStatus.success) {
            Navigator.pop(context, state.createdTag);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Tag created successfully')),
            );
          } else if (state.status == NewTagStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: SelectableText(state.errorMessage ?? 'Failed to create tag')),
            );
          }
        },
        builder: (context, state) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(localization.newTagTitle),
                IconButton(
                  onPressed: state.status == NewTagStatus.submitting
                      ? null
                      : () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            titlePadding: const EdgeInsets.fromLTRB(24, 8, 8, 0),
            content: SizedBox(
              width: 400,
              child: SingleChildScrollView(
                child: NewTagForm(
                  projectId: projectId,
                  currentIssueId: currentIssueId,
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: state.status == NewTagStatus.submitting
                    ? null
                    : () => Navigator.pop(context),
                child: Text(localization.cancelButton),
              ),
              FilledButton(
                onPressed: state.status == NewTagStatus.submitting
                    ? null
                    : () {
                        context.read<NewTagCubit>().createTag(
                              projectId: projectId,
                              currentIssueId: currentIssueId,
                            );
                      },
                child: state.status == NewTagStatus.submitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(localization.createButton),
              ),
            ],
          );
        },
      ),
    );
  }
}
