import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/base/base_screen.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/ui/atoms/loading_indicator.dart';
import '../../../../core/ui/molecules/error_view.dart';
import '../bloc/for_you_bloc.dart';
import '../widgets/joke_card.dart';

class ForYouScreen extends BaseScreen {
  const ForYouScreen({super.key});

  @override
  State<ForYouScreen> createState() => _ForYouScreenState();
}

class _ForYouScreenState extends BaseScreenState<ForYouScreen> {
  @override
  Widget body(BuildContext context) {
    return BlocConsumer<ForYouBloc, ForYouState>(
      listener: (context, state) {
        if (state case ForYouNextFetchFailed(:final message)) {
          showSnackBar(message);
        }
      },
      builder: (context, state) => switch (state) {
        ForYouLoading() => const LoadingIndicator(),
        ForYouLoaded(:final joke, :final isFetchingNext) => Stack(
            children: [
              Center(
                child: JokeCard(
                  key: ValueKey(joke.id),
                  joke: joke,
                  isFetchingNext: isFetchingNext,
                  onTap: isFetchingNext
                      ? null
                      : () => context
                          .read<ForYouBloc>()
                          .add(const ForYouEvent.nextRequested()),
                ),
              ),
              if (isFetchingNext)
                const Positioned(
                  bottom: AppSpacing.xl4,
                  right: AppSpacing.lg,
                  child: LoadingIndicator(size: 24, strokeWidth: 2.5),
                ),
            ],
          ),
        ForYouNextFetchFailed(:final currentJoke) => Center(
            child: JokeCard(
              key: ValueKey(currentJoke.id),
              joke: currentJoke,
              onTap: () => context
                  .read<ForYouBloc>()
                  .add(const ForYouEvent.nextRequested()),
            ),
          ),
        ForYouError(:final message) => Center(
            child: ErrorView(
              message: message,
              onRetry: () => context
                  .read<ForYouBloc>()
                  .add(const ForYouEvent.started()),
            ),
          ),
      },
    );
  }
}
