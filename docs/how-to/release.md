# How to Release

Guide for performing a full release: branch comparison, version bump, release notes, merge to main, GitHub Release creation, and branch cleanup.

---

## Prerequisites

This repo uses **multiple GitHub accounts**, so release auth must be explicit — never rely on whichever account `gh auth login` happens to have active. The token lives in a git-ignored **`.env`** file at the repo root; `gh` honors `GH_TOKEN` over any stored login, so every agent and shell behaves identically once it's sourced.

Load the token from `.env` and check that `gh` is installed and authenticated:

```bash
which gh
set -a && . ./.env && set +a    # exports GH_TOKEN from the root .env
gh auth status
```

`gh auth status` should report `Logged in … (GH_TOKEN)`. **Source `.env` (the `set -a … set +a` line) at the start of every shell that runs a `gh` command in this workflow** — a non-interactive shell does not inherit it automatically.

> **Invalid-token warning in a sandbox:** if `gh auth status` reports the `GH_TOKEN` as invalid, confirm the shell actually has network access before replacing the token. In sandboxed agent environments, blocked network access can surface as an auth failure even when the token is fine. Re-run the check from a shell with network permission and `.env` sourced before assuming the token is bad.

If `gh` is missing, install it (`brew install gh` on macOS or https://cli.github.com).

If the root `.env` does not exist or has no `GH_TOKEN`, create a Personal Access Token for the **account that owns this repo** and add it as `GH_TOKEN=…` in `.env` (the file is git-ignored — never commit it):
- **Fine-grained token** (scoped to one repo, recommended): https://github.com/settings/personal-access-tokens/new — grant **Contents: Read and write** on this repo.
- **Classic token**: https://github.com/settings/tokens/new — tick the `repo` scope (plus `workflow` if the release touches Actions).

Stop here if `GH_TOKEN` is not available.

---

## Step 1 — Identify the release branch

```bash
git branch --show-current
```

If not `main`, confirm with the user: "Release from `{current_branch}`? Type a different branch name or press Enter to confirm."

Record the confirmed branch as `{RELEASE_BRANCH}`.

---

## Step 2 — Compare branch to main

```bash
git log main..{RELEASE_BRANCH} --oneline
git diff main..{RELEASE_BRANCH} --stat
```

Show the commit list so the user can review what is going into the release.

---

## Step 3 — Determine version bump

```bash
grep "^version:" pubspec.yaml
```

Flutter version format: `MAJOR.MINOR.PATCH`

| Bump | When |
|---|---|
| **Major** | `feat!:` or `BREAKING CHANGE:` in any commit; base class public API change that breaks existing subclasses |
| **Minor** | Any `feat:` commit; new atom, molecule, skill, or how-to guide |
| **Patch** | Only `fix:`, `chore:`, `refactor:`, `docs:`, `test:`, `ci:` commits |

Also consider the product context — FlutterAgentic is an AI agent template:
- New or updated AI rules, skills, or agent configs → at minimum **patch**, escalate to **minor** if it meaningfully improves the out-of-the-box agent experience
- Architecture changes that break generated feature scaffolding → **major**

Propose the bump with one sentence of reasoning and wait for the user to confirm before continuing.

---

## Step 4 — Update `pubspec.yaml`

Edit `pubspec.yaml` to replace the version line with the confirmed version.

---

## Step 5 — Write release notes

Create `docs/releases/v{NEW_VERSION}.md` from `docs/releases/_template.md`.

Two sections only:
- **Features** — what a developer using the template gains: new UI components, reference apps, integrations; anything a human directly uses or sees
- **Agent Context Improvements** — what AI agents gain: new skills, new rule docs, forbidden pattern clarifications, guide additions

Writing rules:
- No file paths, class names, or internal identifiers — plain language only
- One bullet per change; one sentence per bullet
- Do not repeat a change across both sections — one bullet per change in the section that best fits its audience
- Do not list things that are obvious or expected

Show the draft to the user and ask: "Does this look good? Edit the file if needed, then confirm."

Wait for confirmation before continuing.

---

## Step 6 — Commit on release branch

```bash
git add pubspec.yaml docs/releases/v{NEW_VERSION}.md
git commit -m "chore: release v{NEW_VERSION}"
git push
```

---

## Step 7 — Merge to main

```bash
git checkout main
git pull origin main
git merge --no-ff {RELEASE_BRANCH} -m "chore: merge {RELEASE_BRANCH} into main for v{NEW_VERSION}"
git push origin main
```

Stop if there are merge conflicts — ask the user to resolve them, then continue from here.

From this point on everything operates on `main`.

---

## Step 8 — Tag main and create GitHub Release

```bash
git tag v{NEW_VERSION}
git push origin v{NEW_VERSION}

gh release create v{NEW_VERSION} \
  --title "v{NEW_VERSION} — {SUMMARY_TITLE}" \
  --notes-file docs/releases/v{NEW_VERSION}.md \
  --target main
```

Report the release URL to the user.

---

## Step 8b — Build and attach Android APK (optional, per app)

> **Monorepo:** the repo root has no runnable app — apps live under `apps/<app>/`. The APK must be built **from inside an app folder**, never the root. Skip this step entirely for a pure template/structure release that ships no app binary.

Ask the user which app to attach (e.g. `doc_scanner`, `jokes`); record it as `{APP}`. Build a release APK from that app folder (a pure build — no device needed):

```bash
cd apps/{APP} && fvm flutter build apk --release
```

If `fvm` is not available, fall back to:

```bash
cd apps/{APP} && flutter build apk --release
```

The APK is output to `apps/{APP}/build/app/outputs/flutter-apk/app-release.apk`.

Upload it to the release as a named asset (name it after the app + version):

```bash
gh release upload v{NEW_VERSION} \
  apps/{APP}/build/app/outputs/flutter-apk/app-release.apk#{APP}-v{NEW_VERSION}.apk
```

Confirm the asset appears on the release page before continuing.

---

## Step 9 — Clean up release branch

Ask the user: "`{RELEASE_BRANCH}` has been merged. Delete it?"

If yes:
```bash
git branch -d {RELEASE_BRANCH}
git push origin --delete {RELEASE_BRANCH}
```
