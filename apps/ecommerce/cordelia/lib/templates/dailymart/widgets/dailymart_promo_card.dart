import 'package:flutter/material.dart';

import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_shapes_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/network_image.dart';

import 'package:cordelia/templates/dailymart/constants/dailymart_color_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_text_style_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_value_const.dart';

/// A "Top Seller" promo card — a product photo under a 20% black scrim with
/// white copy and a small white "Order Now" pill.
///
/// The scrim is not decoration: the photo is store-uploaded and arbitrary, so
/// without it the white headline lands on whatever the image happens to be.
class DailyMartPromoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final VoidCallback? onTap;

  const DailyMartPromoCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final shapes =
        Theme.of(context).extension<AppShapes>() ?? AppShapes.standard;
    final radius = BorderRadius.circular(shapes.cardRadius);

    return ClipRRect(
      borderRadius: radius,
      child: Stack(
        fit: StackFit.expand,
        children: [
          AppNetworkImage(url: imageUrl, fit: BoxFit.cover),
          const ColoredBox(color: DailyMartColorConst.promoScrim),
          Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.base,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      // onPrimary, not onSurface: this copy sits on a photo,
                      // and the pack pairs every image overlay with white.
                      style: DailyMartTextStyleConst.promoTitle(
                        tt,
                      ).copyWith(color: cs.onPrimary),
                    ),
                    const SizedBox(height: AppSpacing.xs3),
                    Text(
                      subtitle,
                      style: DailyMartTextStyleConst.bodyXsMedium(
                        tt,
                      ).copyWith(color: cs.onPrimary),
                    ),
                    const SizedBox(height: AppSpacing.base),
                    _OrderNowPill(onTap: onTap),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderNowPill extends StatelessWidget {
  final VoidCallback? onTap;

  const _OrderNowPill({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Material(
      color: cs.surface,
      borderRadius: AppRadius.full,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.full,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.xs,
          ),
          child: Text(
            DailyMartValueConst.orderNow,
            style: DailyMartTextStyleConst.bodyXsSemibold(
              tt,
            ).copyWith(color: cs.onSurface),
          ),
        ),
      ),
    );
  }
}
