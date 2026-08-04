import 'package:flutter/material.dart';

/// The `color → transparent` gradient a floating CTA sits over, so content
/// scrolling underneath fades out instead of colliding with the control. An
/// [IgnorePointer], so the list beneath stays scrollable through it.
///
/// Position it yourself (`Positioned` across a stack's bottom edge) — this
/// widget is only the gradient. The zero-alpha end stop reuses the fade
/// colour: `Colors.transparent` produces a grey halo on some engines.
class BottomFade extends StatelessWidget {
  final double height;

  /// The colour the fade dissolves into — defaults to `cs.surface`; pass the
  /// canvas actually behind it when that differs (a tinted home canvas).
  final Color? color;

  /// Where (0–1, measured from the **bottom** edge upward) the fade stops
  /// being fully opaque and starts dissolving. `0` fades along the whole
  /// height — for a fade landing on an already-opaque band (a docked bar),
  /// where any solid stretch would read as a slab above it.
  final double solidUntil;

  /// True when the fade sits at the device edge with a control floating in
  /// it: it then adds the device inset to [height], so the control has solid
  /// colour behind it all the way to the edge.
  final bool payBottomInset;

  const BottomFade({
    super.key,
    this.height = 96,
    this.color,
    this.solidUntil = 0.24,
    this.payBottomInset = false,
  });

  @override
  Widget build(BuildContext context) {
    final fadeColor = color ?? Theme.of(context).colorScheme.surface;

    return IgnorePointer(
      child: Container(
        height: payBottomInset
            ? height + MediaQuery.paddingOf(context).bottom
            : height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            stops: [solidUntil, 1],
            colors: [fadeColor, fadeColor.withValues(alpha: 0)],
          ),
        ),
      ),
    );
  }
}
