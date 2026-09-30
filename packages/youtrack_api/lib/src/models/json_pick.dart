/// Defensive readers for the loosely typed maps a JSON decoder produces.
///
/// The board and the issue endpoints both return large projections, and a single
/// malformed row must not take the screen down with it. Every reader here
/// therefore degrades to a safe default instead of throwing, and every reader
/// takes a list of keys so one call can cope with the endpoints that disagree
/// on a field's spelling: the issue routes are snake_case while the board route
/// is camelCase, and the server sends `issue_key` where the column is
/// `id_readable`.
///
/// These are package-internal. `models.dart` does not export this file, so the
/// app layer never sees them.
library;

/// Returns the first key in [keys] that is present and non-null.
Object? pick(Map<String, dynamic> data, List<String> keys) {
  for (final key in keys) {
    final value = data[key];
    if (value != null) return value;
  }
  return null;
}

/// Reads a string, defaulting to ''. Never null, so a required field on a model
/// stays a required non-nullable String.
String pickString(Map<String, dynamic> data, List<String> keys) {
  return pick(data, keys)?.toString() ?? '';
}

/// Reads a string, defaulting to null. An empty string is reported as null: the
/// server sends `''` for "no value" in several places, and the app treats those
/// fields as optional.
String? pickNullableString(Map<String, dynamic> data, List<String> keys) {
  final value = pick(data, keys);
  if (value == null) return null;
  final text = value.toString();
  return text.isEmpty ? null : text;
}

bool pickBool(Map<String, dynamic> data, List<String> keys) {
  final value = pick(data, keys);
  if (value is bool) return value;
  if (value is String) return value.toLowerCase() == 'true';
  return false;
}

/// JSON numbers arrive as `int` for whole values, but a decoder may hand back a
/// `double` or a numeric string, so every shape is tolerated.
int pickInt(Map<String, dynamic> data, List<String> keys) {
  final value = pick(data, keys);
  if (value is int) return value;
  if (value is double) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

int? pickNullableInt(Map<String, dynamic> data, List<String> keys) {
  final value = pick(data, keys);
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.toInt();
  return int.tryParse(value.toString());
}

/// Parses a timestamp.
///
/// Accepts an RFC3339 string or epoch milliseconds, which is the pair the
/// server actually uses: issues are sent as RFC3339 on purpose, because the
/// app's own model calls `DateTime.parse`, whose failure path returns
/// `DateTime.now()` — an integer would therefore not throw there, it would
/// silently relabel every record as created this instant. Returns null rather
/// than `DateTime.now()` so the caller can tell "no timestamp" from "just now".
DateTime? pickDate(Map<String, dynamic> data, List<String> keys) {
  final value = pick(data, keys);
  if (value == null) return null;
  if (value is DateTime) return value;
  if (value is int) {
    return DateTime.fromMillisecondsSinceEpoch(value, isUtc: true);
  }
  return DateTime.tryParse(value.toString());
}

/// Reads a list of objects, skipping any element that is not a map.
///
/// A non-list value yields an empty list rather than throwing: a Go slice with
/// no `omitempty` marshals a nil slice to `null`, so "server sent nothing" and
/// "server sent the wrong shape" both arrive here and both mean the same thing
/// to the app — an empty list to render.
List<T> pickList<T>(
  Map<String, dynamic> data,
  List<String> keys,
  T Function(Map<String, dynamic> item) parse,
) {
  final value = pick(data, keys);
  if (value is! List) return <T>[];

  final parsed = <T>[];
  for (final item in value) {
    if (item is Map) parsed.add(parse(Map<String, dynamic>.from(item)));
  }
  return parsed;
}

/// Reads a list of strings, skipping any element that is not a scalar.
List<String> pickStringList(Map<String, dynamic> data, List<String> keys) {
  final value = pick(data, keys);
  if (value is! List) return const [];
  return value.map((e) => e.toString()).toList(growable: false);
}

/// Reads a list of raw objects, skipping any element that is not a map.
///
/// Used where the payload's element shape is not modelled yet — the issue
/// endpoint sends `tags`, `sprints` and `issue_links` as untyped maps.
List<Map<String, dynamic>> pickMapList(
  Map<String, dynamic> data,
  List<String> keys,
) {
  final value = pick(data, keys);
  if (value is! List) return const [];
  final parsed = <Map<String, dynamic>>[];
  for (final item in value) {
    if (item is Map) parsed.add(Map<String, dynamic>.from(item));
  }
  return parsed;
}

/// Reads a map of string keys to counts, dropping nothing and defaulting an
/// unreadable count to zero.
Map<String, int> pickCountMap(Map<String, dynamic> data, List<String> keys) {
  final value = pick(data, keys);
  if (value is! Map) return const {};

  final parsed = <String, int>{};
  value.forEach((key, count) {
    if (count is int) {
      parsed[key.toString()] = count;
    } else if (count is double) {
      parsed[key.toString()] = count.toInt();
    } else {
      parsed[key.toString()] = int.tryParse('${count ?? ''}') ?? 0;
    }
  });
  return parsed;
}

/// Reads a nested object, returning null when absent or the wrong shape.
///
/// The board's `activeSprint` is a pointer on the server, so a project with no
/// running sprint sends `null` — which is a different thing from an empty
/// object, and the app renders the two differently.
Map<String, dynamic>? pickObject(Map<String, dynamic> data, List<String> keys) {
  final value = pick(data, keys);
  if (value is Map) return Map<String, dynamic>.from(value);
  return null;
}
