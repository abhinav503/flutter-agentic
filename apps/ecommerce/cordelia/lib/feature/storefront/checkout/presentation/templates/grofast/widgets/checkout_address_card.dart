import 'package:flutter/material.dart';

import 'package:core/core/theme/app_shapes_extension.dart';
import 'package:core/core/theme/app_spacing.dart';

import 'package:cordelia/feature/storefront/address/domain/entities/address_entity.dart';
import 'package:cordelia/templates/grofast/constants/grofast_text_style_const.dart';

/// Checkout's delivery-address card (kit frame `119:819`) — the selected
/// address drawn with the pack's primary outline, the way the kit marks the
/// chosen one of its two cards.
///
/// The kit puts a small **map thumbnail** on the left of each card. Nothing in
/// this app stores coordinates for an address, so the card leads with the
/// address tag instead of shipping a fake map (spec sheet §11).
class GrofastCheckoutAddressCard extends StatelessWidget {
  final AddressEntity address;
  final VoidCallback onTap;

  const GrofastCheckoutAddressCard({
    super.key,
    required this.address,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final radius = BorderRadius.circular(context.appShapes.cardRadius);

    return Material(
      color: cs.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(color: cs.primary),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl2),
          child: Row(
            children: [
              Icon(
                Icons.location_on_rounded,
                size: AppSpacing.xl4,
                color: cs.primary,
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      address.tag.isEmpty ? address.name : address.tag,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GrofastTextStyleConst.rowTitleBold(tt),
                    ),
                    const SizedBox(height: AppSpacing.xs3),
                    Text(
                      address.displayLine,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GrofastTextStyleConst.bodySmall(
                        tt,
                      ).copyWith(color: cs.onSurfaceVariant),
                    ),
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
