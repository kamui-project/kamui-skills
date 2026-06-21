---
name: kamui-deploy-workflows
description: Deploy Kamui projects and GitHub-backed dynamic or static apps through MCP, including project creation, app settings, commands, env vars, and safety checks.
---

# Kamui Deploy Workflows

## Operating Model

Use Kamui MCP as the default path. The assistant should inspect current state, collect missing inputs, summarize the planned create operation, and call the MCP create tool only after explicit user confirmation.

Available MCP tools for this workflow:

- Discovery: `list_projects`, `get_project`, `get_app`
- Creation: `create_project`, `create_app`, `create_static_app`
- Diagnostics after creation: `list_deploy_runs`, `get_deploy_run_logs`, `get_app_logs`

Destructive and update operations are intentionally outside the MCP-first workflow. For deletes, app updates, billing changes, database operations, member management, or custom domains, guide the user to the Kamui dashboard or CLI.

## Safety Gate For Create Tools

Before calling `create_project`, `create_app`, or `create_static_app`:

1. Show a concise summary of every argument that will be sent.
2. Mention that the operation creates Kamui resources and may start a deployment.
3. Ask for explicit approval in plain language.
4. Do not call the tool until the user approves.

Never include secret values in the summary. For environment variables, show key names and redact values unless the user explicitly asks to review a non-secret value.

## Project Workflow

1. Call `list_projects` first unless the current project ID is already known from this conversation.
2. If the user needs a new project, collect:
   - `name`
   - `plan_type`: `free` or `pro`
   - `region`: currently `tokyo`
   - `description`: optional, max 80 characters
3. Warn that the free plan allows up to two projects when relevant.
4. Apply the create safety gate, then call `create_project`.
5. Call `list_projects` or `get_project` afterward to confirm the created project is visible.

## Dynamic App Workflow

Use `create_app` for server-side applications.

Collect these required inputs:

- `project_id`
- `app_name`
- `app_type`: `dynamic`
- `language_type`: `go`, `node`, or `python` unless the platform has added another supported language
- `replicas`
- `app_spec_type`: `nano`, `small`, `medium`, or `large`
- `organization_name`
- `owner_type`: `Organization` or `User`
- `repository_name`
- `repository_branch`
- `start_command`

Collect optional inputs when needed:

- `directory` for monorepos
- `setup_command` for dependency install or build
- `pre_command` for one-time startup work such as migrations
- `env_vars` as a map of environment variables

Command guidance:

- Go: build into `out/`, for example `go build -trimpath -ldflags="-s -w" -o out/app .`, then start with `out/app`.
- Node.js: common setup is `npm install` or `npm ci`; common build is `npm run build`; common start is `npm start`.
- Python: common setup is `pip install -r requirements.txt`; common start is `python main.py`.
- The platform sets the listen port. Do not set `PORT` in environment variables.

Environment variable rules:

- Keys must match `^[A-Za-z_][A-Za-z0-9_]*$`.
- Keys are max 64 characters.
- Do not use surrounding whitespace.
- Do not send case-insensitive duplicates such as `api_key` and `API_KEY`.
- Reserved keys are `PORT`, `PATH`, `HOME`, `SHELL`, and `CI`.

After the user approves, call `create_app`. Then inspect status with `get_app` and, if deployment is still in progress or failed, use `kamui-troubleshooting` style diagnostics.

## Static App Workflow

Use `create_static_app` for GitHub-backed static sites.

Collect these required inputs:

- `project_id`
- `app_name`
- `replicas`
- `app_spec_type`: `nano`, `small`, `medium`, or `large`
- `organization_name`
- `owner_type`: `Organization` or `User`
- `repository_name`
- `repository_branch`

Collect optional `directory` for the static output directory or monorepo subdirectory. For common frontend builds, confirm whether the deployed directory should be `dist`, `build`, `out`, or the repository root.

After the user approves, call `create_static_app`. Then use `get_app` and deploy logs to confirm progress.

## GitHub Repository Prerequisite

For GitHub-backed deployments, the KamuiDash GitHub App must have access to the target repository. If the repository is not available or deployment fails due to repository access, guide the user to install or update the GitHub App access from the dashboard before retrying.

## Fallbacks

If MCP is unavailable:

- Use `kamui-mcp-setup` to configure MCP.
- For interactive CLI fallback, guide the user through `kamui projects create`, `kamui projects list`, `kamui apps create`, and `kamui apps list -p PROJECT`.
- For dashboard fallback, guide the user to create projects and apps in the web UI, especially for operations not exposed through MCP.
