# What a full code review taught us

A fifty-item review of one mature app (`apps/ecommerce/cordelia`, three style
packs, seven locales) plus the fixes it produced. Everything below is stated
generically, because the point is the **next** app: these are the failure
modes an app of this shape grows on its own, and the rules that stop a
generated one growing them.

Each lesson is: what happened, why it happened, and the rule that follows.
Where a rule is enforceable it has since been written into
`docs/ai-rules/conventions.md` or `docs/reference/architecture.md`; this file
keeps the reasoning those one-liners can't carry.

---

## 1. Reuse decays quietly

### 1.1 Promotion isn't finished until the call sites move

Six widgets had been extracted into `core` and then **never adopted** — zero
usages, while the hand-rolled code they were extracted *from* still shipped in
every pack. One of them documented its own intent ("packs keep a thin wrapper
over this") and had none.

Extraction feels like the work; adoption is the work. A promotion that stops
at "the shared version now exists" leaves the codebase strictly worse than
before: the duplication is still there, and now there is a second thing to
keep in step with it.

> **Rule.** Promoting and adopting are one task, in one commit. A widget in
> `core/ui/` with no callers is a defect, not a head start.

### 1.2 A fork is usually a missing parameter

Nearly every pack-local copy existed because the shared version lacked exactly
**one** knob — a pinned-header mode, a subtitle line, an asset shorthand, a
ripple, a text alignment, a corner radius. The pack did not want a different
widget. It wanted one more parameter and had no way to ask for one.

> **Rule.** Before forking a shared widget, name the single parameter that is
> missing. If you can name it, add it instead.

### 1.3 …but three parameters means the fork was right

The opposite failure is worse and harder to undo. Several variants needed
**three or more** new configuration parameters to absorb — a different
disabled treatment, a fixed-width slot, its own semantics, no ripple. Adding
those turns the shared widget into a switchboard and each caller into an
override list, and the next reader can no longer tell what the widget *is*.

Some of those forks already carried a comment explaining the decision. The
review proposed undoing them anyway, because a reviewer counting duplication
sees the similarity and not the reasoning.

> **Rule.** If absorbing a variant needs three or more new config params, the
> fork is correct. Write the reason in the file so the next review doesn't
> re-litigate it.

### 1.4 Extract against the right base

Two pack widgets looked like forks of a settings-row molecule. They were not —
they were forks of a *different* molecule's row silhouette. Extracting against
the wrong base would have needed four new parameters; against the right one it
needed one.

> **Rule.** When something looks duplicated, find what it is duplicating
> before deciding where it belongs.

### 1.5 An abstraction earns its keep if it survives the second implementation

The test that settled every "should this be a port?" argument: *would this
interface still be right for a different provider?* Members every provider
models the same way are safe. Anything shaped like one vendor's SDK is not —
it puts the vendor straight back into the callers.

---

## 2. Copy and localisation

### 2.1 English-identical is not identical

Two sets of strings looked like exact duplicates and were, **in English**. In
four other languages one set was a width-budgeted short form for a small badge
and the other an uncapped long form for a timeline. Merging them would have
overflowed the badge in every one of those languages.

> **Rule.** Never deduplicate copy by comparing the source-language value.
> Compare every locale, or don't merge.

### 2.2 Width budgets belong in a test

The bad merge above was caught in seconds, by a test that asserts a maximum
character count for every string that lands in a narrow slot. Nothing else
would have caught it before a screenshot in a language nobody on the team
reads.

> **Rule.** Ship the width-budget test with the first locale, not the third.

### 2.3 Translation drift hides where nobody looks

One pack's badge said *"pending"* in three languages where the source said
*"placed"*. A sibling pack's copies of the same string had been corrected; this
one was missed. It surfaced only because a merge attempt forced a
locale-by-locale diff.

> **Rule.** When the same concept has copies per pack, a fix to one is a bug
> report for the others.

### 2.4 Never show transport or SDK text to a user

An HTTP client's own message — a hostname and a library disclaimer — was what
**every** screen printed when the network dropped, in the source language,
whatever the app's locale. Separately, two payment SDKs' English was forwarded
straight to shoppers.

> **Rule.** One mapper at the presentation boundary turns a failure into
> words. Rewrite only what was never written for a person; a server refusal or
> an app-authored message passes through untouched.

---

## 3. Errors, async and state

### 3.1 Cross a boundary with a reason, not a sentence

A server refused an operation for two distinct reasons and tagged each with a
machine-readable code. Only the human sentence survived the trip into the app,
so the screen could print it but not *act* on it — and handled one refusal as
though it were the other.

> **Rule.** A failure that a caller should react to differently carries a
> code, not just a message. The code is parsed once, at the layer that owns
> the vocabulary.

### 3.2 A modal covers the surface underneath it

Validation from inside a bottom sheet was sent to the host screen's snack bar
— which renders behind the modal barrier. Submitting an incomplete form did
nothing observable at all.

> **Rule.** A sheet reports its own validation inline. If a screen also
> reports it, the state carries a flag saying the sheet already has it.

### 3.3 Don't close a surface before the write is confirmed

Submit dispatched and popped in the same breath, so a failure arrived over an
empty screen and the composer — with everything the user had typed — was
already disposed.

> **Rule.** An async submit resolves before its surface closes. On failure the
> surface stays, holding the input, with the reason in it.

### 3.4 A handler that can decline to emit cannot be awaited

Making the above work meant awaiting the state machine's answer. One handler
returned silently on a guard clause, which would have left the sheet waiting
forever.

> **Rule.** If anything awaits a handler, every path through it answers —
> including the guards. Emitting a state equal to the current one is not an
> answer: value-equal states are dropped.

### 3.5 Resetting state must invalidate work already in flight

A sign-out cleared the in-memory basket but did not invalidate the fetch
already in the air, which then repainted the previous account's data onto a
signed-out device.

> **Rule.** A reset bumps whatever guard token in-flight work checks, and
> clears the scope key, so a late result can identify itself as unwanted.

### 3.6 Guard with an allowlist

A router listed the destinations to **block** for signed-out users. Five
account-only routes had been added since and were never added to the list.

> **Rule.** Guards enumerate what is permitted. A new route is then refused
> until someone decides it is safe, instead of inheriting a pass.

### 3.7 "Unreachable" branches get reached

A state rendered a loading skeleton behind a comment asserting the screen was
gated and the state impossible. It was reachable, and the skeleton span
forever.

> **Rule.** Every branch renders something a user could live with. A comment
> is not a guarantee, and the cost of being wrong is measured in how bad the
> branch looks.

---

## 4. Widget tree and navigation

### 4.1 Position in the tree decides what a widget can reach

A helper called from a page's own context tried to read a bloc provided
*below* it, threw a not-found, and had that swallowed by a deliberate
try/catch. The screen sat on a skeleton for the rest of the session.

The fix was not a better lookup. It was making the derived state **follow its
source** — subscribing to the thing it depends on, rather than waiting to be
notified by whichever screen happened to be nearby.

> **Rule.** State derived from a global fact (who is signed in, which store is
> open) subscribes to that fact. Anything that must be told is a bug waiting
> for a caller in the wrong place.

### 4.2 The same destination twice is still two requests

A route reacted to its arguments changing. A second navigation to the *same*
destination with the *same* arguments was therefore indistinguishable from an
ordinary rebuild, and ignored — so the action worked exactly once per session
and was then silently dead.

Reacting to every rebuild is the opposite bug: it drags the user back off
whatever they had since chosen.

> **Rule.** A navigation request needs an identity separate from its payload —
> a counter, stamped per call. Compare the identity, not the arguments.

### 4.3 Prefer changing state to re-navigating

Two in-app "jumps" re-entered a route to reach a tab the caller was already
inside. Replacing them with a direct tab change deleted the round trip, three
imports (including a screen importing the shell that builds it), and a visible
inconsistency where the first use animated and later ones did not.

> **Rule.** If the destination is already in the tree, change state. Navigate
> only to somewhere you are not.

---

## 5. Tests

### 5.1 A test that reaches the network tests someone's deployment

Widget tests ran the real dependency graph against a live API. They passed for
as long as that environment answered and began failing the day it stopped —
with the fakes they needed already sitting unused in the test helpers folder.

> **Rule.** No test touches the network. Fakes are injected at the boundary,
> and the boundary is named in the architecture doc so there is no argument
> about where.

### 5.2 A test seam in production code is a missing dependency boundary

A static override was added so a widget test could say "signed in", because
nothing else could express it. The right fix was the port that should have
existed: with the dependency injected, the seam deleted itself — and two code
paths became testable that never had been, including the one behind a live
bug.

> **Rule.** When a test needs a seam, the design is missing a boundary. Add
> the boundary. Global mutable state that exists only for tests outlives the
> test that set it.

### 5.3 Empty and failed must not render the same

A subscription with no error callback swallowed every failure. The list
rendered "nothing here" for permission-denied, offline and genuinely-empty
alike — which is exactly how a populated collection was reported as empty and
cost a full investigation to explain.

> **Rule.** Every subscription has an error path. An empty state and an error
> state never share a rendering.

### 5.4 A review finding is a hypothesis

Of the fifty items, several were wrong in ways that looked completely
convincing: three states flagged for missing retry context each retried
correctly through a parameterless event; a "structurally identical" entity pair
was two distinct concepts; the copy merge in §2.1 was actively harmful. Each
had been derived from the letter of a rule without following the code path the
rule exists to protect.

> **Rule.** Verify a finding by reading the path it claims is broken. When the
> claim is behavioural, reproduce it — one navigation bug here was only
> settled by an actual runnable repro, and the leading theory was wrong.

---

## 6. Enforcement

### 6.1 Rules without a check drift

The forbidden-pattern list was largely honoured — and had drifted in exactly
the places nothing verified: the same closure written thirteen times, one
constant declared three times, one hardcoded pair of numbers repeated in three
files.

> **Rule.** A convention worth writing down is worth a grep in review. The
> ones that survive are the ones something checks.

### 6.2 Pin the formatter

A formatter version difference swept dozens of untouched files into diffs,
repeatedly, obscuring real changes and nearly landing unrelated churn in
several commits.

> **Rule.** Pin the formatter version in the toolchain, and never format
> directories the change didn't touch.
