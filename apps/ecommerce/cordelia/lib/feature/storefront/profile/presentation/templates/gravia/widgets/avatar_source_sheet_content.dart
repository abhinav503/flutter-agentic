import 'package:cordelia/enums/avatar_source.dart';
import 'package:cordelia/templates/gravia/constants/gravia_image_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_value_const.dart';
import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/svg_image.dart';
import 'package:core/core/ui/molecules/action_sheet_body.dart';

/// Two-row action sheet — "Take Photo" / "Choose from Gallery" — opened from
/// Edit Profile's avatar camera badge. An action list, not a selection list,
/// so this is an [AppActionSheetBody] rather than a `RadioOptionsSheetContent`
/// (which shows a currently-`selected` value; there isn't one here).
class AvatarSourceSheetContent extends StatelessWidget {
  const AvatarSourceSheetContent({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    Widget glyph(String asset) => AppSvgImage.asset(
      asset,
      color: cs.onSurface,
      width: AppSpacing.xl2,
      height: AppSpacing.xl2,
    );

    return AppActionSheetBody<AvatarSource>(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.base,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      actions: [
        AppSheetAction(
          label: GraviaValueConst.takePhotoLabel,
          value: AvatarSource.camera,
          leading: glyph(GraviaImageConst.camera),
        ),
        AppSheetAction(
          label: GraviaValueConst.chooseFromGalleryLabel,
          value: AvatarSource.gallery,
          leading: glyph(GraviaImageConst.folderGallery),
        ),
      ],
    );
  }
}
