# SOLID Principles in FlutterAgentic

This project applies all five SOLID principles. Every principle maps directly to a rule enforced by the linter, the forbidden-pattern checklist, or the layer structure. Read this alongside `docs/reference/architecture.md`.

---

## S — Single Responsibility Principle

> A class should have only one reason to change.

Each artifact in this codebase owns exactly one concern:

| Artifact | Its single concern |
|---|---|
| `ScannedReceiptEntity` | Shape of receipt data — no fetch, no display, no persistence |
| `EditReceiptUseCase` | Edit business rule: which fields are mutable, what status to set |
| `ReceiptScanRepositoryImpl` | Translation between storage/network and domain |
| `DocScannerBloc` | State transitions for the scan screen — nothing else |
| `AppButton` | Rendering a button — never reads BLoC or has side-effects |
| `DocScannerLocalDataSourceImpl` | Reading/writing receipts from on-device storage |

**Consequence:** a change to the JSON key names for a receipt touches only `ScannedReceiptModel`. A change to what "editing" means touches only `EditReceiptUseCase`. A UI redesign of the button touches only `AppButton`. None of these ripple into each other.

**Forbidden patterns that enforce SRP:**
- Business logic in `build()` or widget classes — UI has one job.
- More than one feature's logic in a single BLoC.
- `*Model` classes exposed outside `data/` — model and entity are separate concerns.

---

## O — Open/Closed Principle

> Software entities should be open for extension but closed for modification.

Extension points are provided by base classes and interfaces. New features extend them without touching the base.

```dart
// UseCase<Output, Param> — any new use case extends, never modifies the base
class EditReceiptUseCase
    extends UseCase<Either<Failure, ScannedReceiptEntity>, EditReceiptParams> {
  @override
  Future<Either<Failure, ScannedReceiptEntity>> call(EditReceiptParams p) async { ... }
}

// BaseRepository — mixin adds handleRequest(); new repos mixin it, never change it
class JokesRepositoryImpl with BaseRepository implements JokesRepository { ... }

// Failure sealed class — add a new variant without touching existing ones or their callers
sealed class Failure { ... }
class ServerFailure extends Failure { ... }
class NetworkFailure extends Failure { ... }  // new variant, existing code unaffected
```

**Consequence:** adding a new feature never requires editing `BaseRepository`, `UseCase`, `BaseScreen`, or `BasePage`. Adding a new failure type never requires editing existing `fold()` calls — the compiler flags any exhaustive `switch` that doesn't handle the new variant.

---

## L — Liskov Substitution Principle

> Subtypes must be substitutable for their base types without altering correctness.

Every repository interface in `domain/` is implemented in `data/`. Use cases and BLoCs are coded exclusively to the interface. A fake, a stub, or a different backend implementation can be swapped in transparently.

```dart
// domain/ — the contract
abstract interface class ReceiptScanRepository {
  Future<Either<Failure, ScannedReceiptEntity>> scanReceipt({ ... });
}

// data/ — the real implementation
class ReceiptScanRepositoryImpl implements ReceiptScanRepository { ... }

// test/helpers/ — a manual fake; substitutable everywhere the interface is accepted
class FakeReceiptScanRepository implements ReceiptScanRepository {
  Either<Failure, ScannedReceiptEntity> result = right(fakeEntity);

  @override
  Future<Either<Failure, ScannedReceiptEntity>> scanReceipt({ ... }) async => result;
}
```

**Consequence:** unit tests never hit the network. Widget tests never exercise real BLoC logic. Any concrete `*RepositoryImpl` can be replaced by an offline, cached, or test variant without changing a single line of use case or BLoC code.

---

## I — Interface Segregation Principle

> Clients should not be forced to depend on interfaces they do not use.

Each feature owns its own narrow repository interface. No shared "mega-repository" exists.

```dart
// Jokes feature — its own interface, nothing from doc_scanner leaks in
abstract interface class JokesRepository {
  Future<Either<Failure, JokeEntity>> getRandomJoke();
  Future<Either<Failure, JokeSearchResponseEntity>> searchJokes({ ... });
}

// Doc scanner feature — completely separate interface
abstract interface class ReceiptScanRepository {
  Future<Either<Failure, ScannedReceiptEntity>> scanReceipt({ ... });
  Future<Either<Failure, Unit>> saveReceipt({ ... });
  // ...
}
```

Within the doc scanner, the remote and local data sources are also segregated into two separate interfaces (`DocScannerRemoteDataSource`, `DocScannerLocalDataSource`). `EditReceiptUseCase` only calls `saveReceipt` — it has no visibility into scanning or PDF generation.

**Consequence:** `GetRandomJokeUseCase` cannot accidentally call a receipt method. A change to `ReceiptScanRepository` never triggers recompilation of jokes code.

---

## D — Dependency Inversion Principle

> High-level modules should not depend on low-level modules. Both should depend on abstractions.

The dependency graph always points inward toward `domain/`. Concrete implementations are wired only at the composition root (`injection_container.dart`).

```
DocScannerBloc (high-level)
  → EditReceiptUseCase (abstraction via UseCase<>)
      → ReceiptScanRepository (abstraction — interface in domain/)
          → ReceiptScanRepositoryImpl (low-level concrete, in data/)
              → DocScannerLocalDataSource (abstraction — interface in data/)
                  → DocScannerLocalDataSourceImpl (concrete)
```

```dart
// domain/ has zero imports from data/ or flutter_bloc or dio — it only knows abstractions
// data/ may import domain/ (for entities and interfaces) — never the reverse
// presentation/ may import domain/ use cases — never data/ repositories or models

// GetIt wires concretions; nothing else knows about them
sl.registerLazySingleton<ReceiptScanRepository>(
  () => ReceiptScanRepositoryImpl(sl(), sl()),   // concrete, registered once
);
sl.registerLazySingleton(() => EditReceiptUseCase(sl())); // receives the interface
```

`domain/` imports no Flutter packages, no Dio, no BLoC. It is a pure Dart layer. The compiler enforces this because nothing in `domain/` can reach the concretions registered in GetIt.

**Consequence:** swapping from a REST backend to GraphQL, changing the local database, or upgrading Dio only touches `data/` and `injection_container.dart`. Every use case, BLoC, and test stays unchanged.

---

## How the Principles Interact

The five principles reinforce each other:

- **SRP** keeps classes small enough that **OCP** extension points are easy to see.
- **LSP** makes **DIP** safe — if subtypes behave correctly, inverting to interfaces is risk-free.
- **ISP** keeps interfaces narrow enough that **LSP** is easy to satisfy — a fake only needs to implement a handful of methods.
- **DIP** enables **OCP** — because high-level code depends on abstractions, low-level implementations can be swapped or extended without modifying callers.

When you add a new feature, follow `docs/how-to/add-feature-template.md`. The template embeds all five principles: a domain interface (DIP + ISP), a use case per action (SRP + OCP), and an impl that implements the interface (LSP).
