import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:youtrack_api/youtrack_api.dart';

void main() {
  group('YouTrack API public package', () {
    test('exports the issue API and its model', () {
      final api = IssuesApi(_RecordingNetworkApi());
      expect(api, isA<IssuesApi>());
      expect(
        IssueModel.fromJson(const {
          'id': 'issue-1',
          'issue_key': 'DEMO-1',
          'issue_sequence': 1,
          'summary': 'Example',
        }).issueKey,
        'DEMO-1',
      );
    });

    test('posts project fields as a JSON body', () async {
      final network = _RecordingNetworkApi()
        ..response = const {
          'id': 'project-1',
          'name': 'Example',
          'shortName': 'EX',
        };

      final result = await ProjectsApi(network).createProject(
        const ProjectModel(id: '', name: 'Example', shortName: 'EX'),
      );

      expect(result.isSuccess, isTrue);
      expect(network.method, 'POST');
      expect(network.endpoint, '/projects');
      expect(network.data, containsPair('name', 'Example'));
      expect(network.queryParameters, isNull);
    });

    test('encodes resource identifiers in issue routes', () async {
      final network = _RecordingNetworkApi()
        ..response = const {
          'id': 'a/b',
          'issue_key': 'DEMO-1',
          'issue_sequence': 1,
          'summary': 'Example',
        };

      final result = await IssuesApi(network).getIssueByID('a/b');

      expect(result.isSuccess, isTrue);
      expect(network.endpoint, '/issues/a%2Fb');
    });

    test('posts group membership batches through the group route', () async {
      final network = _RecordingNetworkApi()
        ..response = const {
          'items': [
            {'id': 'member-1', 'groupId': 'group/1', 'userId': 'user-1'},
          ],
        };

      final result = await GroupsApi(network).addMembers('group/1', ['user-1']);

      expect(result.isSuccess, isTrue);
      expect(result.data.single['id'], 'member-1');
      expect(network.endpoint, '/groups/group%2F1/members');
      expect(network.data, containsPair('userIds', ['user-1']));
    });

    test('checks tag uniqueness with project scope and query', () async {
      final network = _RecordingNetworkApi()..response = const {'unique': true};

      final result = await TagsApi(
        network,
      ).isNameUnique(projectID: 'project-1', name: 'frontend');

      expect(result.isSuccess, isTrue);
      expect(result.data, isTrue);
      expect(network.endpoint, '/projects/project-1/tags/unique');
      expect(network.queryParameters, containsPair('name', 'frontend'));
    });

    test(
      'forwards attachment payload and upload progress to the issue route',
      () async {
        final network = _RecordingNetworkApi()
          ..response = const {'storagePath': 'issues/issue-1/file.txt'};
        void onProgress(double progress) {}

        final result = await IssuesApi(network).uploadAttachment(
          'issue/1',
          filePath: '/tmp/file.txt',
          fileName: 'file.txt',
          onProgress: onProgress,
        );

        expect(result.isSuccess, isTrue);
        expect(network.endpoint, '/issues/issue%2F1/attachments');
        expect(network.data, containsPair('filePath', '/tmp/file.txt'));
        expect(network.onFileProgress, same(onProgress));
      },
    );

    test('downloads attachment bytes through NetworkAPI', () async {
      final network = _RecordingNetworkApi();

      final result = await IssuesApi(
        network,
      ).downloadAttachment('issue/1', storagePath: 'issues/issue-1/file.txt');

      expect(result.isSuccess, isTrue);
      expect(result.data, Uint8List.fromList([1, 2, 3]));
      expect(network.endpoint, '/issues/issue%2F1/attachments/download');
      expect(
        network.queryParameters,
        containsPair('storagePath', 'issues/issue-1/file.txt'),
      );
    });

    test('parses user relations defensively and derives initials', () {
      final user = UserModel.fromJson(const {
        'id': 'user-1',
        'fullName': 'Ada Lovelace',
        'group_members': [
          null,
          'bad-row',
          {'groups': 'bad-group'},
        ],
      });

      expect(user.id, 'user-1');
      expect(user.initials, 'AL');
      expect(user.groups, isEmpty);
    });
  });
}

class _RecordingNetworkApi implements NetworkAPI {
  dynamic response = const <String, dynamic>{};
  String? method;
  String? endpoint;
  dynamic data;
  Map<String, dynamic>? queryParameters;
  void Function(int sent, int total)? onSendProgress;
  void Function(double progress)? onFileProgress;

  @override
  Future<ApiResult<T>> get<T>({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    _record('GET', endpoint, queryParameters: queryParameters);
    return ApiSuccess(fromJson(Map<String, dynamic>.from(response as Map)));
  }

  @override
  Future<ApiResult<List<T>>> getList<T>({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    _record('GET', endpoint, queryParameters: queryParameters);
    final rows = response as List? ?? const [];
    return ApiSuccess(
      rows
          .map((row) => fromJson(Map<String, dynamic>.from(row as Map)))
          .toList(growable: false),
    );
  }

  @override
  Future<ApiResult<T>> post<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    void Function(int sent, int total)? onSendProgress,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    _record('POST', endpoint, data: data, queryParameters: queryParameters);
    this.onSendProgress = onSendProgress;
    return ApiSuccess(fromJson(Map<String, dynamic>.from(response as Map)));
  }

  @override
  Future<ApiResult<T>> put<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    _record('PUT', endpoint, data: data, queryParameters: queryParameters);
    return ApiSuccess(fromJson(Map<String, dynamic>.from(response as Map)));
  }

  @override
  Future<ApiResult<T>> patch<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    _record('PATCH', endpoint, data: data, queryParameters: queryParameters);
    return ApiSuccess(fromJson(Map<String, dynamic>.from(response as Map)));
  }

  @override
  Future<ApiResult<void>> delete({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    dynamic data,
  }) async {
    _record('DELETE', endpoint, data: data, queryParameters: queryParameters);
    return const ApiSuccess(null);
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> uploadFile({
    required String endpoint,
    required String filePath,
    required String fileName,
    String fieldName = 'file',
    Map<String, dynamic>? fields,
    Map<String, dynamic>? queryParameters,
    void Function(double progress)? onProgress,
  }) async {
    _record(
      'UPLOAD',
      endpoint,
      data: {
        'filePath': filePath,
        'fileName': fileName,
        'fieldName': fieldName,
        ...?fields,
      },
      queryParameters: queryParameters,
    );
    onFileProgress = onProgress;
    return ApiSuccess(Map<String, dynamic>.from(response as Map));
  }

  @override
  Future<ApiResult<Uint8List>> downloadFile({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
  }) async {
    _record('DOWNLOAD', endpoint, queryParameters: queryParameters);
    return ApiSuccess(Uint8List.fromList([1, 2, 3]));
  }

  @override
  Future<ApiResult<T>> head<T>({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic) fromJson,
  }) async {
    _record('HEAD', endpoint, queryParameters: queryParameters);
    return ApiSuccess(fromJson(response));
  }

  @override
  Future<void> onLogin(UserAuth token) async {}

  @override
  Future<void> onLogout() async {}

  @override
  Future<void> onRefreshToken(UserAuth token) async {}

  void _record(
    String requestMethod,
    String requestEndpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    method = requestMethod;
    endpoint = requestEndpoint;
    this.data = data;
    this.queryParameters = queryParameters;
  }
}
