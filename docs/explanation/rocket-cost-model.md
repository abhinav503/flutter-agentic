# Rocket.new cost & profit model — 1,000 users

A back-of-envelope unit-economics teardown of a Rocket.new-style vibe-coding platform at **1,000 paying users on the lowest tier ($25/mo = 100 credits)**, focused on **GCP Linux container (compute) cost**. Built to answer: *if every user gets a Linux machine for hot-reload/preview, does the $25 plan still make money?*

> **All GCP numbers:** us-central1, 2026, a Flutter-capable **e2-standard-4 (4 vCPU / 16 GB)** container. On-demand **$0.134/hr**, **spot ~$0.067/hr** (leaner e2-standard-2 = 2 vCPU/8 GB is ~half). LLM-token figures are **labeled estimates** — verify against current Claude/OpenAI pricing.

---

## First: what is a "credit"?

A credit is **not** a compute-hour or a Linux-machine-minute. **A credit is a prepaid unit of AI work — i.e. LLM tokens.** Each prompt/generation/auto-fix consumes credits roughly in proportion to the tokens the model reads + writes (your code is fed back in as context every turn, so edits aren't cheap).

- $25 Build plan = **100 credits/month** ≈ ~100 generate/edit actions.
- The credit cap exists for one reason: **to bound the LLM bill.** Rocket pays Anthropic/OpenAI per token; credits are how they stop a single $25 user from running up a $200 token tab.
- What end-users do *inside* a generated app does **not** burn credits — only building it does.

**Key takeaway up front:** credits = LLM cost, and LLM cost is the dominant COGS. GCP compute is a rounding error by comparison (shown below).

---

## Revenue

| | |
|---|---|
| Users | 1,000 |
| Plan | $25/mo (lowest) |
| **Monthly revenue** | **$25,000** |
| Annual | $300,000 |

(Real Rocket also sells $50/$100 tiers, so blended ARPU is higher — this is the floor.)

---

## Your scenario: one always-on container per user, 16h/day × 30 days

This is the naive model — 1,000 containers, each "on" 16 hours a day:

- Hours/user/month = 16 × 30 = **480 hr**
- Container-hours = 1,000 × 480 = **480,000 hr/month**

| Pricing | Compute cost/mo | vs $25k revenue | Result |
|---|---|---|---|
| e2-standard-4 **on-demand** ($0.134/hr) | **$64,320** | 257% | 🔴 **Loss −$39,320** |
| e2-standard-4 **spot** ($0.067/hr) | **$32,160** | 129% | 🔴 **Loss −$7,160** |

**→ Always-on per-user containers are insolvent before you've paid a cent for LLM tokens.** This is *why no one builds it this way.*

---

## How it actually works: scale-to-zero, per-active-session

A container is **ephemeral and per-session**: spun up when a user is actively building, **reaped after a few minutes idle**. "Tab open 16h" ≠ "16h of compute." Real active compute (generating, building, hot-reloading) for a $25-tier user is more like **5–20 hours/month**, and most of that is bursty.

You pay only for active container-hours. Sensitivity (e2-standard-4):

| Active hrs/user/mo | Container-hrs (1,000 users) | Spot $0.067 | On-demand $0.134 | Compute as % of $25k |
|---|---|---|---|---|
| 2  | 2,000   | **$134**   | $268   | 0.5% |
| 5  | 5,000   | **$335**   | $670   | 1.3% |
| 10 | 10,000  | **$670**   | $1,340 | 2.7% |
| 20 | 20,000  | **$1,340** | $2,680 | 5.4% |
| 40 | 40,000  | **$2,680** | $5,360 | 10.7% |
| 480 (always-on) | 480,000 | $32,160 | $64,320 | 129% |

**Most plausible band (5–20 active hrs/user/mo): GCP compute ≈ $335–$2,680/month** for all 1,000 users — i.e. **1–11% of revenue.**

Small extras (not the driver): container image storage in Artifact Registry (~$0.10/GB-mo × a few GB), internet egress for preview (~$0.12/GB). Call it a few hundred $/mo combined.

---

## The cost that actually decides profit: LLM tokens (= credits)

This is the part the "Linux machine" framing hides. **Estimate** (verify against live pricing):

- 100 credits ≈ ~100 generate/edit actions. Each action pushes a large code context in and gets code out — call it ~$0.05–$0.30 of token cost on a mid/large model.
- Per user: **~$5–$30/month** in LLM tokens.
- Across 1,000 users: **~$5,000–$30,000/month.**

That single line item is **5×–100× the GCP compute bill**, and can equal or exceed the $25 plan price for a heavy user. It's the reason the plan caps at 100 credits.

---

## Putting it together — monthly P&L, 1,000 users @ $25

Using the realistic **10 active hrs/user** (spot compute) and a **mid LLM estimate (~$12/user)**:

| Line | Monthly |
|---|---|
| Revenue | **+$25,000** |
| GCP compute (spot, 10 hr/user) | −$670 |
| Storage + egress | −$300 |
| **LLM tokens (the real COGS)** | **−$12,000** |
| **Gross profit** | **≈ +$12,030 (~48% margin)** |

Compare the extremes:
- **GCP-only view (what you asked):** Revenue $25,000 − compute $670 = **$24,330, ~97% "infra" margin.** Compute alone barely dents profit.
- **Reality with tokens:** margin lands **~40–55%** at mid usage, and goes **negative for heavy users** if credits aren't capped — which is exactly why they are.

---

## Conclusions

1. **GCP Linux containers are cheap — ~1–11% of revenue** — *as long as you use scale-to-zero + idle reaping, not one always-on box per user.* Your always-on 16h/day model is the one scenario that loses money on compute alone.
2. **"Credits" = LLM tokens, and that is the real cost of goods.** It's 5–100× the compute bill and is what the $25/100-credit cap is built to contain.
3. **Spot VMs ≈ halve compute** vs on-demand; for bursty per-session work that's free money. A managed sandbox (E2B/Fly) is similar cents-per-session with far less ops.
4. **The profit lever is token cost, not server cost** — model choice, prompt/context size, and the credit cap matter 50× more to margin than vCPU pricing. Optimize there.

> Applies directly to our own pivot: don't fixate on container cost; the unit economics live in the LLM bill, which is the open **BYOK-vs-bundled-credits** decision in the cloud-machine plan.
