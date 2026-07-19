import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/svg_image.dart';

import 'package:gravia/constants/image_const.dart';
import 'package:gravia/constants/value_const.dart';

enum AvatarSource { camera, gallery }

/// Two-row action sheet — "Take Photo" / "Choose from Gallery" — opened from
/// Edit Profile's avatar camera badge. An action list, not a selection list,
/// so this stays a plain widget rather than a `RadioOptionsSheetContent`
/// (which shows a currently-`selected` value; there isn't one here).
class AvatarSourceSheetContent extends StatelessWidget {
  const AvatarSourceSheetContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.base,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _row(
            context,
            icon: AppSvgImage.asset(
              ImageConst.camera,
              color: Theme.of(context).colorScheme.onSurface,
              width: 20,
              height: 20,
            ),
            label: ValueConst.takePhotoLabel,
            source: AvatarSource.camera,
          ),
          _row(
            context,
            icon: AppSvgImage.asset(
              ImageConst.folderGallery,
              color: Theme.of(context).colorScheme.onSurface,
              width: 20,
              height: 20,
            ),
            label: ValueConst.chooseFromGalleryLabel,
            source: AvatarSource.gallery,
          ),
        ],
      ),
    );
  }

  Widget _row(
    BuildContext context, {
    required Widget icon,
    required String label,
    required AvatarSource source,
  }) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => context.pop(source),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            icon,
            const SizedBox(width: AppSpacing.base),
            Text(label, style: tt.bodyLarge!.copyWith(color: cs.onSurface)),
          ],
        ),
      ),
    );
  }
}
