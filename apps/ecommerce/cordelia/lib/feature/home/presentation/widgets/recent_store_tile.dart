import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/network_image.dart';

import 'package:cordelia/constants/cordelia_dimen_const.dart';
import 'package:cordelia/constants/cordelia_text_style_const.dart';

import '../../domain/entities/store_entity.dart';

/// One store in the recents rail — a circular logo over its name.
///
/// A disc, not the list card's rounded square: the rail's job is brand
/// recognition at a glance, and the round crop reads as an avatar rather
/// than as a second, smaller copy of the card below it.
class RecentStoreTile extends StatelessWidget {
  final StoreEntity store;
  final VoidCallback onTap;

  const RecentStoreTile({super.key, required this.store, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return SizedBox(
      width: CordeliaDimenConst.recentStoreTile,
      // The rail sits on `CollapsingHeaderSheet`'s sheet, which is a
      // DecoratedBox painted over the Scaffold's Material — so an InkWell's
      // ripple would render *under* the sheet fill and never be seen. This
      // transparent Material gives the ink a surface of its own without
      // painting anything.
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(
            CordeliaDimenConst.recentStoreTile,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipOval(
                child: AppNetworkImage(
                  url: store.logoUrl,
                  width: CordeliaDimenConst.recentStoreLogo,
                  height: CordeliaDimenConst.recentStoreLogo,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: AppSpacing.xs2),
              Text(
                store.name,
                style: CordeliaTextStyleConst.textXsRegular(
                  tt,
                ).copyWith(color: cs.onSurface),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
