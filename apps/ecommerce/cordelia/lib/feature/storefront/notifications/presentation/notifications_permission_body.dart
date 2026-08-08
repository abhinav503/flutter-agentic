import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/molecules/empty_state.dart';

import 'package:cordelia/constants/value_const.dart';

/// The Notifications screen's body while the OS is not allowing this app to
/// notify — core's [EmptyState] over the pack's own CTA.
///
/// Shared by all three templates because the copy is (see
/// `ValueConst.notificationsPermission*`); only the glyph and the button come
/// from the pack.
///
/// Deliberately not `EmptyState(actions: …)`: that lays its actions out in a
/// `Row`, which hands each child an unbounded width, and every pack's primary
/// CTA is full-width. The stretched Column here gives it the bounded width it
/// needs, and the same inset each kit docks a CTA at.
class NotificationsPermissionBody extends StatelessWidget {
  /// The pack's own notifications glyph, so this reads as the same screen the
  /// empty state does.
  final IconData icon;

  /// The pack's primary button, already wired to dispatch
  /// [NotificationsEvent.permissionRequested] and carrying its loading state
  /// while the OS dialog is up.
  final Widget action;

  const NotificationsPermissionBody({
    super.key,
    required this.icon,
    required this.action,
  });

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      EmptyState(
        iconData: icon,
        title: ValueConst.notificationsPermissionTitle,
        subtitle: ValueConst.notificationsPermissionSubtitle,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl4),
        child: action,
      ),
    ],
  );
}
