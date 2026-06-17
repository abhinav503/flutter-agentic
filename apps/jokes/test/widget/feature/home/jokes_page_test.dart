import 'package:bloc_test/bloc_test.dart';
import 'package:jokes/constants/value_const.dart';
import 'package:core/core/constants/core_const.dart';
import 'package:core/core/theme/app_theme.dart';
import 'package:core/core/theme/app_theme_config.dart';
import 'package:jokes/feature/home/domain/entities/joke_entity.dart';
import 'package:jokes/feature/home/presentation/bloc/for_you_bloc.dart';
import 'package:jokes/feature/home/presentation/bloc/kept_jokes_cubit.dart';
import 'package:jokes/feature/home/presentation/view/for_you_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _MockForYouBloc extends MockBloc<ForYouEvent, ForYouState>
    implements ForYouBloc {}

Widget _wrap(ForYouBloc forYouBloc) {
  return MaterialApp(
    theme: AppTheme.fromConfig(AppThemeConfig.defaults),
    home: MultiBlocProvider(
      providers: [
        BlocProvider<ForYouBloc>.value(value: forYouBloc),
        BlocProvider<KeptJokesCubit>(create: (_) => KeptJokesCubit()),
      ],
      child: const Scaffold(body: ForYouScreen()),
    ),
  );
}

void main() {
  late _MockForYouBloc forYouBloc;

  setUp(() => forYouBloc = _MockForYouBloc());
  tearDown(() => forYouBloc.close());

  group('ForYouScreen', () {
    testWidgets('shows spinner in loading state', (tester) async {
      whenListen(forYouBloc, Stream<ForYouState>.empty(),
          initialState: const ForYouState.loading());

      await tester.pumpWidget(_wrap(forYouBloc));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows joke content in loaded state', (tester) async {
      const joke = JokeEntity(id: '1', content: 'Why did the chicken?');
      whenListen(
        forYouBloc,
        Stream.fromIterable([ForYouState.loaded(joke: joke)]),
        initialState: const ForYouState.loading(),
      );

      await tester.pumpWidget(_wrap(forYouBloc));
      await tester.pumpAndSettle();

      expect(find.text('Why did the chicken?'), findsOneWidget);
      expect(find.text(ValueConst.jokeTapForMore), findsOneWidget);
    });

    testWidgets('shows error on first-load failure', (tester) async {
      whenListen(forYouBloc, Stream<ForYouState>.empty(),
          initialState: const ForYouState.error(message: 'No internet'));

      await tester.pumpWidget(_wrap(forYouBloc));

      expect(find.text('No internet'), findsOneWidget);
      expect(find.text(CoreConst.retryButton), findsOneWidget);
    });
  });
}
