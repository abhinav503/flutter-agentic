import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:core/core/ui/molecules/bottom_sheet.dart';

void main() {
  Widget host(Widget sheet) => MaterialApp(home: Scaffold(body: sheet));

  group('AppBottomSheet header', () {
    testWidgets('default keeps the classic title-first row with a trailing X',
        (tester) async {
      await tester.pumpWidget(
        host(
          AppBottomSheet(
            title: 'Options',
            onClose: () {},
            child: const SizedBox(height: 100),
          ),
        ),
      );

      expect(find.text('Options'), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets(
        'showCloseAction: false suppresses the default X even with onClose set',
        (tester) async {
      await tester.pumpWidget(
        host(
          AppBottomSheet(
            title: 'Filter',
            onClose: () {},
            showCloseAction: false,
            centerTitle: true,
            headerHeight: 84,
            leading: const Icon(Icons.close_rounded, key: Key('leading-disc')),
            child: const SizedBox(height: 100),
          ),
        ),
      );

      // The pack's own leading control is the only close affordance — a
      // second, default X would read as two competing exits.
      expect(find.byKey(const Key('leading-disc')), findsOneWidget);
      expect(find.byIcon(Icons.close), findsNothing);
      expect(find.text('Filter'), findsOneWidget);
    });

    testWidgets('centerTitle centres the title against the sheet, not the '
        'space left over by leading', (tester) async {
      await tester.pumpWidget(
        host(
          AppBottomSheet(
            title: 'Centered',
            onClose: () {},
            showCloseAction: false,
            centerTitle: true,
            leading: const SizedBox(key: Key('leading'), width: 48, height: 48),
            child: const SizedBox(height: 100),
          ),
        ),
      );

      final sheetCenter = tester.getCenter(find.byType(AppBottomSheet)).dx;
      final titleCenter = tester.getCenter(find.text('Centered')).dx;
      expect(titleCenter, moreOrLessEquals(sheetCenter, epsilon: 1));
    });
  });
}
