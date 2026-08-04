import 'package:core/core/ui/atoms/badge.dart';
import 'package:core/core/ui/atoms/bottom_fade.dart';
import 'package:core/core/ui/atoms/button.dart';
import 'package:core/core/ui/atoms/checkbox.dart';
import 'package:core/core/ui/atoms/chip.dart';
import 'package:core/core/ui/atoms/common_glass_surface.dart';
import 'package:core/core/ui/atoms/concentric_circles.dart';
import 'package:core/core/ui/atoms/device_frame.dart';
import 'package:core/core/ui/atoms/dropdown_menu.dart';
import 'package:core/core/ui/atoms/glass_chip.dart';
import 'package:core/core/ui/atoms/glass_surface.dart';
import 'package:core/core/ui/atoms/app_switcher.dart';
import 'package:core/core/ui/atoms/icon_button.dart';
import 'package:core/core/ui/atoms/icon_circle.dart';
import 'package:core/core/ui/atoms/inline_text_link.dart';
import 'package:core/core/ui/atoms/labeled_divider.dart';
import 'package:core/core/ui/atoms/loading_dots.dart';
import 'package:core/core/ui/atoms/loading_indicator.dart';
import 'package:core/core/ui/atoms/network_image.dart';
import 'package:core/core/ui/atoms/page_indicator.dart';
import 'package:core/core/ui/atoms/radio_dot.dart';
import 'package:core/core/ui/atoms/shimmer_box.dart';
import 'package:core/core/ui/atoms/surface_card.dart';
import 'package:core/core/ui/atoms/svg_image.dart';
import 'package:core/core/ui/atoms/switch.dart';
import 'package:core/core/ui/atoms/text_field.dart';
import 'package:core/core/ui/atoms/theme_mode_toggle.dart';
import 'package:core/core/ui/atoms/top_bar.dart';
import 'package:core/core/theme/app_colors_extension.dart';
import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_shadows_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
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
            'Gradient (primary only)',
            AppButton(
              label: 'Proceed To Checkout',
              onTap: () {},
              size: AppButtonSize.large,
              fullWidth: true,
              height: 50,
              borderRadius: AppRadius.full,
              // A pack whose affirmative controls are all one brand gradient
              // passes it here rather than forking the atom — a ColorScheme
              // role can only hold a single colour (see `grofast`).
              gradient: const LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [Color(0xFF26AD71), Color(0xFF32CB4B)],
              ),
            ),
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
          Variant(
            'Tonal fill (backgroundColor override)',
            Builder(
              builder: (context) {
                final cs = Theme.of(context).colorScheme;
                return AppButton(
                  label: 'Remove',
                  backgroundColor: context.appColors.tintedErrorFill,
                  foregroundColor: cs.error,
                  onTap: () {},
                );
              },
            ),
          ),
          Variant(
            'Brand outline + fixed height (borderColor, height)',
            Builder(
              builder: (context) => AppButton(
                label: 'Add',
                variant: AppButtonVariant.secondary,
                borderColor: Theme.of(context).colorScheme.primary,
                height: 40,
                onTap: () {},
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
        'AppConcentricCircles',
        (context) => showcase(context, [
          Variant(
            'Success icon (3 rings, staggered reveal — e.g. gravia\'s Order '
            'Placed sheet)',
            Builder(
              builder: (context) {
                final cs = Theme.of(context).colorScheme;
                return AppConcentricCircles(
                  radii: const [128, 96, 64],
                  colors: [
                    cs.primary.withValues(alpha: 0.1),
                    cs.primary.withValues(alpha: 0.1),
                    cs.primary,
                  ],
                  child: Icon(Icons.check, color: cs.onPrimary, size: 28),
                );
              },
            ),
          ),
          Variant(
            'Static (animate: false)',
            Builder(
              builder: (context) {
                final cs = Theme.of(context).colorScheme;
                return AppConcentricCircles(
                  animate: false,
                  radii: const [96, 72, 48],
                  colors: [
                    cs.secondary.withValues(alpha: 0.15),
                    cs.secondary.withValues(alpha: 0.15),
                    cs.secondary,
                  ],
                  child: Icon(Icons.star, color: cs.onSecondary, size: 22),
                );
              },
            ),
          ),
          Variant(
            'Status recipe (.status factory)',
            Builder(
              builder: (context) {
                final cs = Theme.of(context).colorScheme;
                return AppConcentricCircles.status(
                  color: cs.primary,
                  child: Icon(Icons.check, color: cs.onPrimary, size: 28),
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
          Variant(
            'Pinned radius + fixed height + padding + selectedLabelStyle',
            Builder(
              builder: (context) => AppChip(
                label: 'Delivered',
                selected: true,
                onTap: () {},
                showCheckIcon: false,
                borderRadius: AppRadius.sm,
                height: 32,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                selectedLabelStyle: Theme.of(context).textTheme.labelMedium!
                    .copyWith(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ]),
      ),
      allVariants(
        'AppSurfaceCard',
        (context) => showcase(context, [
          Variant(
            'Flat (padding + child)',
            Builder(
              builder: (context) => AppSurfaceCard(
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: const Text('Flat card content'),
              ),
            ),
            width: 220,
          ),
          Variant(
            'Tappable (shadows: appShadows.card + borderColor)',
            Builder(
              builder: (context) => AppSurfaceCard(
                onTap: () {},
                shadows: context.appShadows.card,
                borderColor: Theme.of(context).colorScheme.outlineVariant,
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: const Text('Tappable card'),
              ),
            ),
            width: 220,
          ),
          Variant(
            'Custom radius',
            Builder(
              builder: (context) => AppSurfaceCard(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: AppRadius.xl,
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: const Text('Custom radius'),
              ),
            ),
            width: 220,
          ),
        ]),
      ),
      allVariants(
        'BottomFade',
        (context) => showcase(context, [
          Variant(
            'Default (floating-CTA fade)',
            _bottomFadeDemo(context, const BottomFade()),
            width: 240,
          ),
          Variant(
            'Full-height fade (solidUntil: 0 — over a docked bar)',
            _bottomFadeDemo(context, const BottomFade(solidUntil: 0)),
            width: 240,
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
          Variant(
            'Radio (no check icon)',
            AppCheckbox(value: true, showCheckIcon: false),
          ),
        ]),
      ),
      allVariants(
        'AppSwitch',
        (context) => showcase(context, [
          Variant('Off', AppSwitch(value: false, onChanged: (_) {})),
          Variant('On', AppSwitch(value: true, onChanged: (_) {})),
          Variant(
            'Custom inactive track (e.g. gravia)',
            AppSwitch(
              value: false,
              onChanged: (_) {},
              inactiveTrackColor: const Color(0xFFDFDFDF),
            ),
          ),
        ]),
      ),
      allVariants(
        'AppRadioDot',
        (context) => showcase(context, const [
          Variant('Unselected', AppRadioDot(selected: false)),
          Variant('Selected', AppRadioDot(selected: true)),
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
        'AppSwitcher',
        (context) => showcase(context, [
          Variant(
            'Fade between children',
            const _AppSwitcherDemo(),
            width: 320,
          ),
        ]),
      ),
      allVariants(
        'AppIconCircle',
        (context) => showcase(context, [
          Variant(
            'Decorative disc',
            Builder(
              builder: (context) {
                final cs = Theme.of(context).colorScheme;
                return AppIconCircle(
                  size: 44,
                  color: cs.surfaceContainerHighest,
                  child: Icon(Icons.percent_rounded, color: cs.primary),
                );
              },
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
            'Neutral fill (colour overrides)',
            Builder(
              builder: (context) => AppIconButton(
                icon: Icons.arrow_back_rounded,
                containerSize: 48,
                iconSize: 24,
                backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
                foregroundColor: Theme.of(context).colorScheme.onSurface,
                onTap: () {},
              ),
            ),
          ),
          Variant(
            'Outlined (borderColor, no fill)',
            Builder(
              builder: (context) => AppIconButton(
                icon: Icons.notifications_none_rounded,
                containerSize: 52,
                iconSize: 24,
                backgroundColor: Colors.transparent,
                foregroundColor: Theme.of(context).colorScheme.onSurface,
                borderColor: Theme.of(context).colorScheme.outline,
                onTap: () {},
              ),
            ),
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
          Variant(
            'Rounded-rect (borderRadius + size 60×40)',
            Builder(
              builder: (context) => AppIconButton(
                icon: Icons.arrow_back_rounded,
                backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
                foregroundColor: Theme.of(context).colorScheme.onSurface,
                borderRadius: AppRadius.md,
                size: const Size(60, 40),
                onTap: () {},
              ),
            ),
          ),
          Variant(
            'Gradient + dot (gradient, dotColor)',
            Builder(
              builder: (context) {
                final cs = Theme.of(context).colorScheme;
                return AppIconButton(
                  icon: Icons.shopping_bag_outlined,
                  containerSize: 48,
                  iconSize: 22,
                  gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [cs.primary, cs.tertiary],
                  ),
                  dotColor: cs.error,
                  onTap: () {},
                );
              },
            ),
          ),
        ]),
      ),
      allVariants(
        'AppGlassChip',
        (context) => showcase(context, [
          Variant(
            'On primary',
            ColoredBox(
              color: Theme.of(context).colorScheme.primary,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: AppGlassChip(
                  leading: const Icon(Icons.swap_vert),
                  label: 'Sort',
                  trailing: const Icon(Icons.keyboard_arrow_down),
                  onTap: () {},
                ),
              ),
            ),
          ),
          Variant(
            'Fixed height (e.g. matching a nearby text field)',
            ColoredBox(
              color: Theme.of(context).colorScheme.primary,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: AppGlassChip(
                  leading: const Icon(Icons.swap_vert),
                  label: 'Sort',
                  trailing: const Icon(Icons.keyboard_arrow_down),
                  onTap: () {},
                  height: 45,
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
          const Variant(
            'SVG url (renders as vector)',
            AppNetworkImage(
              url:
                  'https://cdn.jsdelivr.net/npm/simple-icons@13/icons/flutter.svg',
              width: 160,
              height: 160,
              fit: BoxFit.contain,
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
        'AppLabeledDivider',
        (context) => showcase(context, [
          const Variant('Default', AppLabeledDivider(label: 'Or Login with')),
        ]),
      ),
      allVariants(
        'AppInlineTextLink',
        (context) => showcase(context, [
          Variant(
            'Default',
            AppInlineTextLink(
              text: "Don't have an account? ",
              linkText: 'Signup',
              onTap: () {},
            ),
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
          Variant(
            'Filled (fillColor + showBorder false) + hintStyle',
            Builder(
              builder: (context) => AppTextField(
                controller: TextEditingController(),
                label: 'Email',
                hint: 'you@example.com',
                fillColor: context.appColors.fieldFill,
                showBorder: false,
                hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
              ),
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
      allVariants(
        'ShimmerBox',
        (context) => showcase(context, [
          const Variant(
            'Rounded rect (e.g. a product card)',
            ShimmerBox(width: 160, height: 100),
          ),
          const Variant(
            'Circle (e.g. a category tile)',
            ShimmerBox.circle(size: 64),
          ),
          const Variant(
            'Card silhouette (ShimmerBox.card — theme card radius)',
            ShimmerBox.card(height: 120),
            width: 160,
          ),
          Variant(
            'Composed skeleton row (category rail)',
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                3,
                (i) => Padding(
                  padding: EdgeInsets.only(left: i == 0 ? 0 : 16),
                  child: const Column(
                    children: [
                      ShimmerBox.circle(size: 64),
                      SizedBox(height: 8),
                      ShimmerBox(width: 48, height: 12),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
      allVariants(
        'ThemeModeToggle',
        (context) => showcase(context, [
          Variant(
            'System',
            ThemeModeToggle(mode: ThemeMode.system, onTap: () {}),
          ),
          Variant(
            'Light',
            ThemeModeToggle(mode: ThemeMode.light, onTap: () {}),
          ),
          Variant('Dark', ThemeModeToggle(mode: ThemeMode.dark, onTap: () {})),
        ]),
      ),
    ],
  );
}

/// A short scrollable stack with [fade] positioned across its bottom edge —
/// `BottomFade` is only the gradient, so the demo provides the Stack +
/// Positioned host a real screen would.
Widget _bottomFadeDemo(BuildContext context, Widget fade) {
  final cs = Theme.of(context).colorScheme;
  return SizedBox(
    height: 200,
    child: Stack(
      children: [
        Positioned.fill(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              for (var i = 0; i < 8; i++)
                Container(
                  height: 40,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  color: i.isEven ? cs.primaryContainer : cs.secondaryContainer,
                  child: Text('Scrolling content row $i'),
                ),
            ],
          ),
        ),
        Positioned(left: 0, right: 0, bottom: 0, child: fade),
      ],
    ),
  );
}

class _AppSwitcherDemo extends StatefulWidget {
  const _AppSwitcherDemo();

  @override
  State<_AppSwitcherDemo> createState() => _AppSwitcherDemoState();
}

class _AppSwitcherDemoState extends State<_AppSwitcherDemo> {
  bool _first = true;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppSwitcher(
          child: Container(
            key: ValueKey(_first),
            height: 64,
            alignment: Alignment.center,
            color: _first ? cs.primaryContainer : cs.tertiaryContainer,
            child: Text(_first ? 'First' : 'Second'),
          ),
        ),
        const SizedBox(height: 12),
        AppButton(label: 'Swap', onTap: () => setState(() => _first = !_first)),
      ],
    );
  }
}
