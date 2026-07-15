import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import 'design_gallery_themes.dart';
import 'showcase/design_gallery_directories.dart';

void main() => runApp(const DesignGalleryApp());

/// Living style-pack gallery — every atom, molecule, and block previewed
/// against every theme preset (`gravia`, `rocketWarm`, …). Use the Theme
/// addon in the toolbar to switch presets and confirm re-skinning per
/// docs/ai-rules/design.md's "Verify" step: everything below should look
/// completely different with zero code changes, only the active preset.
///
/// Each component has a single "All variants" use case that lays out every
/// state on one page — no clicking through the tree per variant.
///
/// Not every atom is showcased here — `atoms/file_thumbnail.dart`
/// (`AppFileThumbnail`) imports `dart:io` to read a local file, which this
/// app can't have unconditionally: it also builds for web (`make
/// web-design-gallery`), and `dart:io` doesn't compile there. Per
/// docs/ai-rules/design.md §1, any other addition should get a showcase
/// entry — this is a documented exception, not an oversight.
class DesignGalleryApp extends StatelessWidget {
  const DesignGalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      directories: designGalleryDirectories,
      addons: [
        MaterialThemeAddon(themes: designGalleryPresetThemes()),
        ViewportAddon([
          Viewports.none,
          ...IosViewports.phones,
          ...AndroidViewports.phones,
        ]),
        AlignmentAddon(),
      ],
    );
  }
}
