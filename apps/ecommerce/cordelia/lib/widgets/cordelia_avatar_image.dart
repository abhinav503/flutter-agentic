import 'package:flutter/material.dart';

import 'package:core/core/ui/atoms/network_image.dart';

import 'package:cordelia/constants/image_const.dart';
import 'package:cordelia/feature/storefront/profile/domain/entities/profile_entity.dart';

/// The shopper's avatar circle — [ProfileEntity.avatarBytes] (a photo picked
/// this session, not yet "uploaded" anywhere) takes priority over
/// [ProfileEntity.avatarUrl] when both are set, since it's the most recent
/// choice; falls back to the bundled default photo when neither is set (via
/// [AppNetworkImage]'s `assetPlaceholder`).
///
/// App-level, not per-pack: the shopper is the same person in every
/// storefront, so gravia's profile header/picker and dailymart's Home header
/// all branch through this one widget instead of each re-deriving the
/// bytes → url → default priority.
class CordeliaAvatarImage extends StatelessWidget {
  final ProfileEntity profile;
  final double size;
  final BoxFit fit;

  const CordeliaAvatarImage({
    super.key,
    required this.profile,
    required this.size,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    final bytes = profile.avatarBytes;

    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: bytes != null
            ? Image.memory(bytes, width: size, height: size, fit: fit)
            : AppNetworkImage(
                url: profile.avatarUrl,
                width: size,
                height: size,
                fit: fit,
                assetPlaceholder: ImageConst.profileDefault,
              ),
      ),
    );
  }
}
