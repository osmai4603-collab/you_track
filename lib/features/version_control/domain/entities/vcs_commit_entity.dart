import 'package:equatable/equatable.dart';

class VcsCommitEntity extends Equatable {
  final String id;
  final String integrationId;
  final String taskId;
  final String commitSha;
  final String authorName;
  final String authorEmail;
  final String message;
  final String branch;
  final DateTime committedAt;
  final DateTime processedAt;

  const VcsCommitEntity({
    required this.id,
    required this.integrationId,
    required this.taskId,
    required this.commitSha,
    required this.authorName,
    required this.authorEmail,
    required this.message,
    required this.branch,
    required this.committedAt,
    required this.processedAt,
  });

  VcsCommitEntity copyWith({
    String? id,
    String? integrationId,
    String? taskId,
    String? commitSha,
    String? authorName,
    String? authorEmail,
    String? message,
    String? branch,
    DateTime? committedAt,
    DateTime? processedAt,
  }) {
    return VcsCommitEntity(
      id: id ?? this.id,
      integrationId: integrationId ?? this.integrationId,
      taskId: taskId ?? this.taskId,
      commitSha: commitSha ?? this.commitSha,
      authorName: authorName ?? this.authorName,
      authorEmail: authorEmail ?? this.authorEmail,
      message: message ?? this.message,
      branch: branch ?? this.branch,
      committedAt: committedAt ?? this.committedAt,
      processedAt: processedAt ?? this.processedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        integrationId,
        taskId,
        commitSha,
        authorName,
        authorEmail,
        message,
        branch,
        committedAt,
        processedAt,
      ];
}
