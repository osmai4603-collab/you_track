enum FieldType {
  build('build'),
  enumField('enum'),
  group('group'),
  ownedField('owned-field'),
  state('state'),
  user('user'),
  version('version');

  final String value;

  const FieldType(this.value);

  static FieldType fromValue(String value) {
    return values.firstWhere(
      (type) => type.value == value,
      orElse: () => throw ArgumentError('Unknown FieldType: $value'),
    );
  }
}