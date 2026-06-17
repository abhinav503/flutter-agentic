abstract class UseCase<Output, Param> {
  const UseCase();
  Future<Output> call(Param params);
}

/// For operations that emit multiple values over time — server-sent events
/// (SSE), sockets, or LLM token streams. Mirrors [UseCase] but returns a
/// [Stream] instead of a [Future]. The output is typically
/// `Either<Failure, T>` so both error and success flow through the stream.
abstract class StreamUseCase<Output, Param> {
  const StreamUseCase();
  Stream<Output> call(Param params);
}

/// Pass to use cases that require no input parameters.
class NoParams {
  const NoParams();
}
