import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../theme/app_shapes_extension.dart';

/// The "coloured header canvas + white sheet" composition: a caller-supplied
/// [header] sits on a solid colour canvas; [body] lives on a surface sheet
/// whose large top radius overlaps the header, scrolling underneath it as
/// the sheet is dragged up (the header stays put — nothing pins it, so it
/// simply gets covered — while an invisible hit-test region above the
/// scrolled-up sheet still lets taps through to it).
///
/// ```dart
/// CollapsingHeaderSheet(
///   header: HomeHeroHeader(...),
///   body: Column(children: [CategorySection(...), PopularItemsSection(...)]),
/// )
/// ```
class CollapsingHeaderSheet extends StatefulWidget {
  final Widget header;
  final Widget body;

  /// Canvas colour behind [header] and around the sheet's rounded corners.
  /// Defaults to `cs.primary` — the pack's usual coloured-canvas colour.
  final Color? headerColor;

  /// Sheet background colour. Defaults to `cs.surface`.
  final Color? sheetColor;

  /// Best-guess header height for the first frame, before [header] is
  /// measured — avoids a visible jump. Match it roughly to the real header.
  final double initialHeaderHeight;

  const CollapsingHeaderSheet({
    super.key,
    required this.header,
    required this.body,
    this.headerColor,
    this.sheetColor,
    this.initialHeaderHeight = 220,
  });

  @override
  State<CollapsingHeaderSheet> createState() => _CollapsingHeaderSheetState();
}

class _CollapsingHeaderSheetState extends State<CollapsingHeaderSheet> {
  final _headerKey = GlobalKey();
  final _scrollController = ScrollController();
  late double _headerHeight = widget.initialHeaderHeight;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureHeader());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _measureHeader() {
    final height = _headerKey.currentContext?.size?.height;
    if (height != null && height != _headerHeight) {
      setState(() => _headerHeight = height);
    }
  }

  double get _uncoveredHeaderHeight => _scrollController.hasClients
      ? (_headerHeight - _scrollController.offset).clamp(0, _headerHeight)
      : _headerHeight;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final shapes = Theme.of(context).extension<AppShapes>() ?? AppShapes.standard;

    return SizedBox.expand(
      child: ColoredBox(
        color: widget.headerColor ?? cs.primary,
        child: Stack(
          children: [
            KeyedSubtree(key: _headerKey, child: widget.header),
            Positioned.fill(
              child: _PassThroughAboveOffset(
                thresholdGetter: () => _uncoveredHeaderHeight,
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverToBoxAdapter(child: SizedBox(height: _headerHeight)),
                    SliverToBoxAdapter(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: widget.sheetColor ?? cs.surface,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(shapes.sheetRadius),
                            topRight: Radius.circular(shapes.sheetRadius),
                          ),
                        ),
                        child: widget.body,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Below [thresholdGetter] (the header's still-uncovered height), hit-tests
/// fall through to whatever's behind this — the header itself — instead of
/// being captured by the scroll view's now-transparent region above the
/// sheet that has scrolled up underneath it.
class _PassThroughAboveOffset extends SingleChildRenderObjectWidget {
  const _PassThroughAboveOffset({
    required this.thresholdGetter,
    required Widget super.child,
  });

  final double Function() thresholdGetter;

  @override
  _RenderPassThroughAboveOffset createRenderObject(BuildContext context) =>
      _RenderPassThroughAboveOffset(thresholdGetter);

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderPassThroughAboveOffset renderObject,
  ) {
    renderObject.thresholdGetter = thresholdGetter;
  }
}

class _RenderPassThroughAboveOffset extends RenderProxyBox {
  _RenderPassThroughAboveOffset(this.thresholdGetter);

  double Function() thresholdGetter;

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (position.dy < thresholdGetter()) return false;
    return super.hitTest(result, position: position);
  }
}
