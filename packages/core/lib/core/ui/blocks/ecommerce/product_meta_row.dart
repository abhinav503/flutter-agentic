import 'package:flutter/material.dart';

import '../../../theme/app_spacing.dart';

/// One icon + label pair on a [ProductMetaRow] (e.g. delivery time, discount).
/// [icon] is a caller-provided widget (e.g. `Icon`, `SvgPicture`) so core
/// doesn't need to depend on an SVG package just for this block.
class ProductCardMeta {
  final Widget icon;
  final String label;
  const ProductCardMeta({required this.icon, required this.label});
}

/// Icon + label meta row (delivery time, discount, …). Shared by [ProductCard]
/// and any other surface — e.g. a product details screen — that needs the
/// same row outside a full card, so both render identical text/colour
/// styling in every theme instead of drifting apart as hand-rolled copies.
///
/// ```dart
/// ProductMetaRow(
///   meta: const [ProductCardMeta(icon: Icon(Icons.bolt), label: '10 Min')],
/// )
/// ```
class ProductMetaRow extends StatelessWidget {
  final List<ProductCardMeta> meta;
  final TextStyle? labelStyle;

  const ProductMetaRow({super.key, required this.meta, this.labelStyle});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Row(
      children: [
        for (final m in meta) ...[
          SizedBox(
            width: 14,
            height: 14,
            // FittedBox rather than a bare SizedBox: an `Icon` renders its
            // glyph at a fixed font size (24 by default) regardless of the
            // box it's laid out in and paints with TextOverflow.visible, so
            // it bleeds into the label next to it instead of scaling down.
            // FittedBox scales whatever `m.icon` is (Icon, SvgPicture, …)
            // to fit.
            child: FittedBox(fit: BoxFit.contain, child: m.icon),
          ),
          const SizedBox(width: AppSpacing.xs4),
          Text(
            m.label,
            style: (labelStyle ?? tt.labelSmall)!
                .copyWith(color: labelStyle?.color ?? cs.onSurfaceVariant),
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ],
    );
  }
}
