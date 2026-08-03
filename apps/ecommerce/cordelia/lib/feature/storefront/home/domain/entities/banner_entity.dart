import 'package:cordelia/enums/banner_target_type.dart';

/// A merchandising banner for a storefront template's promo carousel, authored
/// by the store's admin (dashboard → Banners). Its title/subtitle are
/// marketing copy, not values derived from a catalog item — that's the point
/// of the resource.
class BannerEntity {
  final String id;
  final String imageUrl;
  final String title;
  final String subtitle;
  final BannerTargetType targetType;

  /// The product/category id [targetType] points at — empty when the banner
  /// is display-only. Only the id: a category's display name is read live off
  /// the loaded catalog, so a rename can't leave a stale copy here.
  final String targetId;

  /// The canvas the admin picked for this banner's copy column, as an ARGB
  /// value — an `int`, not a `Color`, so `domain` stays free of `dart:ui`.
  ///
  /// Null when the store never picked one, which is the normal case: a
  /// template that paints copy over the artwork ignores this entirely, and
  /// one that splits copy from artwork falls back to its own surface role.
  final int? backgroundArgb;

  const BannerEntity({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.targetType,
    required this.targetId,
    this.backgroundArgb,
  });
}

extension BannerEntityX on BannerEntity {
  /// Whether the banner navigates anywhere — a `product`/`category` banner
  /// saved without a target is still display-only, so the type alone isn't
  /// enough to decide.
  bool get hasTarget =>
      targetType != BannerTargetType.none && targetId.isNotEmpty;
}
