import 'package:cordelia/templates/gravia/constants/gravia_color_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_image_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_text_style_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_value_const.dart';
import 'package:flutter/material.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/svg_image.dart';
import '../../../../domain/entities/recent_search_entity.dart';

class RecentSearchSection extends StatelessWidget {
  final List<RecentSearchEntity> items;
  final ValueChanged<RecentSearchEntity> onItemTap;
  final ValueChanged<RecentSearchEntity> onRemove;
  static const double _rowHeight = 20;

  const RecentSearchSection({
    super.key,
    required this.items,
    required this.onItemTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final nameColor = Theme.of(context).brightness == Brightness.dark
        ? GraviaColorConst.gray100
        : GraviaColorConst.gray700;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            GraviaValueConst.recentSearchTitle,
            style: GraviaTextStyleConst.textLgBold(tt).copyWith(color: cs.onSurface),
          ),
          const SizedBox(height: AppSpacing.xs),
          for (final item in items)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
              child: SizedBox(
                height: _rowHeight,
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => onItemTap(item),
                        behavior: HitTestBehavior.opaque,
                        child: Row(
                          children: [
                            AppSvgImage.asset(
                              GraviaImageConst.undo,
                              width: _rowHeight,
                              height: _rowHeight,
                              color: cs.onSurface,
                            ),
                            const SizedBox(width: AppSpacing.base),
                            Expanded(
                              child: Text(
                                item.name,
                                style: GraviaTextStyleConst.textSmRegular(
                                  tt,
                                ).copyWith(color: nameColor),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.base),
                    GestureDetector(
                      onTap: () => onRemove(item),
                      behavior: HitTestBehavior.opaque,
                      child: AppSvgImage.asset(
                        GraviaImageConst.remove,
                        width: _rowHeight,
                        height: _rowHeight,
                        color: cs.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
