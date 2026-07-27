enum VcsPrState {
  open('open', 'Open'),
  merged('merged', 'Merged'),
  closed('closed', 'Closed');

  final String value;
  final String displayName;

  const VcsPrState(this.value, this.displayName);

  static VcsPrState fromValue(String value) {
    return VcsPrState.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Unknown VcsPrState: $value'),
    );
  }
}
