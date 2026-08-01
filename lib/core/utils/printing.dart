import 'package:flutter/rendering.dart';

void printMap({required String title, required Map<String, dynamic> data}) {
  debugPrint(
    '$title: \n  ${data.keys.map((e) => '$e: ${data[e] is Map ? '$title(Map<String, dynamic>)' : data[e]}').join('\n  ')}',
  );
}
