import 'package:package_info_plus/package_info_plus.dart';

/// The running build's version, for the one place it has to be said out loud:
/// a support message.
///
/// Read from the platform bundle rather than written down, so it cannot drift
/// from pubspec's `version:` the way a hand-maintained constant does — and a
/// shopper reporting a bug names the build they are actually on.
///
/// App-local, not `core`: only this app has a support channel to print it in,
/// and `core` stays free of the plugin (see CLAUDE.md on per-app deps).
/// Static singleton like [SharedPreferenceService], so screens and message
/// builders reach it without a `BuildContext` or a GetIt lookup.
class AppInfoService {
  AppInfoService._();
  static final AppInfoService instance = AppInfoService._();

  String _version = '';
  String _buildNumber = '';

  /// Called once from `initDependencies()`. A failure here is deliberately
  /// swallowed: a missing version string must never stop the app booting,
  /// and it degrades to an empty label rather than a crash.
  Future<void> init() async {
    try {
      final info = await PackageInfo.fromPlatform();
      _version = info.version;
      _buildNumber = info.buildNumber;
    } catch (_) {
      // Leaves both empty — see `displayVersion`.
    }
  }

  /// `1.0.4 (4)`, or an empty string if the bundle could not be read.
  ///
  /// The build number matters as much as the version: two uploads of the
  /// same `versionName` are routine on a test track, and only the number
  /// after it distinguishes them.
  /// X.Y.Z from pubspec, or '' when unknown — what the update gate
  /// compares against the platform's minimum.
  String get version => _version;

  String get displayVersion {
    if (_version.isEmpty) return '';
    return _buildNumber.isEmpty ? _version : '$_version ($_buildNumber)';
  }
}
