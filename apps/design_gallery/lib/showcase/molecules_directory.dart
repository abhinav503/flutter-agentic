import 'package:core/core/ui/atoms/button.dart';
import 'package:core/core/ui/molecules/bottom_sheet.dart';
import 'package:core/core/ui/molecules/dialog.dart';
import 'package:core/core/ui/molecules/empty_state.dart';
import 'package:core/core/ui/molecules/error_view.dart';
import 'package:core/core/ui/molecules/icon_info_row.dart';
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
                  subtitle: r'$4.99',
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
