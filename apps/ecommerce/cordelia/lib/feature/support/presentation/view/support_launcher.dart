import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:core/core/base/base_screen.dart';

import 'package:cordelia/constants/value_const.dart';

import 'support_channels.dart';

/// Opens a [SupportChannel], and makes sure the shopper is left holding the
/// address either way.
///
/// An extension on `BuildContext` rather than a mixin on `BaseScreenState`
/// because the same tap exists on a screen, inside a pack's bottom sheet, and
/// on an order card — the hosts differ, the behaviour must not (see
/// [AppOverlaysX], which this leans on for the snackbar).
extension SupportLaunchX on BuildContext {
  /// Hands [channel] to the device.
  ///
  /// A phone with no mail client, a work profile that blocks the dialler, a
  /// web preview with no handler registered — all of these answer "no" rather
  /// than opening something, and all of them used to be the point at which a
  /// support channel silently stopped being one. So a failure copies the
  /// address to the clipboard and says so: the shopper can still paste it
  /// somewhere that works, which is the whole promise of the screen.
  Future<void> openSupportChannel(SupportChannel channel) async {
    var opened = false;
    try {
      opened = await launchUrl(
        channel.uri,
        // A policy page belongs in the browser, not in a webview inside a
        // shopping app. mailto:/tel: have no in-app form to prefer, so they
        // take the platform's own default handling.
        mode: channel.kind == SupportChannelKind.link
            ? LaunchMode.externalApplication
            : LaunchMode.platformDefault,
      );
    } catch (_) {
      // PlatformException when nothing on the device claims the scheme —
      // the same outcome as a plain `false`, handled once below.
      opened = false;
    }
    if (opened || !mounted) return;

    // A link row shows no value under its label, so the URL itself is what
    // there is to hand over.
    final fallback = channel.value.isEmpty
        ? channel.uri.toString()
        : channel.value;
    await copyToClipboard(
      fallback,
      ValueConst.supportLaunchFailedMessage(fallback),
    );
  }
}
