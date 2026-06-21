# Kamui Skills for Claude Code

A small bundle of [Claude Code](https://claude.com/claude-code) **Skills** for working
with the [Kamui](https://www.kamui.ai) platform via its MCP server.

| Skill | What it does |
| --- | --- |
| `kamui-mcp-setup` | Set up and verify Kamui MCP for AI assistants — PAT safety, client registration, connection tests, auth troubleshooting. |
| `kamui-deploy-workflows` | Deploy Kamui projects and GitHub-backed dynamic/static apps through MCP — project creation, app settings, commands, env vars, safety checks. |
| `kamui-troubleshooting` | Diagnose Kamui deployment & runtime issues through MCP — app status, deploy runs, deploy logs, build failures, runtime logs. |

## Install (one line)

```bash
curl -fsSL https://raw.githubusercontent.com/YOUR_GH_USER/kamui-skills/main/install.sh | bash
```

This copies the skills into `~/.claude/skills/`. Re-run it any time to update.
Then restart Claude Code (or run `/skills`) and the `kamui-*` skills will be available.

> Replace `YOUR_GH_USER` with the GitHub account/org you push this repo to.
> The same placeholder also lives in `install.sh` (`REPO=...`).

### Alternative: clone and run

```bash
git clone https://github.com/YOUR_GH_USER/kamui-skills.git
cd kamui-skills
./install.sh
```

### Custom install location

```bash
CLAUDE_SKILLS_DIR=/path/to/.claude/skills ./install.sh
```

## What gets installed

```
~/.claude/skills/
├── kamui-deploy-workflows/SKILL.md
├── kamui-mcp-setup/SKILL.md
└── kamui-troubleshooting/SKILL.md
```

Each skill is a single `SKILL.md` with YAML front matter (`name`, `description`)
that Claude Code loads automatically. Nothing else is required.

## Uninstall

```bash
rm -rf ~/.claude/skills/kamui-deploy-workflows \
       ~/.claude/skills/kamui-mcp-setup \
       ~/.claude/skills/kamui-troubleshooting
```

## License

MIT — see [LICENSE](LICENSE).
