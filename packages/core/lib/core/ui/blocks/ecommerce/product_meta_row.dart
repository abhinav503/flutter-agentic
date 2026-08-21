import 'package:flutter/material.dart';

import '../../../theme/app_spacing.dart';

/// One icon + label pair on a [ProductMetaRow] (e.g. delivery time, discount).
/// [icon] is a caller-provided widget (e.g. `Icon`, `SvgPicture`) so core
/// doesn't need to depend on an SVG package just for this block.
class ProductCardMeta {
  final Widget icon;
  final String label;

  /// Overrides the row's shared label colour for this pair alone — for the
  /// one entry that carries a warning (running low) among neutral ones.
  final Color? labelColor;

  const ProductCardMeta({
    required this.icon,
    required this.label,
    this.labelColor,
  });
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

    // An entry with no label would render as a bare orphaned icon (e.g. the
    // lightning glyph beside an empty prep time) — never intentional, so
    // the pair is dropped here rather than at every call site.
    final visible = meta.where((m) => m.label.trim().isNotEmpty).toList();
    if (visible.isEmpty) return const SizedBox.shrink();

    return Row(
      children: [
        for (final m in visible) ...[
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
            style: (labelStyle ?? tt.labelSmall)!.copyWith(
              color: m.labelColor ?? labelStyle?.color ?? cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ],
    );
  }
}
