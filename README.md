# Kamui Skills for Claude Code

A [Claude Code](https://claude.com/claude-code) **plugin marketplace** bundling Skills for
working with the [Kamui](https://www.kamui.ai) platform via its MCP server.

| Skill | What it does |
| --- | --- |
| `kamui-mcp-setup` | Set up and verify Kamui MCP for AI assistants — PAT safety, client registration, connection tests, auth troubleshooting. |
| `kamui-deploy-workflows` | Deploy Kamui projects and GitHub-backed dynamic/static apps through MCP — project creation, app settings, commands, env vars, safety checks. |
| `kamui-troubleshooting` | Diagnose Kamui deployment & runtime issues through MCP — app status, deploy runs, deploy logs, build failures, runtime logs. |

## Install

Inside Claude Code, add the marketplace and install the plugin:

```
/plugin marketplace add YOUR_GH_USER/kamui-skills
/plugin install kamui@kamui-skills
```

Then run `/reload-plugins` (or restart Claude Code). All three `kamui-*` skills are now
available. Claude Code keeps them updated when you push new versions.

> Replace `YOUR_GH_USER` with the GitHub account/org you push this repo to. Also bump
> `metadata.version` in [`.claude-plugin/marketplace.json`](.claude-plugin/marketplace.json)
> when you publish updates so clients pick them up.

This is the standard distribution method used by the official
[`anthropics/skills`](https://github.com/anthropics/skills) marketplace and the community
marketplaces — it handles install, caching, namespacing, trust, and auto-updates for you.

## Alternative: manual install (no plugin system)

If you'd rather drop the skills straight into `~/.claude/skills/` without the plugin
manager, run the bundled script:

```bash
git clone https://github.com/YOUR_GH_USER/kamui-skills.git
cd kamui-skills && ./install.sh
```

It copies the three skill folders into `~/.claude/skills/` (honors `CLAUDE_SKILLS_DIR`).
Re-run to update. This path skips Claude Code's version/auto-update machinery.

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
