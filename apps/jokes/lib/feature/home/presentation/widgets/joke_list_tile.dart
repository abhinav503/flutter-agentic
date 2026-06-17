import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import '../../domain/entities/joke_entity.dart';

class JokeListTile extends StatelessWidget {
  final JokeEntity joke;
  final VoidCallback onTap;

  const JokeListTile({super.key, required this.joke, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.base,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              joke.content,
              style: tt.bodyMedium!.copyWith(color: cs.onSurface),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Divider(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}
