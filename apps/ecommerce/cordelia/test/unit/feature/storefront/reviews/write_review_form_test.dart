import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cordelia/feature/storefront/reviews/presentation/write_review_form.dart';

/// A write used to pop the sheet the instant it was dispatched, so a failure
/// arrived as a snackbar over an empty screen and whatever the shopper had
/// typed was gone with the disposed controller. The sheet now waits for the
/// answer.
class _Host extends StatefulWidget {
  const _Host({required this.onSubmit});

  final Future<String?> Function(int rating, String text) onSubmit;

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> with WriteReviewForm {
  @override
  int get initialRating => 0;

  @override
  String get initialText => '';

  @override
  Future<String?> Function(int rating, String text) get onSubmit =>
      widget.onSubmit;

  @override
  String get missingRatingMessage => 'pick a rating';

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

void main() {
  Future<_HostState> mount(
    WidgetTester tester,
    Future<String?> Function(int, String) onSubmit,
  ) async {
    // Inside a Navigator so `submitReview`'s pop has something to pop.
    await tester.pumpWidget(MaterialApp(home: _Host(onSubmit: onSubmit)));
    return tester.state<_HostState>(find.byType(_Host));
  }

  testWidgets('a failed write keeps the words and shows why', (tester) async {
    final host = await mount(tester, (_, _) async => 'server said no');
    host.selectRating(4);
    host.reviewController.text = 'lovely tomatoes';

    await host.submitReview();

    expect(host.formError, 'server said no');
    expect(
      host.reviewController.text,
      'lovely tomatoes',
      reason: 'the composer must not be thrown away on a failure',
    );
    expect(host.submitting, isFalse, reason: 'the CTA is tappable again');
  });

  testWidgets('picking a rating clears the last failure', (tester) async {
    final host = await mount(tester, (_, _) async => 'server said no');
    host.selectRating(4);
    await host.submitReview();
    expect(host.formError, isNotNull);

    host.selectRating(5);

    expect(host.formError, isNull);
  });

  testWidgets('submitting with no rating never reaches the server', (
    tester,
  ) async {
    var reached = false;
    final host = await mount(tester, (_, _) async {
      reached = true;
      return null;
    });

    await host.submitReview();

    expect(reached, isFalse);
    expect(host.formError, 'pick a rating');
  });
}
