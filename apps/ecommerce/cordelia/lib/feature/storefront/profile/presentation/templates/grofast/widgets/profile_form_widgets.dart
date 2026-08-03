import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/theme/app_spacing.dart';

import 'package:cordelia/enums/avatar_source.dart';
import 'package:cordelia/templates/grofast/constants/grofast_color_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_dimen_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_text_style_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_value_const.dart';
import 'package:cordelia/widgets/cordelia_avatar_image.dart';

import '../../../../domain/entities/profile_entity.dart';

/// Edit Profile's tappable hero avatar — the portrait with a gradient camera
/// badge overlapping its bottom-right corner.
///
/// The badge is a circle painted with the brand gradient, like every other
/// affirmative control in this pack; the kit has no Edit Profile frame, so
/// the composition is assembled from the pack's own recipes (spec sheet §11).
class GrofastProfileAvatarPicker extends StatelessWidget {
  final ProfileEntity profile;
  final Uint8List? pickedAvatarBytes;
  final VoidCallback onTap;

  const GrofastProfileAvatarPicker({
    super.key,
    required this.profile,
    required this.pickedAvatarBytes,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: GrofastDimenConst.editAvatarSize,
        height: GrofastDimenConst.editAvatarSize,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            CordeliaAvatarImage(
              profile: profile,
              size: GrofastDimenConst.editAvatarSize,
              pickedBytes: pickedAvatarBytes,
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: GrofastDimenConst.editAvatarBadgeSize,
                height: GrofastDimenConst.editAvatarBadgeSize,
                decoration: BoxDecoration(
                  gradient: GrofastColorConst.brandGradient,
                  shape: BoxShape.circle,
                  border: Border.all(color: cs.surface, width: 2),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.photo_camera_rounded,
                  size: AppSpacing.xl,
                  color: cs.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Two-row action sheet — "Take Photo" / "Choose from Gallery" — opened from
/// the avatar picker. An action list, not a selection list, so it stays a
/// plain widget rather than the pack's options sheet, which would render a
/// selected value there isn't one of here.
class GrofastAvatarSourceSheetContent extends StatelessWidget {
  const GrofastAvatarSourceSheetContent({super.key});

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      _row(context, GrofastValueConst.takePhotoLabel, AvatarSource.camera),
      _row(
        context,
        GrofastValueConst.chooseFromGalleryLabel,
        AvatarSource.gallery,
      ),
    ],
  );

  Widget _row(BuildContext context, String label, AvatarSource source) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => context.pop(source),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Text(
          label,
          style: GrofastTextStyleConst.bodyMedium(
            tt,
          ).copyWith(color: cs.onSurface),
        ),
      ),
    );
  }
}
