# How to Design a BLoC — Events, States, and Screen Flow

> Architecture reference: `docs/reference/architecture.md`
> Forbidden patterns: `docs/ai-rules/conventions.md`

This guide explains how to think about BLoC design before writing a single line of code. The decisions made here — what events exist, what states exist, what data each state carries — determine whether the screen is a dumb renderer or a mess of conditional logic. Use the jokes feature as the reference throughout.

---

## The core rule: describe business reality, not technical operations

**Events are user intentions.** They answer: *what did the user mean to do?*
**States are business outcomes.** They answer: *what is true about the world right now?*

Neither should describe implementation details like HTTP calls, loading flags, or widget visibility.

---

## Designing events

Ask: *what can the user trigger on this screen?*

| ❌ Technical (wrong) | ✅ Intentional (correct) |
|---|---|
| `fetchJoke()` | `started()` |
| `fetchNextJoke()` | `nextRequested()` |
| `callSearchApi({term})` | `submitted({term})` |
| `triggerLoadMore()` | `loadMore()` |
| `selectFilterChip({term})` | `chipSelected({term})` |

The ForYou screen has two user intentions:

```dart
// apps/jokes/lib/feature/home/presentation/bloc/for_you_event.dart
sealed class ForYouEvent with _$ForYouEvent {
  const factory ForYouEvent.started()       = ForYouStarted;       // page opened
  const factory ForYouEvent.nextRequested() = ForYouNextRequested; // user tapped next
}
```

`nextRequested` — not `fetchNextJoke`. The BLoC decides what fetching to do. The screen just reports the intention.

The Search screen has three user intentions:

```dart
// apps/jokes/lib/feature/home/presentation/bloc/search_page_event.dart
sealed class SearchPageEvent with _$SearchPageEvent {
  const factory SearchPageEvent.submitted({required String term})  = SearchPageSubmitted;
  const factory SearchPageEvent.chipSelected({required String term}) = SearchPageChipSelected;
  const factory SearchPageEvent.loadMore()                          = SearchPageLoadMore;
}
```

`submitted` and `chipSelected` both ultimately trigger a search, but they are *different user intentions* — the BLoC may handle them differently (chip resets page, submitted shows keyboard-dismiss first, etc.). Don't collapse them into one event just because the effect is the same today.

---

## Designing states

Ask: *what are the distinct things that can be true about this screen?*

Each state should represent one observable moment in the user's experience — not a combination of nullable flags.

### What not to do

```dart
// ❌ — loading flag + nullable data = implicit states, no compiler help
class JokeState {
  final bool isLoading;
  final JokeEntity? joke;
  final String? error;
}
```

This forces the screen to reason about which combination of fields is valid. That's business logic leaking into the UI.

### What to do

```dart
// ✅ — sealed states, every case is explicit
sealed class ForYouState with _$ForYouState {
  const factory ForYouState.loading()                              = ForYouLoading;
  const factory ForYouState.loaded({
    required JokeEntity joke,
    @Default(false) bool isFetchingNext,
  })                                                               = ForYouLoaded;
  const factory ForYouState.nextFetchFailed({
    required JokeEntity currentJoke,
    required String message,
  })                                                               = ForYouNextFetchFailed;
  const factory ForYouState.error({required String message})       = ForYouError;
}
```

### Why `nextFetchFailed` is a separate state

When the user taps "next" and the request fails, the screen should keep showing the current joke — not blank out and show a full-screen error. That's a distinct business outcome from a cold `error` (where there was never anything to show).

`nextFetchFailed` carries `currentJoke` so the screen can keep rendering it, and `message` for the snackbar. The screen never has to look at a previous state to recover context.

```dart
// screen handles it cleanly — no prior state inspection
ForYouNextFetchFailed(:final currentJoke) => JokeCard(joke: currentJoke, ...),
```

---

## States must carry retry context

Every error state must carry enough data for the BLoC to re-run the operation without reading prior state.

```dart
// ✅ — error carries searchTerm; screen can retry without reading prior state
const factory SearchPageState.error({
  required String message,
  required String searchTerm,
}) = SearchPageError;

// in screen:
SearchPageError(:final message, :final searchTerm) => ErrorView(
  message: message,
  onRetry: () => context.read<SearchPageBloc>()
      .add(SearchPageEvent.submitted(term: searchTerm)),
),
```

If the error state doesn't carry `searchTerm`, the screen has to read prior state to retry — which is forbidden (`if (state is SearchPageLoaded)` pattern).

---

## States carry all data needed to render — nothing more, nothing less

The loaded state of the search screen carries pagination context because the screen needs to know when to show "load more" and what page it's on:

```dart
const factory SearchPageState.loaded({
  required List<JokeEntity> results,
  required int totalJokes,
  required int totalPages,
  required int currentPage,
  required String searchTerm,     // needed to retry or load more
  @Default(false) bool isLoadingMore,
}) = SearchPageLoaded;
```

`isLoadingMore` lives in the state — not as a local `setState` variable — because it's derived from a BLoC operation (a second API call), not from a user gesture like a tap animation.

---

## The screen is a pure renderer

Once events and states are designed correctly, the screen becomes a `switch` with no logic:

```dart
builder: (context, state) => switch (state) {
  ForYouLoading()                           => const LoadingIndicator(),
  ForYouLoaded(:final joke, :final isFetchingNext)
                                            => JokeCard(joke: joke, isFetchingNext: isFetchingNext),
  ForYouNextFetchFailed(:final currentJoke) => JokeCard(joke: currentJoke),
  ForYouError(:final message)               => ErrorView(message: message),
},
```

Side effects (snackbars, navigation) go in `listener`, not `builder`:

```dart
listener: (context, state) {
  if (state case ForYouNextFetchFailed(:final message)) showSnackBar(message);
},
```

The screen renders. The BLoC decides. Never the other way around.

---

## Naming checklist

Before finalising events and states, run through this:

**Events**
- [ ] Does each event name describe what the *user* did, not what the system will do?
- [ ] Are distinct user intentions modelled as distinct events, even if the effect is the same?
- [ ] Does each event carry only the data the user provided (e.g. `term`), not derived data?

**States**
- [ ] Is each state a distinct, observable moment — not a flag combination?
- [ ] Does every error state carry enough context to retry without reading prior state?
- [ ] Does the loaded state carry everything the screen needs to render (pagination, search term, inline loading flags)?
- [ ] Is there no data in state that the screen never reads?

---

## Summary

| Concept | Rule |
|---|---|
| Event names | User intentions, not API calls |
| State names | Business outcomes, not loading flags |
| Error states | Always carry retry context |
| Loaded states | Carry all render data; nothing derived at render time |
| Screen builder | Pure `switch(state)` — zero logic |
| Side effects | Listener only — snackbars, navigation, never state reads |
