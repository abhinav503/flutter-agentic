import 'package:flutter/material.dart';

import 'package:cordelia/constants/cordelia_dimen_const.dart';
import 'package:cordelia/constants/cordelia_text_style_const.dart';
import 'package:cordelia/constants/value_const.dart';
import 'package:cordelia/enums/store_filter.dart';

/// The Live | All segmented control beside "All stores".
///
/// A segmented control rather than the pack's chips: these two options are
/// one either/or choice over the same list, and a chip row reads as
/// independent toggles that could each be on or off.
///
/// Rendered only when the shopper owns a store that isn't published yet —
/// the discovery API returns an unpublished store solely to its owner, so
/// for anyone else both tabs would show exactly the same stores. The caller
/// decides that (see `_content`); this widget only draws the control.
class StoreFilterTabs extends StatelessWidget {
  final StoreFilter selected;
  final ValueChanged<StoreFilter> onSelected;

  const StoreFilterTabs({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  static const _labels = {
    StoreFilter.live: ValueConst.discoveryFilterLive,
    StoreFilter.all: ValueConst.discoveryFilterAll,
  };

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(CordeliaDimenConst.segmentedRadius);

    return Container(
      height: CordeliaDimenConst.segmentedHeight,
      padding: const EdgeInsets.all(CordeliaDimenConst.segmentedTrackInset),
      decoration: BoxDecoration(
        color: cs.surfaceContainer,
        borderRadius: radius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final filter in StoreFilter.values)
            _Segment(
              label: _labels[filter]!,
              selected: filter == selected,
              onTap: () => onSelected(filter),
            ),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _Segment({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    // Derived from the track's radius so the pill stays concentric inside
    // it — see CordeliaDimenConst.segmentedPillRadius.
    final radius = BorderRadius.circular(
      CordeliaDimenConst.segmentedPillRadius,
    );

    return GestureDetector(
      onTap: onTap,
      // The gap between two segments is still part of the control: without
      // this an angled tap between labels does nothing.
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(
          horizontal: CordeliaDimenConst.segmentedSegmentInset,
        ),
        decoration: BoxDecoration(
          color: selected ? cs.surface : Colors.transparent,
          borderRadius: radius,
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: cs.shadow.withValues(alpha: 0.08),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: CordeliaTextStyleConst.textSmMedium(
            tt,
          ).copyWith(color: selected ? cs.onSurface : cs.onSurfaceVariant),
        ),
      ),
    );
  }
}
