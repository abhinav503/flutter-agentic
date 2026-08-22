import 'package:flutter/foundation.dart' show Uint8List;
import 'package:flutter/material.dart';

import 'package:core/core/ui/atoms/avatar_image.dart';

import 'package:cordelia/constants/image_const.dart';
import 'package:cordelia/feature/storefront/profile/domain/entities/profile_entity.dart';

/// The shopper's avatar circle — [ProfileEntity.avatarBytes] (a photo picked
/// this session) takes priority over [ProfileEntity.avatarUrl] when both are
/// set: after a save they point at the same image, and the local bytes paint
/// without a round-trip to the freshly-written Storage URL. Falls back to the
/// bundled default photo when neither is set (via [AppNetworkImage]'s
/// `assetPlaceholder`).
///
/// App-level, not per-pack: the shopper is the same person in every
/// storefront, so gravia's profile header/picker and dailymart's Home header
/// all branch through this one widget instead of each re-deriving the
/// bytes → url → default priority.
class CordeliaAvatarImage extends StatelessWidget {
  final ProfileEntity profile;
  final double size;
  final BoxFit fit;

  /// A photo picked this session but not yet saved — wins over everything on
  /// [profile], so Edit Profile's picker previews it without composing a
  /// throwaway entity copy.
  final Uint8List? pickedBytes;

  const CordeliaAvatarImage({
    super.key,
    required this.profile,
    required this.size,
    this.fit = BoxFit.cover,
    this.pickedBytes,
  });

  @override
  Widget build(BuildContext context) => AppAvatarImage(
    url: profile.avatarUrl,
    bytes: pickedBytes ?? profile.avatarBytes,
    size: size,
    fit: fit,
    assetPlaceholder: ImageConst.profileDefault,
  );
}
