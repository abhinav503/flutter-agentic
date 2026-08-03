import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';

/// A row deleted by swiping left, revealing a panel with a trash glyph — the
/// cart-row / address-card silhouette every storefront pack redraws.
///
/// The revealed layer is painted by this widget's own `Stack`, **not** handed
/// to [Dismissible.background]: a background is sized to the row and slides
/// with the gesture, so it squares off outside the clip and the glyph moves
/// with the finger. Painting it underneath keeps the glyph still while the
/// row slides off it, clipped to [borderRadius] as one shape.
///
/// Two commit styles, chosen by [confirmDismiss]:
/// - null → optimistic: the fling animation runs and [onDelete] fires when
///   the row is gone (a cart row backed by local state).
/// - non-null → deliberate: the callback decides. To survive a *failed*
///   delete, resolve `false` and run the delete behind it — answering `true`
///   drops the row optimistically, and re-emitting the same list rebuilds a
///   [Dismissible] the framework believes it already dismissed, which
///   throws. Giving up the fling is what buys the row back.
class SwipeToDeleteRow extends StatelessWidget {
  /// Identifies the record, not its position — keyed on an index, a row
  /// removed above this one would hand its dismiss state to a different item.
  final Object itemKey;

  final Widget child;

  /// The glyph on the revealed panel — each pack passes its own trash asset.
  final Widget icon;

  final BorderRadius borderRadius;

  /// Panel fill behind [child]. Defaults to `cs.errorContainer`.
  final Color? backgroundColor;

  /// Gap between [icon] and the row's trailing edge.
  final double iconInset;

  final VoidCallback? onDelete;
  final Future<bool> Function()? confirmDismiss;

  const SwipeToDeleteRow({
    super.key,
    required this.itemKey,
    required this.child,
    required this.icon,
    required this.borderRadius,
    this.backgroundColor,
    this.iconInset = AppSpacing.lg,
    this.onDelete,
    this.confirmDismiss,
  }) : assert(
         onDelete != null || confirmDismiss != null,
         'Pass onDelete (optimistic) or confirmDismiss (deliberate).',
       );

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: borderRadius,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: backgroundColor ?? cs.errorContainer,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: iconInset),
              child: icon,
            ),
          ),
          Dismissible(
            key: ValueKey(itemKey),
            direction: DismissDirection.endToStart,
            confirmDismiss: confirmDismiss == null
                ? null
                : (_) => confirmDismiss!(),
            onDismissed: onDelete == null ? null : (_) => onDelete!(),
            // The panel above is the real background; this one would just
            // double it, unclipped.
            background: const SizedBox.shrink(),
            child: child,
          ),
        ],
      ),
    );
  }
}
