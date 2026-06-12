import 'package:flutter/material.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';

/// Bottom sheet with an optional pinned header and a scrollable body.
///
/// Use [AppBottomSheet.show] to present it:
///
/// ```dart
/// AppBottomSheet.show(
///   context,
///   title: 'Filter',
///   child: FilterOptions(),
/// );
/// ```
class AppBottomSheet extends StatelessWidget {
  final Widget child;
  final String? title;
  final VoidCallback? onClose;
  final List<Widget>? actions;
  final bool isScrollable;
  final double maxHeightFraction;

  const AppBottomSheet({
    super.key,
    required this.child,
    this.title,
    this.onClose,
    this.actions,
    this.isScrollable = true,
    this.maxHeightFraction = 0.9,
  });

  static Future<T?> show<T>(
    BuildContext context, {
    required Widget child,
    String? title,
    VoidCallback? onClose,
    List<Widget>? actions,
    bool isScrollable = true,
    double maxHeightFraction = 0.9,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => AppBottomSheet(
        title: title,
        onClose: () {
          Navigator.of(sheetContext).pop();
          onClose?.call();
        },
        actions: actions,
        isScrollable: isScrollable,
        maxHeightFraction: maxHeightFraction,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * maxHeightFraction,
        ),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppRadius.xlValue)),
        ),
        child: CustomScrollView(
          shrinkWrap: true,
          physics: isScrollable
              ? const ClampingScrollPhysics()
              : const NeverScrollableScrollPhysics(),
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: _HeaderDelegate(
                title: title,
                onClose: onClose,
              ),
            ),
            SliverToBoxAdapter(child: child),
            if (actions != null && actions!.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Row(
                    children: [
                      for (int i = 0; i < actions!.length; i++) ...[
                        if (i > 0) const SizedBox(width: AppSpacing.base),
                        Expanded(child: actions![i]),
                      ],
                    ],
                  ),
                ),
              ),
            SliverToBoxAdapter(
              child: SizedBox(height: MediaQuery.paddingOf(context).bottom),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  final String? title;
  final VoidCallback? onClose;

  static const double _height = 56;

  _HeaderDelegate({this.title, this.onClose});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      elevation: overlapsContent ? 2 : 0,
      color: cs.surface,
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Row(
                children: [
                  Expanded(
                    child: title != null
                        ? Text(
                            title!,
                            style: Theme.of(context).textTheme.titleMedium,
                            overflow: TextOverflow.ellipsis,
                          )
                        : Center(
                            child: Container(
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                color: cs.onSurfaceVariant.withValues(alpha: 0.4),
                                borderRadius:
                                    BorderRadius.circular(AppRadius.smValue),
                              ),
                            ),
                          ),
                  ),
                  if (onClose != null)
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: onClose,
                      color: cs.onSurfaceVariant,
                    ),
                ],
              ),
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: overlapsContent
                ? Colors.transparent
                : cs.outlineVariant.withValues(alpha: 0.5),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => _height;

  @override
  double get minExtent => _height;

  @override
  bool shouldRebuild(covariant _HeaderDelegate old) =>
      title != old.title || onClose != old.onClose;
}
