import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cordelia/enums/product_unit_type.dart';
import 'package:cordelia/feature/storefront/home/domain/entities/product_entity.dart';
import 'package:cordelia/feature/storefront/home/domain/entities/product_variant_entity.dart';
import 'package:cordelia/feature/storefront/product_details/domain/entities/product_detail_entity.dart';
import 'package:cordelia/feature/storefront/product_details/presentation/product_details_actions.dart';

/// The selection every template's Product Details shares: the page opens
/// on the unit the card advertised, a pick on one axis narrows the others,
/// an impossible combination re-resolves to a real unit, and price/stock
/// always belong to the selected variant. Tested through the mixin on a
/// bare host, since that is exactly what the three screens reuse.

ProductVariantEntity _v(
  String id,
  List<String> options,
  double price,
  int stock, {
  double packSize = 0,
}) => ProductVariantEntity(
  id: id,
  options: options,
  price: price,
  originalPrice: price,
  discountPercentage: 0,
  stock: stock,
  packSize: packSize,
);

ProductDetailEntity _detail(ProductEntity product) => ProductDetailEntity(
  product: product,
  images: const [],
  description: '',
  sizeVariants: const [],
  similarProducts: const [],
);

ProductEntity _product({
  required List<String> optionNames,
  required List<ProductVariantEntity> variants,
  double unitValue = 0,
}) => ProductEntity(
  id: 'p1',
  name: 'Tee',
  imageUrl: '',
  price: 10,
  originalPrice: 10,
  discountPercentage: 0,
  unitValue: unitValue,
  unitType: ProductUnitType.grams,
  prepTime: '',
  isFavourite: false,
  stock: 7,
  optionNames: optionNames,
  variants: variants,
);

final _tee = _product(
  optionNames: const ['Size', 'Colour'],
  variants: [
    _v('m-red', const ['M', 'Red'], 30, 2),
    _v('l-red', const ['L', 'Red'], 25, 5),
    _v('l-blue', const ['L', 'Blue'], 28, 0),
    _v('xl-blue', const ['XL', 'Blue'], 32, 1),
  ],
);

final _rice = _product(
  optionNames: const ['Size'],
  unitValue: 1000,
  variants: [
    _v('size-500', const ['500 g'], 60, 4, packSize: 500),
    _v('size-1000', const ['1 kg'], 110, 9, packSize: 1000),
  ],
);

class _Host extends StatefulWidget {
  const _Host();
  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> with ProductDetailsActions<_Host> {
  @override
  String get storeId => 's1';
  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

void main() {
  late _HostState host;

  Future<void> pump(WidgetTester tester) async {
    await tester.pumpWidget(const _Host());
    host = tester.state(find.byType(_Host));
  }

  testWidgets('opens on the product\'s own pack when a variant is it', (
    tester,
  ) async {
    await pump(tester);
    final detail = _detail(_rice);
    expect(host.selectedVariant(detail)?.id, 'size-1000');
    expect(host.unitPrice(detail), 110);
    expect(host.packLabel(detail, (v) => '$v'), '1000.0');
  });

  testWidgets('opens on the cheapest in-stock unit otherwise', (tester) async {
    await pump(tester);
    final detail = _detail(_tee);
    // l-red is cheapest (25) and in stock; l-blue (28) is sold out anyway.
    expect(host.selectedVariant(detail)?.id, 'l-red');
    expect(host.selectedPurchaseLimit(detail), 5);
  });

  testWidgets('a pick on one axis narrows what the other offers', (
    tester,
  ) async {
    await pump(tester);
    final detail = _detail(_tee);
    host.selectOption(1, 'Blue');
    await tester.pump();
    // L stays (L/Blue exists but is sold out → unavailable), XL/Blue is the
    // unit that sells, M/Blue doesn't exist.
    final size = host.optionAxes(detail)[0];
    expect(
      {for (final v in size.values) v.value: v.available},
      {'M': false, 'L': false, 'XL': true},
    );
    // The selection re-resolved to a real unit offering Blue.
    expect(host.selectedVariant(detail)?.id, anyOf('l-blue', 'xl-blue'));
  });

  testWidgets('price, stock and sold-out follow the selected unit', (
    tester,
  ) async {
    await pump(tester);
    final detail = _detail(_tee);
    host.selectOption(0, 'L');
    host.selectOption(1, 'Blue');
    await tester.pump();
    expect(host.selectedVariant(detail)?.id, 'l-blue');
    expect(host.unitPrice(detail), 28);
    expect(host.isSelectedOutOfStock(detail), isTrue);
    expect(host.selectedPurchaseLimit(detail), isNull);
    host.selectOption(0, 'M');
    await tester.pump();
    // M/Blue doesn't exist: the last pick (M) wins and Colour re-resolves.
    expect(host.selectedVariant(detail)?.id, 'm-red');
    expect(host.isSelectedLowStock(detail), isTrue);
    expect(host.selectedStock(detail), 2);
  });

  testWidgets('a simple product has no axes and reads its own numbers', (
    tester,
  ) async {
    await pump(tester);
    final detail = _detail(_product(optionNames: const [], variants: const []));
    expect(host.optionAxes(detail), isEmpty);
    expect(host.selectedVariant(detail), isNull);
    expect(host.unitPrice(detail), 10);
    expect(host.selectedPurchaseLimit(detail), 7);
  });
}
