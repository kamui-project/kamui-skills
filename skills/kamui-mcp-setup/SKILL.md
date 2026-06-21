---
name: kamui-mcp-setup
description: Set up and verify Kamui MCP for AI assistants, including PAT safety, client registration, connection tests, and MCP authentication troubleshooting.
---

# Kamui MCP Setup

## Purpose

Help a user connect an AI assistant to Kamui MCP so the assistant can inspect Kamui projects, deploy GitHub-backed apps, and read logs through MCP tools. Prefer MCP for AI-assisted Kamui work once the connection is configured.

## Default Setup Flow

1. Confirm the user has the `kamui` CLI installed. If not, suggest installing it from the Kamui CLI release or Homebrew instructions.
2. Ask the user to authenticate if needed:

```bash
kamui login
```

3. Register the MCP server with the target AI client when the client is supported by the CLI. Prefer `--register` because the token is written to the client config and does not appear in chat, stdout, shell history, or process arguments.

```bash
kamui mcp setup --client codex --register
kamui mcp setup --client claude-code --register
kamui mcp setup --client cursor --register
```

4. Verify connectivity:

```bash
kamui mcp test
```

5. In the AI assistant, verify that Kamui tools are visible. Expected tools include `list_projects`, `get_project`, `create_project`, `get_app`, `get_app_logs`, `list_deploy_runs`, `get_deploy_run_logs`, `create_app`, and `create_static_app`.

## ChatGPT Notes

ChatGPT does not read local Skill folders directly. To use Kamui from ChatGPT, configure Kamui as a custom MCP app/connector from ChatGPT's app or connector settings, using the public Kamui MCP server URL if it is compatible with ChatGPT's current MCP requirements. ChatGPT connects to remote MCP servers, not local files such as this repository's `skills/` directory.

For ChatGPT workspaces, check the current plan and admin/developer-mode requirements before assuming write tools are available. If only read/fetch actions are supported, use ChatGPT for inspection and use the Kamui dashboard or CLI for creation.

## Token Safety Rules

- Prefer `kamui mcp setup --client CLIENT --register` for supported local AI clients.
- Use `--token-file` when a token must be stored for later use without printing it.
- Use `--token-from-env` or `$KAMUI_PAT` when testing or configuring from an environment variable.
- Avoid passing PATs with command-line flags such as `--token VALUE`; they can leak through process lists or transcripts.
- Never ask the user to paste a PAT into chat unless there is no safer path and they explicitly accept the risk.
- If a token may have leaked, guide the user to revoke it with `kamui tokens delete TOKEN_ID --yes` or through the dashboard.

## Config Snippets Without Registration

If direct registration is unavailable, show config snippets with placeholders:

```bash
kamui mcp config codex
kamui mcp config claude-code
kamui mcp config cursor
```

To embed a token safely from a file or environment variable:

```bash
kamui mcp config codex --token-file ~/.kamui/pat
kamui mcp config codex --token-from-env KAMUI_PAT
```

## Troubleshooting Setup

- If `kamui mcp test` says no token is available, run `kamui login` or configure a PAT with `kamui mcp setup`.
- If the AI client does not show tools after registration, restart the AI client and re-run its MCP tool discovery.
- If registration fails, print a placeholder config with `kamui mcp config CLIENT` and help the user place it in the client config manually.
- If the API URL is customized, preserve the CLI's configured API URL rather than hardcoding one.

## Handoff After Setup

Once MCP is working:

- Use `kamui-deploy-workflows` for creating projects or deploying apps.
- Use `kamui-troubleshooting` for failed deploys, unhealthy apps, runtime logs, or deploy logs.
