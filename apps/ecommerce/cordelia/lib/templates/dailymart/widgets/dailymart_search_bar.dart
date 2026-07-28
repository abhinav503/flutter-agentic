import 'package:flutter/material.dart';

import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/svg_image.dart';

import 'package:cordelia/templates/dailymart/constants/dailymart_dimen_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_image_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_text_style_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_value_const.dart';

/// The pack's search bar in its **idle, tap-to-navigate** form: a pill with a
/// leading search glyph, the placeholder, and a trailing scanner glyph.
///
/// Real typing happens on the pushed Search screen — this never holds a
/// `TextEditingController`, which is why it composes a plain row rather than
/// an `AppTextField` that would only ever be read-only. The kit's other two
/// states (borderless on Search, primary-bordered once a query exists) land
/// with that screen.
class DailyMartSearchBar extends StatelessWidget {
  final VoidCallback? onTap;

  const DailyMartSearchBar({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Material(
      color: cs.surface,
      borderRadius: AppRadius.full,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.full,
        child: Container(
          height: DailyMartDimenConst.headerControlHeight,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          decoration: BoxDecoration(
            borderRadius: AppRadius.full,
            border: Border.all(color: cs.outline),
          ),
          child: Row(
            children: [
              AppSvgImage.asset(
                DailyMartImageConst.search,
                color: cs.onSurfaceVariant,
                width: AppSpacing.xl3,
                height: AppSpacing.xl3,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  DailyMartValueConst.searchHint,
                  style: DailyMartTextStyleConst.bodySmRegular(
                    tt,
                  ).copyWith(color: cs.onSurfaceVariant),
                ),
              ),
              AppSvgImage.asset(
                DailyMartImageConst.scanner,
                color: cs.onSurfaceVariant,
                width: AppSpacing.xl3,
                height: AppSpacing.xl3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
