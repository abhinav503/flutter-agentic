import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/svg_image.dart';

import 'package:gravia/constants/color_const.dart';
import 'package:gravia/constants/image_const.dart';
import 'package:gravia/constants/text_style_const.dart';
import 'package:gravia/constants/value_const.dart';

class RecentSearchSection extends StatelessWidget {
  final List<String> terms;
  final ValueChanged<String> onTermTap;
  final ValueChanged<String> onRemove;
  static const double _rowHeight = 20;

  const RecentSearchSection({
    super.key,
    required this.terms,
    required this.onTermTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (terms.isEmpty) return const SizedBox.shrink();

    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final termColor = Theme.of(context).brightness == Brightness.dark
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
          for (final term in terms)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
              child: SizedBox(
                height: _rowHeight,
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => onTermTap(term),
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
                                term,
                                style: TextStyleConst.textSmRegular(tt)
                                    .copyWith(color: termColor),
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
                      onTap: () => onRemove(term),
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
