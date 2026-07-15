import 'package:core/core/ui/atoms/device_frame.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

/// A single labelled variant shown inside a showcase page.
class Variant {
  const Variant(this.label, this.child, {this.width});
  final String label;
  final Widget child;
  final double? width;
}

Widget placeholderImage(BuildContext context, {IconData icon = Icons.image}) {
  final cs = Theme.of(context).colorScheme;
  return ColoredBox(
    color: cs.surfaceContainerHighest,
    child: Icon(icon, color: cs.onSurfaceVariant),
  );
}

/// One use case, all variants: each [Variant] with its label underneath,
/// flowing left-to-right and wrapping as needed.
Widget showcase(BuildContext context, List<Variant> variants) {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(24),
    child: Wrap(
      spacing: 24,
      runSpacing: 24,
      children: [
        for (final variant in variants)
          SizedBox(
            width: variant.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(child: variant.child),
                const SizedBox(height: 8),
                Text(
                  variant.label,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
          ),
      ],
    ),
  );
}

/// Like [showcase], but stacks full-width variants (Scaffold/AppBar/nav
/// bar previews) top-to-bottom, full-bleed (no side padding), so they keep
/// the same width they'd have in a real app instead of overflowing.
Widget showcaseStacked(BuildContext context, List<Variant> variants) {
  return SingleChildScrollView(
    padding: const EdgeInsets.symmetric(vertical: 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final variant in variants) ...[
          variant.child,
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              variant.label,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ],
    ),
  );
}

/// Like [showcase], but lays variants out in a grid instead of a wrapping
/// row — for components (like `ProductCard`) that are themselves meant to
/// sit in a product grid in the real app, so the gallery preview matches
/// that context rather than a loose horizontal flow.
Widget showcaseGrid(BuildContext context, List<Variant> variants) {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(24),
    child: GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: variants.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        mainAxisSpacing: 24,
        crossAxisSpacing: 24,
        // Product image (square, ~207px at this cell width) + badge + title
        // + meta row + price row + 44px CTA button + inter-item gaps + the
        // variant label below ≈ 400-410px depending on variant; padded up
        // for headroom across other style-pack fonts/metrics.
        mainAxisExtent: 440,
      ),
      itemBuilder: (context, i) {
        final variant = variants[i];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            variant.child,
            const SizedBox(height: 8),
            Text(
              variant.label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        );
      },
    ),
  );
}

/// For whole-screen block compositions (e.g. `CollapsingHeaderSheet` —
/// a `SizedBox.expand` header+sheet screen, not a small component): on web
/// the gallery canvas is an arbitrarily wide browser window, so edge-to-edge
/// rendering stretches the screen far past any real phone and looks broken —
/// wrap it in [DeviceFrame] at phone dimensions instead. On a real mobile
/// device the surrounding hardware already frames it, so just fill the
/// screen.
Widget showcaseDevice(BuildContext context, List<Variant> variants) {
  return SingleChildScrollView(
    padding: const EdgeInsets.symmetric(vertical: 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final variant in variants) ...[
          Center(
            child: kIsWeb
                ? SizedBox(
                    width: 390,
                    height: 844,
                    child: DeviceFrame(child: variant.child),
                  )
                : SizedBox(
                    height: MediaQuery.sizeOf(context).height,
                    child: variant.child,
                  ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              variant.label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ],
    ),
  );
}

WidgetbookComponent allVariants(
  String name,
  Widget Function(BuildContext) builder,
) {
  return WidgetbookComponent(
    name: name,
    useCases: [WidgetbookUseCase(name: 'All variants', builder: builder)],
  );
}
