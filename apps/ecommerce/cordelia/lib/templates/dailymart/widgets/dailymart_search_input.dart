import 'package:flutter/material.dart';

import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/svg_image.dart';
import 'package:core/core/ui/atoms/text_field.dart';

import 'package:cordelia/templates/dailymart/constants/dailymart_dimen_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_image_const.dart';

/// The pack's plain **typed** search pill — 48px on a soft
/// `surfaceContainer` wash with a leading kit search glyph, filtering
/// whatever list it sits above (My Orders, kit frame `35`).
///
/// Distinct from the pack's other two search surfaces on purpose:
/// [DailyMartSearchBar] is the taller tap-to-navigate bar that never holds a
/// controller, and Search's own `DailyMartSearchFieldBar` adds the Hero
/// flight and the primary-border has-query state — it composes this widget
/// in [bare] mode inside its own animated container, so the row recipe
/// (glyph sizing, dense borderless field, hint/text/cursor colours) lives
/// only here.
class DailyMartSearchInput extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;

  /// An extra glyph/control after the field (Search's decorative scanner).
  final Widget? trailing;

  /// False renders an inert copy — no focus node, no callbacks — for a Hero
  /// flight's shuttle.
  final bool interactive;

  /// True renders only the row (glyph + field + [trailing]) with no pill
  /// container — for a caller that draws its own animated container.
  final bool bare;

  const DailyMartSearchInput({
    super.key,
    required this.controller,
    required this.hint,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.trailing,
    this.interactive = true,
    this.bare = false,
  });

  /// The pill's resting fill — shared with `DailyMartSearchFieldBar`'s idle
  /// state so the two can't drift.
  static Color idleFill(ColorScheme cs) =>
      cs.surfaceContainer.withValues(alpha: 0.7);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final row = Row(
      children: [
        AppSvgImage.asset(
          DailyMartImageConst.search,
          color: cs.onSurfaceVariant,
          width: AppSpacing.xl3,
          height: AppSpacing.xl3,
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: AppTextField(
            controller: controller,
            hint: hint,
            hintColor: cs.onSurfaceVariant,
            textColor: cs.onSurface,
            cursorColor: cs.primary,
            dense: true,
            showBorder: false,
            focusNode: interactive ? focusNode : null,
            textInputAction: TextInputAction.search,
            onChanged: interactive ? onChanged : null,
            onSubmitted: interactive ? onSubmitted : null,
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: AppSpacing.xs),
          trailing!,
        ],
      ],
    );

    if (bare) return row;

    return Container(
      height: DailyMartDimenConst.controlHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      decoration: BoxDecoration(
        color: idleFill(cs),
        borderRadius: AppRadius.full,
      ),
      child: row,
    );
  }
}
