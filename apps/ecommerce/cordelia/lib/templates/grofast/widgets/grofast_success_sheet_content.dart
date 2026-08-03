import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/concentric_circles.dart';

import 'package:cordelia/templates/grofast/constants/grofast_color_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_dimen_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_text_style_const.dart';

import 'grofast_dome.dart';
import 'grofast_primary_button.dart';

/// The kit's "Success!" body (frame `179:3199`) — concentric green rings
/// around a tick, a 28/700 title, one muted line, and a single gradient CTA
/// out. Presented by `showGrofastSuccessSheet`.
///
/// The rings are core's [AppConcentricCircles] with the pack's primary at two
/// alphas; the tick is `cs.primary` rather than the gradient because it is a
/// glyph, not a control.
class GrofastSuccessSheetContent extends StatelessWidget {
  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  const GrofastSuccessSheetContent({
    super.key,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        GrofastDimenConst.screenGutter,
        GrofastSheetMetrics.contentTop,
        GrofastDimenConst.screenGutter,
        AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppConcentricCircles(
            radii: const [120, 92],
            colors: [
              cs.primary.withValues(alpha: 0.12),
              cs.primary.withValues(alpha: 0.22),
            ],
            child: Icon(
              Icons.check_rounded,
              size: AppSpacing.xl10,
              color: GrofastColorConst.gradientStart,
            ),
          ),
          const SizedBox(height: AppSpacing.xl4),
          Text(title, style: GrofastTextStyleConst.displayBold(tt)),
          const SizedBox(height: AppSpacing.xs),
          Text(
            message,
            textAlign: TextAlign.center,
            style: GrofastTextStyleConst.bodyMedium(
              tt,
            ).copyWith(color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.xl4),
          GrofastPrimaryButton(label: actionLabel, onTap: onAction),
        ],
      ),
    );
  }
}
