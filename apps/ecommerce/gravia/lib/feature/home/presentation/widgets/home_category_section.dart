import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/network_image.dart';
import 'package:core/core/ui/blocks/ecommerce/category_tile.dart';
import 'package:core/core/ui/blocks/section_header.dart';

import 'package:gravia/constants/value_const.dart';

import '../../domain/entities/category_entity.dart';

class HomeCategorySection extends StatelessWidget {
  final List<CategoryEntity> categories;
  final VoidCallback onComingSoon;

  const HomeCategorySection({
    super.key,
    required this.categories,
    required this.onComingSoon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: ValueConst.allCategoriesTitle,
          actionLabel: ValueConst.seeAll,
          onAction: onComingSoon,
        ),
        const SizedBox(height: AppSpacing.base),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var i = 0; i < categories.length; i++) ...[
                if (i > 0) const SizedBox(width: AppSpacing.lg),
                CategoryTile(
                  image: AppNetworkImage(
                    url: categories[i].imageUrl,
                    fit: BoxFit.contain,
                  ),
                  label: categories[i].name,
                  onTap: onComingSoon,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
