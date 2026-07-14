import 'package:flutter/material.dart';

import 'package:core/core/theme/app_colors_extension.dart';
import 'package:core/core/theme/app_shapes_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/common_glass_surface.dart';
import 'package:core/core/ui/atoms/svg_image.dart';
import 'package:core/core/ui/atoms/text_field.dart';
import 'package:gravia/constants/image_const.dart';
import 'package:gravia/constants/value_const.dart';

class SearchFieldBar extends StatelessWidget {
  final TextEditingController controller;
  final bool autofocus;
  final FocusNode? focusNode;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  static const Object heroTagDefault = 'gravia-search-field-hero';
  final Object heroTag;

  const SearchFieldBar({
    super.key,
    required this.controller,
    this.autofocus = false,
    this.focusNode,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.heroTag = heroTagDefault,
  });

  Widget _buildField(BuildContext context, {required bool interactive}) {
    final cs = Theme.of(context).colorScheme;
    final onOverlay = Theme.of(
      context,
    ).extension<AppColorsExtension>()!.onOverlay;
    final shapes =
        Theme.of(context).extension<AppShapes>() ?? AppShapes.standard;

    return CommonGlassSurface(
      borderRadius: BorderRadius.circular(shapes.inputRadius),
      tintColor: cs.surfaceContainerHighest,
      child: AppTextField(
        controller: controller,
        hint: ValueConst.searchHint,
        hintColor: onOverlay,
        textColor: onOverlay,
        cursorColor: onOverlay,
        dense: true,
        showBorder: false,
        autofocus: interactive && autofocus,
        focusNode: interactive ? focusNode : null,
        onChanged: interactive ? onChanged : null,
        onSubmitted: interactive ? onSubmitted : null,
        prefix: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.base,
          ),
          child: AppSvgImage.asset(
            ImageConst.search,
            color: onOverlay,
            width: 25,
            height: 25,
            fit: BoxFit.contain,
          ),
        ),
        suffix: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.base,
          ),
          child: AppSvgImage.asset(
            ImageConst.mic,
            color: onOverlay,
            width: 25,
            height: 25,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final hero = Hero(
      tag: heroTag,
      createRectTween: (begin, end) => RectTween(begin: begin, end: end),
      flightShuttleBuilder:
          (
            flightContext,
            animation,
            direction,
            fromHeroContext,
            toHeroContext,
          ) => Material(
            type: MaterialType.transparency,
            child: ColoredBox(
              color: cs.primary,
              child: ExcludeFocus(
                child: AbsorbPointer(
                  child: _buildField(flightContext, interactive: false),
                ),
              ),
            ),
          ),
      child: Material(
        type: MaterialType.transparency,
        child: _buildField(context, interactive: true),
      ),
    );

    if (onTap == null) return hero;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AbsorbPointer(child: hero),
    );
  }
}
