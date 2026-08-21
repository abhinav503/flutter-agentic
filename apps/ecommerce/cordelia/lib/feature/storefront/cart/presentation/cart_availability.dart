import 'package:cordelia/constants/value_const.dart';
import 'package:cordelia/feature/storefront/home/domain/entities/product_entity.dart';

import '../domain/entities/cart_item_entity.dart';

/// The copy a cart row shows when its line can't be bought as it stands.
/// Presentation-side, not on the entity: the entity answers *whether* a line
/// is unavailable (`isUnavailable`), and `domain` may not reach the
/// localizations to say it in words.
extension CartItemAvailabilityX on CartItemEntity {
  /// Null while the line is fine — a row renders its usual subtitle then.
  String? get availabilityLabel {
    if (product.isOutOfStock) return ValueConst.outOfStockLabel;
    if (exceedsStock) return ValueConst.onlyNLeftLabel(product.stock!);
    return null;
  }
}
