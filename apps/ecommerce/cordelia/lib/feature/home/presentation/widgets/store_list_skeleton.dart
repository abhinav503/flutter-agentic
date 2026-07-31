import 'package:flutter/material.dart';

import 'package:core/core/theme/app_shapes_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/molecules/skeleton_rows.dart';

/// Mirrors the loaded store list — one `StoreCard` silhouette per row (56px
/// rounded logo beside a title line over a description line, inside the
/// card's own inset), separated like the loaded `ListView`, so the list
/// doesn't jump when the stores land.
class StoreListSkeleton extends StatelessWidget {
  const StoreListSkeleton({super.key});

  static const int _itemCount = 6;

  @override
  Widget build(BuildContext context) {
    // StoreCard clips its logo to half the theme card radius.
    final logoRadius = BorderRadius.circular(context.appShapes.cardRadius / 2);

    return ListView.separated(
      itemCount: _itemCount,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.base),
      itemBuilder: (context, i) => Padding(
        // StoreCard's own content inset.
        padding: const EdgeInsets.all(AppSpacing.base),
        child: ShimmerListRow(
          leadingSize: 56,
          leadingRadius: logoRadius,
          gap: AppSpacing.base,
          titleWidth: 160,
          titleHeight: 16,
          subtitleHeight: 14,
          lineGap: AppSpacing.xs3,
        ),
      ),
    );
  }
}
