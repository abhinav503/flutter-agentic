import 'package:flutter/material.dart';

import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/blocks/section_header.dart';

import 'package:cordelia/templates/dailymart/constants/dailymart_text_style_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_value_const.dart';

/// Every section header in the DailyMart storefront — core's [SectionHeader]
/// with the pack's 18/600 title and its signature action: a **filled green
/// chip at radius 4**, not a text link.
///
/// The kit's first Home frame shows a plain green "See all" link on the
/// category row while `17 Home Scroll` shows the chip on every row; the chip
/// is the rule and the link is the outlier, so only the chip is reproduced
/// (spec sheet §10).
class DailyMartSectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;

  const DailyMartSectionHeader({super.key, required this.title, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return SectionHeader(
      title: title,
      titleStyle: DailyMartTextStyleConst.bodyLgSemibold(
        tt,
      ).copyWith(color: cs.onSurface),
      action: onSeeAll == null ? null : _SeeAllChip(onTap: onSeeAll!),
    );
  }
}

class _SeeAllChip extends StatelessWidget {
  final VoidCallback onTap;

  const _SeeAllChip({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Material(
      color: cs.primary,
      borderRadius: AppRadius.sm,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.sm,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.xs3,
          ),
          child: Text(
            DailyMartValueConst.seeAll,
            style: DailyMartTextStyleConst.chipLabel(
              tt,
            ).copyWith(color: cs.onPrimary),
          ),
        ),
      ),
    );
  }
}
