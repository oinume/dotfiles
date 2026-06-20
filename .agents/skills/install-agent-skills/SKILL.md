---
name: install-agent-skills
description: Install a named skill from a GitHub repository for both Codex and Claude Code at user scope. Use when the user provides or wants to provide a repository and skill to install for both agents.
---

# Install Agent Skills

Install one skill from a GitHub repository for both Codex and Claude Code.

## Inputs

Determine these two values from the user's request:

- `repo`: GitHub repository in `OWNER/REPO` format.
- `skill`: Skill name, namespaced name, exact skill path, or `skill@version` accepted by `gh skill install`.

If either value is missing and cannot be inferred from the conversation, ask the user for it before running any command. Repeat both resolved values before installation when they are ambiguous.

## Installation

Run these commands separately so each agent receives the skill at user scope:

```bash
gh skill install <repo> <skill> --agent codex --scope user
gh skill install <repo> <skill> --agent claude-code --scope user
```

Replace `<repo>` and `<skill>` with the resolved input values. Preserve a version suffix or exact path when the user supplied one. Do not add `--force`, `--pin`, `--all`, or other options unless the user requests that behavior.

If the first command fails, diagnose and report the failure before deciding whether the second command can still run. Never report success for an agent whose command failed.

## Result

Report the installation result for Codex and Claude Code separately, including the installed skill name and repository. Include any action the user must take when `gh` reports an authentication, repository access, or overwrite prompt problem.
