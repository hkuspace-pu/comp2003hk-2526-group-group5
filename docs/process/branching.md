# Branching & Commit Rules

This document defines our Git workflow for **process evidence** (branches, PRs, commits) and for keeping changes reviewable.

## Branch strategy (simple + evidence-friendly)

- **Default branch**: `main`
- **Work happens on branches**: no direct commits to `main`
- **One feature / fix per branch**: keep PRs small and easy to review

### Branch naming

Use this format:

- **feature**: `feature/<short-scope>`
- **fix**: `fix/<short-scope>`
- **docs**: `docs/<short-scope>`
- **chore**: `chore/<short-scope>`
  Rules:
- **lowercase**
- words separated by `-`
- keep under ~40 characters
  Examples:
- `feature/supabase-auth`
- `feature/focus-session-crud`
- `fix/login-validation`
- `docs/testing-evidence`
- `chore/refactor-main-shell`

## Pull request (PR) workflow

For every branch:

- **Open a PR to `main`**
- PR must include:
  - **Summary**: what changed and why
  - **Testing evidence**: what you ran / checked (Android + Web when relevant)
  - **Screenshots** when UI changes
  - **Links to docs/evidence** if the change adds proof (e.g. RLS, Postman)

### Merge rule

- **Squash merge is allowed** if the branch has many small WIP commits
- Otherwise normal merge is fine
- After merge:
  - delete the branch (optional but recommended)

## Commit style (for grading evidence)

### Minimum expectations

- Commit **often**: small, meaningful commits (avoid one giant commit)
- Each commit should represent **one logical step**
- Avoid committing secrets (e.g. API keys, `.env`)

### Commit message format

Use an imperative, descriptive subject:

```
<type>: <short summary>
```

Types:

- `feat` new feature
- `fix` bug fix
- `docs` documentation/evidence
- `refactor` code restructure without behavior change
- `test` tests only
- `chore` tooling / maintenance
  Examples:
- `feat: add focus session insert/select`
- `fix: validate email and password on login`
- `docs: add RLS proof screenshots and notes`
- `refactor: create main shell and route map`

### Commit size guidelines

- Prefer **small diffs** that reviewers can understand quickly
- If a change touches many files, explain why in the commit body

## Branch + PR evidence checklist

For each sprint/week, aim for:

- **3–10 commits** (depending on scope)
- **at least 1 feature branch**
- **at least 1 PR** with a clear description and a small test plan

## Quick commands (reference)

```bash
# create branch
git checkout -b feature/supabase-auth
# stage + commit
git add .
git commit -m "feat: add supabase auth flow"
# push + open PR
git push -u origin HEAD
```
