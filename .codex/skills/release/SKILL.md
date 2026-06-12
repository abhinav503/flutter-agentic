---
name: release
description: >
  Guide the user through a full release: branch comparison, version bump,
  release notes, merge to main, GitHub Release creation, and branch cleanup.
  Invoke with $release or ask to do a release.
---

Check that `gh` is installed and authenticated before starting:

```bash
which gh
gh auth status
```

If `gh` is missing, tell the user to install it (`brew install gh` on macOS or https://cli.github.com) and run `gh auth login`. Stop here if not ready.

---

## Step 1 — Identify the release branch

```bash
git branch --show-current
```

If not `main`, ask: "Release from `{current_branch}`? Type a different branch name or press Enter to confirm."

Record the confirmed branch as `{RELEASE_BRANCH}`.

---

## Step 2 — Compare branch to main

```bash
git log main..{RELEASE_BRANCH} --oneline
git diff main..{RELEASE_BRANCH} --stat
```

Show the commit list so the user can review what is going in.

---

## Step 3 — Determine version bump

```bash
grep "^version:" pubspec.yaml
```

Flutter version format: `MAJOR.MINOR.PATCH`

| Bump | When |
|---|---|
| **Major** | `feat!:` or `BREAKING CHANGE:` in any commit; base class public API change that breaks subclasses |
| **Minor** | Any `feat:` commit; new atom, molecule, skill, or how-to guide |
| **Patch** | Only `fix:`, `chore:`, `refactor:`, `docs:`, `test:`, `ci:` commits |

Propose the bump and wait for the user to confirm before continuing.

---

## Step 4 — Update `pubspec.yaml`

Edit `pubspec.yaml` to replace the version line with the confirmed version.

---

## Step 5 — Write release notes

Create `docs/releases/v{NEW_VERSION}.md` from `docs/releases/_template.md`.

Two sections only:
- **Features** — what a developer gains: new components, apps, integrations
- **Agent Context Improvements** — what AI agents gain: new skills, rules, doc refs

Writing rules:
- No file paths or class names — plain language only
- One bullet per change; one sentence per bullet
- Do not list things that are obvious or expected

Show the draft and ask: "Does this look good? Edit the file if needed, then confirm."

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

Stop if there are merge conflicts — tell the user to resolve them, then continue.

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

## Step 9 — Clean up release branch

Ask: "`{RELEASE_BRANCH}` has been merged. Delete it?"

If yes:
```bash
git branch -d {RELEASE_BRANCH}
git push origin --delete {RELEASE_BRANCH}
```
