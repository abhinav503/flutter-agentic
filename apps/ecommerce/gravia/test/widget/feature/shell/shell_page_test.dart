import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/core/theme/app_theme.dart';
import 'package:core/core/theme/app_theme_config.dart';
import 'package:gravia/constants/value_const.dart';
import 'package:gravia/di/injection_container.dart';
import 'package:gravia/feature/shell/presentation/view/shell_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await sl.reset();
    await initDependencies();
  });

  // ShellPage renders blocks (AppBadge, ProductCard) that read theme
  // extensions the app always provides in production (see app.dart) — a
  // bare MaterialApp with no theme crashes on the extension's force-unwrap.
  Widget buildSubject() => MaterialApp(
        theme: AppTheme.fromConfig(AppThemeConfig.defaults),
        home: const ShellPage(),
      );

  // The Home tab renders real AppNetworkImage/Image.network calls plus a
  // LoadingIndicator with an indeterminate (never-settling) animation, so
  // pumpAndSettle() would time out here — pump a bounded duration instead,
  // enough for the local-asset load and the test HttpClient's fast image
  // error responses to resolve.
  Future<void> settleHome(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
  }

  testWidgets('shows the home tab first, loaded with storefront data',
      (tester) async {
    await tester.pumpWidget(buildSubject());
    await settleHome(tester);

    expect(find.text(ValueConst.allCategoriesTitle), findsOneWidget);
    expect(find.text(ValueConst.popularItemsTitle), findsOneWidget);
  });

  testWidgets('switches tabs from the bottom nav', (tester) async {
    await tester.pumpWidget(buildSubject());
    await settleHome(tester);

    await tester.tap(find.byIcon(Icons.shopping_bag_outlined));
    await tester.pumpAndSettle();
    expect(find.text(ValueConst.ordersEmptyTitle), findsOneWidget);

    await tester.tap(find.byIcon(Icons.person_outline));
    await tester.pumpAndSettle();
    expect(find.text(ValueConst.profileComingTitle), findsOneWidget);
  });
}
