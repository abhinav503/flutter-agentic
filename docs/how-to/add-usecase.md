# How to Add a Use Case

> **Diataxis type:** How-to guide.
> Prerequisites: entity and repository interface already exist for this feature.
> For layer rules see `docs/ai-rules/conventions.md`.

---

## Before you begin

- `{Feature}Entity` exists in `domain/entities/`
- `{Feature}Repository` interface has the method you need
- Use `NoParams` for no-input use cases; define `{Action}Params` in the same file otherwise

---

## Step 1 — Create the use case

`lib/feature/{feature}/domain/usecase/{action}_usecase.dart`

**No parameters:**

```dart
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/{feature}_entity.dart';
import '../repository/{feature}_repository.dart';

class {Action}UseCase extends UseCase<Either<Failure, {Feature}Entity>, NoParams> {
  final {Feature}Repository _repository;
  const {Action}UseCase(this._repository);

  @override
  Future<Either<Failure, {Feature}Entity>> call(NoParams params) =>
      _repository.{action}();
}
```

**With parameters** — define params in the same file:

```dart
class {Action}Params {
  final String id;
  const {Action}Params({required this.id});
}

class {Action}UseCase extends UseCase<Either<Failure, {Feature}Entity>, {Action}Params> {
  final {Feature}Repository _repository;
  const {Action}UseCase(this._repository);

  @override
  Future<Either<Failure, {Feature}Entity>> call({Action}Params params) =>
      _repository.{action}(id: params.id);
}
```

---

## Step 2 — Register in DI

`lib/core/di/injection_container.dart` — add after the repository registration:

```dart
sl.registerLazySingleton(() => {Action}UseCase(sl()));
```

`sl()` resolves `{Feature}Repository` from the already-registered lazy singleton.

---

## Step 3 — Verify

```bash
make analyze
```

- [ ] No analysis issues
- [ ] Use case registered after its repository in `injection_container.dart`
- [ ] No `dio`, `retrofit`, or Flutter imports in the use case file
