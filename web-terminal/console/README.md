# Web Terminal Console (React / Next.js)

The **builder console** for FlutterAgentic — a React/Next.js web app that renders
a real local shell in the browser and previews the app you're building beside it.

This is the console surface described in
[`docs/explanation/end-goal.md`](../../docs/explanation/end-goal.md): chat/prompt
panel, terminal, live preview, and code view live here in React. Flutter is
reserved for the *generated apps* and the in-iframe live preview — not the
console chrome. It supersedes the earlier Flutter `apps/web_terminal` prototype;
the **Node PTY bridge (`../server`) is reused unchanged**.

## Two pieces

A browser is sandboxed — a web page can't spawn a shell or touch your
filesystem. So the system is split in two:

```
Browser (localhost:4000)                  Your machine (local process)
┌──────────────────────────┐   WebSocket  ┌───────────────────────────┐
│ web-terminal/console      │ ───────────► │ web-terminal/server        │
│  Next.js + xterm.js       │ ◄─────────── │  Node + node-pty + ws      │
│  (renders, sends keys)    │   output     │  spawns your $SHELL as YOU │
│  preview pane (iframe)    │ ◄──────────► │  runs apps/ via flutter run│
└──────────────────────────┘   HTTP /apps └───────────────────────────┘
```

- **`web-terminal/console`** (this folder) — the React console. Streams
  keystrokes to the bridge and paints output with
  [`@xterm/xterm`](https://www.npmjs.com/package/@xterm/xterm); includes the
  agent switcher, setup panel, and the live-preview pane.
- **[`web-terminal/server`](../README.md)** — the Node PTY bridge. Runs as you,
  so the shell has exactly your local permissions. The only part that touches
  the OS.

## Run it

The console needs the bridge running. In two shells, from the repo root:

```bash
make terminal-bridge   # shell 1 — PTY bridge on :3000
make console           # shell 2 — this console on :4000  (npm install + npm run dev)
```

Then open **http://localhost:4000** and run `claude` (or anything else) in the
terminal. Or run the console directly:

```bash
cd web-terminal/console
npm install
npm run dev            # Next.js dev server on :4000
```

## Configuration

The console reaches the bridge via `NEXT_PUBLIC_BRIDGE_ORIGIN` (see
`.env.local`):

```
NEXT_PUBLIC_BRIDGE_ORIGIN=http://localhost:3000
```

The bridge prints a per-startup token and serves it from `/config.json`; the
console fetches it automatically to authorize the WebSocket. In dev the console
runs cross-origin (`:4000` → `:3000`); the bridge echoes CORS **only** for
localhost origins.

## Scripts

| Command         | What it does                  |
| --------------- | ----------------------------- |
| `npm run dev`   | Next.js dev server on `:4000` |
| `npm run build` | Production build              |
| `npm start`     | Serve the production build    |
| `npm run lint`  | ESLint                        |

## Structure

```
src/
├── app/                 Next.js App Router — layout, page, globals
├── components/
│   ├── console-shell.tsx    top-level layout (resizable panes)
│   ├── right-pane.tsx
│   ├── terminal/            xterm console, agent selector, apps bar, status bar
│   ├── preview/             live-preview pane + device status
│   ├── setup/               first-run setup panel + command blocks
│   └── ui/                  shadcn/Radix primitives
├── hooks/               use-terminal-socket, use-apps, use-devices, use-setup, …
├── lib/                 bridge client, config, types, query provider, fonts
└── stores/              Zustand stores (terminal, selection, ui)
```

**Stack:** Next.js 16 · React 19 · Tailwind v4 · shadcn/Radix UI ·
`@tanstack/react-query` · Zustand · `@xterm/xterm`.

> Next.js here may differ from older releases — see [`AGENTS.md`](./AGENTS.md)
> before writing Next.js code.
