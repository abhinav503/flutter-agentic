import 'package:core/core/theme/app_colors_extension.dart';
import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/button.dart';
import 'package:core/core/ui/atoms/icon_button.dart';
import 'package:core/core/ui/blocks/action_pair.dart';
import 'package:core/core/ui/molecules/action_sheet_body.dart';
import 'package:core/core/ui/molecules/bottom_sheet.dart';
import 'package:core/core/ui/molecules/confirm_sheet_body.dart';
import 'package:core/core/ui/molecules/dialog.dart';
import 'package:core/core/ui/molecules/empty_state.dart';
import 'package:core/core/ui/molecules/error_view.dart';
import 'package:core/core/ui/molecules/icon_info_row.dart';
import 'package:core/core/ui/molecules/picker_field.dart';
import 'package:core/core/ui/molecules/skeleton_rows.dart';
import 'package:core/core/ui/molecules/menu_tile.dart';
import 'package:core/core/ui/molecules/radio_group.dart';
import 'package:core/core/ui/molecules/swipe_to_delete_row.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import 'showcase_layouts.dart';

WidgetbookCategory moleculesCategory() {
  return WidgetbookCategory(
    name: 'Molecules',
    children: [
      allVariants(
        'IconInfoRow',
        (context) => showcase(context, [
          Variant(
            'Notification-style',
            Builder(
              builder: (context) {
                final cs = Theme.of(context).colorScheme;
                return IconInfoRow(
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: cs.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Icon(Icons.percent_rounded, color: cs.primary),
                  ),
                  title: '30% Special Discount!',
                  subtitle: 'Special promotion only valid today',
                );
              },
            ),
            width: 320,
          ),
          Variant(
            'Tappable list row',
            Builder(
              builder: (context) {
                final cs = Theme.of(context).colorScheme;
                return IconInfoRow(
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Icon(Icons.image_outlined, color: cs.onSurfaceVariant),
                  ),
                  title: 'Fresh Avocado',
                  titleMaxLines: 1,
                  subtitle: '₹4.99',
                  trailing: Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
                  onTap: () {},
                );
              },
            ),
            width: 320,
          ),
        ]),
      ),
      allVariants(
        'SwipeToDeleteRow',
        (context) => showcase(context, [
          Variant(
            'Swipe left to reveal',
            Builder(
              builder: (context) {
                final cs = Theme.of(context).colorScheme;
                return SwipeToDeleteRow(
                  itemKey: 'demo-row',
                  onDelete: () {},
                  borderRadius: BorderRadius.circular(16),
                  icon: Icon(Icons.delete_outline, color: cs.error),
                  child: Container(
                    height: 72,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.centerLeft,
                    child: const Text('Fresh Avocado — swipe me left'),
                  ),
                );
              },
            ),
            width: 320,
          ),
        ]),
      ),
      allVariants(
        'ShimmerListRow',
        (context) => showcase(context, [
          Variant(
            'Single row',
            const ShimmerListRow(),
            width: 320,
          ),
          Variant(
            'List of 3',
            const ShimmerListRow(itemCount: 3),
            width: 320,
          ),
          Variant(
            'Trailing slot (trailingWidth: 48)',
            const ShimmerListRow(trailingWidth: 48),
            width: 320,
          ),
        ]),
      ),
      allVariants(
        'ShimmerSectionHeader',
        (context) => showcase(context, [
          Variant(
            'Title + action chip',
            const ShimmerSectionHeader(),
            width: 320,
          ),
        ]),
      ),
      allVariants(
        'ShimmerCircleTile',
        (context) => showcase(context, [
          Variant(
            'Category-tile silhouette',
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ShimmerCircleTile(),
                ShimmerCircleTile(labelWidth: 40),
                ShimmerCircleTile(),
              ],
            ),
            width: 320,
          ),
        ]),
      ),
      allVariants(
        'EmptyState',
        (context) => showcase(context, [
          Variant(
            'Default',
            EmptyState(
              iconData: Icons.inbox_outlined,
              title: 'No orders yet',
              subtitle: 'Items you order will show up here.',
              actions: [AppButton(label: 'Start shopping', onTap: () {})],
            ),
            width: 320,
          ),
          Variant(
            'Custom padding + iconColor + titleStyle',
            Builder(
              builder: (context) => EmptyState(
                iconData: Icons.favorite_border,
                iconColor: Theme.of(context).colorScheme.primary,
                title: 'No favourites yet',
                titleStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                subtitle: 'Tap the heart on a product to save it here.',
                padding: const EdgeInsets.all(AppSpacing.lg),
              ),
            ),
            width: 320,
          ),
        ]),
      ),
      allVariants(
        'ErrorView',
        (context) => showcase(context, [
          Variant(
            'Default',
            ErrorView(
              message: 'Something went wrong. Please try again.',
              onRetry: () {},
            ),
            width: 320,
          ),
          Variant(
            'Custom retryLabel + messageStyle',
            Builder(
              builder: (context) => ErrorView(
                message: 'We couldn\'t load your orders.',
                messageStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                retryLabel: 'Reload',
                onRetry: () {},
              ),
            ),
            width: 320,
          ),
        ]),
      ),
      allVariants(
        'AppBottomSheet',
        (context) => showcaseStacked(context, [
          Variant(
            'Default (icon close)',
            SizedBox(
              height: 260,
              child: AppBottomSheet(
                title: 'Filter',
                onClose: () {},
                actions: [
                  AppButton(
                    label: 'Cancel',
                    variant: AppButtonVariant.secondary,
                    fullWidth: true,
                    onTap: () {},
                  ),
                  AppButton(label: 'Apply', fullWidth: true, onTap: () {}),
                ],
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Body content goes here.'),
                ),
              ),
            ),
          ),
          Variant(
            // Every override a style pack can plug in — matches gravia's
            // Add to Cart sheet (docs/ai-rules/design.md's per-pack chrome).
            'Text close label + custom typography/colours (e.g. gravia)',
            Builder(
              builder: (context) {
                final cs = Theme.of(context).colorScheme;
                return SizedBox(
                  height: 260,
                  child: AppBottomSheet(
                    title: 'Add to Cart',
                    titleStyle: Theme.of(context).textTheme.titleLarge!
                        .copyWith(
                          fontWeight: FontWeight.w700,
                          height: 1.55,
                          letterSpacing: -0.36,
                        ),
                    onClose: () {},
                    closeLabel: 'Cancel',
                    closeLabelStyle: Theme.of(context).textTheme.bodyMedium!
                        .copyWith(
                          color: cs.primary,
                          height: 1.4,
                          letterSpacing: -0.28,
                        ),
                    dividerColor: cs.outlineVariant,
                    handleColor: cs.outlineVariant,
                    actions: [
                      AppButton(
                        label: 'Cancel',
                        variant: AppButtonVariant.secondary,
                        fullWidth: true,
                        onTap: () {},
                      ),
                      AppButton(
                        label: 'Add to Cart',
                        fullWidth: true,
                        onTap: () {},
                      ),
                    ],
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('Body content goes here.'),
                    ),
                  ),
                );
              },
            ),
          ),
          Variant(
            'Chromeless + handle (showHeader: false, showHandle: true)',
            SizedBox(
              height: 180,
              child: AppBottomSheet(
                showHeader: false,
                showHandle: true,
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Chromeless content — no title row or close control; the '
                    'content draws its own chrome (e.g. a ConfirmSheetBody).',
                  ),
                ),
              ),
            ),
          ),
          Variant(
            'Leading disc + centred title + custom handle (e.g. dailymart)',
            SizedBox(
              height: 220,
              child: Builder(
                builder: (context) {
                  final cs = Theme.of(context).colorScheme;
                  return AppBottomSheet(
                    title: 'Order List',
                    centerTitle: true,
                    leading: AppIconButton(
                      icon: Icons.close,
                      backgroundColor: cs.surfaceContainerHighest,
                      foregroundColor: cs.onSurface,
                      onTap: () {},
                    ),
                    // The leading disc is the close control — a trailing X
                    // too would read as two competing exits.
                    showCloseAction: false,
                    handleSize: const Size(64, 5),
                    headerHeight: 64,
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('Body content goes here.'),
                    ),
                  );
                },
              ),
            ),
          ),
          Variant(
            'Custom outline (shape — e.g. grofast\'s domed top edge)',
            SizedBox(
              height: 220,
              child: AppBottomSheet(
                // A pack whose sheets arch rather than round off passes its
                // own ShapeBorder; the container fills *and* clips to it, so
                // content must stay clear of whatever the shape cuts away —
                // here the handle sits below the arc's crown.
                shape: const _DomeSheetBorder(),
                showHeader: false,
                showHandle: true,
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(16, 32, 16, 16),
                  child: Text(
                    'Domed sheet — the top edge is an arc, not two corner '
                    'radii.',
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
      allVariants(
        'AppRadioGroup',
        (context) => showcase(context, [
          Variant(
            'Default',
            AppRadioGroup(
              options: const [
                'Newest first',
                'Price: low to high',
                'Price: high to low',
              ],
              labelOf: (option) => option,
              selected: 'Newest first',
              onSelected: (_) {},
            ),
            width: 320,
          ),
          Variant(
            'Long list (maxHeightFraction caps + scrolls, padding insets)',
            AppRadioGroup(
              options: [for (var i = 1; i <= 12; i++) 'Option $i'],
              labelOf: (option) => option,
              selected: 'Option 1',
              onSelected: (_) {},
              maxHeightFraction: 0.25,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            ),
            width: 320,
          ),
        ]),
      ),
      allVariants(
        'AppRadioRow',
        (context) => showcase(context, [
          Variant(
            'Selected',
            AppRadioRow(label: 'Last Week', selected: true, onTap: () {}),
            width: 320,
          ),
          Variant(
            'Unselected',
            AppRadioRow(label: 'Last Month', selected: false, onTap: () {}),
            width: 320,
          ),
        ]),
      ),
      allVariants(
        'AppMenuTile',
        (context) => showcase(context, [
          Variant(
            'Navigable (chevron)',
            AppMenuTile(
              iconBuilder: (color, size) =>
                  Icon(Icons.lock_outline, color: color, size: size),
              label: 'Change Password',
              onTap: () {},
            ),
            width: 320,
          ),
          Variant(
            'Custom trailing',
            AppMenuTile(
              iconBuilder: (color, size) =>
                  Icon(Icons.info_outline, color: color, size: size),
              label: 'App Version',
              trailing: Builder(
                builder: (context) => Text(
                  'v1.2.0',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            width: 320,
          ),
          Variant(
            'Danger',
            AppMenuTile(
              iconBuilder: (color, size) =>
                  Icon(Icons.logout, color: color, size: size),
              label: 'Logout',
              danger: true,
              onTap: () {},
            ),
            width: 320,
          ),
          Variant(
            'Strip (showIconCircle: false, height 52, border)',
            Builder(
              builder: (context) => AppMenuTile(
                iconBuilder: (color, size) =>
                    Icon(Icons.person_outline, color: color, size: size),
                label: 'My Profile',
                showIconCircle: false,
                height: 52,
                borderColor: Theme.of(context).colorScheme.outlineVariant,
                borderRadius: AppRadius.md,
                onTap: () {},
              ),
            ),
            width: 320,
          ),
        ]),
      ),
      allVariants(
        'AppPickerField',
        (context) => showcase(context, [
          Variant(
            'Outlined (default) with value',
            AppPickerField(label: 'City', value: 'Mumbai', onTap: () {}),
            width: 260,
          ),
          Variant(
            'Filled (fillColor, no border) with hint',
            Builder(
              builder: (context) => AppPickerField(
                label: 'Country',
                value: '',
                hint: 'Select country',
                fillColor: context.appColors.fieldFill,
                onTap: () {},
              ),
            ),
            width: 260,
          ),
          Variant(
            'Fixed height + custom trailing',
            Builder(
              builder: (context) => AppPickerField(
                label: 'Sort by',
                value: 'Newest first',
                height: 56,
                trailing: Icon(
                  Icons.tune,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onTap: () {},
              ),
            ),
            width: 260,
          ),
        ]),
      ),
      allVariants(
        'ConfirmSheetBody',
        (context) => showcase(context, [
          Variant(
            'Title + message + ActionPair actions',
            ConfirmSheetBody(
              title: 'Remove address?',
              message: 'This address will be deleted permanently.',
              actions: ActionPair(
                first: AppButton(
                  label: 'Cancel',
                  variant: AppButtonVariant.secondary,
                  fullWidth: true,
                  onTap: () {},
                ),
                second: AppButton(label: 'Remove', fullWidth: true, onTap: () {}),
              ),
            ),
            width: 320,
          ),
          Variant(
            'Message only (title: null)',
            ConfirmSheetBody(
              message: 'Are you sure you want to log out?',
              actions: AppButton(label: 'Log Out', fullWidth: true, onTap: () {}),
            ),
            width: 320,
          ),
        ]),
      ),
      allVariants(
        'AppActionSheetBody',
        // Each row pops the enclosing route with its value — rendered inline
        // here (a tap pops the showcase page); the layout is what's on show.
        (context) => showcase(context, [
          Variant(
            'Two actions',
            const AppActionSheetBody<int>(
              actions: [
                AppSheetAction(label: 'Take photo', value: 0),
                AppSheetAction(label: 'Choose from gallery', value: 1),
              ],
            ),
            width: 320,
          ),
          Variant(
            'With leading glyphs',
            Builder(
              builder: (context) {
                final cs = Theme.of(context).colorScheme;
                return AppActionSheetBody<int>(
                  actions: [
                    AppSheetAction(
                      label: 'Take photo',
                      value: 0,
                      leading: Icon(
                        Icons.photo_camera_outlined,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                    AppSheetAction(
                      label: 'Choose from gallery',
                      value: 1,
                      leading: Icon(
                        Icons.image_outlined,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                );
              },
            ),
            width: 320,
          ),
        ]),
      ),
      allVariants(
        'AppDialog',
        // AlertDialog paints its own scrim/positioning via showDialog, so
        // preview the static widget directly rather than opening it — a
        // showcase page isn't a Navigator push a real showDialog needs.
        (context) => showcase(context, [
          Variant(
            'Default',
            AppDialog(
              title: 'Delete address?',
              actions: [
                AppButton(
                  label: 'Cancel',
                  variant: AppButtonVariant.secondary,
                  onTap: () {},
                ),
                AppButton(label: 'Delete', onTap: () {}),
              ],
              child: const Text('This action can\'t be undone.'),
            ),
            width: 320,
          ),
        ]),
      ),
    ],
  );
}

/// A minimal stand-in for a pack's own sheet outline (grofast ships one), so
/// the showcase can demonstrate `AppBottomSheet.shape` without depending on
/// an app. The real thing arcs the handle into the same path; this only needs
/// to prove that a non-rounded top edge fills and clips correctly.
class _DomeSheetBorder extends ShapeBorder {
  const _DomeSheetBorder();

  /// How far the arc's crown climbs above its edges.
  static const double _rise = 18;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      getOuterPath(rect, textDirection: textDirection);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) => Path()
    ..moveTo(rect.left, rect.top + _rise)
    ..quadraticBezierTo(
      rect.center.dx,
      rect.top - _rise,
      rect.right,
      rect.top + _rise,
    )
    ..lineTo(rect.right, rect.bottom)
    ..lineTo(rect.left, rect.bottom)
    ..close();

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}
