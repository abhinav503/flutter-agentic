import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/page_indicator.dart';

import 'package:cordelia/feature/storefront/home/domain/entities/banner_entity.dart';
import 'package:cordelia/templates/grofast/constants/grofast_dimen_const.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_promo_card.dart';

/// Home's promo carousel (kit frame `17:1`): cards at 0.776 of the screen —
/// 291 on the kit's 375 — starting at the screen gutter with an 18 gap
/// between them, so the next banner peeks in from the right edge and the rail
/// reads as continuous rather than paged.
///
/// The gutter is paid by the viewport, not by the cards: padding the *pages*
/// insets every card by it and leaves the first one sitting well inside the
/// screen's own gutter, out of line with every other row on Home.
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

  @override
  State<GrofastHomePromoCarousel> createState() =>
      _GrofastHomePromoCarouselState();
}

class _GrofastHomePromoCarouselState extends State<GrofastHomePromoCarousel> {
  PageController? _controller;
  double _fraction = 0;
  int _page = 0;

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
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: GrofastDimenConst.screenGutter),
          child: SizedBox(
            height: GrofastDimenConst.promoCardHeight,
            child: PageView.builder(
              controller: _controller,
              // Without this the pages centre in the viewport, which pushes
              // the first card off the gutter it is supposed to start on.
              padEnds: false,
              itemCount: widget.banners.length,
              onPageChanged: (page) => setState(() => _page = page),
              itemBuilder: (context, index) {
                final banner = widget.banners[index];
                return Padding(
                  // The gap lives inside the page, so what's left of it is the
                  // card's own width.
                  padding: const EdgeInsets.only(
                    right: GrofastDimenConst.promoCardGap,
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
        ),
        if (widget.banners.length > 1) ...[
          const SizedBox(height: AppSpacing.lg),
          PageIndicator(count: widget.banners.length, currentIndex: _page),
        ],
      ],
    );
  }
}
