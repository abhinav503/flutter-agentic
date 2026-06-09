import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/base/base_screen.dart';
import '../../../../core/base/bloc/master_bloc.dart';
import '../../../../core/constants/value_const.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/ui/atoms/button.dart';
import '../../../../core/ui/atoms/loading_indicator.dart';
import '../../../../core/ui/molecules/error_view.dart';
import '../../domain/entities/joke_search_result_entity.dart';
import '../bloc/joke_bloc.dart';
import '../bloc/joke_search_bloc.dart';
import '../widgets/joke_card.dart';
import '../widgets/joke_empty_state.dart';
import '../widgets/joke_results_view.dart';
import '../widgets/joke_search_header.dart';

class JokesScreen extends BaseScreen {
  const JokesScreen({super.key});

  @override
  State<JokesScreen> createState() => _JokesScreenState();
}

class _JokesScreenState extends BaseScreenState<JokesScreen> {
  @override
  Widget body(BuildContext context) {
    return Column(
      children: [
        const JokeSearchHeader(),
        Expanded(child: _ContentArea(onTileTap: _showJokeDetail)),
      ],
    );
  }

  void _showJokeDetail(JokeSearchResultEntity joke) {
    final tt = Theme.of(context).textTheme;
    showAppBottomSheet(
      title: ValueConst.jokeSheetTitle,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(joke.content, style: tt.bodyLarge),
            const SizedBox(height: AppSpacing.xl4),
            AppButton(
              label: ValueConst.jokeCloseButton,
              variant: AppButtonVariant.secondary,
              fullWidth: true,
              onTap: () => Navigator.of(context).pop(),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}

class _ContentArea extends StatelessWidget {
  final void Function(JokeSearchResultEntity) onTileTap;

  const _ContentArea({required this.onTileTap});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JokeSearchBloc, JokeSearchState>(
      builder: (context, searchState) => searchState is JokeSearchInitial
          ? const _JokeContent()
          : _SearchContent(state: searchState, onTileTap: onTileTap),
    );
  }
}

class _SearchContent extends StatelessWidget {
  final JokeSearchState state;
  final void Function(JokeSearchResultEntity) onTileTap;

  const _SearchContent({required this.state, required this.onTileTap});

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      JokeSearchInitial() => const SizedBox.shrink(),
      JokeSearchLoading() => const LoadingIndicator(),
      JokeSearchLoaded() => JokeResultsView(
          state: state as JokeSearchLoaded,
          onTileTap: onTileTap,
          onLoadMore: () => context
              .read<JokeSearchBloc>()
              .add(const JokeSearchEvent.loadMore()),
        ),
      JokeSearchError(:final message) => ErrorView(
          message: message,
          onRetry: () {
            final bloc = context.read<JokeSearchBloc>();
            final s = bloc.state;
            if (s is JokeSearchLoaded) {
              bloc.add(JokeSearchEvent.submitted(term: s.searchTerm));
            }
          },
        ),
    };
  }
}

// Listens to JokeBloc and drives the page-level MasterBloc overlay.
// JokeLoading  → ShowLoader (page overlay appears)
// JokeLoaded / JokeError → HideLoader (overlay dismissed)
class _JokeContent extends StatelessWidget {
  const _JokeContent();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<JokeBloc, JokeState>(
      listener: (context, state) {
        final master = context.read<MasterBloc>();
        switch (state) {
          case JokeLoading():
            master.add(ShowLoader());
          case JokeLoaded() || JokeError():
            master.add(HideLoader());
          default:
            break;
        }
      },
      builder: (context, state) => switch (state) {
        JokeInitial() => JokeEmptyState(
            onTap: () =>
                context.read<JokeBloc>().add(const JokeEvent.fetched()),
          ),
        JokeLoading() => const SizedBox.shrink(), // overlay handles this
        JokeLoaded(:final joke) => JokeCard(joke: joke),
        JokeError(:final message) => ErrorView(
            message: message,
            onRetry: () =>
                context.read<JokeBloc>().add(const JokeEvent.fetched()),
          ),
      },
    );
  }
}
