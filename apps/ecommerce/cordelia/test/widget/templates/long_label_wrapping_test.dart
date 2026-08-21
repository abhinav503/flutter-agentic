import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/blocks/ecommerce/category_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cordelia/feature/storefront/home/domain/entities/category_entity.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_dimen_const.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_category_tile.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_menu_tile.dart';
import 'package:cordelia/templates/grofast/constants/grofast_dimen_const.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_menu_tile.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_category_tile.dart';

/// Labels that outgrew one line once the storefront spoke six languages and
/// stocked seven markets' catalogs.
///
/// Two sources of long text: **category names** come from the store's own
/// catalog ("Congelados y Platos Preparados") and **translated UI labels** run
/// far past their English originals ("Meine Bestellungen" for "My Orders").
/// Both sat in narrow tiles that truncated them to an ellipsis.
///
/// The failure mode differs per pack, which is why this tests all three rather
/// than trusting the `maxLines` value:
///  - dailymart's tile is a **fixed height**, so a second line overflows unless
///    the height grew with it,
///  - grofast's and gravia's grow freely, so the risk is the rail centring
///    children of different heights and leaving the artwork misaligned.
void main() {
  // The longest name across the seven seed catalogs.
  const longest = 'Congelados y Platos Preparados';
  const shortest = 'Bebidas';

  // Caveat for anyone extending this: widget tests render with a fallback font
  // whose every glyph is a square of the font size, so text is far wider here
  // than on a device — even "Bebidas" wraps at these tile widths. Assertions
  // that compare a short name's height against a long one's therefore prove
  // nothing. What survives the fake font is what these tests check: that
  // nothing overflows, that the label is allowed two lines, and that a tile
  // either grows with its content or is fixed for every entry alike.

  Widget host(Widget child, {Brightness brightness = Brightness.light}) =>
      MaterialApp(
        theme: ThemeData(brightness: brightness),
        home: Scaffold(body: Center(child: child)),
      );

  CategoryEntity category(String name) =>
      CategoryEntity(id: name, name: name, imageUrl: '');

  group('dailymart', () {
    // This tile is `SizedBox(height: categoryTileHeight)`, so two lines only
    // fit because the constant was raised to match. If someone trims it back,
    // this is the test that fails rather than a RenderFlex overflow in the app.
    testWidgets('a long name wraps without overflowing the fixed tile', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(const DailyMartCategoryTile(label: longest, imageUrl: '')),
      );
      expect(tester.takeException(), isNull);

      final text = tester.widget<Text>(find.text(longest));
      expect(text.maxLines, 2);
    });

    testWidgets('a short name still fits the same tile', (tester) async {
      await tester.pumpWidget(
        host(const DailyMartCategoryTile(label: shortest, imageUrl: '')),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('every rail tile is the same height regardless of name', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          const Row(
            children: [
              DailyMartCategoryTile(label: longest, imageUrl: ''),
              DailyMartCategoryTile(label: shortest, imageUrl: ''),
            ],
          ),
        ),
      );
      expect(tester.takeException(), isNull);

      final sizes = tester
          .widgetList<DailyMartCategoryTile>(find.byType(DailyMartCategoryTile))
          .map((w) => tester.getSize(find.byWidget(w)))
          .toList();
      expect(sizes.first.height, sizes.last.height);
    });
  });

  group('grofast', () {
    testWidgets('the rail entry wraps to two lines', (tester) async {
      await tester.pumpWidget(
        host(GrofastCategoryRailTile(category: category(longest), index: 0)),
      );
      expect(tester.takeException(), isNull);
      expect(tester.widget<Text>(find.text(longest)).maxLines, 2);
    });

    testWidgets('the entry is content-sized, so a second line has room', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(GrofastCategoryRailTile(category: category(longest), index: 0)),
      );
      expect(tester.takeException(), isNull);

      // Height is exactly square + gap + label, i.e. nothing is fixed and
      // nothing is clipped — the extra line grows the entry downward, which
      // the rail's top alignment then keeps level with its neighbours.
      final tile = tester.getSize(find.byType(GrofastCategoryRailTile)).height;
      final label = tester.getSize(find.text(longest)).height;
      expect(
        tile,
        GrofastDimenConst.categoryRailTileSize + AppSpacing.xs + label,
      );
    });
  });

  group("grofast profile's quick tiles", () {
    // The row splits the screen three ways: 360 - 2×30 gutter - 2×12 gap = 92
    // per tile. "My Orders" fits on one line; its translations do not.
    Widget quickTile(String label) => host(
      SizedBox(
        width: 92,
        child: GrofastQuickTile(label: label, icon: Icons.star),
      ),
    );

    testWidgets('a translated label wraps without growing the card', (
      tester,
    ) async {
      await tester.pumpWidget(quickTile('Meine Bestellungen'));
      expect(tester.takeException(), isNull);

      // The kit's card proportions are preserved — two lines fit inside the
      // height that a glyph plus one line used to leave slack in.
      expect(
        tester.getSize(find.byType(GrofastQuickTile)).height,
        GrofastDimenConst.quickTileHeight,
      );
      expect(tester.widget<Text>(find.text('Meine Bestellungen')).maxLines, 2);
    });

    testWidgets('a compound word with no spaces still breaks', (tester) async {
      // German runs words together, so there is no whitespace to wrap at.
      // Flutter breaks mid-word rather than overflowing — without that, a
      // two-line cap would do nothing for this label.
      await tester.pumpWidget(quickTile('Ok'));
      final oneLine = tester.getSize(find.text('Ok')).height;

      await tester.pumpWidget(quickTile('Benachrichtigung'));
      expect(tester.takeException(), isNull);
      expect(
        tester.getSize(find.text('Benachrichtigung')).height,
        greaterThan(oneLine),
      );
    });

    testWidgets('all three tiles in a row stay level', (tester) async {
      await tester.pumpWidget(
        host(
          const SizedBox(
            width: 300,
            child: Row(
              children: [
                Expanded(
                  child: GrofastQuickTile(
                    label: 'Benachrichtigung',
                    icon: Icons.star,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: GrofastQuickTile(
                    label: 'Meine Bestellungen',
                    icon: Icons.star,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: GrofastQuickTile(label: 'Merkliste', icon: Icons.star),
                ),
              ],
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull);

      // Fixed height, so a wrapped label can never leave one tile taller.
      final heights = tester
          .widgetList<GrofastQuickTile>(find.byType(GrofastQuickTile))
          .map((w) => tester.getSize(find.byWidget(w)).height)
          .toSet();
      expect(heights, {GrofastDimenConst.quickTileHeight});
    });
  });

  // Help & Support prints the address a row will open under its label, which
  // made two fixed-height kit rows growable. Both packs record the same
  // bargain in their wrappers: a subtitled row is sized by its content, a
  // plain one keeps the kit's exact height. That is only true while these
  // pass — a regression here is a clipped second line on a real device, or a
  // Profile whose rows silently changed height.
  group('support rows that grew a subtitle', () {
    const address = 'support@a-fairly-long-store-domain.example.com';

    testWidgets('dailymart keeps its 52px strip without a subtitle', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          const SizedBox(
            width: 320,
            child: DailyMartMenuTile(icon: Icons.star, label: 'Send an email'),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      expect(
        tester.getSize(find.byType(DailyMartMenuTile)).height,
        DailyMartDimenConst.menuRowHeight,
      );
    });

    testWidgets('dailymart fits the subtitle inside the strip', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          const SizedBox(
            width: 320,
            child: DailyMartMenuTile(
              icon: Icons.star,
              label: 'Send an email',
              subtitle: address,
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      expectSubtitleInsideRow(
        tester,
        row: find.byType(DailyMartMenuTile),
        subtitle: address,
        minHeight: DailyMartDimenConst.menuRowHeight,
      );
    });

    testWidgets('grofast keeps its 60px card without a subtitle', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          const SizedBox(
            width: 320,
            child: GrofastMenuTile(icon: Icons.star, label: 'Send an email'),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      expect(
        tester.getSize(find.byType(GrofastMenuTile)).height,
        GrofastDimenConst.menuRowHeight,
      );
    });

    testWidgets('grofast fits the subtitle inside the card', (tester) async {
      await tester.pumpWidget(
        host(
          const SizedBox(
            width: 320,
            child: GrofastMenuTile(
              icon: Icons.star,
              label: 'Send an email',
              subtitle: address,
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      expectSubtitleInsideRow(
        tester,
        row: find.byType(GrofastMenuTile),
        subtitle: address,
        minHeight: GrofastDimenConst.menuRowHeight,
      );
    });
  });

  group('gravia (core CategoryTile)', () {
    testWidgets('wraps to two lines when asked', (tester) async {
      await tester.pumpWidget(
        host(
          const CategoryTile(
            image: SizedBox.shrink(),
            label: longest,
            labelMaxLines: 2,
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      expect(tester.widget<Text>(find.text(longest)).maxLines, 2);
    });
  });
}

/// Asserts a subtitled row is not clipping its second line.
///
/// Deliberately *not* "the row grew": whether it has to depends on how much
/// slack the kit's fixed height already had — dailymart's 52 has none and
/// grows, grofast's 60 swallows both lines and stays put. Both are correct,
/// and both are wrong the moment the address renders outside the row it is
/// drawn in, which is what this measures instead.
void expectSubtitleInsideRow(
  WidgetTester tester, {
  required Finder row,
  required String subtitle,
  required double minHeight,
}) {
  final rowRect = tester.getRect(row);
  expect(rowRect.height, greaterThanOrEqualTo(minHeight));

  final subtitleRect = tester.getRect(find.text(subtitle));
  expect(subtitleRect.top, greaterThanOrEqualTo(rowRect.top));
  expect(subtitleRect.bottom, lessThanOrEqualTo(rowRect.bottom));

  // The address ellipsises rather than wrapping — a wrapped email address
  // reads as two addresses.
  expect(tester.widget<Text>(find.text(subtitle)).maxLines, 1);
}
