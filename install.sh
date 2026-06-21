#!/usr/bin/env bash
#
# Kamui Skills installer — works for Claude Code, Codex, and Cursor.
#
# One-line install (reads from the public GitHub repo):
#   curl -fsSL https://raw.githubusercontent.com/kamui-project/kamui-skills/main/install.sh | bash
#
# SKILL.md is a cross-tool standard, so the same skill folders work everywhere;
# only the install directory differs. This script copies the skills into the
# global directories each tool reads.
#
# Pick a target with TOOL=... (default: all):
#   TOOL=all     ~/.claude/skills + ~/.agents/skills  (covers Claude Code, Codex, Cursor)
#   TOOL=claude  ~/.claude/skills                     (Claude Code; Cursor reads it too)
#   TOOL=codex   ~/.agents/skills                     (Codex; Cursor reads it too)
#   TOOL=cursor  ~/.agents/skills                     (global) — for a project-local
#                install, run with DEST=./.cursor/skills instead
#
# Override the destination entirely with DEST=/path/to/skills (single dir).
# Re-running updates the skills.

set -euo pipefail

# --- config -----------------------------------------------------------------
REPO="${KAMUI_SKILLS_REPO:-kamui-project/kamui-skills}"
BRANCH="${KAMUI_SKILLS_BRANCH:-main}"
TOOL="${TOOL:-all}"
SKILLS=(kamui-deploy-workflows kamui-mcp-setup kamui-troubleshooting)
# ----------------------------------------------------------------------------

say() { printf '\033[1;36m›\033[0m %s\n' "$*"; }
err() { printf '\033[1;31m✗\033[0m %s\n' "$*" >&2; }

# Resolve destination directories.
DESTS=()
if [[ -n "${DEST:-}" ]]; then
  DESTS=("$DEST")                                   # explicit override (single dir)
elif [[ -n "${CLAUDE_SKILLS_DIR:-}" ]]; then
  DESTS=("$CLAUDE_SKILLS_DIR")                       # legacy override, still honored
else
  case "$TOOL" in
    claude) DESTS=("$HOME/.claude/skills") ;;
    codex)  DESTS=("$HOME/.agents/skills") ;;
    cursor) DESTS=("$HOME/.agents/skills") ;;
    all)    DESTS=("$HOME/.claude/skills" "$HOME/.agents/skills") ;;
    *)      err "Unknown TOOL=$TOOL (use: all | claude | codex | cursor)"; exit 1 ;;
  esac
fi

# Resolve the source skills/ dir: local checkout if present, else download tarball.
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

for dest in "${DESTS[@]}"; do
  mkdir -p "$dest"
  say "Installing into: $dest"
  for s in "${SKILLS[@]}"; do
    if [[ -d "$SRC/$s" ]]; then
      rm -rf "${dest:?}/$s"
      cp -R "$SRC/$s" "$dest/$s"
      printf '   \033[1;32m✓\033[0m %s\n' "$s"
    else
      err "Skipping $s (not found in source)"
    fi
  done
done

say "Done. Restart your AI tool (Claude Code: /skills · Codex: /skills · Cursor: reload workspace)."
