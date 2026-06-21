---
name: kamui-github-setup
description: Use the GitHub CLI (gh) to get a user GitHub-ready for KamuiDash — check/install gh, authenticate, and create or connect the repository a KamuiDash app deploys from. Drive the safe, idempotent steps proactively without stopping at each one; pause and confirm before anything destructive or account-wide.
---

# Kamui GitHub Setup (gh CLI)

## Purpose

Help a user — often a first-time builder — get their GitHub side ready so KamuiDash can
deploy a GitHub-backed app. Use the `gh` CLI as the default tool, and carry the setup
forward proactively instead of stopping for approval at every individual step, while
protecting the user from irreversible actions.

## Autonomy Policy (read first)

A skill cannot override your host tool's permission system. Whether a `gh` command runs
without a confirmation prompt is decided by the user's tool settings, not by this file.
Within whatever approval mode you are in, follow this policy:

- **Proceed without asking** for read-only and idempotent setup steps: `gh --version`,
  `gh auth status`, `gh repo view`, `gh repo list`, `gh api` GET requests, and creating a
  repository the user explicitly asked you to create. Run these, then report what you did.
- **Stop and get explicit confirmation** before irreversible or account-wide actions:
  deleting or transferring a repo, changing repo visibility, renaming, deleting
  tokens/SSH keys, `gh auth logout`, changing org membership, force-push, or any bulk
  operation. State exactly what will change and wait for a clear "yes".
- **Never put secrets on the command line.** Authenticate through `gh auth login` or an
  environment variable; never echo a token into chat, stdout, or shell history.
- After each cluster of commands, summarize what ran and what changed.

If the user wants `gh` to run with **no prompts at all**, that is a host-tool setting you
cannot grant from here — point them to "Enabling no-prompt gh" below.

## Default Flow

1. **Check gh is installed:** `gh --version`. If missing, guide install:
   - macOS: `brew install gh`
   - Windows: `winget install --id GitHub.cli` (or `scoop install gh`)
   - Other: https://cli.github.com
2. **Check authentication:** `gh auth status`.
   - If not logged in, run `gh auth login` and walk the user through the interactive
     device/browser flow. You cannot complete it for them — it needs their browser and the
     one-time code. Prefer HTTPS, authenticate via web browser.
   - `gh` cannot create a GitHub account. If the user has none, send them to
     https://github.com/signup, then come back to `gh auth login`.
3. **Confirm identity:** `gh api user --jq .login`.
4. **Repository for the KamuiDash app:**
   - Existing repo: `gh repo view OWNER/REPO` to confirm access.
   - New repo (confirm name and visibility with the user first, then run):
     `gh repo create OWNER/REPO --private --source=. --remote=origin --push`
     Visibility (`--public` vs `--private`) is a confirm-first decision.
5. **KamuiDash GitHub App:** `gh` cannot install the KamuiDash GitHub App. Once the repo
   exists, guide the user to install/grant the KamuiDash GitHub App for that repository
   from the dashboard (see `kamui-deploy-workflows`).
6. **Hand off:** continue with `kamui-deploy-workflows` to create the project/app, or
   `kamui-mcp-setup` if Kamui MCP is not configured yet.

## Safe defaults (run proactively)

- `gh auth status`, `gh auth login`, `gh auth refresh -s SCOPE`
- `gh repo view`, `gh repo list`, `gh repo create`
- `gh api user`, `gh api repos/OWNER/REPO` (GET), `gh api user/orgs --jq '.[].login'`

## Confirm-first (never auto-run)

- `gh repo delete`, `gh repo edit --visibility ...`, `gh repo rename`, repo transfer
- `gh secret set` / `gh secret remove`, `gh auth logout`, `gh ssh-key delete`, token deletion
- anything passing `--force`

## Multiple accounts

If `gh auth status` shows more than one account, confirm which one to act as before
creating or pushing. Switch with `gh auth switch --user NAME`. Creating a repo in an
organization requires that the active account has create rights in that org.

## Enabling no-prompt gh (optional, host-tool setting)

Truly unattended `gh` requires the user's tool to pre-authorize it. Recommend allow-listing
only the read-only / idempotent commands and leaving destructive ones to prompt:

- **Claude Code** — add allow rules to `settings.json`, for example:
  ```json
  { "permissions": { "allow": [
      "Bash(gh auth status)",
      "Bash(gh repo view:*)",
      "Bash(gh repo list:*)",
      "Bash(gh api:*)",
      "Bash(gh repo create:*)"
  ] } }
  ```
  Keep `gh repo delete`, `gh repo edit`, and other destructive commands OFF the allow-list
  so they still prompt.
- **Codex** — run in an approval mode that permits shell commands, or approve `gh` when
  prompted.
- **Cursor** — allow terminal/command execution for the session.

## Boundaries

`gh` covers the GitHub side only. KamuiDash project/app creation goes through Kamui MCP
(`kamui-deploy-workflows`) or the dashboard. Do not improvise destructive GitHub API calls,
and do not auto-run anything in the "Confirm-first" list.
