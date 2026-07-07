# Design quality plan — making generated UI look designed, not generated

> Status: research + plan, July 2026. Problem: the conventions produce clean
> architecture, but the generated UI is visually bland and not
> production-grade. This doc records how the category leaders get good UI out
> of the same base models, and the concrete work items for us.
> Companion docs: `docs/explanation/end-goal.md` (Phase 5/6),
> `docs/explanation/single-domain-multiuser-plan.md`.

## Headline finding: nobody fine-tunes for design taste

Analysis of the leaked system prompts of the major vibe-coding tools
(Lovable's is ~6,500 lines, public on GitHub) shows the design quality of
Lovable / v0 / Bolt / Rocket comes from **prompt engineering + a curated
component stack + feedback loops** — not model fine-tuning. The consensus:
neither base models nor fine-tuning create durable advantage; the moat is
tool schemas and workflow integration. Every competitor at $100M ARR got
there without fine-tuning. **We should not fine-tune** — including on UI8
assets (slow to iterate, no durable edge, and training on purchased design
kits is legally gray).

## How the category leaders do it

### 1. Ride a stack the base model already "knows"

Lovable / v0 / Bolt lock output to **shadcn + Tailwind** — the model has seen
millions of well-designed examples of exactly those components, so a
high-level prompt yields tasteful output "for free." With a custom design
system that intuition disappears and the system must teach the model
explicitly.

**Our situation:** Claude knows Material deeply, but not the *vibe* of our
atoms. So it emits structurally-correct, visually-default screens. The fix is
the same one the leaders use for custom systems: explicit design rules +
pre-composed blocks (below).

### 2. Encode taste as rules, not weights

Lovable's system prompt carries explicit design directives — typography
hierarchy, spacing rhythm, sophisticated palettes, animation defaults. Our
`CLAUDE.md` is the architectural equivalent but has **zero visual-design
content**: it says *never hardcode a colour*, never *what a good screen looks
like*. We have forbidden patterns for code; we have no required patterns for
design.

### 3. Rocket's specific tricks

- **Template library** — Rocket claims templates save ~80% of tokens per
  build: the design decisions are pre-made, the agent only adapts.
- **Figma import** — a "layout and semantics engine" detects UI patterns
  (nav bars, cards, forms) and maps the design file's system to tokens;
  their docs stress "the cleaner the Figma, the better the app."
- **Their own Figma UI kit** so users start from a system Rocket understands.

### 4. The visual feedback loop (most relevant to us)

The proven Flutter pattern (published by Very Good Ventures): the agent
renders the widget via a **golden test** with `autoUpdateGoldenFiles`, reads
its own screenshot **with vision**, compares against a reference/checklist,
and iterates until parity. Design quality becomes a closed loop instead of a
first-shot gamble. We already run generated apps as Flutter Web in the
console — the screenshot substrate exists.

## Work items (priority order)

### A. Design-rules layer — `docs/ai-rules/design.md` (~2–4 days)

The visual counterpart of `conventions.md`, synced across all agent surfaces
like every other rule doc. Contents:

- Hierarchy: one focal element per screen; size/weight/colour express rank.
- Spacing rhythm on the `AppSpacing` scale (generous whitespace defaults;
  consistent gutters; breathing room over density).
- Typography pairing rules on the `textTheme` roles.
- Composition: when cards vs. lists vs. grids; max content width; alignment.
- State polish: empty/loading/error states are designed moments
  (`EmptyState`, `LoadingDots`), never bare spinners or plain text.
- Touch targets, contrast minimums, motion/transition defaults.
- A short "screen smell" list (the design twin of forbidden patterns):
  e.g. three+ font sizes in one card, full-width buttons everywhere,
  unstyled ListTiles as the whole UI, default AppBar on every screen.

### B. "Blocks" tier between atoms and screens (~1–2 weeks)

The current gap isn't atoms — it's **composition**. Add pre-designed
organisms in `core/ui/blocks/`: hero header, stat-card row, feed tile,
settings section, onboarding pager, profile header, section header w/ action.
This is what Creative Tim sells for shadcn and what makes generated screens
look *designed* — the agent assembles proven compositions instead of
inventing layout from scratch.

**UI8 fits here.** Hand-translate the best patterns from the UI8 kits into
Flutter blocks + richer `app_theme_presets` (fonts via `google_fonts`,
palettes, shape languages). **Licensing caution:** UI8 licenses cover use in
end products; a platform generating apps for third parties from those assets
is murkier — translate *patterns and proportions*, not pixel-for-pixel
assets, and don't fine-tune on them.

### C. `/design-review` visual loop skill (~1 week)

The design twin of the Phase 5 self-review gate (`flutter analyze` +
`/review-code`). Flow: screenshot each screen (golden test or the console's
web preview) → Claude vision critiques against the design.md checklist →
apply fixes → re-screenshot → repeat until pass. **Highest-leverage item** —
it catches the 80% of ugliness that rules alone miss, autonomously.

### D. Feature-research step in spec extraction (~2–3 days)

Users are vague ("make me a habit tracker"). Before generating, the agent
web-searches the category ("top habit tracker app features 2026"), produces
a competitor-informed feature list + screen map, confirms with the user,
*then* generates. Slots into Phase 5 "spec extraction." Fixes vague-input
quality for both features and design (competitor teardowns also show how
those apps structure their home screens visually).

### Explicitly skipped

- **Model fine-tuning** — see headline finding.
- **Pixel-copying UI8 assets into the template** — licensing risk; patterns
  only.

## Sequence

A → C → B → D. A is pure prompt work and lifts every generation immediately;
C makes quality self-correcting; B deepens the ceiling; D widens the input
funnel. A+C together are ~2 weeks and deliver most of the visible jump.

## Sources

- [Design Systems ♡ Lovable, Bolt, V0 and Replit](https://www.designsystemscollective.com/design-systems-lovable-bolt-v0-and-replit-50a0a197bc35)
- [Lovable leaked Agent Prompt (GitHub, x1xhlol collection)](https://github.com/x1xhlol/system-prompts-and-models-of-ai-tools/blob/main/Lovable/Agent%20Prompt.txt)
- [Leaked AI system prompts analysis — Augment Code](https://www.augmentcode.com/learn/leaked-ai-system-prompts-github)
- [VGV — Figma-to-Flutter with Claude Code skill + golden tests](https://verygood.ventures/blog/figma-to-flutter-claude-code-skill-golden-tests/)
- [Agentic Coding Handbook — Visual Feedback Loop](https://tweag.github.io/agentic-coding-handbook/WORKFLOW_VISUAL_FEEDBACK/)
- [Rocket.new — Figma design guidelines](https://docs.rocket.new/get-started/figma-design-guidelines/overview)
- [Rocket.new — build from a Figma file](https://www.rocket.new/blog/how-rocket-new-build-from-figma-file-without-developer-handoff)
- [Creative Tim UI — shadcn blocks for v0/Lovable/Claude](https://www.creative-tim.com/ui)
- [Superdesign — I tested 8 AI UI generators](https://superdesign.dev/blog/i-tested-8-ai-ui-generators)
