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
class AppSvgImage extends StatelessWidget {
  final String src;
  final double width;
  final double height;
  final BoxFit fit;
  final Color? color;
  final _SvgSource _source;

  const AppSvgImage.asset(
    this.src, {
    super.key,
    this.width = 24,
    this.height = 24,
    this.fit = BoxFit.contain,
    this.color,
  }) : _source = _SvgSource.asset;

  const AppSvgImage.network(
    this.src, {
    super.key,
    this.width = 24,
    this.height = 24,
    this.fit = BoxFit.contain,
    this.color,
  }) : _source = _SvgSource.network;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final colorFilter =
        color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null;
    final iconSize = (width < height ? width : height) * 0.6;

    Widget errorBuilder(BuildContext context, Object error, StackTrace stackTrace) =>
        Container(
          width: width,
          height: height,
          color: cs.surfaceContainerHighest,
          alignment: Alignment.center,
          child: Icon(Icons.broken_image_outlined,
              size: iconSize, color: cs.onSurfaceVariant),
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
