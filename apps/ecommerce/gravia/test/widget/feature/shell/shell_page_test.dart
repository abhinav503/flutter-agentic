import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/core/theme/app_theme.dart';
import 'package:core/core/theme/app_theme_config.dart';
import 'package:core/core/ui/blocks/bottom_nav_bar.dart';
import 'package:gravia/constants/value_const.dart';
import 'package:gravia/di/injection_container.dart';
import 'package:gravia/feature/cart/presentation/cubit/cart_cubit.dart';
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
  // CartCubit is likewise provided above the router in production; the
  // shell's cart status bar reads it unconditionally.
  Widget buildSubject() => MaterialApp(
    theme: AppTheme.fromConfig(AppThemeConfig.defaults),
    home: BlocProvider(create: (_) => CartCubit(), child: const ShellPage()),
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

  testWidgets('shows the home tab first, loaded with storefront data', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());
    await settleHome(tester);

    expect(find.text(ValueConst.allCategoriesTitle), findsOneWidget);
    expect(find.text(ValueConst.popularItemsTitle), findsOneWidget);
  });

  testWidgets('switches tabs from the bottom nav', (tester) async {
    await tester.pumpWidget(buildSubject());
    await settleHome(tester);

    // Tabs render an SVG icon via iconBuilder, not a findable Icons.* value,
    // and inactive tabs show no label text — tap by position (Orders = 3,
    // Profile = 4 in the fixed tab order) instead.
    final tabs = find.descendant(
      of: find.byType(BottomNavBar),
      matching: find.byType(GestureDetector),
    );

    await tester.tap(tabs.at(3));
    await tester.pumpAndSettle();
    expect(find.text(ValueConst.ordersEmptyTitle), findsOneWidget);

    // Profile renders a real AppNetworkImage (the avatar) too — same
    // never-settles reasoning as Home, so a bounded pump again.
    await tester.tap(tabs.at(4));
    await settleHome(tester);
    expect(find.text(ValueConst.changePasswordLabel), findsOneWidget);
  });
}
