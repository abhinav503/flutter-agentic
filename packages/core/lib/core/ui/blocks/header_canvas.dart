import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';

/// The coloured header canvas — a primary-coloured, status-bar-inset surface
/// a screen-top hero header sits on (design.md's "coloured header canvas"
/// composition). Rich headers (a location row, a live search field) compose
/// their own content onto this; title-based headers use [HeroHeader], which
/// wraps it.
///
/// Keep [child] free of `Center`/`Align`: inside `CollapsingHeaderSheet`'s
/// Stack the header gets loose (unbounded) height, and an alignment widget
/// would expand to fill it, blowing the header up to nearly the full screen.
/// Rows/Columns of fixed-size controls size themselves correctly.
class HeaderCanvas extends StatelessWidget {
  final Widget child;

  /// [AppSpacing.xl2] for a plain header row; headers with a second content
  /// row sitting close to the sheet below (e.g. a filter-chip row) pass a
  /// tighter value.
  final double bottomPadding;

  const HeaderCanvas({
    super.key,
    required this.child,
    this.bottomPadding = AppSpacing.xl2,
  });

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;

    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.primary,
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        topInset + AppSpacing.xs,
        AppSpacing.lg,
        bottomPadding,
      ),
      child: child,
    );
  }
}
