# KamuiDash Skills

Shared skill source for bundling with the KamuiDash connectors in ChatGPT and Claude.

| Skill | Purpose |
| --- | --- |
| `kamui-deploy-workflows` | Recommend deployment settings from repository evidence, publish or update authorized apps, guide custom-domain DNS setup, and verify the requested result. |
| `kamui-troubleshooting` | Investigate failures using matching logs and execution results, distinguish established facts from unknown causes, and propose supported repairs. |

## Use

With KamuiDash connected in ChatGPT or Claude, ask for the workflow you need:

- "Publish this repository on KamuiDash. Recommend the commands from its source."
- "The new deployment failed, but the old version still responds. Check the logs."
- "Connect this app to my domain and tell me which DNS records to add and how to check them."

Skills do not grant permissions. Changes follow the host/server approval requirements and the user's authorized scope. Enter application secrets in secure KamuiDash dashboard settings, never in chat or tool arguments.

## Distribution

The two skill directories are maintained here as shared source. Bundling and publishing them with each connector follows that host's supported release and review process. Updating this repository does not automatically update an approved connector listing.

This repository does not provide local installers or a Claude Code marketplace. Earlier local installations and manually added permissions are not automatically removed: users of the former GitHub setup skill should remove the broad `Bash(gh api:*)` allow rule from their Claude Code permission settings.

## Files

```text
skills/kamui-deploy-workflows/SKILL.md
skills/kamui-troubleshooting/SKILL.md
README.md
LICENSE
```

## Service

- [Dashboard](https://dashboard.kamui-platform.com)

## License

MIT; see `LICENSE`.
