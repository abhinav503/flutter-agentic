import 'package:cordelia/templates/gravia/constants/gravia_color_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_image_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_text_style_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_value_const.dart';
import 'package:cordelia/templates/gravia/widgets/search_field_bar.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_glass_icon_button.dart';
import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/blocks/header_canvas.dart';

/// [HeaderCanvas] for Home: delivery location + notification bell,
/// plus a white search field. The search field is a tap-to-navigate trigger
/// here (see [SearchFieldBar]) — real typing happens on the pushed Search
/// screen it Hero-morphs into.
class HomeHeroHeader extends StatefulWidget {
  /// Scopes the search bar's Hero tag — see [SearchFieldBar.heroTagFor].
  final String storeId;

  final String addressLabel;
  final VoidCallback onLocationTap;
  final VoidCallback onNotificationTap;
  final VoidCallback onSearchTap;

  const HomeHeroHeader({
    super.key,
    required this.storeId,
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
                asset: GraviaImageConst.locationIcon,
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
                        GraviaValueConst.deliveryLocationLabel,
                        style: GraviaTextStyleConst.textXsRegular(
                          tt,
                        ).copyWith(color: GraviaColorConst.gray100),
                      ),
                      SizedBox(height: AppSpacing.xs2),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              widget.addressLabel,
                              style: GraviaTextStyleConst.textMdMedium(
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
                asset: GraviaImageConst.notification,
                iconSize: _iconSize,
                onTap: widget.onNotificationTap,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          SearchFieldBar(
            heroTag: SearchFieldBar.heroTagFor(widget.storeId),
            controller: _searchController,
            onTap: widget.onSearchTap,
          ),
        ],
      ),
    );
  }
}
