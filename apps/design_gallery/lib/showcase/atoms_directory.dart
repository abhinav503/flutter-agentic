import 'package:core/core/ui/atoms/badge.dart';
import 'package:core/core/ui/atoms/button.dart';
import 'package:core/core/ui/atoms/checkbox.dart';
import 'package:core/core/ui/atoms/chip.dart';
import 'package:core/core/ui/atoms/common_glass_surface.dart';
import 'package:core/core/ui/atoms/device_frame.dart';
import 'package:core/core/ui/atoms/dropdown_menu.dart';
import 'package:core/core/ui/atoms/glass_surface.dart';
import 'package:core/core/ui/atoms/icon_button.dart';
import 'package:core/core/ui/atoms/loading_dots.dart';
import 'package:core/core/ui/atoms/loading_indicator.dart';
import 'package:core/core/ui/atoms/network_image.dart';
import 'package:core/core/ui/atoms/page_indicator.dart';
import 'package:core/core/ui/atoms/svg_image.dart';
import 'package:core/core/ui/atoms/text_field.dart';
import 'package:core/core/ui/atoms/top_bar.dart';
import 'package:core/core/theme/app_colors_extension.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import 'showcase_layouts.dart';

WidgetbookCategory atomsCategory() {
  return WidgetbookCategory(
    name: 'Atoms',
    children: [
      allVariants(
        'AppButton',
        (context) => showcase(context, [
          Variant('Primary', AppButton(label: 'Continue', onTap: () {})),
          Variant(
            'Secondary',
            AppButton(
              label: 'Cancel',
              variant: AppButtonVariant.secondary,
              onTap: () {},
            ),
          ),
          Variant(
            'Text',
            AppButton(
              label: 'Skip',
              variant: AppButtonVariant.text,
              onTap: () {},
            ),
          ),
          Variant(
            'Loading',
            AppButton(
              label: 'Saving',
              state: AppButtonState.loading,
              onTap: () {},
            ),
          ),
          const Variant(
            'Disabled',
            AppButton(label: 'Disabled', state: AppButtonState.disabled),
          ),
          Variant(
            'With trailing action',
            SizedBox(
              width: 200,
              child: AppButton(
                label: 'Add To Cart',
                onTap: () {},
                size: AppButtonSize.small,
                fullWidth: true,
                height: 40,
                trailingAction: AppIconButton(
                  icon: Icons.shopping_bag_outlined,
                  variant: AppIconButtonVariant.glass,
                  containerSize: 32,
                  iconSize: 16,
                  glassHighlightThickness: 2,
                  glassBlurSigma: 4,
                  onTap: () {},
                ),
              ),
            ),
          ),
        ]),
      ),
      allVariants(
        'AppBadge',
        (context) => showcase(context, [
          for (final intent in AppBadgeIntent.values)
            Variant(intent.name, AppBadge(text: intent.name, intent: intent)),
          Variant(
            'Custom colors',
            Builder(
              builder: (context) {
                final cs = Theme.of(context).colorScheme;
                return AppBadge(
                  text: '300 g',
                  backgroundColor: cs.primary.withValues(alpha: 0.1),
                  textStyle: TextStyle(color: cs.primary),
                );
              },
            ),
          ),
        ]),
      ),
      allVariants(
        'AppChip',
        (context) => showcase(context, [
          Variant('Unselected', AppChip(label: 'Flutter', onTap: () {})),
          Variant(
            'Selected',
            AppChip(label: 'Flutter', selected: true, onTap: () {}),
          ),
          Variant(
            'Selector (no check icon)',
            AppChip(
              label: 'M',
              selected: true,
              onTap: () {},
              showCheckIcon: false,
              borderColor: const Color(0xFFDFDFDF),
              selectedBorderColor: Colors.transparent,
              backgroundColor: Colors.transparent,
            ),
          ),
        ]),
      ),
      allVariants(
        'AppCheckbox',
        (context) => showcase(context, const [
          Variant('Unchecked', AppCheckbox(value: false)),
          Variant('Checked', AppCheckbox(value: true)),
          Variant(
            'Square',
            AppCheckbox(value: true, shape: AppCheckboxShape.square),
          ),
        ]),
      ),
      allVariants(
        'AppDropdownMenu',
        (context) => showcase(context, [
          Variant(
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
      allVariants(
        'DeviceFrame',
        (context) => showcase(context, [
          Variant(
            'Default',
            SizedBox(
              width: 200,
              height: 420,
              child: DeviceFrame(child: placeholderImage(context)),
            ),
          ),
        ]),
      ),
      allVariants(
        'AppIconButton',
        (context) => showcase(context, [
          Variant(
            'Filled',
            AppIconButton(icon: Icons.arrow_back, onTap: () {}),
          ),
          Variant(
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
          Variant(
            'Glass (on image)',
            SizedBox(
              width: 120,
              height: 120,
              child: Stack(
                children: [
                  Positioned.fill(child: placeholderImage(context)),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: AppIconButton(
                      icon: Icons.favorite_border,
                      variant: AppIconButtonVariant.glass,
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
          Variant(
            'Glass (on primary)',
            ColoredBox(
              color: Theme.of(context).colorScheme.primary,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: AppIconButton(
                  icon: Icons.notifications_outlined,
                  variant: AppIconButtonVariant.glass,
                  onTap: () {},
                ),
              ),
            ),
          ),
          Variant(
            'Glass (small, on primary)',
            // Smaller containerSize needs proportionally thinner highlight
            // + blur — the 40px defaults would overpower/wash out a 32px disc.
            ColoredBox(
              color: Theme.of(context).colorScheme.primary,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: AppIconButton(
                  icon: Icons.shopping_bag_outlined,
                  variant: AppIconButtonVariant.glass,
                  containerSize: 32,
                  iconSize: 16,
                  glassHighlightThickness: 2,
                  glassBlurSigma: 4,
                  onTap: () {},
                ),
              ),
            ),
          ),
        ]),
      ),
      allVariants(
        'AppGlassSurface',
        (context) => showcase(context, [
          Variant(
            'On primary',
            ColoredBox(
              color: Theme.of(context).colorScheme.primary,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: AppGlassSurface(
                  size: 48,
                  tintColor: Theme.of(context).colorScheme.onPrimary,
                  child: Icon(
                    Icons.star_border,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ),
          Variant(
            'On image',
            SizedBox(
              width: 120,
              height: 120,
              child: Stack(
                children: [
                  Positioned.fill(child: placeholderImage(context)),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: AppGlassSurface(
                      size: 48,
                      tintColor: Colors.white,
                      child: const Icon(Icons.star_border, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
      allVariants(
        'CommonGlassSurface',
        (context) => showcase(context, [
          Variant(
            'On primary (search field)',
            Builder(
              builder: (context) {
                final cs = Theme.of(context).colorScheme;
                // `onOverlay` (not `cs.onPrimary`): this field sits on a
                // glass tint over the primary header, which stays visually
                // consistent across themes — `onPrimary` would flip dark in
                // dark mode and wash the icon/text/cursor out.
                final onOverlay = Theme.of(
                  context,
                ).extension<AppColorsExtension>()!.onOverlay;
                return ColoredBox(
                  color: cs.primary,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: CommonGlassSurface(
                      borderRadius: BorderRadius.circular(999),
                      tintColor: cs.surfaceContainerHighest,
                      child: AppTextField(
                        controller: TextEditingController(),
                        hint: 'Search',
                        hintColor: onOverlay,
                        textColor: onOverlay,
                        cursorColor: onOverlay,
                        dense: true,
                        showBorder: false,
                        prefix: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Icon(Icons.search, size: 18, color: onOverlay),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Variant(
            'On image',
            SizedBox(
              width: 160,
              height: 60,
              child: Stack(
                children: [
                  Positioned.fill(child: placeholderImage(context)),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: CommonGlassSurface(
                      borderRadius: BorderRadius.circular(12),
                      tintColor: Colors.white,
                      child: const Center(
                        child: Text(
                          'Glass',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
      allVariants(
        'AppNetworkImage',
        (context) => showcase(context, [
          Variant(
            'Default',
            AppNetworkImage.placeholder(
              seed: 'widgetbook-network-image',
              width: 160,
              height: 160,
            ),
          ),
        ]),
      ),
      allVariants(
        'AppSvgImage',
        (context) => showcase(context, [
          Variant(
            'Default',
            const AppSvgImage.asset(
              'assets/icons/check_circle.svg',
              width: 32,
              height: 32,
            ),
          ),
          Variant(
            'Tinted (on primary)',
            ColoredBox(
              color: Theme.of(context).colorScheme.primary,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: AppSvgImage.asset(
                  'assets/icons/check_circle.svg',
                  width: 32,
                  height: 32,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ),
          Variant(
            'Error (missing asset)',
            const AppSvgImage.asset(
              'assets/icons/does_not_exist.svg',
              width: 32,
              height: 32,
            ),
          ),
        ]),
      ),
      allVariants(
        'PageIndicator',
        (context) => showcase(context, [
          Variant(
            'Page 1 of 3',
            const PageIndicator(count: 3, currentIndex: 0),
          ),
          Variant(
            'Page 2 of 3',
            const PageIndicator(count: 3, currentIndex: 1),
          ),
          Variant(
            'Page 3 of 3',
            const PageIndicator(count: 3, currentIndex: 2),
          ),
          Variant(
            'Vertical',
            const PageIndicator(count: 3, currentIndex: 1, axis: Axis.vertical),
          ),
        ]),
      ),
      allVariants(
        'AppTextField',
        (context) => showcase(context, [
          Variant(
            'Idle',
            AppTextField(
              controller: TextEditingController(),
              label: 'Email',
              hint: 'you@example.com',
            ),
            width: 260,
          ),
          Variant(
            'Error',
            AppTextField(
              controller: TextEditingController(),
              label: 'Email',
              state: AppTextFieldState.error,
              errorText: 'Invalid email address',
            ),
            width: 260,
          ),
          Variant(
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
      allVariants(
        'AppTopBar',
        (context) => showcaseStacked(context, [
          Variant(
            'Primary',
            SizedBox(
              height: kToolbarHeight,
              child: AppTopBar.primary(title: 'Home'),
            ),
          ),
          Variant(
            'Secondary',
            SizedBox(
              height: kToolbarHeight,
              child: AppTopBar.secondary(title: 'Settings'),
            ),
          ),
        ]),
      ),
      allVariants(
        'LoadingIndicator',
        (context) => showcase(context, const [
          Variant('Default', SizedBox(height: 120, child: LoadingIndicator())),
        ]),
      ),
      allVariants(
        'LoadingDots',
        (context) =>
            showcase(context, const [Variant('Default', LoadingDots())]),
      ),
    ],
  );
}
