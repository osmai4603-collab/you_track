# Contracts: YouTrack Issue Form Rebuild

**Feature**: 001-youtrack-issue-form
**Date**: 2026-07-27

## Contract Type: Repository Interface (Domain Layer)

These are the abstract contracts that the presentation layer depends on. Implementations live in the data layer.

### IssuesRepository (Extended)

Existing repository interface with new methods for issue lifecycle management.

```dart
abstract class IssuesRepository {
  // EXISTING
  Future<Either<Failure, List<Issue>>> getIssues(IssueFilter filter);
  Future<Either<Failure, Issue>> getIssueById(String id);
  Future<Either<Failure, List<String>>> getAllTags();

  // NEW: Issue CRUD
  Future<Either<Failure, Issue>> createIssue({
    required String projectKey,
    required String title,
    required String description,
    required IssuePriority priority,
    required IssueStateEnum state,
    required IssueTypeEnum issueType,
    String? assigneeId,
    String? subsystem,
    String? fixVersions,
    String? fixedInBuild,
    Duration? estimation,
    List<String> visibility = const ['team'],
    String? parentId,
  });

  Future<Either<Failure, Issue>> updateIssue({
    required String issueId,
    String? title,
    String? description,
    IssuePriorityTypeEnum? priority,
    IssueStateEnum? state,
    IssueTypeEnum? issueType,
    String? assigneeId,
    bool clearAssignee = false,
    String? subsystem,
    String? fixVersions,
    String? fixedInBuild,
    Duration? estimation,
    Duration? spentTime,
    List<String>? visibility,
  });

  Future<Either<Failure, void>> deleteIssue(String issueId);

  // NEW: Attachments
  Future<Either<Failure, String>> uploadAttachment({
    required String issueId,
    required String filePath,
    required String fileName,
    void Function(double progress)? onProgress,
  });

  Future<Either<Failure, void>> deleteAttachment({
    required String issueId,
    required String storagePath,
  });

  Future<Either<Failure, List<IssueAttachment>>> getAttachments(String issueId);
}
```

### IssuesRemoteDataSource (Extended)

Existing data source interface with new Supabase operations.

```dart
abstract class IssuesRemoteDataSource {
  // EXISTING
  Future<List<IssueModel>> getIssues(IssueFilter filter);
  Future<IssueModel> getIssueById(String id);
  Future<List<String>> getAllTags();

  // NEW
  Future<IssueModel> createIssue(Map<String, dynamic> issueData);
  Future<IssueModel> updateIssue(String issueId, Map<String, dynamic> updates);
  Future<void> deleteIssue(String issueId);
  Future<String> uploadAttachment({
    required String issueId,
    required String filePath,
    required String fileName,
    void Function(double progress)? onProgress,
  });
  Future<void> deleteAttachment(String storagePath);
  Future<List<Map<String, dynamic>>> getAttachments(String issueId);
}
```

## Contract Type: Cubit Public API (Presentation Layer)

### IssueFormCubit

Public interface for the form state manager.

```dart
class IssueFormCubit extends Cubit<IssueFormState> {
  // Constructor
  IssueFormCubit({required IssuesRepository repository});

  // Initialization
  void initWithProject(String projectKey);  // Create mode
  void initWithIssue(Issue issue);          // Edit mode

  // Field updates
  void updateSummary(String value);
  void updateDescription(String value);
  void updateDescriptionFormat(DescriptionFormat format);
  void updatePriority(IssuePriority value);
  void updateState(IssueStateEnum value);
  void updateIssueType(IssueTypeEnum value);
  void updateAssignee(String? userId, String? userName);
  void clearAssignee();
  void updateSubsystem(String value);
  void updateFixVersions(String value);
  void updateFixedInBuild(String value);
  void updateEstimation(Duration? value);
  void updateSpentTime(Duration? value);
  void updateVisibility(List<String> value);

  // Attachment management
  void addAttachment(IssueAttachment attachment);
  void removeAttachment(String attachmentId);

  // Form operations
  Future<void> submit();    // Create or update
  Future<void> delete();    // Delete (edit mode only)
  void cancel();            // Discard and navigate back
}
```

### IssueFormState

```dart
class IssueFormState extends Equatable {
  final String summary;
  final String description;
  final DescriptionFormat descriptionFormat;
  final IssuePriority priority;
  final IssueStateEnum state;
  final IssueTypeEnum issueType;
  final String? assigneeId;
  final String? assigneeName;
  final String subsystem;
  final String fixVersions;
  final String fixedInBuild;
  final Duration? estimation;
  final Duration? spentTime;
  final List<String> visibility;
  final List<IssueAttachment> attachments;
  final Map<String, String> validationErrors;
  final bool isSubmitting;
  final bool isEditing;
  final String? issueId;
  final String? projectKey;
  final String? errorMessage;

  // copyWith method
  // props getter
}
```

## Contract Type: UI Widget Interface

### IssueForm (Page)

```dart
class IssueForm extends StatefulWidget {
  final String? issueId;    // null = create mode, non-null = edit mode
  final String projectKey;  // required project context

  const IssueForm({super.key, this.issueId, required this.projectKey});
}
```

### Navigation Route Contract

```
Route: /issues/new-issue?project=:projectKey
Route: /issues/:issueId/edit
```

Both routes wrap `IssueForm` in `BlocProvider<IssueFormCubit>`.
