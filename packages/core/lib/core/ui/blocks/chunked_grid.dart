import 'package:flutter/material.dart';

/// Lays out [itemCount] items in fixed-width rows of [columns], built with
/// manual `Row`/`Expanded` chunking rather than a `GridView` — for a fixed
/// column grid nested inside a scrollable that isn't itself sliver-composed.
/// A `shrinkWrap` `GridView` there forces every item to lay out up front
/// anyway (no real laziness win), and a guessed `mainAxisExtent` either clips
/// content or leaves dead space.
///
/// The last row, if short of a full [columns], is padded with empty
/// [Expanded] fillers so real items stay left-aligned instead of stretching
/// wider to fill the row.
///
/// ```dart
/// ChunkedGrid(
///   itemCount: categories.length,
///   columns: 4,
///   spacing: AppSpacing.xs,
///   runSpacing: AppSpacing.lg,
///   itemBuilder: (context, index) => CategoryTile(...),
/// )
/// ```
class ChunkedGrid extends StatelessWidget {
  final int itemCount;
  final int columns;
  final IndexedWidgetBuilder itemBuilder;

  /// Horizontal gap between columns.
  final double spacing;

  /// Vertical gap between rows.
  final double runSpacing;

  /// Matches [Row]'s own default (`center`) — override to `start` when items
  /// in the same row can have different heights (e.g. a product grid whose
  /// cards carry a variable-length meta row).
  final CrossAxisAlignment crossAxisAlignment;

  const ChunkedGrid({
    super.key,
    required this.itemCount,
    required this.columns,
    required this.itemBuilder,
    this.spacing = 0,
    this.runSpacing = 0,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    final rowCount = (itemCount / columns).ceil();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var r = 0; r < rowCount; r++) ...[
          if (r > 0) SizedBox(height: runSpacing),
          Row(
            crossAxisAlignment: crossAxisAlignment,
            children: [
              for (var c = 0; c < columns; c++) ...[
                if (c > 0) SizedBox(width: spacing),
                Expanded(
                  child: r * columns + c < itemCount
                      ? itemBuilder(context, r * columns + c)
                      : const SizedBox.shrink(),
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }
}
