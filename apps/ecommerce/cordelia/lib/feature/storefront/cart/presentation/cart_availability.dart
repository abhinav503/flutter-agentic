import 'package:cordelia/constants/value_const.dart';
import 'package:cordelia/enums/product_unit_type.dart';

import '../domain/entities/cart_item_entity.dart';

/// The copy a cart row shows when its line can't be bought as it stands.
/// Presentation-side, not on the entity: the entity answers *whether* a line
/// is unavailable (`isUnavailable`), and `domain` may not reach the
/// localizations to say it in words.
extension CartItemAvailabilityX on CartItemEntity {
  /// Null while the line is fine — a row renders its usual subtitle then.
  /// Judged against the line's own unit ([stockLimit]): a product with
  /// thirty units across its sizes and none of the size in this line is out
  /// of stock here, not "30 left".
  String? get availabilityLabel {
    if (!isUnavailable) return null;
    final limit = stockLimit;
    if (limit == null || limit <= 0) return ValueConst.outOfStockLabel;
    return ValueConst.onlyNLeftLabel(limit);
  }

  /// What this line holds — the server's variant label ("500 ml", "M / Red")
  /// once synced, the pack size formatted locally until then.
  String get lineLabel => variantLabel.isNotEmpty
      ? variantLabel
      : product.unitType.format(effectiveSizeValue);

  /// The row's one subtitle: the unit, and beside it why it can't be bought
  /// when it can't. The unit stays visible either way — a shopper fixing
  /// "Out of stock" needs to know *which* size that is.
  String get subtitle {
    final availability = availabilityLabel;
    return availability == null
        ? lineLabel
        : ValueConst.cartLineSubtitle(lineLabel, availability);
  }
}

/// How far a product's photo fades once it can't be bought — enough to read
/// as inactive beside an in-stock card in the same rail, not so far the
/// product stops being recognisable.
///
/// One number for all three packs: a sold-out card in one template and a
/// sold-out card in another are the same statement, and three copies of the
/// value is three chances for them to stop agreeing. The *treatment* is
/// still each pack's own — a fade here, a pill there.
const double kSoldOutImageOpacity = 0.45;
