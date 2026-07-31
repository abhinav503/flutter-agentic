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
/// flight and the primary-border has-query state. This one is the recipe
/// with neither — a field that searches in place.
class DailyMartSearchInput extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final ValueChanged<String>? onChanged;

  const DailyMartSearchInput({
    super.key,
    required this.controller,
    required this.hint,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      height: DailyMartDimenConst.controlHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      decoration: BoxDecoration(
        color: cs.surfaceContainer.withValues(alpha: 0.7),
        borderRadius: AppRadius.full,
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
            child: AppTextField(
              controller: controller,
              hint: hint,
              hintColor: cs.onSurfaceVariant,
              textColor: cs.onSurface,
              cursorColor: cs.primary,
              dense: true,
              showBorder: false,
              textInputAction: TextInputAction.search,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
