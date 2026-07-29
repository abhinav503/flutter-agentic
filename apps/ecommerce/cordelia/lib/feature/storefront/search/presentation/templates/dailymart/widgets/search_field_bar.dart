import 'package:flutter/material.dart';

import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/svg_image.dart';
import 'package:core/core/ui/atoms/text_field.dart';

import 'package:cordelia/templates/dailymart/constants/dailymart_dimen_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_image_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_value_const.dart';

/// The Search screen's live search field — the kit's two on-screen states
/// (spec sheet §10): idle is a borderless 48px pill on a soft
/// `surfaceContainer` wash; once a query exists the fill lifts to
/// `surfaceContainerLow` and a 1px **primary** border appears — the only
/// place a form control turns brand green. (Home's third, taller state is
/// `DailyMartSearchBar`, which never holds a controller.)
///
/// The border listens to the controller directly rather than the bloc:
/// `SearchBloc` debounces `queryChanged` by 300ms, and a border that lags
/// the first keystroke by that much reads as broken.
class DailyMartSearchFieldBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  /// The Home <-> Search flight tag — derive it via
  /// `DailyMartSearchBar.heroTagFor` so both ends of the flight agree.
  final Object heroTag;

  const DailyMartSearchFieldBar({
    super.key,
    required this.controller,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag,
      createRectTween: (begin, end) => RectTween(begin: begin, end: end),
      // The shuttle is a non-interactive copy: the live field's FocusNode
      // must stay out of the overlay (Search requests focus the moment the
      // route settles, mid-dismount of the shuttle), and a TextFormField in
      // the overlay has no Material ancestor without the wrapper.
      flightShuttleBuilder:
          (
            flightContext,
            animation,
            direction,
            fromHeroContext,
            toHeroContext,
          ) => Material(
            type: MaterialType.transparency,
            child: ExcludeFocus(
              child: AbsorbPointer(
                child: _buildBar(flightContext, interactive: false),
              ),
            ),
          ),
      child: Material(
        type: MaterialType.transparency,
        child: _buildBar(context, interactive: true),
      ),
    );
  }

  Widget _buildBar(BuildContext context, {required bool interactive}) {
    final cs = Theme.of(context).colorScheme;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final hasQuery = controller.text.isNotEmpty;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          height: DailyMartDimenConst.controlHeight,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          decoration: BoxDecoration(
            color: hasQuery
                ? cs.surfaceContainerLow
                : cs.surfaceContainer.withValues(alpha: 0.7),
            borderRadius: AppRadius.full,
            // Transparent instead of absent so the border never changes the
            // pill's size mid-animation.
            border: Border.all(
              color: hasQuery ? cs.primary : Colors.transparent,
            ),
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
                  hint: DailyMartValueConst.searchHint,
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
              const SizedBox(width: AppSpacing.xs),
              // Decorative in the kit as well — scanning isn't a storefront
              // capability, so this stays a glyph rather than a dead button.
              AppSvgImage.asset(
                DailyMartImageConst.scanner,
                color: cs.onSurfaceVariant,
                width: AppSpacing.xl3,
                height: AppSpacing.xl3,
              ),
            ],
          ),
        );
      },
    );
  }
}
