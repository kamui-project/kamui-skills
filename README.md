# KamuiDash

Deploy and manage your apps on KamuiDash from Claude. This plugin combines the KamuiDash MCP connector with two skills for deployment and troubleshooting.

## What you can do

- Recommend deployment settings from the repository's actual source for Go, Node.js, Python, Ruby, and static sites.
- Publish or update an app within the scope you approve, then check the relevant deployment and application URL.
- Configure a custom domain, copy the DNS records shown by KamuiDash, and check verification and HTTPS.
- Investigate failures using the matching logs and execution results, explaining what is known and what still needs checking.

## Get started

After adding the plugin, open its Connectors tab and connect KamuiDash. Sign in with your KamuiDash account and grant access. The plugin uses the same server URL as the existing KamuiDash connector in the Claude directory.

GitHub deployments require the KamuiDash GitHub App to access your selected repository. Repository inspection also needs an authorized source reader or relevant non-secret files; the KamuiDash connector itself does not read source files.

Try asking:

- "Publish this repository on KamuiDash. Recommend the commands from its source."
- "The new deployment failed, but the old version still responds. Check the logs."
- "Connect this app to my domain and tell me which DNS records to add and how to check them."

Before resource changes, the workflow explains the target, public exposure, applicable cost, and service or data impact. Existing approval for the identical action is reused. DNS records are entered in your DNS provider's management screen; the connector does not edit external DNS.

## Data and access

The plugin includes instructions and a connection to the KamuiDash service. Signing in authorizes access under your KamuiDash account permissions; the skills do not grant additional permissions. Enter application secrets in secure KamuiDash dashboard settings, never in chat or tool arguments.

- [Documentation](https://docs.kamui-platform.com/mcp.html)
- [Privacy policy](https://dashboard.kamui-platform.com/en/documents/privacy-policy)
- [Terms of use](https://dashboard.kamui-platform.com/en/documents/terms-of-use)
- [Support](https://dashboard.kamui-platform.com/en/inquiry)

## Source and distribution

The two skill directories are shared source for ChatGPT and Claude. The Claude bundle is declared by `.claude-plugin/plugin.json` and `.mcp.json`. Updating this repository does not automatically update the approved ChatGPT listing; each host uses its own release and review process.

This repository has no local installer or Claude Code marketplace. Earlier local installations and manually added permissions are not automatically removed. Users of the former GitHub setup skill should remove the broad `Bash(gh api:*)` allow rule from their Claude Code permission settings.

## License

MIT; see `LICENSE`. Published by SIMD LLC.
