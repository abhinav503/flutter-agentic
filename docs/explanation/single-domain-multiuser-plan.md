# Single domain, many users — closing the gap to Rocket.new

> Status: research + gap analysis, July 2026. Builds on
> `docs/explanation/cloud-workspace-plan.md` (what we shipped) and
> `docs/explanation/rocket-cost-model.md` (why scale-to-zero is mandatory).
> Question answered: how does Rocket serve every user from one URL with
> persistent chat history + code, and what would it take us to match that?

## How Rocket (and the category) does it

Rocket publishes features, not infrastructure — nothing public confirms their
exact stack. But the standard blueprint for this product shape is well
documented (Cloudflare ships a [reference architecture for an AI vibe-coding
platform](https://developers.cloudflare.com/reference-architecture/diagrams/ai/ai-vibe-coding-platform/);
E2B / Fly Machines / Modal exist to sell the compute half). Two planes:

### Control plane — the single domain

`app.rocket.new` is **one stateless web app + API behind one domain**. All
durable state lives in a database + object storage, keyed by user and project:

- **Accounts** — Google/GitHub OAuth → user row → session cookie.
- **Projects** — metadata, settings, version history.
- **Chat history as DB rows** — every prompt/response is a record. That is why
  revisiting a page re-renders the whole conversation: the UI reads chat from
  the DB, not from any terminal scrollback.
- **Credit ledger** — token metering per user.

The URL never identifies a machine. It identifies *the user* (via the session
cookie), and the control plane looks up which project/compute belongs to them.

### Compute plane — invisible, ephemeral

When a user opens a project, the control plane **finds-or-boots a sandbox**
(Firecracker microVM — E2B, Fly Machines, or self-run), restores the project
files into it (object-storage snapshot or git), and **proxies the browser's
WS/API traffic to it through the same domain**. Idle a few minutes → sandbox
reaped, files snapshotted back out. Each user session maps to its own isolated
sandbox; a returning user gets files restored into a fresh one.

**The key mental shift: state lives outside compute.** Chat is data in a DB,
code is data in storage, containers are disposable and rehydrated on demand.
`rocket-cost-model.md` shows this isn't a style choice — always-on per-user
compute is insolvent at $25/user.

## What we have today (branch `web_app`)

| Concern | Today | Rocket model |
|---|---|---|
| URL | one per user — `https://<vm-ip-dashes>.sslip.io` (the URL *is* the VM) | one domain for everyone; cookie → user → backend |
| Identity | none — possession of URL + basic-auth token | Google OAuth → user row → session |
| Chat | `claude` CLI in a PTY; history = terminal scrollback + `~/.claude` on that VM (not queryable, not renderable) | chat panel backed by DB rows; agent driven headlessly |
| Code persistence | that VM's boot disk (host-path mounts) | object storage / git snapshot, restored into any sandbox |
| Compute | one **persistent** spot VM per user, manual `ws-create`/`ws-delete` | ephemeral sandbox per active session, auto-reaped |
| Isolation | VM boundary (good) | microVM boundary (same idea, faster lifecycle) |

What ports cleanly: the console is stateless React talking to a relative
`/bridge` base — it doesn't care which backend it's pointed at. The bridge is
already env-configured (`PROJECT_DIR`, `TERMINAL_TOKEN`, `BIND_HOST`). The
Docker image is the sandbox template. None of that is throwaway.

## Gap components + estimates

Estimates assume solo dev + agent assistance, elapsed calendar time.

| # | Component | What it is | Estimate |
|---|---|---|---|
| 1 | **Google login** | Auth.js (NextAuth) in the console, `users` table, session cookie | 2–4 days |
| 2 | **Control-plane API + DB** | Postgres (Supabase / Cloud SQL): users, workspaces, workspace→backend mapping; create/stop endpoints replacing the manual `ws-create` script | 1–2 weeks |
| 3 | **Single-domain gateway** | One public `app.<domain>`; after login, proxy `/bridge/*` + WS to *that user's* backend over a private VPC. Workspace VMs lose their public IPs; the gateway is the only public listener. Keeps VM-per-user initially — just hides it behind one URL | ~1 week |
| 4 | **Chat as data** | The big architectural shift: primary UX becomes a chat panel driven headlessly (Agent SDK / `claude -p`), every turn stored in the DB so history survives and re-renders on revisit. Terminal stays as a power-user pane | 2–4 weeks |
| 5 | **Ephemeral compute + scale-to-zero** | Orchestrator: boot sandbox on session start; snapshot `/workspace` to GCS (or git-push) on idle; reap; restore on return. Cold-start tuning. Alternative: buy this layer (E2B / Fly Machines) instead of building on GCE | 3–6 weeks |

### Milestones

- **Milestone A — "Rocket-looking" (~3–5 weeks).** Items 1–3. One URL for
  everyone, Google sign-in, each user routed to their own (still persistent)
  VM. Sessions "persist" because the VM never died. Honest scope: appearance
  of Rocket, economics unchanged.
- **Milestone B — "Rocket-working" (~2.5–4 months cumulative).** Items 1–5.
  DB-backed chat history, ephemeral sandboxes, scale-to-zero economics.

### The 80/20 read

- Items 1–3 are a few weeks and give the product one login-gated URL.
- Item 4 is what makes it *feel* like Rocket (chat that survives revisits).
- Item 5 is what makes it a *business* at scale — but is irrelevant below
  ~20 users; the current spot-VM model is fine until then. Don't build the
  orchestrator before there are users to reap.

## Sources

- [Cloudflare — AI Vibe Coding Platform reference architecture](https://developers.cloudflare.com/reference-architecture/diagrams/ai/ai-vibe-coding-platform/)
- [Cloudflare — VibeSDK announcement](https://blog.cloudflare.com/deploy-your-own-ai-vibe-coding-platform/)
- [AgentMarketCap — E2B / Modal / Daytona / Fly Machines sandbox landscape](https://agentmarketcap.ai/blog/2026/04/07/ai-agent-sandbox-infrastructure-e2b-modal-daytona-fly-machines-secure-code-execution)
- [Rocket.new docs — workspace connectors](https://docs.rocket.new/getting-started/workspace/connectors)
- [Rocket.new blog — build vs other AI builders](https://www.rocket.new/blog/rocket-new-build-vs-other-ai-app-builders)
