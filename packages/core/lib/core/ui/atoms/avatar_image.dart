import 'package:flutter/foundation.dart' show Uint8List;
import 'package:flutter/material.dart';

import 'network_image.dart';

/// A person's photo in a circle, from whichever source is available.
///
/// The order matters and is the reason this exists once: [bytes] (a photo
/// picked this session, which paints without waiting on a freshly-written
/// URL) beats [url], and when there is neither, [fallback] stands in — a
/// glyph on a tinted disc, a bundled default, whatever the caller has.
/// [assetPlaceholder] is the gentler version of that: a bundled image
/// [AppNetworkImage] uses for an empty *or* broken URL.
///
/// Every avatar in an app tends to re-derive this priority, and they drift:
/// one shows the placeholder while a picked photo uploads, another flashes
/// an empty circle.
class AppAvatarImage extends StatelessWidget {
  final String url;

  /// A photo held in memory — picked this session, not yet uploaded.
  final Uint8List? bytes;

  final double size;
  final BoxFit fit;

  /// Bundled image for an empty or unreachable [url].
  final String? assetPlaceholder;

  /// Rendered instead of the image when there is nothing to show at all —
  /// no [bytes], no [url]. Takes the whole circle, so it can carry its own
  /// background.
  final Widget? fallback;

  const AppAvatarImage({
    super.key,
    required this.url,
    required this.size,
    this.bytes,
    this.fit = BoxFit.cover,
    this.assetPlaceholder,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    final picked = bytes;
    if (picked == null && url.isEmpty && fallback != null) return fallback!;

    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: picked != null
            ? Image.memory(picked, width: size, height: size, fit: fit)
            : AppNetworkImage(
                url: url,
                width: size,
                height: size,
                fit: fit,
                assetPlaceholder: assetPlaceholder,
              ),
      ),
    );
  }
}
