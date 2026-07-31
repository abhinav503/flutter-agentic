import 'package:flutter/material.dart';

/// Raw brand swatches for the app's own chrome — shades a spec calls out
/// exactly rather than through a `ColorScheme` role. Shared with the
/// `gravia` pack (`GraviaColorConst` re-exposes [gray500]).
abstract final class CordeliaColorConst {
  /// Form-field label gray — same shade in both light and dark, unlike
  /// `onSurfaceVariant`, which resolves to different grays per theme.
  static const gray500 = Color(0xFFA1A1A1);
}
