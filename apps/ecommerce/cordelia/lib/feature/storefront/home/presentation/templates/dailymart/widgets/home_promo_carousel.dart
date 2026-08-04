import 'package:flutter/material.dart';

import 'package:core/core/theme/app_shapes_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/page_indicator.dart';
import 'package:core/core/ui/atoms/shimmer_box.dart';

import 'package:cordelia/feature/storefront/home/domain/entities/banner_entity.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_dimen_const.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_promo_card.dart';

/// The "Top Seller" rail — peeking promo cards with a dot indicator beneath.
///
/// Driven by the store's admin-authored banners (dashboard → Banners): the
/// kit's promo copy is per-banner marketing text, which is what a banner
/// carries. A banner with no link target renders as a non-tappable card.
///
/// A `PageView` rather than a horizontal `ListView`: the list gets the peek
/// right but loses page snapping and the page index the indicator needs.
class DailyMartHomePromoCarousel extends StatefulWidget {
  final List<BannerEntity> banners;
  final ValueChanged<BannerEntity> onBannerTap;

  const DailyMartHomePromoCarousel({
    super.key,
    required this.banners,
    required this.onBannerTap,
  });

  /// The rail opens on the **second** banner whenever there is one, so the
  /// first peeks on the left and the third on the right and the rail reads as
  /// centred rather than as a list that starts at the edge. A lone banner has
  /// nothing to sit between, so it stays on page 0.
  ///
  /// Public so [DailyMartHomePromoCarouselSkeleton] settles on the same page —
  /// a skeleton resting somewhere else would slide sideways on load.
  static int restingPage(int bannerCount) => bannerCount > 1 ? 1 : 0;

  @override
  State<DailyMartHomePromoCarousel> createState() =>
      _DailyMartHomePromoCarouselState();
}

class _DailyMartHomePromoCarouselState
    extends State<DailyMartHomePromoCarousel> {
  late final PageController _controller = PageController(
    viewportFraction: DailyMartDimenConst.promoViewportFraction,
    initialPage: DailyMartHomePromoCarousel.restingPage(widget.banners.length),
  );
  late int _page = DailyMartHomePromoCarousel.restingPage(
    widget.banners.length,
  );

  @override
  void didUpdateWidget(covariant DailyMartHomePromoCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    // A silent refresh can hand this rail a shorter list while it is on
    // screen; without this the indicator would keep marking a page the
    // PageView no longer has.
    final lastPage = widget.banners.length - 1;
    if (_page > lastPage && lastPage >= 0) {
      _page = lastPage;
      _controller.jumpToPage(lastPage);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // No screen gutter of its own — `padEnds` (left at its default) is
        // what insets the rail, and it does so equally on both sides, so the
        // resting card is centred with its neighbours peeking symmetrically.
        // Adding a gutter here would break that symmetry.
        SizedBox(
          height: DailyMartDimenConst.promoCardHeight,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.banners.length,
            onPageChanged: (page) => setState(() => _page = page),
            itemBuilder: (context, index) {
              final banner = widget.banners[index];
              return Padding(
                // Split across both edges, not just the right: on a centred
                // page a one-sided inset shifts every card off its own slot.
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs2),
                child: DailyMartPromoCard(
                  title: banner.title,
                  subtitle: banner.subtitle,
                  imageUrl: banner.imageUrl,
                  onTap: banner.hasTarget
                      ? () => widget.onBannerTap(banner)
                      : null,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.base),
        PageIndicator(
          count: widget.banners.length,
          currentIndex: _page,
          // On the mint canvas, `surfaceContainerHighest` (the default) is a
          // near-white blue that all but disappears — the outline shade is
          // the one neutral that still reads there and on dark's surface.
          inactiveColor: cs.outline,
        ),
      ],
    );
  }
}

/// [DailyMartHomePromoCarousel]'s loading state: three shimmering cards in the
/// real rail's geometry, resting on the same page, under a dot row marking the
/// same dot.
///
/// Built on an actual `PageView` with the same controller settings rather than
/// a hand-measured Row — the peek width falls out of `viewportFraction`,
/// `padEnds` and the resting page together, so re-deriving it here is how a
/// skeleton ends up a few pixels off and visibly snaps into place on load.
/// Lives beside the carousel for the same reason: the two share one set of
/// numbers and have to change together.
class DailyMartHomePromoCarouselSkeleton extends StatefulWidget {
  /// Matches the fallback promo count the loaded rail falls back to when a
  /// store has authored no banners — so the dot row keeps its width too.
  static const placeholderCount = 3;

  const DailyMartHomePromoCarouselSkeleton({super.key});

  @override
  State<DailyMartHomePromoCarouselSkeleton> createState() =>
      _DailyMartHomePromoCarouselSkeletonState();
}

class _DailyMartHomePromoCarouselSkeletonState
    extends State<DailyMartHomePromoCarouselSkeleton> {
  /// Derived, not written as `1`: the carousel owns the rule, and a literal
  /// here would silently stop matching if that rule changed.
  static final _restingPage = DailyMartHomePromoCarousel.restingPage(
    DailyMartHomePromoCarouselSkeleton.placeholderCount,
  );

  late final PageController _controller = PageController(
    viewportFraction: DailyMartDimenConst.promoViewportFraction,
    initialPage: _restingPage,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final shapes = context.appShapes;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: DailyMartDimenConst.promoCardHeight,
          child: PageView.builder(
            controller: _controller,
            // A skeleton is not a control — swiping placeholders would let a
            // shopper leave the resting page and land mid-scroll on load.
            physics: const NeverScrollableScrollPhysics(),
            itemCount: DailyMartHomePromoCarouselSkeleton.placeholderCount,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs2),
              child: ShimmerBox(
                width: double.infinity,
                height: DailyMartDimenConst.promoCardHeight,
                borderRadius: BorderRadius.circular(shapes.cardRadius),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.base),
        PageIndicator(
          count: DailyMartHomePromoCarouselSkeleton.placeholderCount,
          currentIndex: _restingPage,
          inactiveColor: cs.outline,
        ),
      ],
    );
  }
}
