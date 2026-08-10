import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:core/core/theme/app_theme.dart';
import 'package:core/core/theme/app_theme_config.dart';
import 'package:core/core/ui/atoms/text_field.dart';

import 'package:core/core/services/shared_pref_service/shared_preference_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cordelia/constants/cordelia_dimen_const.dart';
import 'package:cordelia/constants/value_const.dart';
import 'package:cordelia/feature/home/presentation/recent_stores_prefs.dart';
import 'package:cordelia/feature/home/presentation/widgets/discovery_header.dart';
import 'package:cordelia/feature/home/presentation/widgets/store_list_skeleton.dart';
import 'package:cordelia/feature/storefront/profile/domain/entities/profile_entity.dart';
import 'package:cordelia/widgets/cordelia_brand_mark.dart';

/// Discovery's header carries three things that regressed easily before it
/// existed: the brand mark (which reached users on the splash alone), the
/// personalised greeting, and a search field that isn't a cramped strip.
void main() {
  Widget host({ProfileEntity? profile}) => MaterialApp(
    theme: AppTheme.fromConfig(AppThemeConfig.defaults),
    home: Scaffold(
      body: DiscoveryHeader(
        profile: profile,
        searchController: TextEditingController(),
        onQueryChanged: (_) {},
      ),
    ),
  );

  const profile = ProfileEntity(
    name: 'Abhinav Kumar',
    email: 'a@b.com',
    phone: '',
    avatarUrl: '',
  );

  testWidgets('the search field keeps its full control height', (tester) async {
    await tester.pumpWidget(host());
    await tester.pump();

    // The regression this guards: a `dense: true` field with no explicit
    // height collapses to roughly 40px around its icon.
    expect(
      tester.getSize(find.byType(AppTextField)).height,
      CordeliaDimenConst.discoverySearchHeight,
    );
  });

  testWidgets('the greeting addresses the shopper by first name', (
    tester,
  ) async {
    await tester.pumpWidget(host(profile: profile));
    await tester.pump();

    // Asserted as a suffix rather than a fixed string: the greeting half
    // depends on the wall clock, and pinning it would only restate the
    // widget's own branch back at itself.
    final greeting = tester.widget<Text>(
      find.byWidgetPredicate(
        (w) => w is Text && (w.data?.contains(',') ?? false),
      ),
    );
    expect(greeting.data, endsWith(', Abhinav'));
  });

  testWidgets('an unresolved profile greets without a trailing comma', (
    tester,
  ) async {
    await tester.pumpWidget(host());
    await tester.pump();

    expect(find.textContaining(','), findsNothing);
    expect(find.text(ValueConst.discoveryPrompt), findsOneWidget);
  });

  testWidgets('the clear button appears only once something is typed', (
    tester,
  ) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    final queries = <String>[];

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.fromConfig(AppThemeConfig.defaults),
        home: Scaffold(
          body: DiscoveryHeader(
            profile: null,
            searchController: controller,
            onQueryChanged: queries.add,
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.byIcon(Icons.close_rounded), findsNothing);

    await tester.enterText(find.byType(AppTextField), 'gro');
    await tester.pump();
    expect(find.byIcon(Icons.close_rounded), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pump();

    expect(controller.text, isEmpty);
    expect(find.byIcon(Icons.close_rounded), findsNothing);
    // The regression this guards: `controller.clear()` does NOT fire the
    // field's onChanged, so clearing the box without also dispatching an
    // empty query leaves the list filtered against text no longer on screen.
    expect(queries.last, isEmpty);
  });

  testWidgets('the brand mark opens the header', (tester) async {
    await tester.pumpWidget(host(profile: profile));
    await tester.pump();

    expect(find.byType(CordeliaBrandMark), findsOneWidget);
    expect(find.text(ValueConst.appTitle), findsOneWidget);
  });

  // A full rail is 6 tiles at an 84px pitch — 504px, wider than the content
  // width of any phone. The skeleton's rail must scroll like the loaded one;
  // as a bare Row it overflowed by 53px on a 411dp screen the moment a
  // shopper had remembered six stores.
  testWidgets('a full recents rail scrolls rather than overflowing', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues(const {});
    await SharedPreferenceService.instance.init();
    for (var i = 0; i < kRecentStoresLimit; i++) {
      await recordRecentStore('store-$i');
    }
    expect(readRecentStoreIds(), hasLength(kRecentStoresLimit));

    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625; // 411dp wide — a common phone.
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.fromConfig(AppThemeConfig.defaults),
        home: const Scaffold(
          body: SingleChildScrollView(child: StoreListSkeleton()),
        ),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
  });
}
