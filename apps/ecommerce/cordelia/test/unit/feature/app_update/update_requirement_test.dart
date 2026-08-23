import 'package:flutter_test/flutter_test.dart';

import 'package:cordelia/feature/app_update/domain/entities/app_update_requirement_entity.dart';

/// The gate compares X.Y.Z numerically and fails open on anything it can't
/// read — a typo in the platform config must never lock every shopper out.
void main() {
  AppUpdateRequirementEntity min(String v) =>
      AppUpdateRequirementEntity(minVersion: v, updateUrl: 'https://x');

  test('below the minimum requires an update', () {
    expect(min('1.0.5').requiresUpdate('1.0.4'), isTrue);
    expect(min('1.1.0').requiresUpdate('1.0.9'), isTrue);
    expect(min('2.0.0').requiresUpdate('1.9.9'), isTrue);
  });

  test('at or above the minimum proceeds', () {
    expect(min('1.0.5').requiresUpdate('1.0.5'), isFalse);
    expect(min('1.0.5').requiresUpdate('1.0.10'), isFalse);
    expect(min('1.0.5').requiresUpdate('1.2'), isFalse);
  });

  test('build suffixes are ignored', () {
    expect(min('1.0.5').requiresUpdate('1.0.5+7'), isFalse);
    expect(min('1.0.5').requiresUpdate('1.0.4+6'), isTrue);
  });

  test('no gate or unreadable versions never require an update', () {
    expect(AppUpdateRequirementEntity.none.requiresUpdate('0.0.1'), isFalse);
    expect(min('banana').requiresUpdate('1.0.0'), isFalse);
    expect(min('1.0.5').requiresUpdate(''), isFalse);
    expect(min('1.0.5').requiresUpdate('dev'), isFalse);
  });
}
