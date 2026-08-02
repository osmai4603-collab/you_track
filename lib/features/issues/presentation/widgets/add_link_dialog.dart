import 'package:flutter/material.dart';
import 'package:issues_tracking/core/enums/issue_link_type.dart';
import 'package:issues_tracking/core/localization/app_localizations.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue_link.dart';

class AddLinkDialog extends StatefulWidget {
  final String? currentIssueId;
  final Function(IssueLink) onSave;

  const AddLinkDialog({super.key, this.currentIssueId, required this.onSave});

  static Future<void> show(
    BuildContext context, {
    String? currentIssueId,
    required Function(IssueLink) onSave,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AddLinkDialog(
        currentIssueId: currentIssueId,
        onSave: onSave,
      ),
    );
  }

  @override
  State<AddLinkDialog> createState() => _AddLinkDialogState();
}

class _AddLinkDialogState extends State<AddLinkDialog> {
  late TextEditingController _issueLinkedIdController;
  IssueLinkType _selectedLinkType = IssueLinkType.relatesTo;

  @override
  void initState() {
    super.initState();
    _issueLinkedIdController = TextEditingController();
  }

  @override
  void dispose() {
    _issueLinkedIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final localization = AppLocalizations.of(context)!;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Link',
              style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildLabel('Link type'),
            DropdownButtonFormField<IssueLinkType>(
              initialValue: _selectedLinkType,
              isExpanded: true,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                border: OutlineInputBorder(),
              ),
              items: IssueLinkType.values.map((linkType) {
                return DropdownMenuItem(
                  value: linkType,
                  child: Text(linkType.displayName(localization)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedLinkType = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            _buildLabel('Issue'),
            TextFormField(
              controller: _issueLinkedIdController,
              decoration: const InputDecoration(
                hintText: 'Enter issue key (e.g., DEM-123)',
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  onPressed: () {
                    final linkedId = _issueLinkedIdController.text.trim();
                    if (linkedId.isEmpty) return;

                    final link = IssueLink(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      issueId: widget.currentIssueId ?? '',
                      linkType: _selectedLinkType,
                      issueLinkedId: linkedId,
                    );
                    
                    widget.onSave(link);
                    Navigator.pop(context);
                  },
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                  child: const Text('Add'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
    );
  }
}
