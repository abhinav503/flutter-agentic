import 'package:flutter/material.dart';

import 'package:core/core/theme/app_shapes_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/network_image.dart';
import 'package:core/core/ui/atoms/surface_card.dart';

import 'package:cordelia/constants/cordelia_dimen_const.dart';
import 'package:cordelia/constants/cordelia_text_style_const.dart';

import '../../domain/entities/store_entity.dart';

/// One store on the discovery list: logo, name, description, chevron.
///
/// Outlined on `surface` rather than filled with `surfaceContainerLow` — the
/// list sits on the sheet, and a filled row on a filled sheet flattened the
/// two together; a hairline gives each store its own edge without adding
/// weight to a list that can run long.
class StoreCard extends StatelessWidget {
  final StoreEntity store;
  final VoidCallback onTap;

  const StoreCard({super.key, required this.store, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final shapes = context.appShapes;

    return AppSurfaceCard(
      onTap: onTap,
      borderColor: cs.outlineVariant,
      padding: const EdgeInsets.all(AppSpacing.base),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(shapes.cardRadius / 2),
            child: AppNetworkImage(
              url: store.logoUrl,
              width: CordeliaDimenConst.storeCardLogo,
              height: CordeliaDimenConst.storeCardLogo,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: AppSpacing.base),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  store.name,
                  style: CordeliaTextStyleConst.textMdBold(
                    tt,
                  ).copyWith(color: cs.onSurface),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (store.description.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xs4),
                  Text(
                    store.description,
                    style: CordeliaTextStyleConst.textSmRegular(
                      tt,
                    ).copyWith(color: cs.onSurfaceVariant),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.xs2),
          Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
        ],
      ),
    );
  }
}
