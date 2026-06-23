# Product Doc — Local-First AI App Builder for Flutter

> Working title: TBD (e.g. **ForgeKit**, **NativeForge**, **AppSmith-but-local**, **FlutterAgentic Studio**).
> Status: thinking / pre-MVP. Author: Abhinav. Built on top of **FlutterAgentic**.

---

## 1. One-liner

**Lovable for mobile, but local.** An AI-driven workflow that takes you from *idea → a correctly-architected Flutter app → Firebase backend → published on the stores* — running entirely on your own machine, with your own API key, producing real code you fully own.

## 2. The thesis

The web AI-builders (Lovable, v0, bolt.new, Replit Agent) all share two traits that don't fit mobile:

1. **They depend on a hosted sandbox + instant browser preview.** That only works because JS runs in the browser. Flutter must compile Dart, so a hosted preview is slow and expensive (see the cost analysis — it's the #1 reason none of them do Flutter well).
2. **They lock you into their cloud, their billing, and one-shot messy code.**

So instead of fighting Flutter's compile step with cloud infra, **flip it**: the developer already has the Flutter toolchain on their machine. `flutter run` on an emulator/device is a *real* preview — better than any iframe. We don't rebuild the sandbox; we orchestrate the tools that are already local.

The wedge nobody else has: **architecture quality.** Generic builders emit tangled, un-maintainable code. We generate code that follows FlutterAgentic's strict, tested, AI-legible architecture — so the output is something you can actually keep building on, not throw away.

## 3. Why local + mobile + Firebase

- **Local** — no compile/preview servers to pay for (kills the biggest cost), no cloud lock-in, full privacy, your code on disk, your git history. The LLM cost is the user's own API key (BYO), not our COGS.
- **Mobile only (Flutter)** — sharp focus, and exactly where the web builders are weakest. One codebase → Android + iOS.
- **Firebase** — generous free tier for the mobile backend stack (Auth, Firestore, Storage, Cloud Messaging). Zero-config, scales later. *Caveat: Cloud Functions now require the Blaze (pay-as-you-go) plan, though it has a free monthly quota — plan around that.*

## 4. Target user

- Solo devs / indie hackers who want to ship a real mobile app fast without a builder's lock-in.
- Flutter devs who want AI speed but refuse to inherit spaghetti.
- Agencies/freelancers who repeat the same idea→app→store loop and want it productized.

## 5. How it works (architecture)

We are an **orchestration layer**, not a new IDE. The pieces, all local:

```
You (a prompt / spec)
   ↓
AI coding agent (Claude Code / Codex)   ← reads RULES (FlutterAgentic), invokes SKILLS
   ↓
Generates / edits a FlutterAgentic project on disk
   ↓
flutter run  → real preview on emulator/device      (no hosted sandbox)
Firebase      → backend (Auth, Firestore, Storage, FCM)
SKILLS        → configure signing, build, publish to stores
   ↓
A shipped, store-published app you own
```

The "product" is the **curated bundle**: the opinionated architecture (rules) + a complete set of guided **skills** that cover the whole lifecycle, wired so an agent can drive idea → store with minimal hand-holding.

## 6. Feature parity map (Lovable → our local equivalent)

| Lovable (cloud/web) | Our local-first / mobile equivalent |
|---|---|
| Prompt → app | Agent + scaffold skills generate an architected FlutterAgentic project |
| Chat-based editing | The agent edits the local repo, guided by rules (consistent, no drift) |
| Instant live preview | `flutter run` — the **real** app on emulator/device (not an iframe) |
| Hosted backend (Supabase) | Firebase: Auth, Firestore, Storage, Cloud Messaging |
| One-click deploy | Skills: configure signing, build, publish to Play Store / App Store |
| Component library | FlutterAgentic design system (atoms/molecules) + feature templates |
| Version history | Native git (full ownership, real branches) |
| Project storage | Local filesystem (+ user's own GitHub) |
| Billing per generation | BYO LLM API key — no per-generation SaaS fee |

## 7. Skills — the lifecycle (what exists vs what to build)

**Already in FlutterAgentic:**
- `setup-project` — scaffold a new app
- `add-feature-template` — scaffold a feature (data/domain/presentation + tests)
- `add-usecase`, `review-code`, `rename-app`, `change-app-id`, `release`

**New skills to build (the productizing work):**
- `generate-app-from-spec` — turn a plain-language brief into a multi-feature scaffolded app
- `firebase-setup` — wire Firebase (Auth + Firestore + Storage + FCM), config files, DI registration, security-rules starter
- `configure-android-publishing` — keystore/signing, `build.gradle` release config, versioning
- `configure-ios-publishing` — certificates/provisioning, export options (the painful one)
- `publish-to-play-store` — build AAB + upload (Codemagic/Fastlane); `publish-to-app-store` likewise
- `add-auth`, `add-push-notifications`, `add-analytics` — common feature playbooks on Firebase
- `connect-backend` — generate data sources/repos against a Firebase (or REST) schema

These are mostly **documentation + scripted workflows**, not heavy engineering — which is exactly why a solo dev can ship them.

## 8. MVP scope (what to build first)

**v1 — "Idea to running app, locally, well-architected":**
1. `generate-app-from-spec` + the existing scaffold skills → prompt produces a runnable, architected app.
2. `firebase-setup` + `add-auth` → a real backend in one guided step.
3. Polished local loop: run on device, iterate via the agent.
4. A killer README/quickstart so a stranger can do all the above in under an hour.

**Explicitly NOT in v1:** hosted preview, our own cloud, billing, iOS store automation (do Android first — it's far less painful).

**v2:** store publishing skills (Android first), more Firebase playbooks (push, analytics, storage), a thin CLI wrapper that sequences the skills.

**v3+:** optional hosted convenience (template gallery, one-click Firebase project creation), iOS publishing, team features.

## 9. Tech, cost & resourcing (solo)

- **Infra cost: ~$0 to start.** No servers. Firebase free tier. LLM cost is the user's own key.
- **Your cost = time.** v1 is mostly skill-authoring + glue + docs, leveraging what exists. Realistic solo effort to a credible v1: **~1–3 months part-time**, because you're orchestrating existing tools, not building a sandbox.
- **Your fit:** you already do backend/frontend/devops solo and own the architecture — this plays directly to that.

## 10. Risks & open questions

- **iOS publishing is genuinely hard** (certs/provisioning, needs a Mac, Apple review). Lead with Android.
- **Agent dependency** — v1 rides on Claude Code/Codex. Fine to start; note it's a dependency, not a moat. The moat is the rules + skills + Firebase glue.
- **"Local" limits the magic** — no shareable URL preview like Lovable. Counter-position: *you own real code + a real native app*, not a locked web demo.
- **Where's the business model?** Options: paid skill packs / templates, a Pro CLI, support/setup for agencies, or keep it OSS to grow the FlutterAgentic brand and monetize later. Decide before over-investing.
- **Firebase Functions need Blaze** — design v1 to avoid Functions (use client SDKs + security rules) so it stays truly free.

---

## 11. The local dashboard — the UX layer (how we compete with bolt/lovable on usability)

The CLI/agent loop (v1) is for developers. To reach the broader audience that bolt/lovable
win — people who don't want to live in an IDE — we add a **local web dashboard**: a UI you
open in Chrome/Safari at `localhost`, that orchestrates everything on your own machine. No
cloud, no compile servers — just a friendly front door to the tools already installed locally.

### What it is (architecture)

```
Browser (Chrome/Safari) @ localhost:xxxx
   │  HTTP + WebSocket (localhost only, token-guarded)
   ▼
Local control server  (Dart `shelf` or Node)
   ├─ spawns agent CLIs   → claude / codex / gemini  (stream stdout/stderr to UI)
   ├─ runs Flutter tools  → flutter run / build / devices / analyze
   ├─ runs SKILLS         → setup, add-feature, firebase-setup, publish-to-play-store…
   ├─ reads/writes files  → project tree + diffs
   └─ git, Firebase CLI, signing config
   ▼
Your Flutter project on disk  +  emulator/device
```

The dashboard is a **thin orchestrator**, not a new engine. It shells out to the same CLIs a
developer would run, and streams the results into a friendly UI. The agent (Claude/Codex/Gemini)
still does the codegen — picked from a dropdown in the UI.

### Must-have features (so the user never opens an IDE)

- **Prompt / chat panel** — type what you want; pick the **agent + model** from a dropdown
  (claude / codex / gemini). The command runs locally; output streams live.
- **Agent activity stream** — a readable mirror of what the agent is doing (not a raw terminal):
  "creating `feature/auth`…", "editing 4 files…", with a collapsible raw-log view.
- **Diff & approve** — show every file the agent changed; **Approve / Reject / tweak** before it
  sticks. This is the trust mechanism bolt/lovable lack control over.
- **One-click skills as buttons** — your skills become UI actions: *New App, Add Feature,
  Add Auth, Set up Firebase, Configure Android Publishing, Publish to Play Store, Rename App,
  Review Code, Release.* (This is the biggest leverage — the skills already exist; the UI just
  triggers them.)
- **Devices panel — this *is* the preview.** The dashboard lists every connected
  device/emulator (`flutter devices`) and clearly shows **which one the app will run on**
  ("Running on: Pixel 7 emulator"). Hit **Run** and the *real* app launches on that device —
  no iframe, no compile farm, no mirroring needed. Live logs (logcat) are parsed into a readable
  panel; errors surface as cards. One-click **Start emulator** when nothing is connected.
- **Project manager** — list local projects, create one from the template, open/switch.
- **Settings** — store LLM API keys, signing config, Firebase project — all on-device, via UI.

### Nice-to-have (later)

- **Screen mirroring (much later, optional).** Preview is already solved by the real
  device/emulator (Devices panel). If users ever want the app rendered *inside* the browser
  window, add `scrcpy`-style emulator mirroring then — an Android-only nicety, not needed to ship.
- **Git panel** — visual commits, branches, push.
- **Firebase panel** — which services are enabled, quick links.
- **Template/component gallery** — drop in pre-built screens from the design system.

### Security (do not skip)

A local server that spawns shell commands from a browser is a real attack surface. Non-negotiables:
**bind to `127.0.0.1` only**, require a per-session **token** (printed in the terminal on launch),
never expose to `0.0.0.0`, and confirm destructive actions (publish, delete) in the UI. Treat any
page that can run shell as if it were `sudo`.

### Onboarding the non-coder (the real cliff)

> Full step-by-step macOS flow: **[macos-onboarding-flow.md](./macos-onboarding-flow.md)** —
> from a clean Mac (nothing installed) to a running app, every step driven by the dashboard.

Local-first has one hard trade-off bolt/lovable don't: the user must have a working toolchain
(Flutter SDK, platform SDKs, an emulator or a connected phone). A true non-coder won't set that up
from a README. This is the make-or-break UX problem for a local tool — design for it explicitly:

- **Setup wizard / "doctor" on first launch.** Wrap `flutter doctor` in a friendly checklist:
  green ticks for what's ready, one-click fixes or step-by-step guides for what's missing
  (install Flutter, accept Android licenses, create an emulator).
- **Detect & guide, never assume.** If no device is connected, the dashboard says exactly what to
  do — "No device found → [Start emulator] or plug in a phone with USB debugging on" — with a link
  to the exact setting.
- **Automate what you can.** One-click emulator creation (`flutter emulators --create` /
  `avdmanager`) so "Start emulator" really is one click.
- **Permissions in plain language.** When the OS needs something (USB debugging, macOS security
  prompt for the local server, keystore access), explain *why* in one sentence and link the exact
  setting — the user grants it without needing to understand the internals.

**Honest ceiling:** even with a great wizard, first-run setup is the steepest part of any local
tool, and you won't fully match a zero-install web builder here. So target users who can clear the
one-time setup hump first — indie devs, technical founders, students — and treat pure non-coders as
a later goal once the wizard is polished. Your counter-offer for the setup pain is everything
*after* it: a real native app, real code, no per-build cost, full ownership.

### Why this is still "local-first" (and still cheaper than bolt/lovable)

- No hosted sandbox, no compile farm — the dashboard drives the user's own toolchain.
- LLM cost stays the user's own key (BYO), not our COGS.
- The user keeps real code, real git, a real native app — we just made the loop friendly.

### Build effort & phasing (honest)

This is a **separate, non-trivial app** (a local web server + a frontend). Don't build it for v1.

- **v1** — CLI/agent + skills (developers). Ships in weeks; validates the core.
- **v2** — the dashboard MVP: chat panel + agent dropdown + one-click skills + run/logs +
  diff-approve. This is where it starts to *feel* like bolt/lovable. ~1–2 months solo on top of v1,
  because it's wiring a UI to commands that already work.
- **v3** — preview pane (web iframe → emulator mirror), git/Firebase panels, gallery.

> Reuse what you know: you can build the dashboard frontend in **Flutter web** (your strength) or
> React/Next.js (your other strength + matches the brand). The control server is small — Dart
> `shelf` keeps it one-language with the rest.

---

# Part 2 — Repo visibility & growth

Moved to its own doc so it can evolve independently of the product spec:
see **[repo-visibility-playbook.md](./repo-visibility-playbook.md)** — covers the
GitHub Template switch + one-command setup, discovery channels (Show HN, Reddit,
awesome-lists, dev.to, SEO), the framework-agnostic sibling repo, and a 30-day order.
