import 'package:core/core/theme/app_shapes_extension.dart';
import 'package:core/core/theme/app_theme.dart';
import 'package:core/core/theme/app_theme_config.dart';
import 'package:core/core/ui/atoms/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Radius of a button component theme's shape (all button themes share one
/// [ButtonStyle.shape]).
double _buttonThemeRadius(ButtonStyle? style) {
  final shape = style!.shape!.resolve({})! as RoundedRectangleBorder;
  return (shape.borderRadius as BorderRadius).topLeft.x;
}

void main() {
  group('AppTheme shape wiring', () {
    test('rocketWarm preset gives pill (999) radius to atoms AND raw Material',
        () {
      final config = AppThemeConfig.fromJson({'activeTheme': 'rocketWarm'});
      final theme = AppTheme.fromConfig(config);

      // The atom's source of truth.
      final shapes = theme.extension<AppShapes>()!;
      expect(shapes.buttonRadius, 999);

      // Raw Material buttons read the SAME radius via the component themes.
      expect(_buttonThemeRadius(theme.elevatedButtonTheme.style), 999);
      expect(_buttonThemeRadius(theme.filledButtonTheme.style), 999);
      expect(_buttonThemeRadius(theme.outlinedButtonTheme.style), 999);
      expect(_buttonThemeRadius(theme.textButtonTheme.style), 999);

      // Parity: a raw ElevatedButton and AppButton derive from one value.
      expect(_buttonThemeRadius(theme.elevatedButtonTheme.style),
          shapes.buttonRadius);
    });

    test('no shape block falls back to standard tokens (button 8)', () {
      // A preset without a shape block.
      final config = AppThemeConfig.fromJson({'activeTheme': 'forestWalk'});
      final theme = AppTheme.fromConfig(config);

      expect(theme.extension<AppShapes>()!.buttonRadius,
          AppShapes.standard.buttonRadius);
      expect(_buttonThemeRadius(theme.elevatedButtonTheme.style),
          AppShapes.standard.buttonRadius);
    });

    testWidgets('AppButton actually renders with the theme radius (999)',
        (tester) async {
      final theme =
          AppTheme.fromConfig(AppThemeConfig.fromJson({'activeTheme': 'rocketWarm'}));

      await tester.pumpWidget(MaterialApp(
        theme: theme,
        home: Scaffold(
          body: AppButton(label: 'Save', onTap: () {}),
        ),
      ));

      final container =
          tester.widget<AnimatedContainer>(find.byType(AnimatedContainer));
      final decoration = container.decoration! as BoxDecoration;
      final radius = (decoration.borderRadius! as BorderRadius).topLeft.x;
      expect(radius, 999);
    });
  });
}
