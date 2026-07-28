import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:core/core/ui/atoms/page_indicator.dart';
import 'package:core/core/ui/atoms/shimmer_box.dart';

import 'package:cordelia/enums/banner_target_type.dart';
import 'package:cordelia/feature/storefront/home/domain/entities/banner_entity.dart';
import 'package:cordelia/feature/storefront/home/presentation/templates/dailymart/widgets/home_promo_carousel.dart';

/// The indicator's active dot is the elongated pill (20 wide); every inactive
/// dot is a 6px circle — see [PageIndicator].
const _activeDotWidth = 20.0;

List<BannerEntity> _banners(int count) => [
  for (var i = 0; i < count; i++)
    BannerEntity(
      id: 'banner_$i',
      imageUrl: '',
      title: 'Banner $i',
      subtitle: 'Subtitle $i',
      targetType: BannerTargetType.none,
      targetId: '',
    ),
];

/// Which dot the indicator is currently marking active.
int _activeDotIndex(WidgetTester tester) {
  final widths = tester
      .widgetList<AnimatedContainer>(
        find.descendant(
          of: find.byType(PageIndicator),
          matching: find.byType(AnimatedContainer),
        ),
      )
      .map((c) => c.constraints?.maxWidth)
      .toList();
  return widths.indexWhere((w) => w == _activeDotWidth);
}

Future<void> _pumpCarousel(WidgetTester tester, int bannerCount) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: DailyMartHomePromoCarousel(
          banners: _banners(bannerCount),
          onBannerTap: (_) {},
        ),
      ),
    ),
  );
  // Let the PageView settle its initial layout — the reported bug only shows
  // up after the first post-layout frame, not on the raw build.
  await tester.pumpAndSettle();
}

void main() {
  group('DailyMartHomePromoCarousel', () {
    testWidgets('rests on the second banner so its neighbours peek', (
      tester,
    ) async {
      await _pumpCarousel(tester, 3);

      expect(_activeDotIndex(tester), 1);
    });

    testWidgets('still rests on the second banner when only two exist', (
      tester,
    ) async {
      await _pumpCarousel(tester, 2);

      expect(_activeDotIndex(tester), 1);
    });

    testWidgets('rests on the only banner when the store has one', (
      tester,
    ) async {
      await _pumpCarousel(tester, 1);

      // Nothing to sit between, so there is no second page to rest on.
      expect(_activeDotIndex(tester), 0);
    });

    testWidgets('skeleton shimmers three cards and rests on the same page', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: DailyMartHomePromoCarouselSkeleton()),
        ),
      );
      await tester.pump();

      expect(
        find.byType(ShimmerBox),
        findsNWidgets(DailyMartHomePromoCarouselSkeleton.placeholderCount),
      );
      // Same dot the loaded rail marks, so the indicator doesn't jump sideways
      // when the banners land.
      expect(_activeDotIndex(tester), 1);
    });

    testWidgets('falls back to the last page when a refresh shortens the list', (
      tester,
    ) async {
      await _pumpCarousel(tester, 3);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DailyMartHomePromoCarousel(
              banners: _banners(1),
              onBannerTap: (_) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(_activeDotIndex(tester), 0);
    });
  });
}
