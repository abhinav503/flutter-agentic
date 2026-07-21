import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/blocks/header_canvas.dart';

import 'package:gravia/constants/image_const.dart';
import 'package:gravia/widgets/gravia_glass_icon_button.dart';
import 'package:gravia/widgets/search_field_bar.dart';

/// Reduced [HeaderCanvas] for the Search screen — a glass back button
/// + the search field (real input this time), matching HomeHeroHeader's
/// canvas but without the location/notification row that's Home's alone.
/// Focus is the caller's concern ([focusNode]): the screen requests it only
/// after the route transition settles, so the keyboard doesn't animate up
/// mid-Hero-flight and fight the field's glide for attention.
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
    return HeaderCanvas(
      child: Row(
        children: [
          // Same glass-circle treatment as Home's header controls; the fade
          // route has no iOS swipe-back edge gesture, so this is the only
          // on-screen way back on iOS.
          GraviaGlassIconButton(asset: ImageConst.arrowLeft, onTap: onBack),
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
