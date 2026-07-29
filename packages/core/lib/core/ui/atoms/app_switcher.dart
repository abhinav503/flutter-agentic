import 'package:flutter/material.dart';

/// The design system's content-swap transition — an [AnimatedSwitcher] with
/// the standard 300ms fade, so screens don't each carry their own duration
/// that can drift apart.
///
/// [topAligned] keeps in-flight children pinned to the top: the default
/// `AnimatedSwitcher` layout centres a shorter child against a taller one
/// mid-swap, which floats a few-row body mid-screen during loading → loaded.
class AppSwitcher extends StatelessWidget {
  final Widget child;
  final Duration duration;

  /// Applied to both the in and out transitions.
  final Curve curve;

  final bool topAligned;

  const AppSwitcher({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.linear,
    this.topAligned = false,
  });

  @override
  Widget build(BuildContext context) => AnimatedSwitcher(
    duration: duration,
    switchInCurve: curve,
    switchOutCurve: curve,
    layoutBuilder: topAligned
        ? (currentChild, previousChildren) => Stack(
            alignment: Alignment.topCenter,
            children: [...previousChildren, ?currentChild],
          )
        : AnimatedSwitcher.defaultLayoutBuilder,
    child: child,
  );
}
