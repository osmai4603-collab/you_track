enum TimeTrackingFieldType {
  text('text'),
  number('number'),
  date('date'),
  dropdown('dropdown');

  const TimeTrackingFieldType(this.value);

  final String value;

  static TimeTrackingFieldType fromValue(String value) {
    return TimeTrackingFieldType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Unknown TimeTrackingFieldType: $value'),
    );
  }
}
