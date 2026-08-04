import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

/// Debounce + switchMap: waits out the typing burst, then cancels any
/// in-flight request when a newer event arrives — so results can never come
/// back out of order. The default duration is the app's one search-debounce
/// window; `SearchBloc` and `DiscoveryBloc` were each carrying a verbatim
/// copy of both the transformer and the 300ms constant.
EventTransformer<E> debounceRestartable<E>([
  Duration duration = const Duration(milliseconds: 300),
]) =>
    (events, mapper) => events.debounce(duration).switchMap(mapper);
