
class YoutrackApiConfig {
  /// Base URL of the YouTrack server
  final String baseUrl;

  /// Authentication token
  String? token;

  /// Connection timeout in milliseconds
  final Duration connectTimeout;

  /// Receive timeout in milliseconds
  final Duration receiveTimeout;

  /// Enable debug logs
  final bool enableDebugLogs;

  YoutrackApiConfig({
    required this.baseUrl,
    this.token,
    this.connectTimeout = const Duration(seconds: 30),
    this.receiveTimeout = const Duration(seconds: 30),
    this.enableDebugLogs = false,
  });
}