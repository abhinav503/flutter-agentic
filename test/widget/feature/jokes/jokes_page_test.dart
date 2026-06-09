import 'package:bloc_test/bloc_test.dart';
import 'package:cordelia_base/core/base/bloc/master_bloc.dart';
import 'package:cordelia_base/core/constants/value_const.dart';
import 'package:cordelia_base/core/theme/app_theme.dart';
import 'package:cordelia_base/core/theme/app_theme_config.dart';
import 'package:cordelia_base/feature/jokes/domain/entities/joke_entity.dart';
import 'package:cordelia_base/feature/jokes/presentation/bloc/for_you_bloc.dart';
import 'package:cordelia_base/feature/jokes/presentation/bloc/kept_jokes_cubit.dart';
import 'package:cordelia_base/feature/jokes/presentation/view/for_you_screen.dart';
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
        BlocProvider<MasterBloc>(create: (_) => MasterBloc()),
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
      expect(find.text('Retry'), findsOneWidget);
    });
  });
}
