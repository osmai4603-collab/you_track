enum VcsConnectionStatus {
  connected('connected', 'Connected'),
  disabled('disabled', 'Disabled'),
  authFailed('auth_failed', 'Authentication Failed'),
  syncError('sync_error', 'Sync Error');

  final String value;
  final String displayName;

  const VcsConnectionStatus(this.value, this.displayName);

  static VcsConnectionStatus fromValue(String value) {
    return VcsConnectionStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Unknown VcsConnectionStatus: $value'),
    );
  }
}
