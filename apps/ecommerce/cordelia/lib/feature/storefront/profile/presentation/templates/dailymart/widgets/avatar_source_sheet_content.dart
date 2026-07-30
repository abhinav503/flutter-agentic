import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/theme/app_spacing.dart';

import 'package:cordelia/templates/dailymart/constants/dailymart_text_style_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_value_const.dart';

enum AvatarSource { camera, gallery }

/// Two-row action sheet — "Take Photo" / "Choose from Gallery" — opened from
/// Edit Profile's pencil badge. An action list, not a selection list, so it
/// stays a plain widget rather than a [DailyMartRadioSheetContent], which
/// renders a currently-`selected` value there isn't one of here.
///
/// The kit exports no camera/gallery glyph, and a row set of two Material
/// fallbacks would read as a different icon family mid-sheet — so these rows
/// are label-only, which the pack's sheet chrome already supports.
class AvatarSourceSheetContent extends StatelessWidget {
  const AvatarSourceSheetContent({super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(
      AppSpacing.lg,
      0,
      AppSpacing.lg,
      AppSpacing.lg,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _row(context, DailyMartValueConst.takePhotoLabel, AvatarSource.camera),
        _row(
          context,
          DailyMartValueConst.chooseFromGalleryLabel,
          AvatarSource.gallery,
        ),
      ],
    ),
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
          style: DailyMartTextStyleConst.bodyMdRegular(
            tt,
          ).copyWith(color: cs.onSurface),
        ),
      ),
    );
  }
}
