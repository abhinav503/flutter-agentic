import 'package:flutter/material.dart';

import '../../../../core/constants/value_const.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/ui/atoms/badge.dart';
import '../../../../core/ui/atoms/button.dart';
import '../../domain/entities/joke_search_result_entity.dart';
import '../bloc/search_page_bloc.dart';

import 'joke_list_tile.dart';

class JokeResultsView extends StatelessWidget {
  final SearchPageLoaded state;
  final void Function(JokeSearchResultEntity) onTileTap;
  final VoidCallback onLoadMore;

  const JokeResultsView({
    super.key,
    required this.state,
    required this.onTileTap,
    required this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.base,
            ),
            child: AppBadge(
              text: ValueConst.jokeResultsCount(state.totalJokes),
              intent: AppBadgeIntent.info,
            ),
          ),
        ),
        SliverList.builder(
          itemCount: state.results.length,
          itemBuilder: (_, i) => JokeListTile(
            joke: state.results[i],
            onTap: () => onTileTap(state.results[i]),
          ),
        ),
        if (state.currentPage < state.totalPages)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: AppButton(
                label: ValueConst.jokeLoadMore,
                variant: AppButtonVariant.primary,
                size: AppButtonSize.medium,
                state: state.isLoadingMore
                    ? AppButtonState.loading
                    : AppButtonState.idle,
                fullWidth: true,
                onTap: onLoadMore,
              ),
            ),
          ),
      ],
    );
  }
}
