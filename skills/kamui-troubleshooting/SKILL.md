---
name: kamui-troubleshooting
description: Diagnose Kamui deployment and runtime issues through MCP, including app status, deploy runs, deploy logs, build failures, and runtime logs.
---

# Kamui Troubleshooting

## Operating Model

Use MCP read tools first, then explain the evidence. Keep the response practical: current state, relevant log lines or deploy-run facts, likely cause, and the next action.

Available diagnostic tools:

- `list_projects`: find projects and app IDs when the user only gives a name.
- `get_project`: inspect a project and its apps/databases.
- `get_app`: inspect app type, URL, custom domain, GitHub repo, branch, spec, language, and pod status.
- `list_deploy_runs`: list deployment runs and their statuses.
- `get_deploy_run_logs`: fetch detailed logs for one deploy run.
- `get_app_logs`: fetch latest runtime logs from the app.

All of these are read-only. Do not invent missing log content; say when logs are absent or inconclusive.

## Diagnostic Flow

1. Identify the app.
   - If the user provides an app ID, start with `get_app`.
   - If they provide a project/app name, call `list_projects`, find the project/app, then call `get_project` or `get_app`.
2. Check app state with `get_app`.
   - Look at pod status, app type, language, spec, URL, custom domain, GitHub repository, and branch.
3. Inspect deployment history.
   - Call `list_deploy_runs`.
   - Pick the newest failed or in-progress run. If all are completed, inspect the newest run when deployment behavior is still relevant.
4. Inspect detailed deploy logs.
   - Call `get_deploy_run_logs` with the selected `run_id`.
   - Look for build failures, missing commands, repository access problems, package install errors, Docker build errors, image push errors, and Kubernetes/deployer messages.
5. Inspect runtime logs.
   - Call `get_app_logs` when pods are running, restarting, unknown, or the user reports runtime behavior.
   - Look for missing environment variables, port binding issues, startup crashes, health-check failures, dependency errors, and application exceptions.

## How To Report Findings

Use this shape by default:

```text
Current state: ...
Evidence: ...
Likely cause: ...
Next action: ...
```

Keep evidence short. Quote only the smallest relevant log snippets or summarize if logs are long.

## Common Patterns

- Build command fails: recommend fixing `setup_command` or repository files, then redeploy from the dashboard or CLI if no MCP update/redeploy tool exists.
- Start command missing or wrong: explain that dynamic apps require a valid `start_command`; recommend the correct command for the runtime.
- App does not bind to the expected port: remind that Kamui sets the port and app code should read the platform-provided port rather than hardcoding an incompatible one.
- Missing environment variable: identify the missing key, do not ask the user to paste secret values, and guide them to set it through the dashboard or supported CLI path.
- GitHub repository access failure: guide the user to install or update the KamuiDash GitHub App access for that repository.
- No deploy runs found: explain that deployment may not have started or logs may not yet be available; check `get_app` and project state.
- Runtime logs are empty: say so directly and use pod status plus deploy logs to narrow the next step.

## Boundaries

MCP troubleshooting is read-only. Do not delete, update, redeploy, rotate credentials, change billing, or mutate project membership through improvised API calls. If the fix requires an operation not exposed by MCP, guide the user to the dashboard or the supported `kamui` CLI command.

## Fallbacks

If MCP is not configured, use `kamui-mcp-setup`. If the user only has CLI access, suggest:

```bash
kamui projects list
kamui projects get PROJECT_ID
kamui apps list -p PROJECT
```

For detailed deploy and runtime logs, prefer MCP once available because the current CLI surface is narrower than the MCP diagnostic tools.
