# SOLID Principles — A Complete Tutorial

SOLID is a set of five object-oriented design principles introduced by Robert C. Martin (Uncle Bob). They make software easier to understand, change, and test. Each letter stands for one principle.

---

## S — Single Responsibility Principle (SRP)

> **A class should have only one reason to change.**

A class is doing too much if a change in one unrelated area forces you to touch it. Split it so each class owns exactly one concern.

### ❌ Violation

```dart
class UserService {
  // Reason 1: user data management
  User getUserById(String id) { ... }
  void saveUser(User user) { ... }

  // Reason 2: email sending — completely different concern
  void sendWelcomeEmail(User user) { ... }
  void sendPasswordReset(User user) { ... }

  // Reason 3: report generation — yet another concern
  String generateUserReport(User user) { ... }
}
```

If the email provider changes → you edit `UserService`.
If the report format changes → you edit `UserService`.
If the database changes → you edit `UserService`.
**Three reasons to change = three responsibilities.**

### ✅ Correct

```dart
class UserRepository {
  User getUserById(String id) { ... }
  void saveUser(User user) { ... }
}

class EmailService {
  void sendWelcomeEmail(User user) { ... }
  void sendPasswordReset(User user) { ... }
}

class UserReportGenerator {
  String generateUserReport(User user) { ... }
}
```

Now each class has exactly one reason to change.

### Real-world analogy

A chef cooks. A waiter serves. A cashier handles payment. Each has one job. You don't ask the chef to take payment just because they're both in the restaurant.

---

## O — Open/Closed Principle (OCP)

> **Software entities should be open for extension but closed for modification.**

You should be able to add new behaviour without editing existing, tested code. Achieve this through abstractions (interfaces or abstract classes) so new variants plug in without touching old logic.

### ❌ Violation

```dart
class DiscountCalculator {
  double calculate(String customerType, double price) {
    if (customerType == 'regular') return price * 0.95;
    if (customerType == 'premium') return price * 0.80;
    if (customerType == 'vip') return price * 0.70;
    // Adding 'employee' discount means editing this method → violation
    return price;
  }
}
```

Every new customer type requires modifying `DiscountCalculator` and re-testing every branch.

### ✅ Correct

```dart
abstract interface class DiscountStrategy {
  double apply(double price);
}

class RegularDiscount implements DiscountStrategy {
  @override double apply(double price) => price * 0.95;
}

class PremiumDiscount implements DiscountStrategy {
  @override double apply(double price) => price * 0.80;
}

class VipDiscount implements DiscountStrategy {
  @override double apply(double price) => price * 0.70;
}

// Adding employee discount = new class, zero modification to existing code
class EmployeeDiscount implements DiscountStrategy {
  @override double apply(double price) => price * 0.60;
}

class DiscountCalculator {
  double calculate(DiscountStrategy strategy, double price) =>
      strategy.apply(price);
}
```

`DiscountCalculator` is **closed** — it never changes. `DiscountStrategy` is **open** — new types plug in freely.

### Real-world analogy

A power strip is open to new devices (extension) — you just plug them in. But you never have to rewire the house (modification) to add a new appliance.

---

## L — Liskov Substitution Principle (LSP)

> **Objects of a subtype must be substitutable for objects of their base type without altering the correctness of the program.**

If `S` is a subtype of `T`, you should be able to use an `S` wherever a `T` is expected and everything should still work correctly. A subclass should honour the contract its parent established — not weaken preconditions, not strengthen postconditions, not throw unexpected exceptions.

### ❌ Violation

```dart
class Rectangle {
  double width;
  double height;
  Rectangle(this.width, this.height);
  double area() => width * height;
}

class Square extends Rectangle {
  Square(double side) : super(side, side);

  @override
  set width(double value) {
    super.width = value;
    super.height = value; // maintains square invariant
  }

  @override
  set height(double value) {
    super.width = value;
    super.height = value;
  }
}

void setDimensions(Rectangle r) {
  r.width = 4;
  r.height = 5;
  // Expected area: 20. For Square it's 25. Behaviour changed → LSP violation.
  assert(r.area() == 20);
}
```

`Square` breaks the contract of `Rectangle` — a caller who expects width and height to be independent gets surprised.

### ✅ Correct

```dart
abstract interface class Shape {
  double area();
}

class Rectangle implements Shape {
  final double width;
  final double height;
  const Rectangle(this.width, this.height);
  @override double area() => width * height;
}

class Square implements Shape {
  final double side;
  const Square(this.side);
  @override double area() => side * side;
}

void printArea(Shape shape) {
  // Works correctly for any Shape — Rectangle or Square
  print(shape.area());
}
```

Both types implement `Shape` and honour its contract. No surprises.

### Signs of LSP violation to watch for

- Overridden methods that throw `UnsupportedError` or do nothing
- Subclasses that check `if (this is Subtype)` in the parent
- Comments like "don't call this on a Square"

### Real-world analogy

Every car, regardless of make, has an accelerator, brake, and steering wheel that work the same way. A rental driver doesn't need to relearn driving for each model.

---

## I — Interface Segregation Principle (ISP)

> **Clients should not be forced to depend on interfaces they do not use.**

Fat interfaces force implementors to provide methods they don't need, leading to empty or `UnsupportedError` implementations. Split large interfaces into smaller, focused ones.

