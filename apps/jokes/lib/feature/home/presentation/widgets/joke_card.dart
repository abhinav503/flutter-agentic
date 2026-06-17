import 'package:flutter/material.dart';

import 'package:jokes/constants/value_const.dart';
import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/badge.dart';
import '../../domain/entities/joke_entity.dart';

class JokeCard extends StatelessWidget {
  final JokeEntity joke;
  final VoidCallback? onTap;
  final bool isFetchingNext;

  const JokeCard({
    super.key,
    required this.joke,
    this.onTap,
    this.isFetchingNext = false,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.md,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppBadge(
                  text: ValueConst.jokeCardBadge,
                  intent: AppBadgeIntent.info,
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  joke.content,
                  style: tt.bodyLarge!.copyWith(color: cs.onSurface),
                  textAlign: TextAlign.start,
                ),
                if (!isFetchingNext) ...[
                  const SizedBox(height: AppSpacing.base),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.touch_app_outlined,
                          size: 14, color: cs.onSurfaceVariant),
                      const SizedBox(width: AppSpacing.xs3),
                      Text(
                        ValueConst.jokeTapForMore,
                        style: tt.labelSmall!
                            .copyWith(color: cs.onSurfaceVariant),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
