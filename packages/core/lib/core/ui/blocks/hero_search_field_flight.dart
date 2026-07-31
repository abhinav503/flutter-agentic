import 'package:flutter/material.dart';

/// The Home <-> Search hero-flight mechanics both templates' search bars
/// share, so the fiddly reasoning lives once:
///
/// - a plain [RectTween] (the default `MaterialRectArcTween` bows the pill
///   sideways mid-flight);
/// - the shuttle is a **non-interactive copy** of the bar: the live field's
///   `FocusNode` must stay out of the overlay (Search requests focus the
///   moment the route settles, mid-dismount of the shuttle), and a text
///   field in the overlay has no Material ancestor without the transparent
///   [Material] wrapper.
///
/// The bar's visuals stay entirely with the caller via [barBuilder];
/// [shuttleWrapper] optionally paints pack chrome behind the in-flight copy
/// (gravia's primary canvas under its glass field).
class HeroSearchFieldFlight extends StatelessWidget {
  final Object tag;

  /// Builds the bar; `interactive: false` must detach focus/callbacks so
  /// the shuttle copy is inert.
  final Widget Function(BuildContext context, {required bool interactive})
  barBuilder;

  /// Wraps the shuttle copy (inside the transparent Material).
  final Widget Function(BuildContext flightContext, Widget child)?
  shuttleWrapper;

  const HeroSearchFieldFlight({
    super.key,
    required this.tag,
    required this.barBuilder,
    this.shuttleWrapper,
  });

  @override
  Widget build(BuildContext context) => Hero(
    tag: tag,
    createRectTween: (begin, end) => RectTween(begin: begin, end: end),
    flightShuttleBuilder:
        (flightContext, animation, direction, fromHeroContext, toHeroContext) {
          Widget shuttle = ExcludeFocus(
            child: AbsorbPointer(
              child: barBuilder(flightContext, interactive: false),
            ),
          );
          if (shuttleWrapper != null) {
            shuttle = shuttleWrapper!(flightContext, shuttle);
          }
          return Material(type: MaterialType.transparency, child: shuttle);
        },
    child: Material(
      type: MaterialType.transparency,
      child: barBuilder(context, interactive: true),
    ),
  );
}
