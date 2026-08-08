import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/text_field.dart';

import 'package:cordelia/constants/cordelia_dimen_const.dart';
import 'package:cordelia/constants/cordelia_text_style_const.dart';
import 'package:cordelia/constants/value_const.dart';

/// Discovery's store search — a filled pill sitting on the header's coloured
/// canvas.
///
/// Filled rather than outlined ([AppTextField.showBorder] off, `surface` as
/// the fill): an outline drawn in the theme's border colour is nearly
/// invisible against the primary canvas, so the field's own surface is what
/// gives it an edge. The explicit [CordeliaDimenConst.discoverySearchHeight]
/// replaces what used to be a `dense: true` field with a default
/// content-driven height — about 40px including the icon, which read as a
/// cramped strip under the greeting.
class DiscoverySearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const DiscoverySearchField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return AppTextField(
      controller: controller,
      hint: ValueConst.discoverySearchHint,
      textInputAction: TextInputAction.search,
      height: CordeliaDimenConst.discoverySearchHeight,
      fillColor: cs.surface,
      showBorder: false,
      hintStyle: CordeliaTextStyleConst.textSmRegular(
        tt,
      ).copyWith(color: cs.onSurfaceVariant),
      prefix: Padding(
        padding: const EdgeInsets.only(
          left: AppSpacing.base,
          right: AppSpacing.sm,
        ),
        child: Icon(Icons.search, size: 20, color: cs.onSurfaceVariant),
      ),
      onChanged: onChanged,
    );
  }
}
