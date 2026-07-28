import 'package:flutter_test/flutter_test.dart';

import 'package:cordelia/feature/storefront/notifications/data/data_source/notifications_remote_data_source_impl.dart';
import 'package:cordelia/feature/storefront/template/storefront_template.dart';

/// The mock lives in a per-template asset folder resolved by string, so a
/// renamed folder or a missing `pubspec.yaml` line fails only at runtime, on
/// the screen. These load every template's file through the real data source
/// so that breaks the build instead.
void main() {
  // rootBundle reaches for ServicesBinding.instance, which nothing has set up
  // in a plain unit test.
  TestWidgetsFlutterBinding.ensureInitialized();

  const dataSource = NotificationsRemoteDataSourceImpl();

  group('notifications mock assets', () {
    for (final template in StorefrontTemplate.values) {
      test('${template.wireValue} ships a parseable notifications mock', () async {
        final sections = await dataSource.getNotifications(template);

        expect(sections, isNotEmpty);
        expect(
          sections.every((s) => s.title.isNotEmpty),
          isTrue,
          reason: 'every section needs a dated heading',
        );
        expect(
          sections.every((s) => s.notifications.isNotEmpty),
          isTrue,
          reason: 'an empty section would render a heading with no rows',
        );
      });
    }

    test('each template gets its own list, not one shared file', () async {
      final gravia = await dataSource.getNotifications(
        StorefrontTemplate.gravia,
      );
      final dailymart = await dataSource.getNotifications(
        StorefrontTemplate.dailymart,
      );

      String titles(List<dynamic> sections) => sections
          .expand((s) => (s.notifications as List).map((n) => n.title))
          .join('|');

      expect(titles(gravia), isNot(equals(titles(dailymart))));
    });
  });
}
