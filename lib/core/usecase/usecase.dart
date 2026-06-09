abstract class UseCase<Output, Param> {
  const UseCase();
  Future<Output> call(Param params);
}

/// Pass to use cases that require no input parameters.
class NoParams {
  const NoParams();
}
