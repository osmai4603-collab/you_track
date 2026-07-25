enum FieldEnumType {
  build('build'),
  enumField('enum'),
  group('group'),
  ownedField('owned-field'),
  state('state'),
  user('user'),
  version('version'),
  date('date'),
  dateTime('date-time'),
  float('float'),
  integer('integer'),
  string('string'),
  text('text'),
  period('period');

  final String value;

  const FieldEnumType(this.value);

  static FieldEnumType fromValue(String value) {
    return values.firstWhere(
      (type) => type.value == value,
      orElse: () => throw ArgumentError('Unknown FieldEnumType: $value'),
    );
  }
}
