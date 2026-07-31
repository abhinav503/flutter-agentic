import 'package:flutter/material.dart';

import 'package:core/core/theme/app_shapes_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/network_image.dart';

import '../../domain/entities/store_entity.dart';

class StoreCard extends StatelessWidget {
  final StoreEntity store;
  final VoidCallback onTap;

  const StoreCard({super.key, required this.store, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final shapes =
        context.appShapes;

    return Material(
      color: cs.surfaceContainerLow,
      borderRadius: BorderRadius.circular(shapes.cardRadius),
      child: InkWell(
        borderRadius: BorderRadius.circular(shapes.cardRadius),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.base),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(shapes.cardRadius / 2),
                child: AppNetworkImage(
                  url: store.logoUrl,
                  width: 56,
                  height: 56,
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
                      style: tt.titleMedium!.copyWith(
                        color: cs.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (store.description.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.xs4),
                      Text(
                        store.description,
                        style: tt.bodyMedium!.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
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
        ),
      ),
    );
  }
}
