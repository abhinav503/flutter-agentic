import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:jokes/constants/value_const.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/button.dart';
import 'package:core/core/ui/atoms/loading_indicator.dart';
import 'package:core/core/ui/molecules/error_view.dart';
import '../../domain/entities/joke_entity.dart';
import '../bloc/kept_jokes_cubit.dart';
import '../bloc/search_page_bloc.dart';
import '../widgets/joke_results_view.dart';
import '../widgets/joke_search_header.dart';

class SearchScreen extends BaseScreen {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends BaseScreenState<SearchScreen> {
  @override
  Widget body(BuildContext context) {
    return Column(
      children: [
        const JokeSearchHeader(),
        Expanded(
          child: BlocBuilder<SearchPageBloc, SearchPageState>(
            builder: (context, state) => switch (state) {
              SearchPageInitial() => const _SearchEmptyPlaceholder(),
              SearchPageLoading() => const LoadingIndicator(),
              SearchPageLoaded() => JokeResultsView(
                  state: state,
                  onTileTap: _showDetail,
                  onLoadMore: () => context
                      .read<SearchPageBloc>()
                      .add(const SearchPageEvent.loadMore()),
                ),
              SearchPageError(:final message, :final searchTerm) => ErrorView(
                  message: message,
                  onRetry: () => context
                      .read<SearchPageBloc>()
                      .add(SearchPageEvent.submitted(term: searchTerm)),
                ),
            },
          ),
        ),
      ],
    );
  }

  void _showDetail(JokeEntity joke) {
    showAppBottomSheet(
      title: ValueConst.jokeSheetTitle,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Text(joke.content, style: Theme.of(context).textTheme.bodyLarge),
      ),
      actions: [
        AppButton(
          label: ValueConst.jokeSheetKeepButton,
          variant: AppButtonVariant.primary,
          fullWidth: true,
          onTap: () {
            context.read<KeptJokesCubit>().keep(joke);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class _SearchEmptyPlaceholder extends StatelessWidget {
  const _SearchEmptyPlaceholder();

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search, size: 64, color: cs.onSurfaceVariant),
          const SizedBox(height: AppSpacing.base),
          Text(
            ValueConst.jokeSearchEmptyHint,
            style: tt.bodyMedium!.copyWith(color: cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
