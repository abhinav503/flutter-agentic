import 'package:cordelia_base/app.dart';
import 'package:cordelia_base/core/di/injection_container.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

void main() {
  setUpAll(() async {
    await GetIt.instance.reset();
    await initDependencies();
  });

  testWidgets('app renders without crashing', (tester) async {
    await tester.pumpWidget(const App());
    await tester.pump();
    expect(find.text('Dad Jokes'), findsOneWidget);
  });
}
