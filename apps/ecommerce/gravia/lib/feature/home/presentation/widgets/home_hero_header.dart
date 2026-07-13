import 'package:flutter/material.dart';

import 'package:core/core/theme/app_shapes_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/common_glass_surface.dart';
import 'package:core/core/ui/atoms/icon_button.dart';
import 'package:core/core/ui/atoms/svg_image.dart';
import 'package:core/core/ui/atoms/text_field.dart';

import 'package:gravia/constants/image_const.dart';
import 'package:gravia/constants/value_const.dart';

/// The coloured header canvas: delivery location + notification bell sitting
/// directly on primary, plus a white search field — the pack's signature
/// "coloured header canvas" composition (docs/ai-rules/design.md).
class HomeHeroHeader extends StatefulWidget {
  final VoidCallback onNotificationTap;

  const HomeHeroHeader({super.key, required this.onNotificationTap});

  @override
  State<HomeHeroHeader> createState() => _HomeHeroHeaderState();
}

class _HomeHeroHeaderState extends State<HomeHeroHeader> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final shapes =
        Theme.of(context).extension<AppShapes>() ?? AppShapes.standard;
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // Without this, Column defaults to MainAxisSize.max — harmless when
        // this header's parent always bounded it to its own content height,
        // but inside the home screen's Stack (which gives it loose
        // constraints up to the full screen height) it greedily expands to
        // fill all of that instead of hugging its own content.
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppIconButton(
                iconBuilder: (color, size) => AppSvgImage.asset(
                  ImageConst.locationIcon,
                  color: color,
                  width: size,
                  height: size,
                ),
                containerSize: 45,
                iconSize: 25,
                variant: AppIconButtonVariant.glass,
                onTap: widget.onNotificationTap,
              ),

              const SizedBox(width: AppSpacing.xs2),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        ValueConst.deliveryLocationLabel,
                        style: tt.labelSmall!.copyWith(
                          color: cs.onPrimary.withValues(alpha: 0.7),
                        ),
                      ),
                      SizedBox(height: AppSpacing.xs2),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              ValueConst.deliveryLocationAddress,
                              style: tt.labelLarge!.copyWith(
                                color: cs.onPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: cs.onPrimary,
                            size: 18,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              AppIconButton(
                iconBuilder: (color, size) => AppSvgImage.asset(
                  ImageConst.notification,
                  color: color,
                  width: size,
                  height: size,
                ),
                containerSize: 45,
                iconSize: 25,
                variant: AppIconButtonVariant.glass,
                onTap: widget.onNotificationTap,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          CommonGlassSurface(
            borderRadius: BorderRadius.circular(shapes.inputRadius),
            tintColor: cs.surfaceContainerHighest,
            child: AppTextField(
              controller: _searchController,
              hint: ValueConst.searchHint,
              hintColor: cs.onPrimary,
              dense: true,
              showBorder: false,
              prefix: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                child: AppSvgImage.asset(
                  ImageConst.search,
                  color: cs.onPrimary,
                  width: 25,
                  height: 25,
                  fit: BoxFit.contain,
                ),
              ),
              suffix: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                child: AppSvgImage.asset(
                  ImageConst.mic,
                  color: cs.onPrimary,
                  width: 25,
                  height: 25,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
