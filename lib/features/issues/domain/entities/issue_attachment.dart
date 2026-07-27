import 'package:equatable/equatable.dart';

enum AttachmentStatus { pending, uploading, uploaded, error }

enum DescriptionFormat { visual, markdown }

class IssueAttachment extends Equatable {
  final String id;
  final String fileName;
  final int fileSize;
  final String mimeType;
  final double uploadProgress;
  final String? storagePath;
  final AttachmentStatus status;

  const IssueAttachment({
    required this.id,
    required this.fileName,
    required this.fileSize,
    required this.mimeType,
    this.uploadProgress = 0.0,
    this.storagePath,
    this.status = AttachmentStatus.pending,
  });

  IssueAttachment copyWith({
    String? id,
    String? fileName,
    int? fileSize,
    String? mimeType,
    double? uploadProgress,
    String? storagePath,
    AttachmentStatus? status,
    bool clearStoragePath = false,
  }) {
    return IssueAttachment(
      id: id ?? this.id,
      fileName: fileName ?? this.fileName,
      fileSize: fileSize ?? this.fileSize,
      mimeType: mimeType ?? this.mimeType,
      uploadProgress: uploadProgress ?? this.uploadProgress,
      storagePath: clearStoragePath ? null : (storagePath ?? this.storagePath),
      status: status ?? this.status,
    );
  }

  String get fileSizeDisplay {
    if (fileSize < 1024) return '$fileSize B';
    if (fileSize < 1024 * 1024) return '${(fileSize / 1024).toStringAsFixed(1)} KB';
    return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  List<Object?> get props => [
        id,
        fileName,
        fileSize,
        mimeType,
        uploadProgress,
        storagePath,
        status,
      ];
}
