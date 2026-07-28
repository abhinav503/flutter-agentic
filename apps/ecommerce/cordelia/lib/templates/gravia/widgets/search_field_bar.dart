import 'package:flutter/material.dart';

import 'package:core/core/theme/app_colors_extension.dart';
import 'package:core/core/theme/app_shapes_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/common_glass_surface.dart';
import 'package:core/core/ui/atoms/svg_image.dart';
import 'package:core/core/ui/atoms/text_field.dart';

import 'package:cordelia/templates/gravia/constants/gravia_image_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_value_const.dart';

class SearchFieldBar extends StatelessWidget {
  final TextEditingController controller;
  final bool autofocus;
  final FocusNode? focusNode;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  /// The Home <-> Search flight tag, scoped to one store.
  ///
  /// A fixed tag would also let *two different storefronts* running this pack
  /// pair their search bars during a storefront-to-storefront transition, so
  /// the bar would fly out of one store's Home into another's. Both ends of
  /// the intended flight derive the tag through this one factory, so they
  /// cannot drift apart and silently stop flying.
  static Object heroTagFor(String storeId) =>
      'gravia-search-field-hero-$storeId';

  final Object heroTag;

  const SearchFieldBar({
    super.key,
    required this.controller,
    this.autofocus = false,
    this.focusNode,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    required this.heroTag,
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
        hint: GraviaValueConst.searchHint,
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
            GraviaImageConst.search,
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
            GraviaImageConst.mic,
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
          ) {
            final shapes =
                Theme.of(flightContext).extension<AppShapes>() ??
                AppShapes.standard;
            return Material(
              type: MaterialType.transparency,
              // Clipped to the same pill radius as the field itself — an
              // unclipped ColoredBox is a hard rectangle, so its corners
              // would peek out past the glass surface's rounded corners for
              // the whole flight.
              child: ClipRRect(
                borderRadius: BorderRadius.circular(shapes.inputRadius),
                child: ColoredBox(
                  color: cs.primary,
                  child: ExcludeFocus(
                    child: AbsorbPointer(
                      child: _buildField(flightContext, interactive: false),
                    ),
                  ),
                ),
              ),
            );
          },
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
