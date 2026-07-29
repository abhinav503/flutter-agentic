import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';

import 'package:cordelia/constants/image_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_dimen_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_text_style_const.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_icon_disc.dart';

/// Every non-Home DailyMart screen's header: a back disc, a centred title,
/// and an optional trailing control — the first item of the screen's scroll
/// view, never an `AppBar` and never a coloured canvas (spec sheet §8, §13).
///
/// The title is centred against the *screen*, not against the space left
/// over, so an empty [trailing] still reserves a disc-sized slot rather than
/// letting the title drift right. The kit does this with an invisible copy of
/// the back button; a sized box is the same geometry without the second
/// tappable target. A null [onBack] (a shell-tab root, which has nowhere to
/// go back to) reserves the same slot on the leading side.
class DailyMartHeaderRow extends StatelessWidget {
  final String title;
  final VoidCallback? onBack;
  final Widget? trailing;

  const DailyMartHeaderRow({
    super.key,
    required this.title,
    this.onBack,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Row(
      children: [
        if (onBack != null)
          DailyMartIconDisc(
            asset: ImageConst.arrowLeft,
            iconSize: AppSpacing.xl2,
            onTap: onBack,
          )
        else
          const SizedBox.square(dimension: DailyMartDimenConst.controlHeight),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: DailyMartTextStyleConst.bodyLgSemibold(
              tt,
            ).copyWith(color: cs.onSurface),
          ),
        ),
        trailing ??
            const SizedBox.square(
              dimension: DailyMartDimenConst.controlHeight,
            ),
      ],
    );
  }
}
