import 'package:flutter/material.dart';

import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_shapes_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/network_image.dart';

import 'package:cordelia/feature/storefront/home/domain/entities/banner_entity.dart';
import 'package:cordelia/templates/grofast/constants/grofast_color_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_dimen_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_text_style_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_value_const.dart';

/// Home's promo banner (spec sheet §10): the store's artwork at radius 28
/// with the admin's copy stacked on the left and a small gradient "claim now"
/// pill beneath it.
///
/// The kit draws its banners on flat illustrated artwork, so its copy needs
/// no protection; a real store uploads a photograph, so the copy sits over
/// [GrofastColorConst.promoScrim] — a documented departure from the kit, made
/// because the alternative is unreadable text on half the stores' banners.
class GrofastPromoCard extends StatelessWidget {
  final BannerEntity banner;
  final VoidCallback? onTap;

  const GrofastPromoCard({super.key, required this.banner, this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final radius = BorderRadius.circular(context.appShapes.cardRadius);

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: radius,
        child: SizedBox(
          height: GrofastDimenConst.promoCardHeight,
          child: Stack(
            fit: StackFit.expand,
            children: [
              AppNetworkImage(url: banner.imageUrl, fit: BoxFit.cover),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      GrofastColorConst.promoScrim,
                      GrofastColorConst.promoScrim.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.xl2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      banner.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GrofastTextStyleConst.subheadBold(
                        tt,
                      ).copyWith(color: cs.onPrimary),
                    ),
                    if (banner.subtitle.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.xs3),
                      Text(
                        banner.subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GrofastTextStyleConst.bodySmall(
                          tt,
                        ).copyWith(color: cs.onPrimary),
                      ),
                    ],
                    if (banner.hasTarget) ...[
                      const SizedBox(height: AppSpacing.base),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: const BoxDecoration(
                          gradient: GrofastColorConst.brandGradient,
                          borderRadius: AppRadius.full,
                        ),
                        child: Text(
                          GrofastValueConst.claimNow,
                          style: GrofastTextStyleConst.bodySmall(
                            tt,
                          ).copyWith(color: cs.onPrimary),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
