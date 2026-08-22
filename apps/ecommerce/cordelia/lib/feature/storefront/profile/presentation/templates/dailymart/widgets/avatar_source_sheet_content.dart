import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/molecules/action_sheet_body.dart';

import 'package:cordelia/enums/avatar_source.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_text_style_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_value_const.dart';

/// Two-row action sheet — "Take Photo" / "Choose from Gallery" — opened from
/// Edit Profile's pencil badge. An action list, not a selection list, so it
/// is an [AppActionSheetBody] rather than a [DailyMartRadioSheetContent],
/// which renders a currently-`selected` value there isn't one of here.
///
/// The kit exports no camera/gallery glyph, and a row set of two Material
/// fallbacks would read as a different icon family mid-sheet — so these rows
/// are label-only, which the pack's sheet chrome already supports.
class AvatarSourceSheetContent extends StatelessWidget {
  const AvatarSourceSheetContent({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return AppActionSheetBody<AvatarSource>(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      rowPadding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      labelStyle: DailyMartTextStyleConst.bodyMdRegular(
        tt,
      ).copyWith(color: cs.onSurface),
      actions: [
        AppSheetAction(
          label: DailyMartValueConst.takePhotoLabel,
          value: AvatarSource.camera,
        ),
        AppSheetAction(
          label: DailyMartValueConst.chooseFromGalleryLabel,
          value: AvatarSource.gallery,
        ),
      ],
    );
  }
}
