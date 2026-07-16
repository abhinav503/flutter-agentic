import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';

/// The pack's coloured header canvas — the primary-coloured, status-bar-inset
/// surface every gravia hero header sits on (docs/ai-rules/design.md's
/// "coloured header canvas" composition). Rich headers (Home's location row,
/// Search's live field) compose their own content onto this; title-based
/// headers use [GraviaHeroHeader], which wraps it.
///
/// Keep [child] free of `Center`/`Align`: inside `CollapsingHeaderSheet`'s
/// Stack the header gets loose (unbounded) height, and an alignment widget
/// would expand to fill it, blowing the header up to nearly the full screen.
/// Rows/Columns of fixed-size controls size themselves correctly.
class GraviaHeaderCanvas extends StatelessWidget {
  final Widget child;

  /// [AppSpacing.xl2] for a plain header row; headers with a second content
  /// row sitting close to the sheet (e.g. Category Details' filter chips)
  /// pass a tighter value.
  final double bottomPadding;

  const GraviaHeaderCanvas({
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
