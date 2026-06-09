abstract final class ValueConst {
  // ── App ───────────────────────────────────────────────────────────────────
  static const appTitle = 'Cordelia Base';

  // ── Jokes feature ─────────────────────────────────────────────────────────
  static const jokeAppBarTitle   = 'Dad Jokes';
  static const jokeFabTooltip    = 'Random joke';
  static const jokeSheetTitle    = 'Dad Joke';
  static const jokeCardBadge     = 'Dad Joke';
  static const jokeEmptyTitle    = 'Ready for a laugh?';
  static const jokeEmptySubtitle = 'Search above or tap below for a random joke.';
  static const jokeEmptyButton   = 'Get a Random Joke';
  static const jokeSearchHint    = 'Search jokes...';
  static const jokeLoadMore      = 'Load More';

  static String jokeResultsCount(int count) => '$count jokes found';

  static const List<String> jokeQuickFilters = [
    'cat', 'dog', 'math', 'music', 'computer',
  ];

  // ── For You tab ───────────────────────────────────────────────────────────
  static const jokeForYouTabTitle  = 'For You';
  static const jokeSearchTabTitle  = 'Search';
  static const jokeTapForMore      = 'Tap for more';
  static const jokeSheetKeepButton = 'Keep this one';
  static const jokeSearchEmptyHint = 'Search for a joke above';

  // ── Shared UI ─────────────────────────────────────────────────────────────
  static const retryButton = 'Retry';
}
