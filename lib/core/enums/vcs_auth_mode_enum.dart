enum VcsAuthMode {
  oauth('oauth', 'OAuth 2.0'),
  token('token', 'Personal Access Token'),
  ssh('ssh', 'SSH Key');

  final String value;
  final String displayName;

  const VcsAuthMode(this.value, this.displayName);

  static VcsAuthMode fromValue(String value) {
    return VcsAuthMode.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Unknown VcsAuthMode: $value'),
    );
  }
}
