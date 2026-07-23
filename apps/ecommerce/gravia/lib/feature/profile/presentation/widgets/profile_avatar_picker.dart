import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:core/core/theme/app_colors_extension.dart';
import 'package:core/core/ui/atoms/svg_image.dart';

import 'package:gravia/constants/image_const.dart';
import 'package:gravia/widgets/gravia_avatar_image.dart';

import '../../domain/entities/profile_entity.dart';

/// Edit Profile's tappable avatar — the current (or freshly-picked) photo
/// with a small dark camera badge on top. [pickedAvatarBytes] previews a
/// photo picked this session, winning over [profile]'s existing `avatarUrl`
/// (see `GraviaAvatarImage`) without needing to round-trip through the
/// backend yet.
class ProfileAvatarPicker extends StatelessWidget {
  final ProfileEntity profile;
  final Uint8List? pickedAvatarBytes;
  final VoidCallback onTap;

  const ProfileAvatarPicker({
    super.key,
    required this.profile,
    required this.pickedAvatarBytes,
    required this.onTap,
  });

  static const _avatarSize = 96.0;
  static const _cameraBadgeSize = 32.0;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final onOverlay = Theme.of(context).extension<AppColorsExtension>()!.onOverlay;
    final previewProfile = pickedAvatarBytes == null
        ? profile
        : ProfileEntity(
            name: profile.name,
            email: profile.email,
            phone: profile.phone,
            avatarUrl: profile.avatarUrl,
            avatarBytes: pickedAvatarBytes,
          );

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          GraviaAvatarImage(profile: previewProfile, size: _avatarSize),
          Container(
            width: _cameraBadgeSize,
            height: _cameraBadgeSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: cs.scrim.withValues(alpha: 0.45),
            ),
            alignment: Alignment.center,
            child: AppSvgImage.asset(
              ImageConst.camera,
              color: onOverlay,
              width: 18,
              height: 18,
            ),
          ),
        ],
      ),
    );
  }
}
