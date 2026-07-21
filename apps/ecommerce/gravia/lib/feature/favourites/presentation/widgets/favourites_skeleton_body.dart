import 'package:flutter/material.dart';

import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_shapes_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/shimmer_box.dart';
import 'package:core/core/ui/blocks/chunked_grid.dart';

/// Mirrors the loaded [ChunkedGrid] of [GraviaProductCard]s — same 2-column
/// card-shaped placeholder recipe as [CategoryDetailsSkeletonBody], since
/// the Favourite tab renders the same grid composition.
class FavouritesSkeletonBody extends StatelessWidget {
  const FavouritesSkeletonBody({super.key});

  @override
  Widget build(BuildContext context) {
    final cardRadius = BorderRadius.circular(
      Theme.of(context).extension<AppShapes>()?.cardRadius ?? AppRadius.xlValue,
    );
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: ChunkedGrid(
        itemCount: 6,
        columns: 2,
        spacing: AppSpacing.lg,
        runSpacing: AppSpacing.lg,
        crossAxisAlignment: CrossAxisAlignment.start,
        itemBuilder: (context, index) => ShimmerBox(
          width: double.infinity,
          height: 260,
          borderRadius: cardRadius,
        ),
      ),
    );
  }
}
