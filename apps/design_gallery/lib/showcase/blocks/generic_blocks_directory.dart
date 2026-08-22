import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_shapes_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/bottom_fade.dart';
import 'package:core/core/ui/atoms/button.dart';
import 'package:core/core/ui/atoms/icon_button.dart';
import 'package:core/core/ui/blocks/action_pair.dart';
import 'package:core/core/ui/blocks/bottom_nav_bar.dart';
import 'package:core/core/ui/blocks/chunked_grid.dart';
import 'package:core/core/ui/blocks/collapsing_header_sheet.dart';
import 'package:core/core/ui/blocks/docked_bar.dart';
import 'package:core/core/ui/blocks/docked_bar_overlap.dart';
import 'package:core/core/ui/blocks/header_canvas.dart';
import 'package:core/core/ui/blocks/hero_header.dart';
import 'package:core/core/ui/blocks/hero_search_field_flight.dart';
import 'package:core/core/ui/blocks/quantity_stepper.dart';
import 'package:core/core/ui/blocks/screen_body.dart';
import 'package:core/core/ui/blocks/section_header.dart';
import 'package:core/core/ui/blocks/section_rail.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../showcase_layouts.dart';

WidgetbookFolder genericBlocksFolder() {
  return WidgetbookFolder(
    name: 'Generic',
    children: [
      allVariants(
        'SectionRail',
        (context) => showcase(context, [
          Variant(
            'Header + scrolling rail',
            SectionRail(
              header: SectionHeader(
                title: 'Shop by category',
                actionLabel: 'See All',
                onAction: () {},
              ),
              itemCount: 6,
              itemBuilder: (context, i) => Container(
                width: 72,
                height: 72,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child: Text('${i + 1}'),
              ),
            ),
            width: 320,
          ),
        ]),
      ),
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
          Variant(
            'Custom action widget',
            Builder(
              builder: (context) => SectionHeader(
                title: 'Top Seller',
                action: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 5,
                    ),
                    child: Text(
                      'See all',
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
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
                final shapes = context.appShapes;
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
          Variant(
            'Bare (showContainer: false)',
            QuantityStepper(
              value: 2,
              showContainer: false,
              onIncrement: () {},
              onDecrement: () {},
            ),
          ),
          Variant(
            'Square keys (buttonSize 32, buttonRadius + buttonColor)',
            Builder(
              builder: (context) {
                final cs = Theme.of(context).colorScheme;
                return QuantityStepper(
                  value: 2,
                  onIncrement: () {},
                  onDecrement: () {},
                  showContainer: false,
                  buttonSize: 32,
                  buttonRadius: AppRadius.sm,
                  buttonColor: cs.surfaceContainerHighest,
                );
              },
            ),
          ),
        ]),
      ),
      allVariants(
        'ActionPair',
        (context) => showcase(context, [
          Variant(
            'Secondary + primary pair',
            ActionPair(
              first: AppButton(
                label: 'Cancel',
                variant: AppButtonVariant.secondary,
                fullWidth: true,
                onTap: () {},
              ),
              second: AppButton(label: 'Apply', fullWidth: true, onTap: () {}),
            ),
            width: 320,
          ),
        ]),
      ),
      allVariants(
        'ScreenBody',
        (context) => showcase(context, [
          Variant(
            'Header + body + floating CTA over a BottomFade',
            SizedBox(
              width: 360,
              height: 500,
              child: ScreenBody(
                header: Row(
                  children: [
                    Builder(
                      builder: (context) => AppIconButton(
                        icon: Icons.arrow_back_rounded,
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.surfaceContainer,
                        foregroundColor: Theme.of(
                          context,
                        ).colorScheme.onSurface,
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(width: AppSpacing.base),
                    Builder(
                      builder: (context) => Text(
                        'My Cart',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < 12; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.xs,
                        ),
                        child: Text('Content row $i'),
                      ),
                  ],
                ),
                floatingAction: AppButton(
                  label: 'Proceed To Checkout',
                  fullWidth: true,
                  onTap: () {},
                ),
                floatingActionScrollInset: 120,
                bottomFade: const BottomFade(),
              ),
            ),
          ),
          Variant(
            'Pinned header — body clips at the viewport, not under the title',
            SizedBox(
              width: 360,
              height: 320,
              child: ScreenBody(
                pinnedHeader: true,
                header: Builder(
                  builder: (context) => Text(
                    'My Orders',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < 12; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.xs,
                        ),
                        child: Text('Content row $i'),
                      ),
                  ],
                ),
              ),
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
        'DockedBar',
        (context) => showcaseStacked(context, [
          Variant(
            'Default (e.g. a docked "Add to Cart" CTA)',
            Builder(
              builder: (context) {
                final cs = Theme.of(context).colorScheme;
                final shapes = context.appShapes;
                return DockedBar(
                  child: Container(
                    height: 45,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: cs.primary,
                      borderRadius: BorderRadius.circular(shapes.buttonRadius),
                    ),
                    child: Text(
                      'Add to Cart',
                      style: TextStyle(color: cs.onPrimary),
                    ),
                  ),
                );
              },
            ),
          ),
        ]),
      ),
      allVariants(
        'HeaderCanvas',
        (context) => showcaseStacked(context, [
          Variant(
            'Default (a screen-top hero header composes onto this)',
            HeaderCanvas(
              child: Builder(
                builder: (context) => Text(
                  'Header content\n(e.g. a location row, a search field)',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ),
          Variant(
            'Gradient — for a brand whose header is a ramp, not one role',
            HeaderCanvas(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF02291F), Color(0xFF027A60)],
              ),
              child: Builder(
                builder: (context) => Text(
                  'Pair with CollapsingHeaderSheet.headerColor set to the\n'
                  'gradient\'s end colour, or the sheet seams under it.',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
      allVariants(
        'HeroHeader',
        (context) => showcaseStacked(context, [
          Variant(
            'Default — leading control + centered title',
            HeroHeader(
              title: 'My Cart',
              leading: Builder(
                builder: (context) => IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onPressed: () {},
                ),
              ),
              leadingBalanceWidth: 48,
            ),
          ),
          Variant(
            'HeroHeader.page — left-aligned, no leading control',
            HeroHeader.page(title: 'Categories'),
          ),
          Variant(
            'With a bottom row (e.g. filter chips)',
            HeroHeader(
              title: 'Vegetables',
              leading: Builder(
                builder: (context) => IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onPressed: () {},
                ),
              ),
              leadingBalanceWidth: 48,
              bottom: Builder(
                builder: (context) => Text(
                  'Sort: Relevance · Price: All',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
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
          Variant(
            'Stacked — Home active',
            BottomNavBar(
              variant: BottomNavBarVariant.stacked,
              currentIndex: 0,
              onTap: (_) {},
              items: const [
                BottomNavBarItem(icon: Icons.home_outlined, label: 'Home'),
                BottomNavBarItem(
                  icon: Icons.favorite_border,
                  label: 'Wishlist',
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
            'Stacked — Cart active',
            BottomNavBar(
              variant: BottomNavBarVariant.stacked,
              currentIndex: 2,
              onTap: (_) {},
              items: const [
                BottomNavBarItem(icon: Icons.home_outlined, label: 'Home'),
                BottomNavBarItem(
                  icon: Icons.favorite_border,
                  label: 'Wishlist',
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
      allVariants(
        'HeroSearchFieldFlight',
        // A Hero only animates during a route transition, so the showcase
        // shows the wrapped bar at rest — the flight mechanics (straight
        // RectTween, inert shuttle copy) only matter mid-navigation.
        (context) => showcase(context, [
          Variant(
            'Wrapped search bar (at rest)',
            HeroSearchFieldFlight(
              tag: 'gallery-search-flight',
              barBuilder: (context, {required bool interactive}) => Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Search products',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            width: 320,
          ),
        ]),
      ),
    ],
  );
}
