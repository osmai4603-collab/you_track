import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum UploadStatus { initial, uploading, success, failure }

class UploadState {
  final UploadStatus status;
  final double progress;
  final String? downloadUrl;
  final String? errorMessage;

  const UploadState({
    this.status = UploadStatus.initial,
    this.progress = 0.0,
    this.downloadUrl,
    this.errorMessage,
  });

  UploadState copyWith({
    UploadStatus? status,
    double? progress,
    String? downloadUrl,
    String? errorMessage,
  }) {
    return UploadState(
      status: status ?? this.status,
      progress: progress ?? this.progress,
      downloadUrl: downloadUrl ?? this.downloadUrl,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class SupabaseStorageService {
  final SupabaseClient _supabaseClient;

  SupabaseStorageService({SupabaseClient? supabaseClient})
    : _supabaseClient = supabaseClient ?? Supabase.instance.client;

  /// Uploads a file to Supabase storage and returns a stream of [UploadState]
  /// to track the upload status and progress.
  Stream<UploadState> uploadFile({
    String bucket = 'youtrack',
    required String path,
    required File file,
    FileOptions fileOptions = const FileOptions(),
  }) async* {
    yield const UploadState(status: UploadStatus.uploading, progress: 0.0);

    try {
      // NOTE: Supabase Dart client currently does not provide a native byte-level
      // progress callback for standard uploads. Progress will jump from 0.0 to 1.0.
      await _supabaseClient.storage
          .from(bucket)
          .upload(path, file, fileOptions: fileOptions);
      final String downloadUrl = _supabaseClient.storage
          .from(bucket)
          .getPublicUrl(path);

      yield UploadState(
        status: UploadStatus.success,
        progress: 1.0,
        downloadUrl: downloadUrl,
      );
    } on StorageException catch (e) {
      debugPrint(e.toString());
      yield UploadState(status: UploadStatus.failure, errorMessage: e.message);
    } catch (e) {
      debugPrint(e.toString());
      yield UploadState(
        status: UploadStatus.failure,
        errorMessage: e.toString(),
      );
    }
  }

  /// Deletes a file from Supabase storage
  Future<void> deleteFile({
    String bucket = 'youtrack',
    required String path,
  }) async {
    await _supabaseClient.storage.from(bucket).remove([path]);
  }
}
