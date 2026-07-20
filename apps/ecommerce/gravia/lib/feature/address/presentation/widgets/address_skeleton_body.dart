import 'package:flutter/material.dart';

import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/shimmer_box.dart';

import 'package:gravia/constants/dimen_const.dart';

/// Mirrors the loaded Select Address layout — the full-width Add New
/// Address pill, a Default Address section (title + one card), and an Other
/// Address section with two cards. Card rows follow [AddressCard]'s
/// silhouette: radio + name + tag badge, indented address/phone lines, and
/// the Edit/Delete pill pair.
class AddressSkeletonBody extends StatelessWidget {
  // AddressCard._identityInset: radio width + the gap after it.
  static const double _identityInset = 16 + AppSpacing.base;

  const AddressSkeletonBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xl2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerBox(
            width: double.infinity,
            height: DimenConst.controlHeight,
            borderRadius: AppRadius.full,
          ),
          const SizedBox(height: AppSpacing.xl4),
          const ShimmerBox(width: 140, height: 20),
          const SizedBox(height: AppSpacing.base),
          _addressCardSkeleton(),
          const SizedBox(height: AppSpacing.xl4),
          const ShimmerBox(width: 120, height: 20),
          const SizedBox(height: AppSpacing.base),
          _addressCardSkeleton(),
          const SizedBox(height: AppSpacing.xl2),
          _addressCardSkeleton(),
        ],
      ),
    );
  }

  Widget _addressCardSkeleton() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Row(
        children: [
          ShimmerBox.circle(size: 16),
          SizedBox(width: AppSpacing.base),
          ShimmerBox(width: 120, height: 16),
          SizedBox(width: AppSpacing.base),
          ShimmerBox(width: 48, height: 16, borderRadius: AppRadius.full),
        ],
      ),
      const SizedBox(height: AppSpacing.sm),
      const Padding(
        padding: EdgeInsets.only(left: _identityInset),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerBox(width: double.infinity, height: 12),
            SizedBox(height: AppSpacing.xs),
            ShimmerBox(width: 100, height: 12),
          ],
        ),
      ),
      const SizedBox(height: AppSpacing.base),
      const Padding(
        padding: EdgeInsets.only(left: _identityInset),
        child: Row(
          children: [
            ShimmerBox(width: 88, height: 32, borderRadius: AppRadius.full),
            SizedBox(width: AppSpacing.base),
            ShimmerBox(width: 88, height: 32, borderRadius: AppRadius.full),
          ],
        ),
      ),
    ],
  );
}
