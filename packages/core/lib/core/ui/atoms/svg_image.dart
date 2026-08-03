import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'loading_indicator.dart';

enum _SvgSource { asset, network }

/// SVG image with built-in tinting, default sizing, and a loading/error state
/// — the SVG counterpart to [AppNetworkImage], so screens never hand-roll
/// `SvgPicture`'s `colorFilter`/`placeholderBuilder`/`errorBuilder`.
///
/// ```dart
/// AppSvgImage.asset('assets/icons/notification.svg', color: cs.onPrimary)
/// AppSvgImage.network(iconUrl, width: 32, height: 32)
/// ```
///
/// A CMS/Storage-driven URL that may or may not be an SVG doesn't need this
/// atom directly — [AppNetworkImage] dispatches to it on `url.isSvgUrl`.
class AppSvgImage extends StatelessWidget {
  final String src;

  /// Null on the `.network` constructor means "size to the parent", the way
  /// a raster [AppNetworkImage] inside a sized box behaves — the icon-sized
  /// 24 default only makes sense for the bundled glyphs `.asset` serves.
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;

  /// Bundled asset shown instead of the error state, so a delegating
  /// [AppNetworkImage] keeps the same fallback for vector and raster URLs.
  final String? assetPlaceholder;

  final _SvgSource _source;

  const AppSvgImage.asset(
    this.src, {
    super.key,
    this.width = 24,
    this.height = 24,
    this.fit = BoxFit.contain,
    this.color,
    this.assetPlaceholder,
  }) : _source = _SvgSource.asset;

  const AppSvgImage.network(
    this.src, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.color,
    this.assetPlaceholder,
  }) : _source = _SvgSource.network;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final colorFilter = color != null
        ? ColorFilter.mode(color!, BlendMode.srcIn)
        : null;
    final placeholder = assetPlaceholder;
    // Both unconstrained (a network SVG filling its parent) → fall back to the
    // icon default so the spinner/glyph still has a size to draw at.
    final shortestSide = switch ((width, height)) {
      (final w?, final h?) => w < h ? w : h,
      (final w?, null) => w,
      (null, final h?) => h,
      _ => 24.0,
    };
    final iconSize = shortestSide * 0.6;

    Widget errorBuilder(
      BuildContext context,
      Object error,
      StackTrace stackTrace,
    ) => placeholder != null
        ? Image.asset(placeholder, width: width, height: height, fit: fit)
        : Container(
            width: width,
            height: height,
            color: cs.surfaceContainerHighest,
            alignment: Alignment.center,
            child: Icon(
              Icons.broken_image_outlined,
              size: iconSize,
              color: cs.onSurfaceVariant,
            ),
          );

    return switch (_source) {
      _SvgSource.asset => SvgPicture.asset(
        src,
        width: width,
        height: height,
        fit: fit,
        colorFilter: colorFilter,
        errorBuilder: errorBuilder,
      ),
      _SvgSource.network => SvgPicture.network(
        src,
        width: width,
        height: height,
        fit: fit,
        colorFilter: colorFilter,
        placeholderBuilder: (context) => Container(
          width: width,
          height: height,
          color: cs.surfaceContainerHighest,
          alignment: Alignment.center,
          child: LoadingIndicator(size: iconSize, strokeWidth: 2),
        ),
        errorBuilder: errorBuilder,
      ),
    };
  }
}
