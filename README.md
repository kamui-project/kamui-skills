# Kamui Skills for Claude Code

A [Claude Code](https://claude.com/claude-code) **plugin marketplace** bundling Skills for
working with the [KamuiDash](https://kamui-platform.com) platform via its MCP server.

| Skill | What it does |
| --- | --- |
| `kamui-github-setup` | Get GitHub-ready for KamuiDash with the `gh` CLI — check/install gh, authenticate, create or connect the deploy repo. Drives safe steps proactively; confirms before destructive ones. |
| `kamui-mcp-setup` | Set up and verify Kamui MCP for AI assistants — PAT safety, client registration, connection tests, auth troubleshooting. |
| `kamui-deploy-workflows` | Deploy Kamui projects and GitHub-backed dynamic/static apps through MCP — project creation, app settings, commands, env vars, safety checks. |
| `kamui-troubleshooting` | Diagnose Kamui deployment & runtime issues through MCP — app status, deploy runs, deploy logs, build failures, runtime logs. |

## Install

`SKILL.md` is a cross-tool standard, so these skills work in **Claude Code, Codex, and
Cursor** — only the install method differs.

### Easiest: Claude Code (no terminal, Windows & macOS)

If you use **Claude Code**, you don't need a terminal, git, or any developer setup. Just
type these two lines into the Claude Code chat box and press Enter after each:

```
/plugin marketplace add kamui-project/kamui-skills
/plugin install kamui@kamui-skills
```

Then run `/reload-plugins` (or restart Claude Code). Done — identical on Windows and Mac.
Claude Code keeps the skills updated when you push new versions. This is the standard
method used by the official [`anthropics/skills`](https://github.com/anthropics/skills)
marketplace — it handles install, caching, namespacing, trust, and auto-updates for you.

> The `/plugin` marketplace is **Claude Code only**. Codex and Cursor users use the
> one-line installer below.

### Codex & Cursor — one-line installer

These tools install skills by folder placement. Paste **one** line into your terminal; it
downloads the skills and copies them into the directory each tool reads (no git clone
needed). Re-run any time to update.

**macOS / Linux** (Terminal):

```bash
curl -fsSL https://raw.githubusercontent.com/kamui-project/kamui-skills/main/install.sh | bash
```

**Windows** (PowerShell):

```powershell
irm https://raw.githubusercontent.com/kamui-project/kamui-skills/main/install.ps1 | iex
```

By default both install for **all three tools** (into `~/.claude/skills` and
`~/.agents/skills`). After installing: Claude Code `/skills` · Codex `/skills` · Cursor
reload workspace.

Target a single tool, or a project-local Cursor folder:

```bash
# macOS / Linux
TOOL=codex ./install.sh                   # ~/.agents/skills
DEST=./.cursor/skills ./install.sh        # Cursor, project-local
```

```powershell
# Windows
.\install.ps1 -Tool codex                 # %USERPROFILE%\.agents\skills
.\install.ps1 -Dest .\.cursor\skills      # Cursor, project-local
```

| Tool | Reads skills from |
| --- | --- |
| Claude Code | `~/.claude/skills/` |
| Codex | `~/.agents/skills/`, `.agents/skills/`, `/etc/codex/skills` |
| Cursor | `.cursor/skills/`, `~/.agents/skills/`, and `~/.claude/skills/` (compat) |

> **Not an engineer?** The Claude Code route above needs no terminal at all and is the
> same on Windows and Mac. The one-line installers do require opening a terminal once
> (Terminal on Mac, PowerShell on Windows) — copy, paste, Enter.

> Maintainers: bump `metadata.version` in
> [`.claude-plugin/marketplace.json`](.claude-plugin/marketplace.json) when you publish
> updates so Claude Code clients pick them up.

## Repository layout

```
kamui-skills/
├── .claude-plugin/
│   └── marketplace.json     ← marketplace catalog (the entry point for /plugin)
├── skills/
│   ├── kamui-github-setup/SKILL.md
│   ├── kamui-mcp-setup/SKILL.md
│   ├── kamui-deploy-workflows/SKILL.md
│   └── kamui-troubleshooting/SKILL.md
├── install.sh               ← installer for macOS / Linux (Codex, Cursor)
├── install.ps1              ← installer for Windows PowerShell (Codex, Cursor)
├── LICENSE
└── README.md
```

Each skill is a folder with a `SKILL.md` (YAML front matter: `name`, `description`) that
Claude Code loads automatically.

## Uninstall

Plugin install:

```
/plugin uninstall kamui@kamui-skills
```

Script install — delete the skill folders from wherever they were installed
(`~/.claude/skills` and/or `~/.agents/skills`):

```bash
# macOS / Linux
rm -rf ~/.claude/skills/kamui-* ~/.agents/skills/kamui-*
```

```powershell
# Windows
Remove-Item "$env:USERPROFILE\.claude\skills\kamui-*","$env:USERPROFILE\.agents\skills\kamui-*" -Recurse -Force
```

## License

MIT — see [LICENSE](LICENSE).
