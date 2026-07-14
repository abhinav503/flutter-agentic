import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/icon_button.dart';
import 'package:core/core/ui/atoms/svg_image.dart';

import 'package:gravia/constants/color_const.dart';
import 'package:gravia/constants/image_const.dart';
import 'package:gravia/constants/text_style_const.dart';
import 'package:gravia/constants/value_const.dart';
import 'package:gravia/widgets/search_field_bar.dart';

/// The coloured header canvas: delivery location + notification bell sitting
/// directly on primary, plus a white search field — the pack's signature
/// "coloured header canvas" composition (docs/ai-rules/design.md). The
/// search field is a tap-to-navigate trigger here (see [SearchFieldBar]) —
/// real typing happens on the pushed Search screen it Hero-morphs into.
class HomeHeroHeader extends StatefulWidget {
  final VoidCallback onNotificationTap;
  final VoidCallback onSearchTap;

  const HomeHeroHeader({
    super.key,
    required this.onNotificationTap,
    required this.onSearchTap,
  });

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
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        ValueConst.deliveryLocationLabel,
                        style: TextStyleConst.textXsRegular(
                          tt,
                        ).copyWith(color: ColorConst.gray100),
                      ),
                      SizedBox(height: AppSpacing.xs2),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              ValueConst.deliveryLocationAddress,
                              style: TextStyleConst.textMdMedium(
                                tt,
                              ).copyWith(color: cs.onPrimary),
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
          SearchFieldBar(
            controller: _searchController,
            onTap: widget.onSearchTap,
          ),
        ],
      ),
    );
  }
}