### ❌ Violation

```dart
abstract interface class Animal {
  void eat();
  void sleep();
  void fly();   // ← forces Dog and Fish to implement this
  void swim();  // ← forces Eagle to implement this
  void bark();  // ← forces Cat and Eagle to implement this
}

class Dog implements Animal {
  @override void eat() { ... }
  @override void sleep() { ... }
  @override void fly() => throw UnsupportedError('Dogs cannot fly');  // ❌
  @override void swim() { ... }
  @override void bark() { ... }
}
```

`Dog` is forced to "implement" flying even though it can't. Any caller holding a `Dog` as `Animal` might call `fly()` and crash.

### ✅ Correct

```dart
abstract interface class Eater  { void eat(); }
abstract interface class Sleeper { void sleep(); }
abstract interface class Flier  { void fly(); }
abstract interface class Swimmer { void swim(); }
abstract interface class Barker { void bark(); }

class Dog implements Eater, Sleeper, Swimmer, Barker {
  @override void eat() { ... }
  @override void sleep() { ... }
  @override void swim() { ... }
  @override void bark() { ... }
  // No fly() — Dog simply doesn't implement Flier
}

class Eagle implements Eater, Sleeper, Flier {
  @override void eat() { ... }
  @override void sleep() { ... }
  @override void fly() { ... }
}
```

Each class implements only what it actually does. Callers that need a `Flier` ask for `Flier` — they can't accidentally pass a `Dog`.

### Real-world analogy

A printer interface should have `print()`. A scanner interface should have `scan()`. A multifunction device implements both. A basic printer implements only the first — it shouldn't be forced to have a `scan()` that throws an error.

---

## D — Dependency Inversion Principle (DIP)

> **High-level modules should not depend on low-level modules. Both should depend on abstractions. Abstractions should not depend on details. Details should depend on abstractions.**

Business logic (high-level) should not import infrastructure (low-level) directly. Both should talk through an interface. The concrete implementation is provided at startup (the "composition root") — typically via dependency injection.

### ❌ Violation

```dart
// Low-level: concrete MySQL database
class MySqlDatabase {
  void save(String data) { ... }
  String load(String id) { ... }
}

// High-level: business logic directly depends on MySqlDatabase
class UserService {
  final MySqlDatabase _db = MySqlDatabase(); // ❌ tight coupling

  void createUser(String name) {
    _db.save(name);
  }
}
```

`UserService` is tightly coupled to MySQL. Switching to PostgreSQL or a test in-memory store requires rewriting `UserService`.

### ✅ Correct

```dart
// Abstraction — lives in the business/domain layer
abstract interface class UserStorage {
  void save(String data);
  String load(String id);
}

// Low-level detail — depends on the abstraction
class MySqlStorage implements UserStorage {
  @override void save(String data) { /* MySQL implementation */ }
  @override String load(String id) { /* MySQL implementation */ }
}

class InMemoryStorage implements UserStorage {
  final _store = <String, String>{};
  @override void save(String data) => _store[data] = data;
  @override String load(String id) => _store[id] ?? '';
}

// High-level business logic — depends only on the abstraction
class UserService {
  final UserStorage _storage;
  const UserService(this._storage); // injected from outside

  void createUser(String name) => _storage.save(name);
}

// Composition root — the only place that knows about concretions
void main() {
  final service = UserService(MySqlStorage()); // production
  // or
  final testService = UserService(InMemoryStorage()); // tests
}
```

`UserService` never imports `MySqlStorage`. Swapping storage is a one-line change at the composition root.

### The Dependency Rule visualised

```
┌─────────────────────────────┐
│   Presentation / UI         │  depends on ↓
├─────────────────────────────┤
│   Business Logic / Domain   │  depends on ↓ (abstractions only)
├─────────────────────────────┤
│   Data / Infrastructure     │  implements the abstractions ↑
└─────────────────────────────┘

Arrows of dependency point INWARD (toward business logic).
Business logic never imports infrastructure — ever.
```

### Real-world analogy

A lamp doesn't care which power plant generated the electricity. It depends on the socket standard (abstraction). The power plant (concrete) also follows that standard. You can switch from coal to solar without rewiring your lamp.

---

## How the Five Principles Work Together

| Principle | Core question |
|---|---|
| **SRP** | Does this class have more than one reason to change? |
| **OCP** | Can I add new behaviour without editing existing classes? |
| **LSP** | Can I use a subtype anywhere the base type is expected? |
| **ISP** | Am I forced to implement methods I don't use? |
| **DIP** | Does my business logic import concrete infrastructure? |

Run through these five questions when reviewing any new class or interface. If the answer to any is "yes", the design needs to be split, extracted, or abstracted.

---

## Quick Reference

```
S — One class, one job
O — Add new code; don't change old code
L — Subtypes keep the contract of their base type
I — Small interfaces beat one big one
D — Depend on interfaces, not implementations
```

---

## Further Reading

- *Clean Code* — Robert C. Martin
- *Clean Architecture* — Robert C. Martin
- *Design Patterns: Elements of Reusable Object-Oriented Software* — Gang of Four
- How this project applies all five principles → `docs/explanation/solid-in-flutteragentic.md`
