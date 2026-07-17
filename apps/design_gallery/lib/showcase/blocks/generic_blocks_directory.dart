import 'package:core/core/theme/app_shapes_extension.dart';
import 'package:core/core/ui/blocks/bottom_nav_bar.dart';
import 'package:core/core/ui/blocks/chunked_grid.dart';
import 'package:core/core/ui/blocks/collapsing_header_sheet.dart';
import 'package:core/core/ui/blocks/docked_bar_overlap.dart';
import 'package:core/core/ui/blocks/quantity_stepper.dart';
import 'package:core/core/ui/blocks/section_header.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../showcase_layouts.dart';

WidgetbookFolder genericBlocksFolder() {
  return WidgetbookFolder(
    name: 'Generic',
    children: [
      allVariants(
        'SectionHeader',
        (context) => showcase(context, [
          Variant(
            'Default',
            SectionHeader(
              title: 'Fresh Vegetables',
              actionLabel: 'See All',
              onAction: () {},
            ),
            width: 320,
          ),
          Variant(
            'Custom titleStyle/actionStyle',
            Builder(
              builder: (context) => SectionHeader(
                title: 'Fresh Vegetables',
                actionLabel: 'See All',
                onAction: () {},
                titleStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  height: 1.55,
                  letterSpacing: -0.36,
                ),
                actionStyle: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 14,
                  height: 1.4,
                  letterSpacing: -0.28,
                ),
              ),
            ),
            width: 320,
          ),
        ]),
      ),
      allVariants(
        'CollapsingHeaderSheet',
        (context) => showcaseDevice(context, [
          Variant(
            'Default',
            CollapsingHeaderSheet(
              initialHeaderHeight: 140,
              header: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Header content\n(e.g. HomeHeroHeader)',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < 8; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text('Sheet content row $i'),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
      allVariants(
        'DockedBarOverlap',
        (context) => showcaseDevice(context, [
          Variant(
            'Content shows through the bar\'s corner cut-outs',
            Builder(
              builder: (context) {
                final cs = Theme.of(context).colorScheme;
                final shapes =
                    Theme.of(context).extension<AppShapes>() ??
                    AppShapes.standard;
                return DockedBarOverlap(
                  overlap: shapes.sheetRadius,
                  bar: DecoratedBox(
                    decoration: BoxDecoration(
                      color: cs.surface,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(shapes.sheetRadius),
                        topRight: Radius.circular(shapes.sheetRadius),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text('Docked bar (e.g. a cart status bar)'),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: cs.primary,
                              borderRadius: BorderRadius.circular(
                                shapes.buttonRadius,
                              ),
                            ),
                            child: Text(
                              'Action',
                              style: TextStyle(color: cs.onPrimary),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Edge-to-edge tinted rows so the strip revealed by the
                  // bar's transparent corner cut-outs is visible.
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      for (var i = 0; i < 14; i++)
                        Container(
                          height: 72,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          color: i.isEven
                              ? cs.primaryContainer
                              : cs.secondaryContainer,
                          child: Text('Scrolling content row $i'),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ]),
      ),
      allVariants(
        'QuantityStepper',
        (context) => showcase(context, [
          Variant(
            'Default',
            QuantityStepper(value: 2, onIncrement: () {}, onDecrement: () {}),
          ),
          Variant('At minimum', QuantityStepper(value: 1, onIncrement: () {})),
          Variant(
            'Custom icons + colour + value style (e.g. gravia)',
            Builder(
              builder: (context) {
                final cs = Theme.of(context).colorScheme;
                return QuantityStepper(
                  value: 2,
                  onIncrement: () {},
                  onDecrement: () {},
                  // A style pack's own icon asset would replace these
                  // Icon() calls (see AppIconButton.iconBuilder).
                  decrementIconBuilder: (color, size) =>
                      Icon(Icons.remove, color: color, size: size),
                  incrementIconBuilder: (color, size) =>
                      Icon(Icons.add, color: color, size: size),
                  iconColor: cs.onSurfaceVariant,
                  valueTextStyle: Theme.of(context).textTheme.titleMedium!
                      .copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.32,
                      ),
                );
              },
            ),
          ),
        ]),
      ),
      allVariants(
        'ChunkedGrid',
        (context) => showcase(context, [
          Variant(
            '4 columns, even count',
            Builder(
              builder: (context) {
                final cs = Theme.of(context).colorScheme;
                return ChunkedGrid(
                  itemCount: 8,
                  columns: 4,
                  spacing: 8,
                  runSpacing: 16,
                  itemBuilder: (context, i) => Container(
                    height: 48,
                    alignment: Alignment.center,
                    color: cs.primaryContainer,
                    child: Text('${i + 1}'),
                  ),
                );
              },
            ),
            width: 320,
          ),
          Variant(
            '2 columns, odd count (last row gets an empty filler)',
            Builder(
              builder: (context) {
                final cs = Theme.of(context).colorScheme;
                return ChunkedGrid(
                  itemCount: 5,
                  columns: 2,
                  spacing: 16,
                  runSpacing: 16,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  itemBuilder: (context, i) => Container(
                    height: i.isEven ? 80 : 56,
                    alignment: Alignment.center,
                    color: cs.secondaryContainer,
                    child: Text('${i + 1}'),
                  ),
                );
              },
            ),
            width: 320,
          ),
        ]),
      ),
      allVariants(
        'BottomNavBar',
        (context) => showcaseStacked(context, [
          Variant(
            'Home active',
            BottomNavBar(
              currentIndex: 0,
              onTap: (_) {},
              items: const [
                BottomNavBarItem(icon: Icons.home_outlined, label: 'Home'),
                BottomNavBarItem(icon: Icons.apps, label: 'Categories'),
                BottomNavBarItem(
                  icon: Icons.favorite_border,
                  label: 'Favourite',
                ),
                BottomNavBarItem(
                  icon: Icons.shopping_bag_outlined,
                  label: 'Cart',
                ),
                BottomNavBarItem(icon: Icons.person_outline, label: 'Profile'),
              ],
            ),
          ),
          Variant(
            'Cart active',
            BottomNavBar(
              currentIndex: 3,
              onTap: (_) {},
              items: const [
                BottomNavBarItem(icon: Icons.home_outlined, label: 'Home'),
                BottomNavBarItem(icon: Icons.apps, label: 'Categories'),
                BottomNavBarItem(
                  icon: Icons.favorite_border,
                  label: 'Favourite',
                ),
                BottomNavBarItem(
                  icon: Icons.shopping_bag_outlined,
                  label: 'Cart',
                ),
                BottomNavBarItem(icon: Icons.person_outline, label: 'Profile'),
              ],
            ),
          ),
        ]),
      ),
    ],
  );
}
