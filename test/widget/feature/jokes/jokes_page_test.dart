import 'package:bloc_test/bloc_test.dart';
import 'package:cordelia_base/feature/jokes/domain/entities/joke_entity.dart';
import 'package:cordelia_base/feature/jokes/presentation/bloc/joke_bloc.dart';
import 'package:cordelia_base/feature/jokes/presentation/view/jokes_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _MockJokeBloc extends MockBloc<JokeEvent, JokeState> implements JokeBloc {}

Widget _wrap(Widget child, JokeBloc bloc) {
  return MaterialApp(
    home: BlocProvider<JokeBloc>.value(
      value: bloc,
      child: child,
    ),
  );
}

void main() {
  late _MockJokeBloc bloc;

  setUp(() => bloc = _MockJokeBloc());
  tearDown(() => bloc.close());

  group('JokesPage', () {
    testWidgets('shows prompt text in initial state', (tester) async {
      whenListen(bloc, Stream<JokeState>.empty(), initialState: const JokeState.initial());

      await tester.pumpWidget(_wrap(const JokesPage(), bloc));

      expect(find.text('Tap ➕ for a joke'), findsOneWidget);
    });

    testWidgets('shows loading indicator in loading state', (tester) async {
      whenListen(bloc, Stream<JokeState>.empty(), initialState: const JokeState.loading());

      await tester.pumpWidget(_wrap(const JokesPage(), bloc));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows joke content in loaded state', (tester) async {
      const joke = JokeEntity(id: '1', content: 'Why did the chicken?');
      whenListen(bloc, Stream<JokeState>.empty(), initialState: JokeState.loaded(joke: joke));

      await tester.pumpWidget(_wrap(const JokesPage(), bloc));

      expect(find.text('Why did the chicken?'), findsOneWidget);
    });

    testWidgets('shows error message and retry button in error state', (tester) async {
      whenListen(bloc, Stream<JokeState>.empty(), initialState: const JokeState.error(message: 'No internet'));

      await tester.pumpWidget(_wrap(const JokesPage(), bloc));

      expect(find.text('No internet'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });
  });
}
