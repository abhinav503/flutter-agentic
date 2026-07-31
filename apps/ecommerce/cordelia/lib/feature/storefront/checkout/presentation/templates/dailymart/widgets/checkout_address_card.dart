import 'package:flutter/material.dart';

import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/svg_image.dart';

import 'package:cordelia/feature/storefront/address/domain/entities/address_entity.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_image_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_text_style_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_value_const.dart';

/// Checkout's delivery-address block (kit frame `29 Checkout`) — a recessed
/// card with the pin, the "Shipping Address" label beside a white tag pill,
/// the address line and phone, and a chevron opening Select Address.
///
/// The whole card is the tap target, not just the chevron: the kit draws no
/// separate "Change" control here (unlike its Shipping Type block), so the
/// row itself has to be what changes the address.
class CheckoutAddressCard extends StatelessWidget {
  final AddressEntity address;
  final VoidCallback onChange;

  const CheckoutAddressCard({
    super.key,
    required this.address,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final lineStyle = DailyMartTextStyleConst.bodySmRegular(
      tt,
    ).copyWith(color: cs.onSurfaceVariant);

    return Material(
      color: cs.surfaceContainerLow,
      borderRadius: AppRadius.xl,
      child: InkWell(
        onTap: onChange,
        borderRadius: AppRadius.xl,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ships 14 × 20 — a square box lets BoxFit.contain letterbox it
              // rather than stretching the pin.
              SizedBox.square(
                dimension: AppSpacing.xl4,
                child: AppSvgImage.asset(
                  DailyMartImageConst.location,
                  color: cs.onSurface,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            DailyMartValueConst.shippingAddressLabel,
                            style: DailyMartTextStyleConst.bodyMdSemibold(
                              tt,
                            ).copyWith(color: cs.onSurface),
                          ),
                        ),
                        _TagPill(label: address.tag),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs3),
                    Text(address.displayLine, style: lineStyle),
                    if (address.phone.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.xs3),
                      Text(address.phone, style: lineStyle),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              SizedBox.square(
                dimension: AppSpacing.xl4,
                child: AppSvgImage.asset(
                  DailyMartImageConst.chevronRight,
                  color: cs.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The address's tag ("Home", "Work") as the kit's white pill — brand-green
/// label on the card's own surface colour, so it reads as a chip lifted off
/// the recessed card rather than another line of text.
class _TagPill extends StatelessWidget {
  final String label;

  const _TagPill({required this.label});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xs4,
      ),
      decoration: BoxDecoration(color: cs.surface, borderRadius: AppRadius.xl),
      child: Text(
        label,
        style: DailyMartTextStyleConst.bodyXsMedium(
          tt,
        ).copyWith(color: cs.primary),
      ),
    );
  }
}
