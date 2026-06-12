# AI Coding Agents

This project is configured for six AI coding agents. Each one automatically picks up
project conventions, architecture, and documentation on every prompt.

---

## How context loads

Each agent reads instruction files that eagerly load high-signal docs and name the rest:
1. **Always in context** — conventions, architecture, end-goal
2. **Named for on-demand fetch** — contributing guide, this file

Conventions and architecture shape every coding decision so they pay their token cost on every request. The others are situational.

---

## Claude Code

**Install**
```bash
npm install -g @anthropic-ai/claude-code
```

**Auth**
```bash
claude login
```

**Usage** — run in the project root:
```bash
claude
```

**How context loads** — `CLAUDE.md` is auto-loaded on every session. It eagerly loads `docs/ai-rules/conventions.md`, `docs/reference/architecture.md`, and `docs/explanation/end-goal.md`. Contributing and agent guides are named for on-demand fetch.

**Setup skill** — run `/setup-project` to check all prerequisites.
**Scaffold skill** — run `/add-feature-template` (or `/add-feature-template <name>`) to scaffold a new feature.

---

## Cursor

**Install** — Download from [cursor.com](https://cursor.com)

**Usage** — Open the project folder in Cursor. Switch to Agent mode in the chat panel.

**How context loads** — `.cursor/rules/conventions.mdc` has `alwaysApply: true` so it is included in every Agent request. It contains conventions and named pointers to `docs/reference/architecture.md` and `docs/explanation/end-goal.md`.

**Setup skill** — ask *"help me set up this project"*.
**Scaffold skill** — ask *"scaffold a products feature"*.

---

## Gemini CLI

**Install**
```bash
npm install -g @google/gemini-cli
```

**Auth**
```bash
gemini auth login
```

**Usage** — run in the project root:
```bash
gemini
```

**How context loads** — `GEMINI.md` is auto-loaded at session start. It eagerly loads conventions, architecture, and end-goal via `@` imports.

**Setup skill** — ask *"help me set up this project"*.
**Scaffold skill** — ask *"scaffold a products feature"*.

---

## Gemini in Android Studio

**Install** — Open Android Studio → Plugins → search *Gemini* → Install.

**Usage** — Open the project. Use the Gemini chat panel with Agent mode enabled.

**How context loads** — `AGENTS.md` is auto-loaded. It contains conventions inline and named pointers to `docs/reference/architecture.md` and `docs/explanation/end-goal.md`.

**Setup skill** — ask *"help me set up this project"*.
**Scaffold skill** — ask *"scaffold a products feature"*.

---

## Codex CLI

**Install**
```bash
npm install -g @openai/codex
```

**Auth**
```bash
export OPENAI_API_KEY=your_key
```

**Usage** — run in the project root:
```bash
codex
```

**How context loads** — `AGENTS.md` is auto-loaded at session start. It contains conventions inline and named pointers to `docs/reference/architecture.md` and `docs/explanation/end-goal.md`.

**Setup skill** — type `$setup-project` to run the environment checklist, or ask about project setup and Codex auto-triggers it.
**Scaffold skill** — type `$add-feature-template <name>` to scaffold a new feature.

---

## Amazon Q Developer

**Install (CLI)**
```bash
brew install amazon-q   # macOS
# or download from https://aws.amazon.com/q/developer/
```

**Install (IDE)** — VS Code or JetBrains → Extensions → search *Amazon Q*.

**Auth**
```bash
q login
```

**Usage** — run in the project root:
```bash
q chat
```

**How context loads** — all files in `.amazonq/rules/` are auto-loaded on every interaction. `instructions.md` points to all key docs; `review-code.md` and `change-app-id.md` provide specialised rules for those tasks.

**Setup skill** — ask *"help me set up this project"*.
**Scaffold skill** — ask *"scaffold a products feature"*.

---

## Quick comparison

| Agent | Instruction file | Setup trigger | Scaffold trigger |
|---|---|---|---|
| Claude Code | `CLAUDE.md` | `/setup-project` | `/add-feature-template` |
| Cursor | `.cursor/rules/conventions.mdc` | Ask about setup | Ask to scaffold a feature |
| Gemini CLI | `GEMINI.md` | Ask about setup | Ask to scaffold a feature |
| Android Studio | `AGENTS.md` | Ask about setup | Ask to scaffold a feature |
| Codex CLI | `AGENTS.md` | `$setup-project` | `$add-feature-template` |
| Amazon Q | `.amazonq/rules/` (all files) | Ask about setup | Ask to scaffold a feature |
