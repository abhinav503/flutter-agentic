import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('seed-derived outline (no override) for gravia green seed', () {
    final cs = ColorScheme.fromSeed(seedColor: const Color(0xFF027A60));
    // ignore: avoid_print
    print('seed-derived outline=#${cs.outline.toARGB32().toRadixString(16)}');
    // ignore: avoid_print
    print('seed-derived outlineVariant=#${cs.outlineVariant.toARGB32().toRadixString(16)}');
  });
}
