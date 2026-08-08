import 'package:cordelia/enums/notification_kind.dart';
import 'package:cordelia/templates/gravia/constants/gravia_color_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_image_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_text_style_const.dart';
import 'package:flutter/material.dart';

import 'package:core/core/theme/app_colors_extension.dart';
import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/icon_circle.dart';
import 'package:core/core/ui/atoms/network_image.dart';
import 'package:core/core/ui/atoms/svg_image.dart';
import 'package:core/core/ui/molecules/icon_info_row.dart';

import '../../../../domain/entities/notification_entity.dart';

/// One notification row: a tinted-primary icon circle (same mint-on-tint
/// look as `ProductCard`'s weight badge — kept identical so it doesn't drift
/// into its own one-off colour), bold title, and a muted message line below,
/// with the sender's artwork under it when there is any.
/// Read-only — the kit spec has no tap/dismiss affordance on these rows.
class NotificationRow extends StatelessWidget {
  final NotificationEntity notification;

  const NotificationRow({super.key, required this.notification});

  static const double _iconCircleSize = 44;

  /// The shape the console asks senders to upload at, so a picture that
  /// looked right in the composer isn't cropped differently here than it is
  /// in the push banner.
  static const double _artworkAspect = 2;

  /// The pack's glyph for each notification kind. The kind is what the shared
  /// data carries — the asset path is this template's business, so a store on
  /// another template can draw the same notification with its own artwork.
  static String _asset(NotificationKind kind) => switch (kind) {
    NotificationKind.discount => GraviaImageConst.badgePercent,
    NotificationKind.orderPlaced => GraviaImageConst.packageBox,
    NotificationKind.orderDelivered => GraviaImageConst.openBox,
    NotificationKind.payment => GraviaImageConst.card,
    NotificationKind.account => GraviaImageConst.navProfile,
    NotificationKind.security => GraviaImageConst.lock,
  };

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final row = IconInfoRow(
      crossAxisAlignment: CrossAxisAlignment.start,
      lineGap: AppSpacing.xs4,
      leading: AppIconCircle(
        size: _iconCircleSize,
        color: context.appColors.tintedPrimaryFill,
        child: AppSvgImage.asset(_asset(notification.kind), color: cs.primary),
      ),
      title: notification.title,
      titleStyle: GraviaTextStyleConst.textMdBold(
        tt,
      ).copyWith(color: cs.onSurface),
      subtitle: notification.message,
      subtitleStyle: GraviaTextStyleConst.textXsRegular(
        tt,
      ).copyWith(color: GraviaColorConst.gray500),
    );

    if (notification.imageUrl.isEmpty) return row;

    // Full width rather than inset to the text column: it reads as the
    // banner it was uploaded as, and doesn't have to track the leading
    // circle's size to stay aligned.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        row,
        const SizedBox(height: AppSpacing.base),
        ClipRRect(
          borderRadius: AppRadius.lg,
          child: AspectRatio(
            aspectRatio: _artworkAspect,
            child: AppNetworkImage(url: notification.imageUrl),
          ),
        ),
      ],
    );
  }
}
