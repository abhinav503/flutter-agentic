import 'package:flutter/material.dart';

/// Raw kit swatches that don't map to a `ColorScheme`/`AppColorsExtension`
/// role — used when a design spec calls out an exact shade (e.g. "Gray/500")
/// rather than a semantic role like `onSurfaceVariant`.
abstract final class ColorConst {
  static const gray100 = Color(0xFFEDEDED);
  static const gray500 = Color(0xFFA1A1A1);
  static const primary50 = Color(0xFFECFDF6);
}
