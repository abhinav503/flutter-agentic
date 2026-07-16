import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:core/core/theme/app_theme.dart';
import 'package:core/core/theme/app_theme_config.dart';
import 'package:core/core/ui/blocks/quantity_stepper.dart';

import 'package:gravia/enums/product_unit_type.dart';
import 'package:gravia/feature/home/domain/entities/product_entity.dart';
import 'package:gravia/widgets/add_to_cart_sheet_content.dart';

const _product = ProductEntity(
  id: '1',
  name: 'Green Grapes',
  imageUrl: 'https://example.com/grapes.png',
  price: 4.00,
  originalPrice: 5.00,
  discountPercentage: 20,
  unitValue: 500,
  unitType: ProductUnitType.grams,
  prepTime: '10 Min',
  isFavourite: false,
);

Widget _wrap({required ValueChanged<int> onAddToCart}) => MaterialApp(
  theme: AppTheme.fromConfig(AppThemeConfig.defaults),
  home: Scaffold(
    body: Builder(
      builder: (context) => ElevatedButton(
        onPressed: () => showModalBottomSheet<void>(
          context: context,
          builder: (_) => AddToCartSheetContent(
            product: _product,
            onAddToCart: onAddToCart,
          ),
        ),
        child: const Text('open'),
      ),
    ),
  ),
);

Future<void> _openSheet(
  WidgetTester tester, {
  required ValueChanged<int> onAddToCart,
}) async {
  await tester.pumpWidget(_wrap(onAddToCart: onAddToCart));
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
}

Finder get _stepButtons => find.descendant(
  of: find.byType(QuantityStepper),
  matching: find.byType(InkWell),
);

void main() {
  testWidgets('starts at quantity 1 showing the unit price and weight', (
    tester,
  ) async {
    await _openSheet(tester, onAddToCart: (_) {});

    expect(find.text('1'), findsOneWidget);
    expect(find.text('\$4.00'), findsOneWidget);
    expect(find.text('500 g'), findsOneWidget);
  });

  testWidgets('increment scales quantity, price, and weight together', (
    tester,
  ) async {
    await _openSheet(tester, onAddToCart: (_) {});

    await tester.tap(_stepButtons.at(1)); // increment
    await tester.pump();

    expect(find.text('2'), findsOneWidget);
    expect(find.text('\$8.00'), findsOneWidget);
    expect(find.text('1 kg'), findsOneWidget);
  });

  testWidgets('decrement is clamped at a minimum of 1', (tester) async {
    await _openSheet(tester, onAddToCart: (_) {});

    await tester.tap(_stepButtons.at(0)); // decrement, already at the floor
    await tester.pump();

    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('Add To Cart reports the chosen quantity and closes the sheet', (
    tester,
  ) async {
    int? confirmedQuantity;
    await _openSheet(
      tester,
      onAddToCart: (quantity) => confirmedQuantity = quantity,
    );

    await tester.tap(_stepButtons.at(1)); // increment to 2
    await tester.pump();
    await tester.tap(find.text('Add To Cart'));
    await tester.pumpAndSettle();

    expect(confirmedQuantity, 2);
    expect(find.byType(AddToCartSheetContent), findsNothing);
  });

  testWidgets('Cancel closes the sheet without reporting a quantity', (
    tester,
  ) async {
    var called = false;
    await _openSheet(tester, onAddToCart: (_) => called = true);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(called, isFalse);
    expect(find.byType(AddToCartSheetContent), findsNothing);
  });
}
