#!/usr/bin/env bash
#
# Kamui Skills installer for Claude Code.
#
# One-line install (reads from the public GitHub repo):
#   curl -fsSL https://raw.githubusercontent.com/YOUR_GH_USER/kamui-skills/main/install.sh | bash
#
# It downloads the skills and copies them into your Claude Code skills
# directory (~/.claude/skills by default). Re-running it updates them.

set -euo pipefail

# --- config -----------------------------------------------------------------
REPO="${KAMUI_SKILLS_REPO:-YOUR_GH_USER/kamui-skills}"
BRANCH="${KAMUI_SKILLS_BRANCH:-main}"
DEST="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"
SKILLS=(kamui-deploy-workflows kamui-mcp-setup kamui-troubleshooting)
# ----------------------------------------------------------------------------

say() { printf '\033[1;36m›\033[0m %s\n' "$*"; }
err() { printf '\033[1;31m✗\033[0m %s\n' "$*" >&2; }

mkdir -p "$DEST"

# If run from inside a cloned repo, install from local ./skills. Otherwise
# download a tarball of the repo and install from there.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || true)"

if [[ -n "$SCRIPT_DIR" && -d "$SCRIPT_DIR/skills" ]]; then
  SRC="$SCRIPT_DIR/skills"
  say "Installing from local checkout: $SRC"
else
  TMP="$(mktemp -d)"
  trap 'rm -rf "$TMP"' EXIT
  URL="https://codeload.github.com/$REPO/tar.gz/refs/heads/$BRANCH"
  say "Downloading $REPO@$BRANCH …"
  if ! curl -fsSL "$URL" | tar -xz -C "$TMP"; then
    err "Download failed. Check the repo name: $REPO"
    exit 1
  fi
  SRC="$(find "$TMP" -maxdepth 2 -type d -name skills | head -n1)"
  if [[ -z "$SRC" ]]; then
    err "Could not find a skills/ directory in the downloaded repo."
    exit 1
  fi
fi

say "Installing into: $DEST"
for s in "${SKILLS[@]}"; do
  if [[ -d "$SRC/$s" ]]; then
    rm -rf "${DEST:?}/$s"
    cp -R "$SRC/$s" "$DEST/$s"
    printf '   \033[1;32m✓\033[0m %s\n' "$s"
  else
    err "Skipping $s (not found in source)"
  fi
done

say "Done. Restart Claude Code (or run /skills) to pick up the new skills."
