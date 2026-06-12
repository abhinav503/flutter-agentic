# release

Guide the user through a full release: branch comparison, version bump, release notes, GitHub Release.

---

## Prerequisites

Check that `gh` is installed and authenticated:

```bash
which gh
gh auth status
```

If `gh` is missing, tell the user:
> Install the GitHub CLI before running a release:
> `brew install gh` (macOS) or https://cli.github.com
> Then run `gh auth login`.

Stop here if `gh` is not ready.

---

## Step 1 — Identify the release branch

Get the current branch:
```bash
git branch --show-current
```

If the current branch is not `main`, ask:
> "Release from `{current_branch}`? Type a different branch name or press Enter to confirm."

If the answer is `main` or the user confirms, proceed. Record the branch as `{RELEASE_BRANCH}`.

---

## Step 2 — Compare branch to main

If `{RELEASE_BRANCH}` is not `main`, show what will be included:

```bash
git log main..{RELEASE_BRANCH} --oneline
git diff main..{RELEASE_BRANCH} --stat
```

Present the commit list to the user so they can review what is going into the release.

---

## Step 3 — Determine version bump

Read the current version from `pubspec.yaml`:
```bash
grep "^version:" pubspec.yaml
```

Flutter version format: `MAJOR.MINOR.PATCH+BUILD`

Analyse the commits from Step 2 using these rules:

| Bump | When |
|---|---|
| **Major** | Any commit with `feat!:` or `BREAKING CHANGE:` in its body; or a change to base class public API (`BasePage`, `BaseScreen`, `BaseRepository`) that breaks existing subclasses |
| **Minor** | Any `feat:` commit; new atom, molecule, skill, or how-to guide |
| **Patch** | Only `fix:`, `chore:`, `refactor:`, `docs:`, `test:`, `ci:` commits; rule/convention clarifications; agent context improvements with no API change |

Also consider the product context — FlutterAgentic is an AI agent template:
- New or updated AI rules, skills, or agent configs → at minimum **patch**, escalate to **minor** if it meaningfully improves the out-of-the-box agent experience
- Architecture changes that break generated feature scaffolding → **major**

Propose the bump with one sentence of reasoning. Example:
> "Suggested: **minor** bump → `0.2.0+2` — 3 `feat:` commits (new release skill, AppCheckbox atom, Amazon Q rules)."

Ask the user:
> "Confirm version `0.2.0+2`? Or type `major` / `minor` / `patch` to override."

Wait for confirmation before continuing.

---

## Step 4 — Update `pubspec.yaml`

Replace the version line with the confirmed version (increment the build number by 1):

```bash
# Read old version, compute new, then edit pubspec.yaml
```

Use the Edit tool to update `pubspec.yaml`:
- `version: {NEW_VERSION}+{NEW_BUILD}`

---

## Step 5 — Write release notes

Copy the template and fill it in:

1. Create `docs/releases/v{NEW_VERSION}.md` from `docs/releases/_template.md`
2. Two sections only — no other headings:
   - **Features** — what a developer using the template gains: new UI components, reference apps, integrations; anything a human directly uses or sees
   - **Agent Context Improvements** — what AI agents gain: new skills, new rule docs, forbidden pattern clarifications, guide additions; if something primarily benefits the agent workflow (e.g. a new skill), it belongs here, not in Features
   - Add a **Breaking Changes** section only for a major bump; include migration steps
   - No changelog, no highlights, no full git log dump
3. **Duplication rule** — one bullet per change, in the section that best describes its primary audience; if a change is already in Agent Context Improvements do not repeat it in Features
4. **Writing rules** — the release notes are read by developers, not agents:
   - No file paths, class names, or internal identifiers — describe *what changed* in plain language
   - No "first release" framing unless it literally is the very first tag ever
   - Keep every bullet to one sentence; if it needs two, it is too detailed
   - Do not list things that are expected or obvious — only list what meaningfully improves the experience
4. Show the draft to the user and ask: "Does this look good? Edit the file if needed, then confirm."

Wait for confirmation before continuing.

---

## Step 6 — Commit on release branch

Stage and commit the version bump and release notes on `{RELEASE_BRANCH}`:
```bash
git add pubspec.yaml docs/releases/v{NEW_VERSION}.md
git commit -m "chore: release v{NEW_VERSION}"
git push
```

---

## Step 7 — Merge to main

Switch to `main`, pull latest, and merge the release branch in:

```bash
git checkout main
git pull origin main
git merge --no-ff {RELEASE_BRANCH} -m "chore: merge {RELEASE_BRANCH} into main for v{NEW_VERSION}"
git push origin main
```

If the merge has conflicts, stop and tell the user to resolve them manually, then continue from here once resolved.

From this point on everything operates on `main`.

---

## Step 8 — Tag main and create GitHub Release

Tag the merge commit on `main` and push the tag:

```bash
git tag v{NEW_VERSION}
git push origin v{NEW_VERSION}
```

Create the GitHub Release from `main`:

```bash
gh release create v{NEW_VERSION} \
  --title "v{NEW_VERSION} — {SUMMARY_TITLE}" \
  --notes-file docs/releases/v{NEW_VERSION}.md \
  --target main
```

Report the release URL to the user.

---

## Step 9 — Clean up release branch

Ask the user:
> "`{RELEASE_BRANCH}` has been merged. Delete it?"

If yes:
```bash
git branch -d {RELEASE_BRANCH}
git push origin --delete {RELEASE_BRANCH}
```
