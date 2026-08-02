import 'package:flutter/material.dart';
import 'package:issues_tracking/core/enums/issue_link_type.dart';
import 'package:issues_tracking/core/localization/app_localizations.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue.dart';

class IssueLinkForm extends StatefulWidget {
  final String issueId;
  const IssueLinkForm({super.key, required this.issueId});

  @override
  State<IssueLinkForm> createState() => _IssueLinkFormState();
}

class _IssueLinkFormState extends State<IssueLinkForm> {
  IssueLinkType linkTypeSelected = IssueLinkType.relatesTo;
  List<Issue> recentIssues = [];

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    final colors = ColorScheme.of(context);
    final localization = AppLocalizations.of(context)!;
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            spacing: 8,
            crossAxisAlignment: .start,
            children: [
              Text(
                'Add Link',
                style: textTheme.titleLarge?.copyWith(fontWeight: .bold),
              ),
              Row(
                spacing: 8,
                children: [
                  Text('Select a link type'),
                  SizedBox(
                    width: 200,
                    child: DropdownButtonFormField<IssueLinkType>(
                      initialValue: linkTypeSelected,
                      onChanged: _onLinkTypeSelected,

                      items: IssueLinkType.values.map((linkType) {
                        return DropdownMenuItem(
                          value: linkType,
                          child: Text(linkType.displayName(localization)),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              Row(
                spacing: 8,
                children: [
                  Text('Find link targets'),
                  Expanded(
                    child: DropdownButtonFormField<IssueLinkType>(
                      initialValue: linkTypeSelected,
                      onChanged: _onLinkTypeSelected,
                      hint: Text(
                        'Type to find matching issues and tickets or enter an ID',
                      ),

                      items: IssueLinkType.values.map((linkType) {
                        return DropdownMenuItem(
                          value: linkType,
                          child: Text(linkType.displayName(localization)),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              Divider(height: 24),
              Divider(height: 16),
              Text(
                'This draft will be linked as "${linkTypeSelected.displayName(localization)}" to selected targets',
              ),
              Row(
                children: [
                  FilledButton(child: Text('Add'), onPressed: () {}),
                  TextButton(child: Text('Cancel'), onPressed: () {}),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onLinkTypeSelected(IssueLinkType? value) {}
}
