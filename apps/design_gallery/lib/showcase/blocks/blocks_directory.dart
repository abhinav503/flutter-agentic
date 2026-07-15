import 'package:widgetbook/widgetbook.dart';

import 'ecommerce_blocks_directory.dart';
import 'generic_blocks_directory.dart';

WidgetbookCategory blocksCategory() {
  return WidgetbookCategory(
    name: 'Blocks',
    children: [genericBlocksFolder(), ecommerceBlocksFolder()],
  );
}
