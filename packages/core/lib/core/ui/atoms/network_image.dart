import 'package:flutter/material.dart';

import 'loading_indicator.dart';

/// Network image with a built-in loading and error state, so screens never
/// hand-roll `Image.network`'s `loadingBuilder`/`errorBuilder`.
///
/// ```dart
/// AppNetworkImage(url: product.imageUrl, fit: BoxFit.cover)
/// ```
class AppNetworkImage extends StatelessWidget {
  final String url;
  final BoxFit fit;
  final double? width;
  final double? height;

  /// Bundled asset shown instead of the loading/error state — and, when
  /// [url] is empty, instead of ever hitting the network at all. Lets a
  /// screen ship with a real default photo (e.g. a generic avatar) before
  /// a user-provided URL exists.
  final String? assetPlaceholder;

  const AppNetworkImage({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.assetPlaceholder,
  });

  /// A stable, licence-free placeholder for screens that don't have real
  /// photo content yet — backed by Lorem Picsum (Unsplash-licensed photos;
  /// free, no key, no attribution required). Pass a distinct [seed] per slot
  /// so repeated placeholders don't all render the same photo.
  factory AppNetworkImage.placeholder({
    required String seed,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
  }) {
    final w = (width ?? 400).round();
    final h = (height ?? 400).round();
    return AppNetworkImage(
      url: 'https://picsum.photos/seed/$seed/$w/$h',
      width: width,
      height: height,
      fit: fit,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final placeholder = assetPlaceholder;

    if (url.isEmpty && placeholder != null) {
      return Image.asset(placeholder, width: width, height: height, fit: fit);
    }

    return Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, progress) => progress == null
          ? child
          : Container(
              width: width,
              height: height,
              color: cs.surfaceContainerHighest,
              alignment: Alignment.center,
              child: const LoadingIndicator(size: 24, strokeWidth: 2),
            ),
      errorBuilder: (context, error, stackTrace) => placeholder != null
          ? Image.asset(placeholder, width: width, height: height, fit: fit)
          : Container(
              width: width,
              height: height,
              color: cs.surfaceContainerHighest,
              alignment: Alignment.center,
              child: Icon(Icons.image_not_supported_outlined,
                  color: cs.onSurfaceVariant),
            ),
    );
  }
}
