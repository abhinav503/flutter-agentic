import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/icon_button.dart';
import 'package:core/core/ui/atoms/svg_image.dart';

import 'package:gravia/constants/image_const.dart';
import 'package:gravia/widgets/search_field_bar.dart';

/// Reduced coloured header canvas for the Search screen — a glass back
/// button + the search field (real input this time), matching
/// HomeHeroHeader's canvas but without the location/notification row that's
/// Home's alone. Focus is the caller's concern ([focusNode]): the screen
/// requests it only after the route transition settles, so the keyboard
/// doesn't animate up mid-Hero-flight and fight the field's glide for
/// attention.
class SearchHeroHeader extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final VoidCallback onBack;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  const SearchHeroHeader({
    super.key,
    required this.controller,
    required this.onBack,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final topInset = MediaQuery.paddingOf(context).top;

    return Container(
      width: double.infinity,
      color: cs.primary,
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        topInset + AppSpacing.xs,
        AppSpacing.lg,
        AppSpacing.xl2,
      ),
      child: Row(
        children: [
          // Same glass-circle treatment as Home's header controls; the fade
          // route has no iOS swipe-back edge gesture, so this is the only
          // on-screen way back on iOS.
          AppIconButton(
            iconBuilder: (color, size) => AppSvgImage.asset(
              ImageConst.arrowLeft,
              color: color,
              width: size,
              height: size,
            ),
            containerSize: 45,
            iconSize: 20,
            variant: AppIconButtonVariant.glass,
            onTap: onBack,
          ),
          const SizedBox(width: AppSpacing.base),
          Expanded(
            child: SearchFieldBar(
              controller: controller,
              focusNode: focusNode,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
            ),
          ),
        ],
      ),
    );
  }
}
