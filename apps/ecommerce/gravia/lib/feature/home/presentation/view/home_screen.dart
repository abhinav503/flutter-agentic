import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_shapes_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/loading_indicator.dart';
import 'package:core/core/ui/molecules/error_view.dart';

import 'package:gravia/constants/value_const.dart';

import '../../domain/entities/home_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../bloc/home_bloc.dart';
import '../widgets/home_category_section.dart';
import '../widgets/home_hero_header.dart';
import '../widgets/home_popular_items_section.dart';

class HomeScreen extends BaseScreen {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseScreenState<HomeScreen> {
  @override
  Widget body(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state case HomeError(:final message)) showSnackBar(message);
        },
        builder: (context, state) => switch (state) {
          HomeLoading() => Container(
            color: cs.primary,
            child: const SafeArea(child: Center(child: LoadingIndicator())),
          ),
          HomeError() => SafeArea(
            child: ErrorView(
              message: ValueConst.homeLoadErrorMessage,
              onRetry: () =>
                  context.read<HomeBloc>().add(const HomeEvent.started()),
            ),
          ),
          HomeLoaded(:final home) => _HomeContent(
            home: home,
            onAddToCart: (product) =>
                showSnackBar(ValueConst.addedToCartMessage(product.name)),
            onFavouriteToggle: (id) => context.read<HomeBloc>().add(
              HomeEvent.favouriteToggled(productId: id),
            ),
            onComingSoon: () => showSnackBar(ValueConst.comingSoonMessage),
          ),
        },
      ),
    );
  }
}

class _HomeContent extends StatefulWidget {
  final HomeEntity home;
  final ValueChanged<ProductEntity> onAddToCart;
  final ValueChanged<String> onFavouriteToggle;
  final VoidCallback onComingSoon;

  const _HomeContent({
    required this.home,
    required this.onAddToCart,
    required this.onFavouriteToggle,
    required this.onComingSoon,
  });

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  final _headerKey = GlobalKey();
  final _scrollController = ScrollController();

  // Corrected post-frame once the real header is laid out (size depends on
  // status bar height / text scale) — this estimate just avoids a first-frame
  // jump before that measurement lands.
  double _headerHeight = 220;

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

  // How much of the header is still uncovered by the scrolling sheet right
  // now — shrinks as the user scrolls, reaching 0 once the sheet has fully
  // covered it. Read live at hit-test time, not cached in state, since it
  // must reflect the scroll position at the exact moment of the tap.
  double get _uncoveredHeaderHeight => _scrollController.hasClients
      ? (_headerHeight - _scrollController.offset).clamp(0, _headerHeight)
      : _headerHeight;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final shapes =
        Theme.of(context).extension<AppShapes>() ?? AppShapes.standard;

    return SizedBox.expand(
      // Stack's own size defaults to its non-positioned child (the header)
      // when the incoming constraints are loose, which is all the Scaffold
      // body gives it — without forcing full size here, the Stack (and the
      // Positioned.fill scroll layer inside it) shrink-wraps to just the
      // header's height, leaving the rest of the screen blank until scrolled.
      child: ColoredBox(
        // Matches the header so the rounded sheet's corner cutouts (the small
        // areas outside the arc but inside its bounding box, left unpainted by
        // BoxDecoration) always reveal this colour — whether that point is
        // still over the header or has scrolled past it — instead of the
        // scaffold's default background flashing through as a mismatched notch.
        color: cs.primary,
        child: Stack(
          children: [
            HomeHeroHeader(
              key: _headerKey,
              onNotificationTap: widget.onComingSoon,
            ),
            // Full-bleed scroll layer sitting ON TOP of the header in the stack
            // — a leading spacer sliver sized to the header covers it at rest,
            // and scrolls away with the rest of the content, letting the
            // rounded sheet slide up over the header instead of stopping at
            // its bottom edge the way a plain Column/Expanded split would.
            //
            // A Scrollable claims hit-tests across its whole bounds (it has
            // to, to support dragging from anywhere), so without
            // _PassThroughAboveOffset this layer would swallow every tap over
            // the header's screen region — including the transparent spacer
            // where there's nothing to actually tap — before it ever reaches
            // HomeHeroHeader's buttons/search field underneath.
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
                          color: cs.surface,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(shapes.sheetRadius),
                            topRight: Radius.circular(shapes.sheetRadius),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.xl4,
                          ),
                          child: Column(
                            children: [
                              // Each section pads its own header but leaves
                              // its horizontal scroll row unpadded on the
                              // right, so cards can bleed to the true screen
                              // edge instead of stopping short — padding here
                              // would bound that scroll content on both sides.
                              HomeCategorySection(
                                categories: widget.home.categories,
                                onComingSoon: widget.onComingSoon,
                              ),
                              const SizedBox(height: AppSpacing.xl4),
                              HomePopularItemsSection(
                                products: widget.home.popularProducts,
                                onAddToCart: widget.onAddToCart,
                                onFavouriteToggle: widget.onFavouriteToggle,
                                onComingSoon: widget.onComingSoon,
                              ),
                            ],
                          ),
                        ),
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

/// Forwards hit-testing on [child] down to whatever sits behind it in an
/// enclosing [Stack] for any tap above [thresholdGetter]'s current value —
/// e.g. a [Scrollable] that otherwise claims every tap in its bounds
/// regardless of whether there's real content there.
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
