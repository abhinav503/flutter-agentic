import 'package:flutter/material.dart';

/// Docks [bar] along the bottom edge and lets [child] extend [overlap] px
/// underneath it — a plain `Column` can't overlap, so the transparent
/// cut-outs beside a rounded-top bar's corners would reveal the scaffold
/// background instead of the content. With the overlap set to the bar's
/// corner radius, only the corner strip of content sits behind the bar, so
/// nothing meaningful is hidden and the bar reads as a card floating on the
/// content.
///
/// [bar] draws its own background (typically a `DecoratedBox` with
/// `AppShapes.sheetRadius` top corners); taps inside its transparent corner
/// cut-outs fall through to [child]. Pass a zero-size widget (e.g.
/// `SizedBox.shrink()`) to hide the bar without restructuring the tree —
/// swapping this widget in and out around [child] would remount its subtree
/// (and any `BlocProvider` in it).
///
/// ```dart
/// DockedBarOverlap(
///   overlap: shapes.sheetRadius,
///   bar: CartStatusBar(...),
///   child: content,
/// )
/// ```
class DockedBarOverlap extends StatelessWidget {
  final Widget child;
  final Widget bar;
  final double overlap;

  const DockedBarOverlap({
    super.key,
    required this.child,
    required this.bar,
    required this.overlap,
  });

  @override
  Widget build(BuildContext context) => CustomMultiChildLayout(
    delegate: _DockedBarOverlapDelegate(overlap),
    // Paint order: content first, bar on top of its corner strip.
    children: [
      LayoutId(id: _DockedBarSlot.content, child: child),
      LayoutId(id: _DockedBarSlot.bar, child: bar),
    ],
  );
}

enum _DockedBarSlot { content, bar }

class _DockedBarOverlapDelegate extends MultiChildLayoutDelegate {
  final double overlap;

  _DockedBarOverlapDelegate(this.overlap);

  @override
  void performLayout(Size size) {
    final barSize = layoutChild(
      _DockedBarSlot.bar,
      BoxConstraints(
        maxWidth: size.width,
        maxHeight: size.height,
      ).tighten(width: size.width),
    );
    positionChild(_DockedBarSlot.bar, Offset(0, size.height - barSize.height));

    final contentHeight = (size.height - barSize.height + overlap).clamp(
      0.0,
      size.height,
    );
    layoutChild(
      _DockedBarSlot.content,
      BoxConstraints.tight(Size(size.width, contentHeight)),
    );
    positionChild(_DockedBarSlot.content, Offset.zero);
  }

  @override
  bool shouldRelayout(_DockedBarOverlapDelegate oldDelegate) =>
      oldDelegate.overlap != overlap;
}
