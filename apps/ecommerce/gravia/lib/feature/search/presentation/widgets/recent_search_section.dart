import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/svg_image.dart';

import 'package:gravia/constants/color_const.dart';
import 'package:gravia/constants/image_const.dart';
import 'package:gravia/constants/text_style_const.dart';
import 'package:gravia/constants/value_const.dart';

import '../../domain/entities/recent_search_entity.dart';

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
        ? ColorConst.gray100
        : ColorConst.gray700;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ValueConst.recentSearchTitle,
            style: TextStyleConst.textLgBold(tt).copyWith(color: cs.onSurface),
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
                              ImageConst.undo,
                              width: _rowHeight,
                              height: _rowHeight,
                              color: cs.onSurface,
                            ),
                            const SizedBox(width: AppSpacing.base),
                            Expanded(
                              child: Text(
                                item.name,
                                style: TextStyleConst.textSmRegular(
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
                        ImageConst.remove,
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
