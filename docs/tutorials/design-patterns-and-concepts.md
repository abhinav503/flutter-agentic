# Design Patterns & Concepts

Patterns used in this codebase that are **not** SOLID principles. They come from GoF, DDD, Clean Architecture, and functional programming.

See also → `docs/tutorials/solid-principles.md`

---

## Singleton (GoF)

One instance, private constructor, static access.

```dart
class HttpService {
  HttpService._();
  static final HttpService instance = HttpService._();
}
```

**Trade-off:** callers depend on a concrete class (bends DIP), but async init and shared resources make it the right call for infrastructure. Never use for business logic.

**In this codebase:** `HttpService`, `SharedPreferenceService`, `ImagePickerService`.

---

## Repository Pattern (DDD)

Abstract interface in `domain/`, concrete impl in `data/`. Business logic never touches a database, file, or network directly.

**Trade-off:** more files, but lets you swap backends and fake in tests with zero changes to use cases or BLoCs.

**In this codebase:** every feature — `JokesRepository`, `ReceiptScanRepository`.

---

## DTO — Model vs Entity

`*Model` matches the external source (JSON keys, DB columns). `*Entity` matches what the app needs. Repository translates between them via `model.toEntity()` / `Model.fromEntity(entity)`.

**Trade-off:** two classes per concept, but API schema changes never touch business logic.

**Rule:** never expose a `*Model` outside `data/`. Never build a Model field-by-field inside a repository — use `fromEntity` / `toEntity`.

---

## Factory (GoF)

Named constructors encapsulate object creation. `fromJson`, `fromEntity`, `toEntity` are all factory methods.

**Trade-off:** construction logic lives in one place; callers never repeat field mapping.

---

## Template Method (GoF)

Base class defines the structure; subclass fills in one step.

```dart
abstract class UseCase<Output, Param> {
  Future<Output> call(Param params); // subclasses override this
}
```

`BaseRepository.handleRequest()` is the same idea — it owns the try/catch/map skeleton; data sources supply the network call.

---

## Mixin (Dart)

Share behaviour across unrelated classes without a shared parent.

```dart
class JokesRepositoryImpl with BaseRepository implements JokesRepository { ... }
```

**vs. abstract class:** a mixin can be applied alongside any parent; an abstract class forces single inheritance.

---

## Either / Result Type (Functional)

`Either<Failure, T>` holds a success (`Right`) or a failure (`Left`). Callers must handle both — the compiler won't let you ignore the failure case.

**Trade-off:** more verbose than `throw/catch`, but error paths are visible in every signature and can't be silently swallowed.

**Rule:** never `throw` across layer boundaries. `BaseRepository.handleRequest()` catches all `DioException`s and converts them to `Left(Failure)`.

---

## Value Object / Immutability (DDD)

Freezed entities are immutable. "Changing" one means producing a new instance via `copyWith`.

**Trade-off:** no accidental mutation; BLoC state is always a complete snapshot. Cost: slight object allocation overhead (negligible in practice).

---

## Sealed Classes + Exhaustive Switch (Dart 3)

All subtypes of a sealed class are known at compile time. The compiler rejects a `switch` that misses a case.

**Trade-off:** adding a new state forces you to handle it everywhere (a feature, not a bug). Requires `make gen` after every change.

**Rule:** always `switch` on BLoC states. `if (state is X)` is forbidden.

---

## Service Locator vs True DI

**Service Locator (GetIt):** caller asks a global registry for its dependency (`sl<T>()`). Less boilerplate, but dependencies are hidden — you can't tell from a constructor what a class needs.

**True DI:** dependencies are passed explicitly to constructors. More verbose at the composition root, but every dependency is visible and easily faked in tests.

**In this codebase:** GetIt for use cases and repositories. BLoCs are wired directly in `BlocProvider(create: (_) => MyBloc(useCase: sl()))` — not registered in GetIt.

---

## Strategy / Dispatcher (GoF)

A family of interchangeable algorithms behind one interface; a dispatcher picks the right one at runtime.

```dart
// Each AI provider is one strategy
class DocScannerDataSourceDispatcher implements DocScannerRemoteDataSource {
  Future<...> scanReceipt({ required model, ... }) => switch (model) {
    AiScanModel.groq   => const GroqRemoteDataSourceImpl().scanReceipt(...),
    AiScanModel.claude => const ClaudeRemoteDataSourceImpl().scanReceipt(...),
    AiScanModel.gemini => const GeminiRemoteDataSourceImpl().scanReceipt(...),
  };
}
```

**Trade-off:** new provider = new class, existing ones untouched (OCP in practice). Dispatcher must be updated when a new strategy is added.

---

## Quick Reference

| Pattern | Source | Where in this codebase |
|---|---|---|
| Singleton | GoF | `HttpService`, `SharedPreferenceService`, `ImagePickerService` |
| Repository | DDD | `JokesRepository`, `ReceiptScanRepository` |
| DTO (Model ↔ Entity) | Enterprise patterns | All `*Model` / `*Entity` pairs |
| Factory | GoF | `fromJson`, `fromEntity`, `toEntity` |
| Template Method | GoF | `UseCase.call()`, `BaseRepository.handleRequest()` |
| Mixin | Dart | `with BaseRepository` on every repository impl |
| Either / Result | Functional | `Either<Failure, T>` across all use cases |
| Value Object | DDD | All Freezed entities |
| Sealed Classes | Dart 3 | All BLoC events and states |
| Service Locator | Architecture | GetIt in `injection_container.dart` |
| Strategy / Dispatcher | GoF | `DocScannerDataSourceDispatcher` |
