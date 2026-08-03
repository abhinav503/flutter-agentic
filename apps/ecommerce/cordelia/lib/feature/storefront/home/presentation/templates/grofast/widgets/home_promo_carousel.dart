import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/page_indicator.dart';

import 'package:cordelia/feature/storefront/home/domain/entities/banner_entity.dart';
import 'package:cordelia/templates/grofast/constants/grofast_dimen_const.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_promo_card.dart';

/// Home's promo carousel (kit frame `17:1`): full-bleed cards at 0.776 of the
/// viewport, so the next banner peeks in from the right edge and the rail
/// reads as continuous rather than paged.
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
  late final PageController _controller = PageController(
    viewportFraction: GrofastDimenConst.promoViewportFraction,
  );
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
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
                // Gutter on the leading edge of the first card only; the gap
                // between cards is what makes the neighbour peek.
                padding: EdgeInsets.only(
                  left: index == 0 ? GrofastDimenConst.screenGutter : 0,
                  right: AppSpacing.xl,
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
