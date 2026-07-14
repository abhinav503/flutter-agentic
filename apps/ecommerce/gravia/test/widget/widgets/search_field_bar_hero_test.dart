import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:core/core/theme/app_theme.dart';
import 'package:core/core/theme/app_theme_config.dart';
import 'package:core/core/ui/atoms/text_field.dart';

import 'package:gravia/widgets/search_field_bar.dart';

/// Mirrors the app's transition on a phone-sized surface: Home has the field
/// low and full-width in its header; the pushed fade route (same shape as
/// app.dart's CustomTransitionPage) pins a NARROWER field at the top (its
/// back button eats width). The Hero must FLY — one field gliding between
/// the two positions — and must not overflow mid-flight in either direction
/// (the default MaterialRectArcTween dips the rect height below both
/// endpoints on diagonal size changes; SearchFieldBar pins a linear tween).
void main() {
  const flightDuration = Duration(milliseconds: 350);

  testWidgets('search field Hero flies cleanly there and back',
      (tester) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final homeController = TextEditingController();
    final searchController = TextEditingController();
    addTearDown(homeController.dispose);
    addTearDown(searchController.dispose);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.fromConfig(AppThemeConfig.defaults),
        home: Builder(
          builder: (context) => Scaffold(
            body: Padding(
              // Like Home's header: below the location row, full width
              // minus the screen gutters.
              padding: const EdgeInsets.only(top: 141, left: 16, right: 16),
              child: Align(
                alignment: Alignment.topCenter,
                child: SearchFieldBar(
                  controller: homeController,
                  onTap: () => Navigator.of(context).push(
                    PageRouteBuilder<void>(
                      transitionDuration: flightDuration,
                      reverseTransitionDuration: flightDuration,
                      pageBuilder: (_, _, _) => Scaffold(
                        body: Padding(
                          // Like Search's header: pinned at the top, offset
                          // right past the 45px glass back button + gap.
                          padding: const EdgeInsets.only(
                              top: 70, left: 73, right: 16),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child:
                                SearchFieldBar(controller: searchController),
                          ),
                        ),
                      ),
                      transitionsBuilder: (_, animation, _, child) =>
                          FadeTransition(opacity: animation, child: child),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    final startY = tester.getTopLeft(find.byType(AppTextField)).dy;

    // ── Push: field glides up ────────────────────────────────────────────
    await tester.tap(find.byType(SearchFieldBar));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 175)); // mid-flight

    // Mid-flight, both endpoint Heroes hide their children and the shuttle
    // is the only field on screen — sitting strictly BETWEEN the two
    // positions. If the flight silently failed, there would instead be two
    // static fields at the endpoints (or one that hasn't moved).
    expect(find.byType(AppTextField), findsOneWidget,
        reason: 'exactly one field (the flight shuttle) should be visible '
            'mid-flight');
    final midY = tester.getTopLeft(find.byType(AppTextField)).dy;
    expect(midY, lessThan(startY), reason: 'shuttle should have moved up');
    expect(tester.takeException(), isNull,
        reason: 'no overflow mid-flight on push');

    await tester.pumpAndSettle();
    final endY = tester.getTopLeft(find.byType(AppTextField)).dy;
    expect(endY, lessThan(midY));

    // ── Pop: field glides back down, sweeping frame-by-frame ─────────────
    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    navigator.pop();
    await tester.pump();
    for (var elapsed = 0; elapsed < 350; elapsed += 25) {
      await tester.pump(const Duration(milliseconds: 25));
      expect(tester.takeException(), isNull,
          reason: 'no overflow at ~${elapsed + 25}ms into the return flight');
    }
    await tester.pumpAndSettle();

    expect(tester.getTopLeft(find.byType(AppTextField)).dy, startY,
        reason: 'field should land back at its home position');
  });
}
