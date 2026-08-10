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
      // Only the suffix listens, not the whole field: a TextEditingController
      // is a ValueNotifier, so this rebuilds one icon per keystroke instead
      // of the input it lives in.
      suffix: ValueListenableBuilder<TextEditingValue>(
        valueListenable: controller,
        builder: (context, value, _) => value.text.isEmpty
            ? const SizedBox.shrink()
            : _ClearButton(onTap: _clear),
      ),
      onChanged: onChanged,
    );
  }

  /// `clear()` mutates the controller but does **not** fire `onChanged`, so
  /// the bloc would keep the old query and the list would stay filtered
  /// against text no longer on screen. Both halves, or neither.
  void _clear() {
    controller.clear();
    onChanged('');
  }
}

class _ClearButton extends StatelessWidget {
  final VoidCallback onTap;

  const _ClearButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Semantics(
      button: true,
      label: ValueConst.discoverySearchClearLabel,
      child: GestureDetector(
        onTap: onTap,
        // AppTextField loosens the suffix slot's 48x48 minimum so small
        // icons render at their natural size, which means this has to claim
        // its own tap target — the padding is the target, not decoration.
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.base,
            vertical: AppSpacing.base,
          ),
          child: Icon(
            Icons.close_rounded,
            size: 20,
            color: cs.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
