import 'dart:async';

import 'package:flutter/material.dart';

import 'package:core/core/theme/app_colors_extension.dart';
import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_shapes_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/concentric_circles.dart';
import 'package:core/core/ui/atoms/loading_dots.dart';

import 'package:gravia/constants/text_style_const.dart';
import 'package:gravia/constants/value_const.dart';

/// The persistent, zero-exit verification step after signup/an
/// unverified login — presented directly via `showModalBottomSheet`
/// (`isDismissible: false, enableDrag: false`), same reasoning as
/// `OrderPlacedSheetContent`: no title row or close control to render, so
/// `AppBottomSheet` doesn't fit. [PopScope] additionally blocks the Android
/// back gesture — per product spec there is truly no way out except the
/// email actually getting verified (polled by `AuthBloc`, not this widget);
/// "Resend email" is the only action here.
class VerifyEmailSheetContent extends StatefulWidget {
  final String email;
  final VoidCallback onResend;

  const VerifyEmailSheetContent({
    super.key,
    required this.email,
    required this.onResend,
  });

  @override
  State<VerifyEmailSheetContent> createState() =>
      _VerifyEmailSheetContentState();
}

class _VerifyEmailSheetContentState extends State<VerifyEmailSheetContent> {
  static const _resendCooldown = Duration(seconds: 30);

  Timer? _cooldownTimer;
  int _cooldownSeconds = 0;

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    super.dispose();
  }

  void _handleResend() {
    if (_cooldownSeconds > 0) return;
    widget.onResend();
    setState(() => _cooldownSeconds = _resendCooldown.inSeconds);
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() => _cooldownSeconds--);
      if (_cooldownSeconds <= 0) timer.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final shapes =
        Theme.of(context).extension<AppShapes>() ?? AppShapes.standard;

    return PopScope(
      canPop: false,
      child: Container(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(shapes.sheetRadius),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl4,
              AppSpacing.xs2,
              AppSpacing.xl4,
              AppSpacing.xl2,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 3,
                  margin: const EdgeInsets.only(bottom: AppSpacing.xl4),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).extension<AppColorsExtension>()!.sheetHairline,
                    borderRadius: AppRadius.full,
                  ),
                ),
                _PendingIcon(cs: cs),
                const SizedBox(height: AppSpacing.xl4),
                Text(
                  ValueConst.verifyEmailTitle,
                  textAlign: TextAlign.center,
                  style: TextStyleConst.displayXsBold(
                    tt,
                  ).copyWith(color: cs.onSurface),
                ),
                const SizedBox(height: AppSpacing.base),
                Text(
                  ValueConst.verifyEmailSubtitle(widget.email),
                  textAlign: TextAlign.center,
                  style: TextStyleConst.textSmRegular(tt).copyWith(
                    color: Theme.of(context)
                        .extension<AppColorsExtension>()!
                        .onSheetMuted,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl2),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LoadingDots(color: cs.primary),
                    const SizedBox(width: AppSpacing.xs2),
                    Text(
                      ValueConst.verifyEmailChecking,
                      style: TextStyleConst.textSmRegular(
                        tt,
                      ).copyWith(color: cs.onSurfaceVariant),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl2),
                TextButton(
                  onPressed: _cooldownSeconds > 0 ? null : _handleResend,
                  child: Text(
                    _cooldownSeconds > 0
                        ? '${ValueConst.resendEmailLabel} (${_cooldownSeconds}s)'
                        : ValueConst.resendEmailLabel,
                    style: TextStyleConst.textSmMedium(
                      tt,
                    ).copyWith(color: cs.primary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Pending-state graphic — same concentric-ring construction as
/// `OrderPlacedSheetContent`'s `_SuccessIcon`, deliberately different fill
/// (outline disc + mail glyph, not a solid check) so it doesn't read as
/// "done" while verification is still outstanding.
class _PendingIcon extends StatelessWidget {
  final ColorScheme cs;

  const _PendingIcon({required this.cs});

  static const double _outerSize = 128;
  static const double _middleSize = 96;
  static const double _innerSize = 64;
  static const double _iconSize = 28;

  @override
  Widget build(BuildContext context) => AppConcentricCircles(
    radii: const [_outerSize, _middleSize, _innerSize],
    colors: [
      cs.primary.withValues(alpha: 0.1),
      cs.primary.withValues(alpha: 0.1),
      cs.primary,
    ],
    child: Icon(
      Icons.mark_email_unread_outlined,
      color: cs.onPrimary,
      size: _iconSize,
    ),
  );
}
