import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:core/core/theme/app_theme.dart';
import 'package:core/core/theme/app_theme_config.dart';
import 'package:core/core/ui/atoms/text_field.dart';

import 'package:cordelia/constants/cordelia_dimen_const.dart';
import 'package:cordelia/constants/value_const.dart';
import 'package:cordelia/feature/home/presentation/widgets/discovery_header.dart';
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

  testWidgets('the brand mark opens the header', (tester) async {
    await tester.pumpWidget(host(profile: profile));
    await tester.pump();

    expect(find.byType(CordeliaBrandMark), findsOneWidget);
    expect(find.text(ValueConst.appTitle), findsOneWidget);
  });
}
