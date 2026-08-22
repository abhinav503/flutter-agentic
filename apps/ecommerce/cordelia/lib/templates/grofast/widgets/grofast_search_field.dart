import 'package:flutter/material.dart';

import 'package:core/core/theme/app_shapes_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/svg_image.dart';
import 'package:core/core/ui/blocks/hero_search_field_flight.dart';

import 'package:cordelia/templates/grofast/constants/grofast_color_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_dimen_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_image_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_text_style_const.dart';

/// The pack's search field (spec sheet §10): a 50px bar at radius 18, filled
/// with the ink at 6% — `cs.fieldFill`, a green-cast tint no neutral role
/// reproduces — with the search glyph leading in `cs.primary`.
///
/// Two modes, deliberately one widget: [onTap] makes it a *button* that
/// navigates to Search (Home, Category Details), while a [controller] makes
/// it a live input (the Search screen itself). A screen passes one or the
/// other, never both.
class GrofastSearchField extends StatelessWidget {
  /// The Home <-> Search flight tag, scoped to one store — same reasoning as
  /// gravia's `SearchFieldBar.heroTagFor`: a fixed tag would let two
  /// different storefronts running this pack pair their bars during a
  /// storefront-to-storefront transition. Both ends of the intended flight
  /// derive the tag through this one factory, so they cannot drift apart and
  /// silently stop flying.
  static Object heroTagFor(String storeId) =>
      'grofast-search-field-hero-$storeId';

  final String hint;

  /// Live-input mode.
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool autofocus;

  /// Button mode — the whole field becomes one tap target.
  final VoidCallback? onTap;

  /// A square control docked at the trailing edge (Home's gradient scan
  /// slot, the results screens' filter square). Sized to match the field's
  /// height, so the pair reads as one 50px band.
  final Widget? trailing;

  /// When set, the field flies Home <-> Search instead of cross-fading with
  /// the page. Null renders it plain — which is what every *other* screen
  /// with this bar passes: Category Details carries one too, and sharing the
  /// tag there would fly it on the Home -> Category Details push as well.
  final Object? heroTag;

  const GrofastSearchField({
    super.key,
    required this.hint,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.autofocus = false,
    this.onTap,
    this.trailing,
    this.heroTag,
  }) : assert(
         onTap == null || controller == null,
         'A field is either a navigation target or a live input, not both.',
       ),
       assert(
         heroTag == null || trailing == null,
         'Both ends of the flight are bare bars. A docked square would have '
         'to fly into whatever the other end docks (or nothing), so give the '
         'row its own Hero around the bar alone if this is ever needed.',
       );

  @override
  Widget build(BuildContext context) {
    if (heroTag == null) return _buildBar(context, interactive: true);

    return HeroSearchFieldFlight(
      tag: heroTag!,
      barBuilder: (context, {required interactive}) =>
          _buildBar(context, interactive: interactive),
    );
  }

  Widget _buildBar(BuildContext context, {required bool interactive}) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final radius = BorderRadius.circular(context.appShapes.inputRadius);

    final placeholderStyle = GrofastTextStyleConst.placeholder(
      tt,
    ).copyWith(color: cs.onSurface.withValues(alpha: 0.4));

    final field = Container(
      height: GrofastDimenConst.controlHeight,
      decoration: BoxDecoration(color: cs.fieldFill, borderRadius: radius),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        children: [
          AppSvgImage.asset(
            GrofastImageConst.search,
            width: AppSpacing.xl,
            height: AppSpacing.xl,
            color: cs.primary,
          ),
          const SizedBox(width: AppSpacing.base),
          Expanded(
            child: controller == null
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      hint,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: placeholderStyle,
                    ),
                  )
                : TextField(
                    controller: controller,
                    // The shuttle copy keeps the text (so a back-flight from
                    // a typed query doesn't blank mid-air) but takes no focus
                    // and reports nothing: Search autofocuses the moment the
                    // route settles, which is while this copy is still
                    // dismounting.
                    onChanged: interactive ? onChanged : null,
                    onSubmitted: interactive ? onSubmitted : null,
                    autofocus: interactive && autofocus,
                    textInputAction: TextInputAction.search,
                    style: GrofastTextStyleConst.bodySmall(
                      tt,
                    ).copyWith(color: cs.onSurface),
                    cursorColor: cs.primary,
                    // The bar around it *is* the field, so every border state
                    // is stripped — the theme's `inputDecorationTheme` injects
                    // the pack's input border into anything it isn't.
                    decoration: InputDecoration(
                      isCollapsed: true,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      hintText: hint,
                      hintStyle: placeholderStyle,
                    ),
                    // Flutter's default keeps focus on mobile, so without
                    // this the keyboard outlives a tap on the results.
                    onTapOutside: (_) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                  ),
          ),
        ],
      ),
    );

    final bar = onTap == null || !interactive
        ? field
        : GestureDetector(
            onTap: onTap,
            behavior: HitTestBehavior.opaque,
            child: field,
          );

    if (trailing == null) return bar;
    return Row(
      children: [
        Expanded(child: bar),
        const SizedBox(width: AppSpacing.lg),
        trailing!,
      ],
    );
  }
}

/// The square control that docks beside a [GrofastSearchField] — the kit's
/// filter button. Same 50px side and 18 radius as the field, filled with the
/// neutral card tint (the gradient is reserved for affirmative controls, and
/// opening a filter sheet is not one).
class GrofastSquareAction extends StatelessWidget {
  final String? asset;
  final IconData? icon;
  final VoidCallback onTap;
  final String? tooltip;

  /// Inks the glyph in `cs.primary` — the square's only "something is in
  /// force" signal (My Orders lights it while a date filter is applied).
  final bool active;

  const GrofastSquareAction({
    super.key,
    this.asset,
    this.icon,
    required this.onTap,
    this.tooltip,
    this.active = false,
  }) : assert(
         (asset == null) != (icon == null),
         'Pass a pack asset or a Material icon, not both.',
       );

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(context.appShapes.inputRadius);
    final glyphColor = active ? cs.primary : cs.onSurface;

    return Semantics(
      button: true,
      label: tooltip,
      child: Material(
        color: cs.surfaceContainerLow,
        borderRadius: radius,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: SizedBox.square(
            dimension: GrofastDimenConst.controlHeight,
            child: Center(
              child: asset != null
                  ? AppSvgImage.asset(
                      asset!,
                      width: AppSpacing.xl2,
                      height: AppSpacing.xl2,
                      color: glyphColor,
                    )
                  : Icon(icon, size: AppSpacing.xl2, color: glyphColor),
            ),
          ),
        ),
      ),
    );
  }
}
