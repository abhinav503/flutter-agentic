import 'package:widgetbook/widgetbook.dart';

import 'atoms_directory.dart';
import 'blocks/blocks_directory.dart';
import 'molecules_directory.dart';

/// Every atom, molecule, and block previewed in the gallery, grouped to
/// match `docs/reference/architecture.md`'s atomic hierarchy.
final List<WidgetbookNode> designGalleryDirectories = [
  atomsCategory(),
  moleculesCategory(),
  blocksCategory(),
];
