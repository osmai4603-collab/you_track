class NetworkConfig {
  final String baseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final int maxRetries;
  final List<String> unauthenticatedPaths;
  final Map<String, dynamic>? defaultHeaders;

  const NetworkConfig({
    required this.baseUrl,
    this.connectTimeout = const Duration(seconds: 30),
    this.receiveTimeout = const Duration(seconds: 30),
    this.maxRetries = 3,
    this.unauthenticatedPaths = const [],
    this.defaultHeaders,
  });

  NetworkConfig copyWith({
    String? baseUrl,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    int? maxRetries,
    List<String>? unauthenticatedPaths,
    Map<String, dynamic>? defaultHeaders,
  }) {
    return NetworkConfig(
      baseUrl: baseUrl ?? this.baseUrl,
      connectTimeout: connectTimeout ?? this.connectTimeout,
      receiveTimeout: receiveTimeout ?? this.receiveTimeout,
      maxRetries: maxRetries ?? this.maxRetries,
      unauthenticatedPaths: unauthenticatedPaths ?? this.unauthenticatedPaths,
      defaultHeaders: defaultHeaders ?? this.defaultHeaders,
    );
  }
}
