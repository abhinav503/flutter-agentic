import 'package:core/core/ui/atoms/button.dart';
import 'package:core/core/ui/molecules/bottom_sheet.dart';
import 'package:core/core/ui/molecules/empty_state.dart';
import 'package:core/core/ui/molecules/error_view.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import 'showcase_layouts.dart';

WidgetbookCategory moleculesCategory() {
  return WidgetbookCategory(
    name: 'Molecules',
    children: [
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
    ],
  );
}
