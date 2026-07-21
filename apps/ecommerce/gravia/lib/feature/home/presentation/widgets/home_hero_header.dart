import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/blocks/header_canvas.dart';

import 'package:gravia/constants/color_const.dart';
import 'package:gravia/constants/image_const.dart';
import 'package:gravia/constants/text_style_const.dart';
import 'package:gravia/constants/value_const.dart';
import 'package:gravia/widgets/gravia_glass_icon_button.dart';
import 'package:gravia/widgets/search_field_bar.dart';

/// [HeaderCanvas] for Home: delivery location + notification bell,
/// plus a white search field. The search field is a tap-to-navigate trigger
/// here (see [SearchFieldBar]) — real typing happens on the pushed Search
/// screen it Hero-morphs into.
class HomeHeroHeader extends StatefulWidget {
  final String addressLabel;
  final VoidCallback onLocationTap;
  final VoidCallback onNotificationTap;
  final VoidCallback onSearchTap;

  const HomeHeroHeader({
    super.key,
    required this.addressLabel,
    required this.onLocationTap,
    required this.onNotificationTap,
    required this.onSearchTap,
  });

  @override
  State<HomeHeroHeader> createState() => _HomeHeroHeaderState();
}

class _HomeHeroHeaderState extends State<HomeHeroHeader> {
  final _searchController = TextEditingController();

  // Home's header controls use a larger icon than the standard 20px header
  // discs — the kit's location/bell glyphs are drawn to this size.
  static const _iconSize = 25.0;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return HeaderCanvas(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GraviaGlassIconButton(
                asset: ImageConst.locationIcon,
                iconSize: _iconSize,
                onTap: widget.onLocationTap,
              ),
              const SizedBox(width: AppSpacing.xs2),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xs,
                  ),
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
                              widget.addressLabel,
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
              GraviaGlassIconButton(
                asset: ImageConst.notification,
                iconSize: _iconSize,
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
