import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gravia/constants/value_const.dart';
import 'package:gravia/feature/home/presentation/view/home_page.dart';

void main() {
  Widget buildSubject() => const MaterialApp(home: HomePage());

  testWidgets('shows the storefront tab first', (tester) async {
    await tester.pumpWidget(buildSubject());

    expect(find.text(ValueConst.storefrontComingTitle), findsOneWidget);
  });

  testWidgets('switches tabs from the bottom nav', (tester) async {
    await tester.pumpWidget(buildSubject());

    await tester.tap(find.byIcon(Icons.shopping_bag_outlined));
    await tester.pumpAndSettle();
    expect(find.text(ValueConst.ordersEmptyTitle), findsOneWidget);

    await tester.tap(find.byIcon(Icons.person_outline));
    await tester.pumpAndSettle();
    expect(find.text(ValueConst.profileComingTitle), findsOneWidget);
  });
}
