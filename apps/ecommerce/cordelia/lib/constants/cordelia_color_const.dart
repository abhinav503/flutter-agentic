import 'package:flutter/material.dart';

/// Raw brand swatches for the app's own chrome — shades a spec calls out
/// exactly rather than through a `ColorScheme` role. Shared with the
/// `gravia` pack (`GraviaColorConst` re-exposes [gray500]).
abstract final class CordeliaColorConst {
  /// Form-field label gray — same shade in both light and dark, unlike
  /// `onSurfaceVariant`, which resolves to different grays per theme.
  static const gray500 = Color(0xFFA1A1A1);

  /// The brand gradient: near-black forest green into the brand green a
  /// shade off the mark's own deep stop. A `ColorScheme` role holds one
  /// colour, so the pair lives here.
  ///
  /// Scoped to CordeliaApps' **own** chrome — auth and discovery, the screens
  /// that run before a store's template takes over. A storefront must never
  /// paint with it: each pack owns its own affirmative fill (see
  /// `GrofastColorConst.brandGradient` for the same rule on the other side).
  static const brandGradientStart = Color(0xFF02291F);
  static const brandGradientEnd = Color(0xFF027A60);

  /// The accent Android tints a notification's small icon and title with.
  /// The launcher mark's own deep stop (`assets/icons/cordelia-icon.svg`),
  /// a shade off [brandGradientEnd] — the notification sits beside that
  /// icon in the shade, so it matches the icon rather than the app chrome.
  ///
  /// Here rather than inline in `LocalNotificationService`: that file has no
  /// `BuildContext` to read a role from, which is exactly when a raw swatch
  /// belongs in a constants file instead of at the call site.
  static const notificationAccent = Color(0xFF007A60);

  /// Header canvases. Strictly vertical, not the diagonal a button gets:
  /// `CollapsingHeaderSheet` paints [brandGradientEnd] flat behind the
  /// sheet's rounded top corners, and only a vertical ramp leaves the
  /// header's whole bottom edge at that exact colour — any diagonal parks one
  /// corner mid-gradient and seams visibly against it.
  static const brandHeaderGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [brandGradientStart, brandGradientEnd],
  );

  /// Pill CTAs. Horizontal, because the same vertical ramp across 45px reads
  /// as a bevel on the control rather than as a brand sweep.
  static const brandButtonGradient = LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [brandGradientStart, brandGradientEnd],
  );
}
