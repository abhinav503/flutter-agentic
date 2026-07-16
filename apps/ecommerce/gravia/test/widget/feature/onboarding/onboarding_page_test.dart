import 'package:core/core/services/shared_pref_service/shared_preference_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:gravia/constants/app_routes.dart';
import 'package:gravia/constants/value_const.dart';
import 'package:gravia/feature/onboarding/presentation/view/onboarding_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await SharedPreferenceService.instance.init();
  });

  Widget buildSubject() => MaterialApp.router(
    routerConfig: GoRouter(
      initialLocation: AppRoutes.onboarding,
      routes: [
        GoRoute(
          path: AppRoutes.onboarding,
          builder: (context, _) => const OnboardingPage(),
        ),
        GoRoute(
          path: AppRoutes.home,
          builder: (context, _) => const Scaffold(body: Text('home')),
        ),
      ],
    ),
  );

  testWidgets('shows the first slide first', (tester) async {
    await tester.pumpWidget(buildSubject());

    expect(find.text(ValueConst.onboardingTitle1), findsOneWidget);
    expect(find.text(ValueConst.onboardingNext), findsOneWidget);
  });

  testWidgets('Next advances through all 3 slides to Get Started', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());

    await tester.tap(find.text(ValueConst.onboardingNext));
    await tester.pumpAndSettle();
    expect(find.text(ValueConst.onboardingTitle2), findsOneWidget);

    await tester.tap(find.text(ValueConst.onboardingNext));
    await tester.pumpAndSettle();
    expect(find.text(ValueConst.onboardingTitle3), findsOneWidget);
    expect(find.text(ValueConst.onboardingGetStarted), findsOneWidget);
  });

  testWidgets('Get Started persists the flag and navigates home', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());

    await tester.tap(find.text(ValueConst.onboardingNext));
    await tester.pumpAndSettle();
    await tester.tap(find.text(ValueConst.onboardingNext));
    await tester.pumpAndSettle();
    await tester.tap(find.text(ValueConst.onboardingGetStarted));
    await tester.pumpAndSettle();

    expect(find.text('home'), findsOneWidget);
    expect(
      SharedPreferenceService.instance.getBool(kHasSeenOnboardingPrefKey),
      isTrue,
    );
  });
}
