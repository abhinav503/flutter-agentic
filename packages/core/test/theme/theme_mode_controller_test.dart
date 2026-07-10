import 'package:core/core/theme/theme_mode_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ThemeModeController', () {
    test('defaults to system', () {
      expect(ThemeModeController().value, ThemeMode.system);
    });

    test('cycle advances System → Light → Dark → System', () async {
      final c = ThemeModeController();

      await c.cycle();
      expect(c.value, ThemeMode.light);
      await c.cycle();
      expect(c.value, ThemeMode.dark);
      await c.cycle();
      expect(c.value, ThemeMode.system);
    });

    test('notifies listeners on change', () async {
      final c = ThemeModeController();
      var notified = 0;
      c.addListener(() => notified++);

      await c.setMode(ThemeMode.dark);
      await c.setMode(ThemeMode.dark); // no-op, same value
      expect(c.value, ThemeMode.dark);
      expect(notified, 1);
    });

    test('load without initialised prefs falls back to system (no throw)', () {
      final c = ThemeModeController(ThemeMode.dark);
      c.load();
      expect(c.value, ThemeMode.system);
    });
  });
}
