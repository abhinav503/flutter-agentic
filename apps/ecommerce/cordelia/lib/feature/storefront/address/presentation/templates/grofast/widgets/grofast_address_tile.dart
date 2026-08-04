import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/svg_image.dart';

import 'package:cordelia/constants/image_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_color_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_dimen_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_text_style_const.dart';

import '../../../../domain/entities/address_entity.dart';

/// One saved address, drawn as the kit's `Item/Location` card (frame
/// `129:1458`): a 100-tall tinted card with a rounded map thumbnail on the
/// left, the label over a hairline, and the address lines under a small pin.
/// Selected wraps the card in a 2px ring of the gradient's dark stop —
/// the kit's active treatment, not the pack's usual 1px `cs.primary`.
///
/// The thumbnail cycles the app's placeholder maps by [index] — see
/// [ImageConst.addressPlaceholders] for why no real tile can render.
///
/// The kit's card is select-only; the address *page* adds edit (the pencil
/// riding in as [trailing]) and delete (a swipe — the page wraps the tile in
/// core's `SwipeToDeleteRow`, so no delete control is drawn on the card).
class GrofastAddressTile extends StatelessWidget {
  final AddressEntity address;
  final int index;
  final bool isSelected;
  final VoidCallback onTap;

  /// The page's edit/delete column; null on the picker sheet.
  final Widget? trailing;

  const GrofastAddressTile({
    super.key,
    required this.address,
    required this.index,
    required this.isSelected,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final radius = BorderRadius.circular(GrofastDimenConst.tileRadius);
    final thumbSide =
        GrofastDimenConst.addressTileHeight -
        GrofastDimenConst.addressThumbInset * 2;

    return Material(
      color: cs.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: isSelected
            ? const BorderSide(color: GrofastColorConst.gradientStart, width: 2)
            : BorderSide.none,
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: GrofastDimenConst.addressTileHeight,
          child: Padding(
            padding: const EdgeInsets.all(GrofastDimenConst.addressThumbInset),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                    GrofastDimenConst.addressThumbRadius,
                  ),
                  child: Image.asset(
                    ImageConst.addressPlaceholders[index %
                        ImageConst.addressPlaceholders.length],
                    width: thumbSide,
                    height: thumbSide,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: AppSpacing.xl),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        address.tag.isEmpty ? address.name : address.tag,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GrofastTextStyleConst.cardTitleBold(tt),
                      ),
                      const SizedBox(height: AppSpacing.xs3),
                      Divider(height: 1, color: cs.outlineVariant),
                      const SizedBox(height: AppSpacing.xs3),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            size: AppSpacing.sm,
                            color: cs.onSurfaceVariant,
                          ),
                          const SizedBox(width: AppSpacing.xs3),
                          Expanded(
                            child: Text(
                              address.displayLine,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GrofastTextStyleConst.placeholder(
                                tt,
                              ).copyWith(color: cs.onSurfaceVariant),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: AppSpacing.xs),
                  trailing!,
                  const SizedBox(width: AppSpacing.xs),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A compact glyph action beside the tile (the page's edit pencil).
class GrofastAddressTileAction extends StatelessWidget {
  final String asset;
  final String tooltip;
  final Color color;
  final VoidCallback onTap;

  const GrofastAddressTileAction({
    super.key,
    required this.asset,
    required this.tooltip,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: tooltip,
    child: GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs3,
          vertical: AppSpacing.xs,
        ),
        child: AppSvgImage.asset(
          asset,
          width: AppSpacing.xl2,
          height: AppSpacing.xl2,
          color: color,
        ),
      ),
    ),
  );
}
