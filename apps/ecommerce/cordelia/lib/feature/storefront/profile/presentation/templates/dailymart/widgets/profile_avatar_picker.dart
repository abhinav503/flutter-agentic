import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/ui/atoms/svg_image.dart';

import 'package:cordelia/templates/dailymart/constants/dailymart_dimen_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_image_const.dart';
import 'package:cordelia/widgets/cordelia_avatar_image.dart';

import '../../../../domain/entities/profile_entity.dart';

/// Edit Profile's tappable hero avatar — a 140px photo with the kit's green
/// pencil badge overlapping its bottom-right corner. The badge is a rounded
/// *square* at radius 12, not a circle: it's the one place this pack sets a
/// filled control against a circular one, and the contrast is what makes it
/// read as a button rather than part of the portrait.
///
/// [pickedAvatarBytes] previews a photo picked this session, winning over
/// [profile]'s existing `avatarUrl` (see [CordeliaAvatarImage]) without
/// round-tripping through the backend first.
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

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
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
      child: SizedBox.square(
        dimension: DailyMartDimenConst.editAvatarSize,
        child: Stack(
          children: [
            CordeliaAvatarImage(
              profile: previewProfile,
              size: DailyMartDimenConst.editAvatarSize,
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: DailyMartDimenConst.editAvatarBadgeSize,
                height: DailyMartDimenConst.editAvatarBadgeSize,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: cs.primary,
                  borderRadius: AppRadius.lg,
                ),
                child: AppSvgImage.asset(
                  DailyMartImageConst.pencil,
                  color: cs.onPrimary,
                  width: 18,
                  height: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
