import 'package:core/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

/// The product's spec list — "Material: Cotton", "Origin: India" — the
/// `attributes` a merchant (or a Shopify import) attached. Shared by every
/// pack; each passes its own two text styles, so the rows sit in the pack's
/// type scale without three copies of the layout.
class ProductAttributesList extends StatelessWidget {
  final Map<String, String> attributes;
  final TextStyle keyStyle;
  final TextStyle valueStyle;

  const ProductAttributesList({
    super.key,
    required this.attributes,
    required this.keyStyle,
    required this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    if (attributes.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final entry in attributes.entries)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // A fixed key column keeps values aligned down the list; a
                // long key wraps rather than pushing its value off the row.
                SizedBox(
                  width: AppSpacing.xl13,
                  child: Text(entry.key, style: keyStyle),
                ),
                const SizedBox(width: AppSpacing.base),
                Expanded(child: Text(entry.value, style: valueStyle)),
              ],
            ),
          ),
      ],
    );
  }
}
