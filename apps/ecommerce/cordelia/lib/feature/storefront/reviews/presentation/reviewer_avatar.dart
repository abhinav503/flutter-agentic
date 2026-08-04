import 'package:flutter/material.dart';

import 'package:core/core/ui/atoms/icon_circle.dart';
import 'package:core/core/ui/atoms/network_image.dart';

/// A reviewer's profile photo, or a neutral person glyph when they have
/// none — most shoppers never set one, so the fallback is the common case,
/// not an error state.
///
/// Template-agnostic on purpose: all three packs draw the same circular
/// photo-or-glyph, and only the size differs. It reads its colours from the
/// theme, so each pack's palette skins it without a per-pack copy.
class ReviewerAvatar extends StatelessWidget {
  final String avatarUrl;
  final double size;

  const ReviewerAvatar({
    super.key,
    required this.avatarUrl,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    if (avatarUrl.isEmpty) {
      return AppIconCircle(
        size: size,
        color: cs.surfaceContainer,
        child: Icon(
          Icons.person_rounded,
          // Proportional, not a token: the glyph has to stay centred in
          // whatever disc the pack asked for.
          size: size / 2,
          color: cs.onSurfaceVariant,
        ),
      );
    }

    return ClipOval(
      child: AppNetworkImage(
        url: avatarUrl,
        width: size,
        height: size,
        fit: BoxFit.cover,
      ),
    );
  }
}
