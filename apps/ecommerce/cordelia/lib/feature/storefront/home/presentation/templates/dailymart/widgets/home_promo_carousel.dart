import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/page_indicator.dart';

import 'package:cordelia/feature/storefront/home/domain/entities/product_entity.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_dimen_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_value_const.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_promo_card.dart';

/// The "Top Seller" rail — peeking promo cards with a dot indicator beneath.
///
/// The kit's promo copy is per-banner marketing text. This app has no banner
/// resource (the admin catalog seeds products and categories only), so each
/// card is driven by a real top-selling product: its photo and name, with the
/// subtitle derived from its own discount. Swap the source, not the widget,
/// when a banners endpoint exists.
///
/// A `PageView` rather than a horizontal `ListView`: the list gets the peek
/// right but loses page snapping and the page index the indicator needs.
class DailyMartHomePromoCarousel extends StatefulWidget {
  final List<ProductEntity> products;
  final ValueChanged<ProductEntity> onProductTap;

  const DailyMartHomePromoCarousel({
    super.key,
    required this.products,
    required this.onProductTap,
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
              itemCount: widget.products.length,
              onPageChanged: (page) => setState(() => _page = page),
              itemBuilder: (context, index) {
                final product = widget.products[index];
                return Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.base),
                  child: DailyMartPromoCard(
                    title: product.name,
                    subtitle: DailyMartValueConst.promoSubtitle(
                      product.discountPercentage,
                    ),
                    imageUrl: product.imageUrl,
                    onTap: () => widget.onProductTap(product),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.base),
        PageIndicator(
          count: widget.products.length,
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
