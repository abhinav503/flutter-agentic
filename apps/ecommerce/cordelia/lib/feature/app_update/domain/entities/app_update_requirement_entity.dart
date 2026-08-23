/// What the platform asks of this build at launch: the lowest version it
/// still serves, and where to get a newer one. Empty [minVersion] = no gate.
class AppUpdateRequirementEntity {
  final String minVersion;
  final String updateUrl;

  const AppUpdateRequirementEntity({
    required this.minVersion,
    required this.updateUrl,
  });

  static const none = AppUpdateRequirementEntity(minVersion: '', updateUrl: '');
}

extension AppUpdateRequirementX on AppUpdateRequirementEntity {
  /// True when [installed] (X.Y.Z, extra suffixes ignored) is below
  /// [minVersion]. An unparsable side never forces an update — a config
  /// typo must not log every shopper out.
  bool requiresUpdate(String installed) {
    final min = _parse(minVersion);
    final have = _parse(installed);
    if (min == null || have == null) return false;
    for (var i = 0; i < 3; i++) {
      if (have[i] != min[i]) return have[i] < min[i];
    }
    return false;
  }

  static List<int>? _parse(String v) {
    final core = v.split(RegExp(r'[+\-]')).first.trim();
    if (core.isEmpty) return null;
    final parts = core.split('.').map(int.tryParse).toList();
    if (parts.length > 3 || parts.any((p) => p == null)) return null;
    return [for (var i = 0; i < 3; i++) i < parts.length ? parts[i]! : 0];
  }
}
