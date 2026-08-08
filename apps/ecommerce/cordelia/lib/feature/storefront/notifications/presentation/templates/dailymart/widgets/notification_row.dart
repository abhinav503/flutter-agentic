import 'package:flutter/material.dart';

import 'package:core/core/theme/app_shapes_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/icon_circle.dart';
import 'package:core/core/ui/atoms/network_image.dart';
import 'package:core/core/ui/atoms/svg_image.dart';
import 'package:core/core/ui/molecules/icon_info_row.dart';

import 'package:cordelia/enums/notification_kind.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_color_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_image_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_text_style_const.dart';

import '../../../../domain/entities/notification_entity.dart';

/// One notification row: a 48px tinted-info disc holding the kind's glyph,
/// then a semibold title over a muted message, with the sender's artwork
/// under it when there is any. Read-only — the kit draws no tap or dismiss
/// affordance on these rows.
class NotificationRow extends StatelessWidget {
  final NotificationEntity notification;

  const NotificationRow({super.key, required this.notification});

  static const double _discSize = 48;
  static const double _glyphSize = 24;

  /// The shape the console asks senders to upload at, so a picture that
  /// looked right in the composer isn't cropped differently here than it is
  /// in the push banner.
  static const double _artworkAspect = 2;

  /// Only three of the kinds have a kit export, so the rest take a filled
  /// Material Symbol — visible here at the call site rather than hidden
  /// behind an asset constant that doesn't exist (spec sheet §5). `_rounded`
  /// because the kit's solid glyphs are round-cornered; a `_sharp` or plain
  /// filled icon reads as a different family immediately.
  Widget _glyph(Color color) => switch (notification.kind) {
    NotificationKind.discount => AppSvgImage.asset(
      DailyMartImageConst.discountSolid,
      color: color,
      width: _glyphSize,
      height: _glyphSize,
    ),
    NotificationKind.payment => AppSvgImage.asset(
      DailyMartImageConst.cardSolid,
      color: color,
      width: _glyphSize,
      height: _glyphSize,
    ),
    NotificationKind.account => AppSvgImage.asset(
      DailyMartImageConst.profileSolid,
      color: color,
      width: _glyphSize,
      height: _glyphSize,
    ),
    NotificationKind.orderPlaced => Icon(
      Icons.inventory_2_rounded,
      size: _glyphSize,
      color: color,
    ),
    NotificationKind.orderDelivered => Icon(
      Icons.local_shipping_rounded,
      size: _glyphSize,
      color: color,
    ),
    NotificationKind.security => Icon(
      Icons.lock_rounded,
      size: _glyphSize,
      color: color,
    ),
  };

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    // The kit tints per kind rather than uniformly: a deal is brand-green, a
    // payment is the warm accent, everything else is plain ink.
    final glyphColor = switch (notification.kind) {
      NotificationKind.discount => cs.primary,
      NotificationKind.payment => DailyMartColorConst.paymentIcon,
      _ => cs.onSurface,
    };

    final row = IconInfoRow(
      gap: AppSpacing.lg,
      leading: AppIconCircle(
        size: _discSize,
        color: cs.surfaceContainerHighest,
        child: _glyph(glyphColor),
      ),
      title: notification.title,
      titleStyle: DailyMartTextStyleConst.bodyMdSemibold(
        tt,
      ).copyWith(color: cs.onSurface),
      subtitle: notification.message,
      subtitleStyle: DailyMartTextStyleConst.bodySmRegular(
        tt,
      ).copyWith(color: cs.onSurfaceVariant),
    );

    if (notification.imageUrl.isEmpty) return row;

    // Full width rather than inset to the text column: it reads as the
    // banner it was uploaded as, and doesn't have to track the leading
    // disc's size to stay aligned. Card radius, the same corner the pack's
    // promo card clips its photo to.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        row,
        const SizedBox(height: AppSpacing.base),
        ClipRRect(
          borderRadius: BorderRadius.circular(context.appShapes.cardRadius),
          child: AspectRatio(
            aspectRatio: _artworkAspect,
            child: AppNetworkImage(url: notification.imageUrl),
          ),
        ),
      ],
    );
  }
}
