# KamuiDash Skills

Evidence-based deployment and troubleshooting workflows for KamuiDash MCP.

| Skill | Purpose |
| --- | --- |
| `kamui-deploy-workflows` | Inspect available repository evidence, recommend settings for Go, Node.js, Python, Ruby, or static sites, publish/update authorized resources, guide custom-domain DNS setup, and verify the requested result. |
| `kamui-troubleshooting` | Match incidents to logs and execution results, distinguish established facts from unknown causes, and propose supported repairs. |

## Use

Connect KamuiDash in your host, then ask for the workflow you need:

- "Publish this repository on KamuiDash. Recommend the commands from its source."
- "The new deployment failed, but the old version still responds. Check the logs."
- "Find out why the Rails app failed to start. Do not change anything yet."
- "Connect this app to my domain and tell me which DNS records to add and how to check them."

GitHub deployments require the KamuiDash GitHub App to access the selected repository. A host's separate GitHub connection is not a substitute. Hosted use does not require a local CLI.

For domain setup, the workflow explains the records shown by KamuiDash, where to enter them at the DNS provider, and how to check domain verification and HTTPS. KamuiDash MCP does not edit external DNS records.

Skills do not grant permissions or replace the host/server approval rules. Before publishing or changing resources, the workflow explains the target, exposure, applicable cost, and service/data impact. Existing explicit approval for the identical action is reused.

Keep passwords, API keys, tokens, connection strings, and private keys out of chat and tool arguments. Enter application secrets in secure KamuiDash dashboard settings. KamuiDash injects `DATABASE_URL` when a database is attached.

The current KamuiDash MCP does not read repository files, create GitHub repositories, or push code. Repository inspection uses available authorized source readers; if unavailable, only relevant non-secret excerpts are requested. Accepted requests are not proof of a live release.

## Local installation

For the existing Claude Code marketplace:

```text
/plugin marketplace add kamui-project/kamui-skills
/plugin install kamui@kamui-skills
```

Enable or reload the plugin as your host requires and configure its KamuiDash connection separately. The marketplace retains its existing `kamui` identity.

Other compatible local hosts can install the two skill directories according to their current supported paths. Existing `install.sh` and `install.ps1` copy only these two skills; they are optional local-install helpers, not hosted-plugin prerequisites. Removing an older globally installed setup skill is a separate explicit cleanup; the installer does not silently remove older unrelated folders.

Public OpenAI/Claude distribution requires its own current packaging and review process. This repository's Claude Code marketplace is not itself a submitted hosted-plugin release. Updating this repository does not automatically update the skills in an approved public listing.

## Layout

```text
.claude-plugin/marketplace.json
.claude-plugin/plugin.json
skills/kamui-deploy-workflows/SKILL.md
skills/kamui-troubleshooting/SKILL.md
install.sh
install.ps1
LICENSE
```

The two former setup skills are no longer part of this package. The deployed MCP server and its approved identities/endpoints are maintained separately and are not changed by this package.

## Service

- [Dashboard](https://dashboard.kamui-platform.com)
- [Pricing information](https://dashboard.kamui-platform.com/documents/spec-price-overview)

## License

MIT; see `LICENSE`.
