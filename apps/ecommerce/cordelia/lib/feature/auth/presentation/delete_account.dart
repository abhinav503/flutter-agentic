import 'package:flutter/material.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/ui/atoms/loading_indicator.dart';
import 'package:core/core/usecase/usecase.dart';

import 'package:cordelia/di/injection_container.dart';
import 'package:cordelia/feature/auth/domain/usecase/delete_account_usecase.dart';

import 'sign_out.dart';

/// Closes the account and lands back on Login, the terminal counterpart to
/// [signOutAndReturnToLogin] — which it reuses, because a deleted account
/// needs the same local teardown a sign-out does (profile cache, verify-sheet
/// flag, per-account cubits) on top of the server-side delete.
///
/// Returns the failure message when the server refused, `null` on success —
/// the screens snackbar it. Nothing is torn down on failure: the account
/// still exists, so leaving the shopper signed in on a working session is
/// the correct outcome, and they can retry.
///
/// Called from each pack's Profile row behind its own confirm sheet; the
/// sheet is what gates the tap, this only performs it.
Future<String?> deleteAccountAndReturnToLogin(BuildContext context) async {
  final result = await sl<DeleteAccountUseCase>()(const NoParams());

  final failure = result.fold((f) => f.message, (_) => null);
  if (failure != null) return failure;

  if (!context.mounted) return null;
  await signOutAndReturnToLogin(context);
  return null;
}

/// The Profile-row side of account deletion: the in-flight flag, the call,
/// and the blocking overlay that covers the screen while the server works.
///
/// Shared by all three packs' Profile screens — the copy, the ordering and
/// the busy behaviour of an irreversible action shouldn't differ per
/// template; only the row's glyph and the confirm sheet's chrome do.
mixin DeleteAccountAction<T extends BaseScreen> on BaseScreenState<T> {
  bool _deleting = false;

  /// Runs the delete behind [withDeleteAccountProgress]'s overlay. Guarded
  /// against a second call: the overlay blocks taps, but a confirm sheet
  /// dismissed mid-flight could otherwise let one through.
  Future<void> deleteAccount() async {
    if (_deleting) return;
    setState(() => _deleting = true);

    final failure = await deleteAccountAndReturnToLogin(context);
    // Success navigates to Login and disposes this screen, so there is
    // nothing left to unset — and calling setState here would throw.
    if (!mounted) return;

    setState(() => _deleting = false);
    if (failure != null) showSnackBar(failure);
  }

  /// Wraps a screen body in the busy overlay. A full-screen scrim rather
  /// than a spinner on the row: the action is irreversible and takes a
  /// server round trip, so every other control — including the nav bar —
  /// has to stop responding, not just the one that was tapped.
  Widget withDeleteAccountProgress(Widget child) => Stack(
    children: [
      child,
      if (_deleting)
        Positioned.fill(
          child: AbsorbPointer(
            child: ColoredBox(
              color: Theme.of(context).colorScheme.scrim.withValues(alpha: 0.33),
              child: const Center(child: LoadingIndicator()),
            ),
          ),
        ),
    ],
  );
}
