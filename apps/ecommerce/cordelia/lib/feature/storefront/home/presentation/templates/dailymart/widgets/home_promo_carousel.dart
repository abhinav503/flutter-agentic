import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/page_indicator.dart';

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

  @override
  State<DailyMartHomePromoCarousel> createState() =>
      _DailyMartHomePromoCarouselState();
}

class _DailyMartHomePromoCarouselState
    extends State<DailyMartHomePromoCarousel> {
  late final PageController _controller = PageController(
    viewportFraction: DailyMartDimenConst.promoViewportFraction,
  );
  int _page = 0;

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
        // The gutter shifts the viewport, not each page — inside the item it
        // would widen every inter-card gap. Kept off the whole block so the
        // indicator below still centres on the true screen centre.
        Padding(
          padding: const EdgeInsets.only(left: AppSpacing.lg),
          child: SizedBox(
            height: DailyMartDimenConst.promoCardHeight,
            child: PageView.builder(
              controller: _controller,
              // Left-aligns the first card with the screen gutter instead of
              // centring it — the kit's first card starts flush, with only
              // the next one peeking.
              padEnds: false,
              itemCount: widget.banners.length,
              onPageChanged: (page) => setState(() => _page = page),
              itemBuilder: (context, index) {
                final banner = widget.banners[index];
                return Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.base),
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
