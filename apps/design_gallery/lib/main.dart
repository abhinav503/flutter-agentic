import 'package:core/core/theme/app_theme.dart';
import 'package:core/core/theme/app_theme_config.dart';
import 'package:core/core/theme/app_theme_presets.dart';
import 'package:core/core/ui/atoms/badge.dart';
import 'package:core/core/ui/atoms/button.dart';
import 'package:core/core/ui/atoms/checkbox.dart';
import 'package:core/core/ui/atoms/chip.dart';
import 'package:core/core/ui/atoms/device_frame.dart';
import 'package:core/core/ui/atoms/dropdown_menu.dart';
import 'package:core/core/ui/atoms/icon_button.dart';
import 'package:core/core/ui/atoms/loading_dots.dart';
import 'package:core/core/ui/atoms/loading_indicator.dart';
import 'package:core/core/ui/atoms/network_image.dart';
import 'package:core/core/ui/atoms/page_indicator.dart';
import 'package:core/core/ui/atoms/text_field.dart';
import 'package:core/core/ui/atoms/top_bar.dart';
import 'package:core/core/ui/blocks/bottom_nav_bar.dart';
import 'package:core/core/ui/blocks/ecommerce/category_tile.dart';
import 'package:core/core/ui/blocks/ecommerce/product_card.dart';
import 'package:core/core/ui/blocks/quantity_stepper.dart';
import 'package:core/core/ui/blocks/section_header.dart';
import 'package:core/core/ui/molecules/empty_state.dart';
import 'package:core/core/ui/molecules/error_view.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

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
      directories: _directories,
      addons: [
        MaterialThemeAddon(themes: _presetThemes()),
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

/// One [WidgetbookTheme] per preset × brightness, built the same way an app's
/// `theme_config.json` would (`activeTheme` → [AppThemeConfig.fromJson] →
/// [AppTheme.fromConfig]) — so this is exactly what shipping apps render.
List<WidgetbookTheme<ThemeData>> _presetThemes() {
  return [
    for (final presetName in kThemePresets.keys) ...[
      WidgetbookTheme(
        name: '$presetName · Light',
        data: AppTheme.fromConfig(
          AppThemeConfig.fromJson({'activeTheme': presetName}),
        ),
      ),
      WidgetbookTheme(
        name: '$presetName · Dark',
        data: AppTheme.fromConfig(
          AppThemeConfig.fromJson({'activeTheme': presetName}),
          dark: true,
        ),
      ),
    ],
  ];
}

Widget _placeholderImage(BuildContext context, {IconData icon = Icons.image}) {
  final cs = Theme.of(context).colorScheme;
  return ColoredBox(
    color: cs.surfaceContainerHighest,
    child: Icon(icon, color: cs.onSurfaceVariant),
  );
}

/// A single labelled variant shown inside a showcase page.
class _Variant {
  const _Variant(this.label, this.child, {this.width});
  final String label;
  final Widget child;
  final double? width;
}

/// One use case, all variants: each [_Variant] with its label underneath,
/// flowing left-to-right and wrapping as needed.
Widget _showcase(BuildContext context, List<_Variant> variants) {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(24),
    child: Wrap(
      spacing: 24,
      runSpacing: 24,
      children: [
        for (final variant in variants)
          SizedBox(
            width: variant.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(child: variant.child),
                const SizedBox(height: 8),
                Text(
                  variant.label,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
          ),
      ],
    ),
  );
}

/// Like [_showcase], but stacks full-width variants (Scaffold/AppBar/nav
/// bar previews) top-to-bottom, full-bleed (no side padding), so they keep
/// the same width they'd have in a real app instead of overflowing.
Widget _showcaseStacked(BuildContext context, List<_Variant> variants) {
  return SingleChildScrollView(
    padding: const EdgeInsets.symmetric(vertical: 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final variant in variants) ...[
          variant.child,
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              variant.label,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ],
    ),
  );
}

WidgetbookComponent _allVariants(
  String name,
  Widget Function(BuildContext) builder,
) {
  return WidgetbookComponent(
    name: name,
    useCases: [WidgetbookUseCase(name: 'All variants', builder: builder)],
  );
}

