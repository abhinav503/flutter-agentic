import 'package:flutter/material.dart';

/// Brand elevation (box-shadow) tokens not covered by Material elevation.
///
/// Kits spec exact shadow ramps per surface tier (a product card's soft drop,
/// a floating CTA's deeper throw, a nav bar's upward wash) that Material's
/// single-elevation model can't hold — packs were each keeping a private
/// `*Elevation` constants class for them. Like [AppShapes], the values are
/// theme data: a preset/config can override any tier, and widgets read them
/// through the accessor so a raw call site can't drift:
/// ```dart
/// boxShadow: context.appShadows.card,
/// ```
///
/// Config JSON (each tier optional; each shadow `color` is ARGB hex):
/// ```jsonc
/// "shadows": {
///   "card": [ { "color": "#14000000", "blur": 12, "y": 4 } ],
///   "floatingAction": [ { "color": "#29000000", "blur": 16, "y": 6 } ]
/// }
/// ```
@immutable
class AppShadows extends ThemeExtension<AppShadows> {
  /// Resting card/tile drop shadow.
  final List<BoxShadow> card;

  /// Emphasised raised surface (a promo card, a modal-adjacent panel).
  final List<BoxShadow> raised;

  /// Floating CTA / pill docked over scrolling content.
  final List<BoxShadow> floatingAction;

  /// Bottom nav bar's upward wash.
  final List<BoxShadow> navBar;

  const AppShadows({
    required this.card,
    required this.raised,
    required this.floatingAction,
    required this.navBar,
  });

  /// Neutral defaults for themes that don't spec a ramp — subtle scrims that
  /// read on both light and dark surfaces.
  static const AppShadows standard = AppShadows(
    card: [
      BoxShadow(color: Color(0x14000000), blurRadius: 12, offset: Offset(0, 4)),
    ],
    raised: [
      BoxShadow(color: Color(0x1F000000), blurRadius: 20, offset: Offset(0, 8)),
    ],
    floatingAction: [
      BoxShadow(color: Color(0x29000000), blurRadius: 16, offset: Offset(0, 6)),
    ],
    navBar: [
      BoxShadow(
        color: Color(0x1A000000),
        blurRadius: 24,
        offset: Offset(0, -4),
      ),
    ],
  );

  @override
  AppShadows copyWith({
    List<BoxShadow>? card,
    List<BoxShadow>? raised,
    List<BoxShadow>? floatingAction,
    List<BoxShadow>? navBar,
  }) => AppShadows(
    card: card ?? this.card,
    raised: raised ?? this.raised,
    floatingAction: floatingAction ?? this.floatingAction,
    navBar: navBar ?? this.navBar,
  );

  @override
  AppShadows lerp(AppShadows other, double t) => AppShadows(
    card: BoxShadow.lerpList(card, other.card, t) ?? other.card,
    raised: BoxShadow.lerpList(raised, other.raised, t) ?? other.raised,
    floatingAction:
        BoxShadow.lerpList(floatingAction, other.floatingAction, t) ??
        other.floatingAction,
    navBar: BoxShadow.lerpList(navBar, other.navBar, t) ?? other.navBar,
  );
}

/// The one way to read the theme's shadows — with the [AppShadows.standard]
/// fallback baked in, mirroring `context.appShapes`.
extension AppShadowsContextX on BuildContext {
  AppShadows get appShadows =>
      Theme.of(this).extension<AppShadows>() ?? AppShadows.standard;
}
