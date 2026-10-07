import 'dart:convert';

/// Parse `{ "data": [ ... ] }` from the generic CRUD API.
List<T> parseApiList<T>(
  String result,
  T Function(Map<String, dynamic>) fromMap,
) {
  try {
    final decoded = json.decode(result);
    if (decoded is! Map) return [];
    final data = decoded['data'];
    if (data is! List) return [];
    return data
        .whereType<Map>()
        .map((row) => fromMap(Map<String, dynamic>.from(row)))
        .toList();
  } catch (_) {
    return [];
  }
}

int? extractInsertedId(dynamic jsonResult, String table) {
  if (jsonResult is! Map) return null;
  final id = jsonResult['id'] ??
      jsonResult['insertId'] ??
      jsonResult['insert_id'] ??
      (jsonResult['data'] is Map ? jsonResult['data']['id'] : null);
  if (id is int) return id;
  return int.tryParse(id?.toString() ?? '');
}
