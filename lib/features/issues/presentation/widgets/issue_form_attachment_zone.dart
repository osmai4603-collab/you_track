import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:issues_tracking/features/issues/domain/entities/issue_attachment.dart';
import 'package:issues_tracking/features/issues/presentation/cubits/issue_form_cubit.dart';

class IssueFormAttachmentZone extends StatelessWidget {
  const IssueFormAttachmentZone({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<IssueFormCubit>();
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => _pickFiles(context),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: Colors.grey.shade300,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.attach_file, color: Colors.grey.shade600),
                    const SizedBox(width: 8),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 14,
                        ),
                        children: [
                          const TextSpan(text: 'Click to '),
                          TextSpan(
                            text: 'browse',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const TextSpan(text: ' or drag files here'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (cubit.attachments.isNotEmpty) ...[
              const SizedBox(height: 8),
              ...cubit.attachments.map(
                (attachment) => _AttachmentItem(attachment: attachment),
              ),
            ],
          ],
        );
  }

  void _pickFiles(BuildContext context) async {
    final result = await FilePicker.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: [
        'png',
        'jpg',
        'jpeg',
        'gif',
        'webp',
        'pdf',
        'doc',
        'docx',
        'txt',
        'log',
        'csv',
        'zip',
      ],
    );

    if (result != null && context.mounted) {
      for (final file in result.files) {
        if (file.path != null) {
          context.read<IssueFormCubit>().uploadFile(File(file.path!));
        }
      }
    }
  }
}

class _AttachmentItem extends StatelessWidget {
  final IssueAttachment attachment;

  const _AttachmentItem({required this.attachment});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<IssueFormCubit>();
    final Color statusColor;
    final IconData statusIcon;

    switch (attachment.status) {
      case AttachmentStatus.pending:
        statusColor = Colors.grey;
        statusIcon = Icons.hourglass_empty;
      case AttachmentStatus.uploading:
        statusColor = Colors.blue;
        statusIcon = Icons.cloud_upload;
      case AttachmentStatus.uploaded:
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
      case AttachmentStatus.error:
        statusColor = Colors.red;
        statusIcon = Icons.error;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Icon(statusIcon, size: 16, color: statusColor),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  attachment.fileName,
                  style: const TextStyle(fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  attachment.fileSizeDisplay,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          if (attachment.status == AttachmentStatus.uploading)
            SizedBox(
              width: 48,
              child: LinearProgressIndicator(
                value: attachment.uploadProgress,
                minHeight: 3,
              ),
            ),
          IconButton(
            icon: const Icon(Icons.close, size: 16),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () => cubit.removeAttachment(attachment.id),
          ),
        ],
      ),
    );
  }
}
