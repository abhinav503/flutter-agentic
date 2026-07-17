import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/svg_image.dart';

import 'package:gravia/constants/color_const.dart';
import 'package:gravia/constants/text_style_const.dart';

import '../../domain/entities/notification_entity.dart';

/// One notification row: a tinted-primary icon circle (same mint-on-tint
/// look as `ProductCard`'s weight badge — kept identical so it doesn't drift
/// into its own one-off colour), bold title, and a muted message line below.
/// Read-only — the kit spec has no tap/dismiss affordance on these rows.
class NotificationRow extends StatelessWidget {
  final NotificationEntity notification;

  const NotificationRow({super.key, required this.notification});

  static const double _iconCircleSize = 44;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: _iconCircleSize,
          height: _iconCircleSize,
          decoration: BoxDecoration(
            color: cs.tintedPrimaryFill,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: AppSvgImage.asset(
            notification.iconAsset,
            color: cs.primary,
            width: 24,
            height: 24,
          ),
        ),
        const SizedBox(width: AppSpacing.base),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notification.title,
                style: TextStyleConst.textMdBold(tt).copyWith(color: cs.onSurface),
              ),
              const SizedBox(height: AppSpacing.xs4),
              Text(
                notification.message,
                style: TextStyleConst.textXsRegular(
                  tt,
                ).copyWith(color: ColorConst.gray500),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