final _directories = <WidgetbookNode>[
  WidgetbookCategory(
    name: 'Atoms',
    children: [
      _allVariants(
        'AppButton',
        (context) => _showcase(context, [
          _Variant('Primary', AppButton(label: 'Continue', onTap: () {})),
          _Variant(
            'Secondary',
            AppButton(
              label: 'Cancel',
              variant: AppButtonVariant.secondary,
              onTap: () {},
            ),
          ),
          _Variant(
            'Text',
            AppButton(
              label: 'Skip',
              variant: AppButtonVariant.text,
              onTap: () {},
            ),
          ),
          _Variant(
            'Loading',
            AppButton(
              label: 'Saving',
              state: AppButtonState.loading,
              onTap: () {},
            ),
          ),
          const _Variant(
            'Disabled',
            AppButton(label: 'Disabled', state: AppButtonState.disabled),
          ),
        ]),
      ),
      _allVariants(
        'AppBadge',
        (context) => _showcase(context, [
          for (final intent in AppBadgeIntent.values)
            _Variant(intent.name, AppBadge(text: intent.name, intent: intent)),
        ]),
      ),
      _allVariants(
        'AppChip',
        (context) => _showcase(context, [
          _Variant('Unselected', AppChip(label: 'Flutter', onTap: () {})),
          _Variant(
            'Selected',
            AppChip(label: 'Flutter', selected: true, onTap: () {}),
          ),
        ]),
      ),
      _allVariants(
        'AppCheckbox',
        (context) => _showcase(context, const [
          _Variant('Unchecked', AppCheckbox(value: false)),
          _Variant('Checked', AppCheckbox(value: true)),
          _Variant(
            'Square',
            AppCheckbox(value: true, shape: AppCheckboxShape.square),
          ),
        ]),
      ),
      _allVariants(
        'AppDropdownMenu',
        (context) => _showcase(context, [
          _Variant(
            'Default',
            AppDropdownMenu<int>(
              value: 0,
              trigger: const Icon(Icons.more_vert),
              onSelected: (_) {},
              items: const [
                AppDropdownItem(value: 0, label: 'Edit', icon: Icons.edit),
                AppDropdownItem(value: 1, label: 'Delete', icon: Icons.delete),
              ],
            ),
          ),
        ]),
      ),
      _allVariants(
        'DeviceFrame',
        (context) => _showcase(context, [
          _Variant(
            'Default',
            SizedBox(
              width: 200,
              height: 420,
              child: DeviceFrame(child: _placeholderImage(context)),
            ),
          ),
        ]),
      ),
      _allVariants(
        'AppIconButton',
        (context) => _showcase(context, [
          _Variant(
            'Filled',
            AppIconButton(icon: Icons.arrow_back, onTap: () {}),
          ),
          _Variant(
            'Translucent (on primary)',
            ColoredBox(
              color: Theme.of(context).colorScheme.primary,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: AppIconButton(
                  icon: Icons.favorite_border,
                  variant: AppIconButtonVariant.translucent,
                  onTap: () {},
                ),
              ),
            ),
          ),
        ]),
      ),
      _allVariants(
        'AppNetworkImage',
        (context) => _showcase(context, [
          _Variant(
            'Default',
            AppNetworkImage.placeholder(
              seed: 'widgetbook-network-image',
              width: 160,
              height: 160,
            ),
          ),
        ]),
      ),
      _allVariants(
        'PageIndicator',
        (context) => _showcase(context, [
          _Variant('Page 1 of 3', const PageIndicator(count: 3, currentIndex: 0)),
          _Variant('Page 2 of 3', const PageIndicator(count: 3, currentIndex: 1)),
          _Variant('Page 3 of 3', const PageIndicator(count: 3, currentIndex: 2)),
        ]),
      ),
      _allVariants(
        'AppTextField',
        (context) => _showcase(context, [
          _Variant(
            'Idle',
            AppTextField(
              controller: TextEditingController(),
              label: 'Email',
              hint: 'you@example.com',
            ),
            width: 260,
          ),
          _Variant(
            'Error',
            AppTextField(
              controller: TextEditingController(),
              label: 'Email',
              state: AppTextFieldState.error,
              errorText: 'Invalid email address',
            ),
            width: 260,
          ),
          _Variant(
            'Disabled',
            AppTextField(
              controller: TextEditingController(text: 'Locked value'),
              label: 'Email',
              state: AppTextFieldState.disabled,
            ),
            width: 260,
          ),
        ]),
      ),
      _allVariants(
        'AppTopBar',
        (context) => _showcaseStacked(context, [
          _Variant(
            'Primary',
            SizedBox(
              height: kToolbarHeight,
              child: AppTopBar.primary(title: 'Home'),
            ),
          ),
          _Variant(
            'Secondary',
            SizedBox(
              height: kToolbarHeight,
              child: AppTopBar.secondary(title: 'Settings'),
            ),
          ),
        ]),
      ),
      _allVariants(
        'LoadingIndicator',
        (context) => _showcase(context, const [
          _Variant('Default', SizedBox(height: 120, child: LoadingIndicator())),
        ]),
      ),
      _allVariants(
        'LoadingDots',
        (context) => _showcase(context, const [
          _Variant('Default', LoadingDots()),
        ]),
      ),
    ],
  ),
  WidgetbookCategory(
    name: 'Molecules',
    children: [
      _allVariants(
        'EmptyState',
        (context) => _showcase(context, [
          _Variant(
            'Default',
            EmptyState(
              iconData: Icons.inbox_outlined,
              title: 'No orders yet',
              subtitle: 'Items you order will show up here.',
              actions: [AppButton(label: 'Start shopping', onTap: () {})],
            ),
            width: 320,
          ),
        ]),
      ),
      _allVariants(
        'ErrorView',
        (context) => _showcase(context, [
          _Variant(
            'Default',
            ErrorView(
              message: 'Something went wrong. Please try again.',
              onRetry: () {},
            ),
            width: 320,
          ),
        ]),
      ),
    ],
  ),
  WidgetbookCategory(
    name: 'Blocks',
    children: [
      WidgetbookFolder(
        name: 'Generic',
        children: [
          _allVariants(
            'SectionHeader',
            (context) => _showcase(context, [
              _Variant(
                'Default',
                SectionHeader(
                  title: 'Fresh Vegetables',
                  actionLabel: 'See All',
                  onAction: () {},
                ),
                width: 320,
              ),
            ]),
          ),
          _allVariants(
            'QuantityStepper',
            (context) => _showcase(context, [
              _Variant(
                'Default',
                QuantityStepper(value: 2, onIncrement: () {}, onDecrement: () {}),
              ),
              _Variant(
                'At minimum',
                QuantityStepper(value: 1, onIncrement: () {}),
              ),
            ]),
          ),
          _allVariants(
            'BottomNavBar',
            (context) => _showcaseStacked(context, [
              _Variant(
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
              _Variant(
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
      ),
      WidgetbookFolder(
        name: 'Ecommerce',
        children: [
          _allVariants(
            'ProductCard',
            (context) => _showcase(context, [
              _Variant(
                'Default',
                ProductCard(
                  image: _placeholderImage(context),
                  title: 'Washington Red Apple',
                  badgeLabel: '300 g',
                  meta: const [
                    ProductCardMeta(icon: Icons.bolt, label: '10 Min'),
                  ],
                  price: '\$6.30',
                  originalPrice: '\$8.00',
                  actionLabel: 'Add To Cart',
                  onAction: () {},
                ),
                width: 180,
              ),
            ]),
          ),
          _allVariants(
            'CategoryTile',
            (context) => _showcase(context, [
              _Variant(
                'Default',
                CategoryTile(
                  image: _placeholderImage(context, icon: Icons.eco_outlined),
                  label: 'Vegetables',
                  onTap: () {},
                ),
              ),
            ]),
          ),
        ],
      ),
    ],
  ),
];
