import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

/// The splash lockup is the mark plus live text, not a baked wordmark SVG.
///
/// Worth a test because the thing it replaced failed silently: the old
/// `cordelia-wordmark.svg` set "ordelia Apps" in an SVG `<text>` element, which
/// `flutter_svg` does not lay out — so the splash could only ever have shown
/// the symbol, with the name missing, and nothing would have complained.
void main() {
  const markPath = 'assets/icons/cordelia-icon.svg';

  testWidgets('the brand mark parses — its facet cut is a <mask>', (
    tester,
  ) async {
    final svg = File(markPath).readAsStringSync();
    expect(
      svg.contains('<mask'),
      isTrue,
      reason:
          'the cut must stay a mask, not a stroke in the page colour — a '
          'stroked cut only works on the surface it was drawn against',
    );

    await tester.pumpWidget(
      MaterialApp(home: Center(child: SvgPicture.string(svg, height: 34))),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });

  testWidgets('the lockup shows the mark beside the app name', (tester) async {
    final svg = File(markPath).readAsStringSync();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.string(svg, height: 34),
                const SizedBox(width: 8),
                const Text('CordeliaApps'),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // The name must be real text: that is what makes it themeable and what the
    // old SVG could not deliver.
    expect(find.text('CordeliaApps'), findsOneWidget);
    expect(find.byType(SvgPicture), findsOneWidget);
  });

  test('no wordmark asset is left behind for someone to reach for', () {
    expect(File('assets/icons/cordelia-wordmark.svg').existsSync(), isFalse);
  });
}
