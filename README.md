# Kamui Skills for Claude Code

A [Claude Code](https://claude.com/claude-code) **plugin marketplace** bundling Skills for
working with the [Kamui](https://www.kamui.ai) platform via its MCP server.

| Skill | What it does |
| --- | --- |
| `kamui-mcp-setup` | Set up and verify Kamui MCP for AI assistants — PAT safety, client registration, connection tests, auth troubleshooting. |
| `kamui-deploy-workflows` | Deploy Kamui projects and GitHub-backed dynamic/static apps through MCP — project creation, app settings, commands, env vars, safety checks. |
| `kamui-troubleshooting` | Diagnose Kamui deployment & runtime issues through MCP — app status, deploy runs, deploy logs, build failures, runtime logs. |

## Install

`SKILL.md` is a cross-tool standard, so these skills work in **Claude Code, Codex, and
Cursor** — only the install method differs.

### Claude Code (recommended)

Add the marketplace and install the plugin:

```
/plugin marketplace add kamui-platform/kamui-skills
/plugin install kamui@kamui-skills
```

Then run `/reload-plugins` (or restart Claude Code). Claude Code keeps the skills updated
when you push new versions. This is the standard method used by the official
[`anthropics/skills`](https://github.com/anthropics/skills) marketplace — it handles
install, caching, namespacing, trust, and auto-updates for you.

> The `/plugin` marketplace is **Claude Code only**. Codex and Cursor users use the
> script below.

### Codex & Cursor (and Claude Code without the plugin system)

Run the bundled installer — it copies the skill folders into the global directory each
tool reads (`~/.claude/skills` for Claude Code, `~/.agents/skills` for Codex/Cursor):

```bash
git clone https://github.com/kamui-platform/kamui-skills.git
cd kamui-skills && ./install.sh          # installs for all three by default
```

Target a single tool with `TOOL=`:

```bash
TOOL=claude ./install.sh                 # ~/.claude/skills
TOOL=codex  ./install.sh                 # ~/.agents/skills
TOOL=cursor ./install.sh                 # ~/.agents/skills (global)
DEST=./.cursor/skills ./install.sh       # Cursor, project-local
```

Then: Claude Code `/skills` · Codex `/skills` · Cursor reload workspace. Re-run to update.

| Tool | Reads skills from |
| --- | --- |
| Claude Code | `~/.claude/skills/` |
| Codex | `~/.agents/skills/`, `.agents/skills/`, `/etc/codex/skills` |
| Cursor | `.cursor/skills/`, `~/.agents/skills/`, and `~/.claude/skills/` (compat) |

> Replace `kamui-platform` with the GitHub account/org you push this repo to. Bump
> `metadata.version` in [`.claude-plugin/marketplace.json`](.claude-plugin/marketplace.json)
> when you publish updates so Claude Code clients pick them up.

## Repository layout

```
kamui-skills/
├── .claude-plugin/
│   └── marketplace.json     ← marketplace catalog (the entry point for /plugin)
├── skills/
│   ├── kamui-mcp-setup/SKILL.md
│   ├── kamui-deploy-workflows/SKILL.md
│   └── kamui-troubleshooting/SKILL.md
├── install.sh               ← optional manual installer
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

Manual install:

```bash
rm -rf ~/.claude/skills/kamui-deploy-workflows \
       ~/.claude/skills/kamui-mcp-setup \
       ~/.claude/skills/kamui-troubleshooting
```

## License

MIT — see [LICENSE](LICENSE).
