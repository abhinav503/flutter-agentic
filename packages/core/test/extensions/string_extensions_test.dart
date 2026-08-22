import 'package:core/core/extensions/string_extensions.dart';
import 'package:flutter_test/flutter_test.dart';

/// A keyboard that auto-capitalises the first letter turns `sam@x.com` into
/// `Sam@x.com`, which signs up a second account and then fails to log into
/// the first.
void main() {
  test('an email address is stored trimmed and lower cased', () {
    expect('  Sam@Example.COM '.asEmailAddress, 'sam@example.com');
    expect('sam@example.com'.asEmailAddress, 'sam@example.com');
  });
}
