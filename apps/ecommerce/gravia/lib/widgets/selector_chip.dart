import 'package:flutter/material.dart';

import 'package:core/core/ui/atoms/chip.dart';

import 'package:gravia/constants/color_const.dart';
import 'package:gravia/constants/text_style_const.dart';

/// Gravia's option-picker look for [AppChip] — a size/variant selector
/// (no check mark; unselected is an outline, selected is the same tinted
/// fill + primary text as the [ProductCard] weight badge) — as opposed to
/// core's default filter-chip look (filled container + check mark), which
/// `AppChip` still renders when none of these overrides are passed.
///
/// ```dart
/// SelectorChip(label: '250 g', selected: i == _selectedIndex, onTap: () => ...)
/// ```
class SelectorChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const SelectorChip({
    super.key,
    required this.label,
    required this.selected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return AppChip(
      label: label,
      selected: selected,
      onTap: onTap,
      showCheckIcon: false,
      // Instant, not the default 150ms crossfade — with no check mark to
      // anchor the eye, a crossfade on both the newly- and
      // previously-selected chip at once read as a flicker rather than a
      // deliberate transition.
      animationDuration: Duration.zero,
      // Fixed grey200 border regardless of theme — matches the size-picker
      // spec, not the generic (theme-flipping) hairline token.
      borderColor: ColorConst.gray200,
      selectedBorderColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      selectedBackgroundColor: cs.tintedPrimaryFill,
      // Same base style for both states — only the colour differs — so the
      // chip's footprint doesn't change size when selection toggles.
      labelStyle: TextStyleConst.badgeLabel(
        tt,
      ).copyWith(color: selected ? cs.primary : cs.onSurface),
    );
  }
}
