import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/page_indicator.dart';

import 'package:cordelia/feature/storefront/home/domain/entities/banner_entity.dart';
import 'package:cordelia/templates/grofast/constants/grofast_dimen_const.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_product_grid.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_promo_card.dart';

/// Home's promo carousel (kit frame `17:1`): cards at 0.776 of the screen
/// with an 18 gap between them, run as a **centred peeking rail** — the
/// dailymart carousel's behaviour, adopted here over the kit's left-gutter
/// start so the rail is full-bleed: no gutter of its own, `padEnds` (left at
/// its default) insets the resting page equally on both sides, and while
/// scrolling the cards touch both screen edges.
///
/// The dots are only drawn for a real carousel — a store with one banner gets
/// the card alone, since an indicator with a single dot is noise.
class GrofastHomePromoCarousel extends StatefulWidget {
  final List<BannerEntity> banners;
  final ValueChanged<BannerEntity> onBannerTap;

  const GrofastHomePromoCarousel({
    super.key,
    required this.banners,
    required this.onBannerTap,
  });

  /// The rail opens on the **second** banner whenever there is one, so the
  /// first peeks on the left and the third on the right and the rail reads as
  /// centred rather than as a list that starts at the edge. A lone banner has
  /// nothing to sit between, so it stays on page 0.
  ///
  /// Public so [GrofastHomePromoCarouselSkeleton] settles on the same page —
  /// a skeleton resting somewhere else would slide sideways on load.
  static int restingPage(int bannerCount) => bannerCount > 1 ? 1 : 0;

  @override
  State<GrofastHomePromoCarousel> createState() =>
      _GrofastHomePromoCarouselState();
}

class _GrofastHomePromoCarouselState extends State<GrofastHomePromoCarousel> {
  PageController? _controller;
  double _fraction = 0;
  late int _page = GrofastHomePromoCarousel.restingPage(widget.banners.length);

  // The page fraction depends on the screen width (see promoPageFraction), and
  // PageController takes it as a final — so the controller is rebuilt here,
  // where a width change is actually observable, rather than in initState.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final fraction = GrofastDimenConst.promoPageFraction(
      MediaQuery.sizeOf(context).width,
    );
    if (fraction == _fraction) return;
    _fraction = fraction;
    _controller?.dispose();
    _controller = PageController(
      viewportFraction: fraction,
      initialPage: _page,
    );
  }

  @override
  void didUpdateWidget(covariant GrofastHomePromoCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    // A silent refresh can hand this rail a shorter list while it is on
    // screen; without this the indicator would keep marking a page the
    // PageView no longer has.
    final lastPage = widget.banners.length - 1;
    if (_page > lastPage && lastPage >= 0) {
      _page = lastPage;
      _controller?.jumpToPage(lastPage);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: GrofastDimenConst.promoCardHeight,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.banners.length,
            onPageChanged: (page) => setState(() => _page = page),
            itemBuilder: (context, index) {
              final banner = widget.banners[index];
              return Padding(
                // The gap splits across both edges, not just the right: on a
                // centred page a one-sided inset shifts every card off its
                // own slot.
                padding: const EdgeInsets.symmetric(
                  horizontal: GrofastDimenConst.promoCardGap / 2,
                ),
                child: GrofastPromoCard(
                  banner: banner,
                  onTap: banner.hasTarget
                      ? () => widget.onBannerTap(banner)
                      : null,
                ),
              );
            },
          ),
        ),
        if (widget.banners.length > 1) ...[
          const SizedBox(height: AppSpacing.lg),
          PageIndicator(count: widget.banners.length, currentIndex: _page),
        ],
      ],
    );
  }
}

/// [GrofastHomePromoCarousel]'s loading state: shimmering cards in the real
/// rail's geometry, resting on the same page, under a dot row marking the
/// same dot.
///
/// Built on an actual `PageView` with the same controller settings rather
/// than a hand-measured Row — the peek width falls out of `viewportFraction`,
/// `padEnds` and the resting page together, so re-deriving it here is how a
/// skeleton ends up a few pixels off and visibly snaps into place on load.
class GrofastHomePromoCarouselSkeleton extends StatefulWidget {
  static const placeholderCount = 3;

  const GrofastHomePromoCarouselSkeleton({super.key});

  @override
  State<GrofastHomePromoCarouselSkeleton> createState() =>
      _GrofastHomePromoCarouselSkeletonState();
}

class _GrofastHomePromoCarouselSkeletonState
    extends State<GrofastHomePromoCarouselSkeleton> {
  /// Derived, not written as `1`: the carousel owns the rule, and a literal
  /// here would silently stop matching if that rule changed.
  static final _restingPage = GrofastHomePromoCarousel.restingPage(
    GrofastHomePromoCarouselSkeleton.placeholderCount,
  );

  PageController? _controller;
  double _fraction = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final fraction = GrofastDimenConst.promoPageFraction(
      MediaQuery.sizeOf(context).width,
    );
    if (fraction == _fraction) return;
    _fraction = fraction;
    _controller?.dispose();
    _controller = PageController(
      viewportFraction: fraction,
      initialPage: _restingPage,
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: GrofastDimenConst.promoCardHeight,
          child: PageView.builder(
            controller: _controller,
            // A skeleton is not a control — swiping placeholders would let a
            // shopper leave the resting page and land mid-scroll on load.
            physics: const NeverScrollableScrollPhysics(),
            itemCount: GrofastHomePromoCarouselSkeleton.placeholderCount,
            itemBuilder: (context, index) => const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: GrofastDimenConst.promoCardGap / 2,
              ),
              child: GrofastCardSkeleton(
                height: GrofastDimenConst.promoCardHeight,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        PageIndicator(
          count: GrofastHomePromoCarouselSkeleton.placeholderCount,
          currentIndex: _restingPage,
        ),
      ],
    );
  }
}
