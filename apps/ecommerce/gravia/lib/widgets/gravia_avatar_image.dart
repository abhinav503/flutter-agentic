import 'package:flutter/material.dart';

import 'package:core/core/ui/atoms/network_image.dart';

import 'package:gravia/constants/image_const.dart';
import 'package:gravia/feature/profile/domain/entities/profile_entity.dart';

/// Gravia's avatar circle — [ProfileEntity.avatarBytes] (a photo picked this
/// session, not yet "uploaded" anywhere) takes priority over
/// [ProfileEntity.avatarUrl] when both are set, since it's the most recent
/// choice; falls back to the bundled default photo when neither is set (via
/// [AppNetworkImage]'s `assetPlaceholder`). Used by both `ProfileHeroHeader`
/// (56px) and `EditProfileScreen` (large preview) — the second caller is
/// what moved this branching out of `ProfileHeroHeader` and into its own
/// widget instead of copy-pasting it.
class GraviaAvatarImage extends StatelessWidget {
  final ProfileEntity profile;
  final double size;
  final BoxFit fit;

  const GraviaAvatarImage({
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
