# Repo Visibility & Growth Playbook — FlutterAgentic

> Goal: turn "people read it and find it insightful" into "people use it, fork it, and star it."
> Current baseline: ~7★ / 2 forks, ~3 LinkedIn posts (1–2★ each), 1 Medium blog.

## The core principle

Stars are a **lagging** indicator. They follow from two things:

1. **Low usage friction** — a stranger can go from landing to *running something useful* in minutes.
2. **Discovery** — the repo reaches people who already have the pain it solves.

LinkedIn gives 1–2★/post because it's *peers*, not *users*. The wins below fix friction first, then point real discovery channels at it. Do them roughly in order.

---

## Phase 1 — Make the repo effortless to use (on-repo, do this week)

- [ ] **Turn it into a GitHub Template repo.** Settings → General → check **"Template repository."** Adds a green **"Use this template"** button → people start a fresh project in one click (clean copy, no your-commits). Single biggest friction-killer.
- [ ] **README hero rewrite.** First screen must answer "what, for whom, why" in 3 seconds. Lead with the **methodology** ("an AI-first repo any coding agent can follow"), then "with a production Flutter reference app." Add a "Use this template" CTA + 3-line quickstart at the very top.
- [ ] **30-second demo GIF/video** at the top of the README: prompt → scaffolded feature → running app. Visual proof converts far better than paragraphs. (Tools: Kap, ScreenStudio, asciinema.)
- [ ] **One-command setup.** A plain `./setup.sh` / `make setup` that runs `flutter pub get`, installs hooks, renames the app, and prints "run `make run`." Target: **clone → running app in under 2 minutes.**
- [ ] **GitHub topics** (gear icon next to About): `ai-agents`, `claude-code`, `cursor`, `agents-md`, `llm`, `ai-coding`, `clean-architecture`, `flutter`, `bloc`. Topics are a real search/discovery surface.
- [ ] **Social preview image** (Settings → Social preview) so links unfurl with a branded card on X/LinkedIn/Slack.
- [ ] **About section** — crisp one-liner + link to the blog + link to the live demo apps.
- [ ] **LICENSE, CONTRIBUTING.md, and 3–5 "good first issue" labels** — signals a living, contributable project (invites the forks/PRs that compound).

## Phase 2 — Win discovery (compounding channels)

Ranked by leverage:

- [ ] **Show HN (Hacker News).** Your blog's framing ("make any AI agent follow your repo") is HN-shaped. One front-page hit beats months of LinkedIn. Post the *blog* or a "Show HN: <repo>" with a tight description; be present in comments.
- [ ] **Awesome-lists (PRs).** Submit to `awesome-claude-code`, `awesome-cursor`, `awesome-ai-coding-tools`, `awesome-flutter`, `awesome-agents`. Passive, durable, high-intent traffic.
- [ ] **Reddit.** r/FlutterDev, r/ChatGPTCoding, r/cursor, r/ExperiencedDevs, r/programming. **Lead with the problem** (agent drift / inconsistent AI code), link the blog — not a bare repo link (reads as spam).
- [ ] **dev.to + Hashnode.** Cross-post the Medium blog with a `canonical_url` back to Medium (no SEO penalty). Both rank well in Google.
- [ ] **X/Twitter dev community.** Thread version of the blog; tag/relate to the agent tools (Claude Code, Cursor, Codex). Short, screenshot-driven.
- [ ] **SEO on the blog.** Target low-competition, high-intent terms: `AGENTS.md`, `AI-first repository`, `stop AI agents drifting`, `CLAUDE.md best practices`. Put them in the title, first paragraph, and headers.

## Phase 3 — Broaden the addressable audience (highest ceiling)

People praise the **method**, not the Flutter code — but the repo is Flutter-locked, which caps the audience at ~1% of "devs using AI agents."

- [ ] **Sibling framework-agnostic starter** (`ai-first-repo`): just the `docs/` Diátaxis skeleton + agent pointer files (`CLAUDE.md`, `AGENTS.md`, `.cursor/rules/`, …) + the generator script. No Flutter. FlutterAgentic becomes its **reference implementation**. This multiplies reach because *any* dev, any stack, can use it.
- [ ] Cross-link the two repos in both READMEs.

## Content cadence (sustainable, not spammy)

- 1 substantive artifact / 2–3 weeks (a how-to, a pattern deep-dive, a "what broke and what I fixed" post), each cross-posted Medium → dev.to → LinkedIn → X.
- Each post **leads with a problem/insight**, ends with a soft "⭐ if useful" — never opens with "star my repo."
- Reply to every comment/issue fast. Early responsiveness is what turns a curious reader into a contributor.

## Metrics — track these, not just stars

- **Traffic → action ratio:** GitHub Insights → Traffic (views, unique clones). Clones matter more than stars (= actual use).
- **Referrers:** which channel actually sends visitors (kill what doesn't work).
- **The one question:** *"Can a stranger who lands here ship something useful today?"* If clone → run → scaffold takes under an hour, stars follow as a side effect.

## Anti-patterns to avoid

- Leading any post with "please star my repo."
- Bare repo links on Reddit/HN with no problem framing.
- Optimizing the star count directly instead of the usage loop.
- Letting the README assume the reader already knows Flutter/Clean Architecture — explain the value before the structure.

---

### Suggested 30-day order

1. Template switch + README hero + demo GIF + one-command setup (Phase 1).
2. Topics + social preview + CONTRIBUTING + good-first-issues.
3. One Show HN + 2 problem-led Reddit posts + dev.to cross-post.
4. Submit to 3 awesome-lists.
5. Start the framework-agnostic sibling repo (Phase 3).
