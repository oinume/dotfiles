# dotfiles

## Install

```bash
$ git clone https://github.com/oinume/dotfiles --recurse-submodules
$ cd dotfiles
$ ./setup.sh
```

## Install macOS applications with homebrew

```bash
brew bundle install
```

## Set up Claude Code

```
./claude.sh
```

Install Claude Code plugins

```
./claude-plugins.sh
```

## Set up Codex

```
./codex.sh
```

Install Codex plugins

```
./codex-plugins.sh
```

## Agent skills

User skills are managed in `home.codex/skills` and `home.claude/skills`.
`codex.sh` and `claude.sh` symlink these directories to `~/.codex/skills` and
`~/.claude/skills`, making the skills available across projects.

Install a skill for both agents from the repository root:

```bash
gh skill install vercel-labs/agent-skills react-best-practices --dir home.codex/skills
gh skill install vercel-labs/agent-skills react-best-practices --dir home.claude/skills
```

The following user skills are tracked in this repository. Built-in skills and
plugin-provided skills are managed by their respective agents and plugins.

| Skill | Agents | Source |
| --- | --- | --- |
| `apple-note` | Claude Code | [Repository-managed](home.claude/skills/apple-note/SKILL.md) |
| `browser-use` | Claude Code | [Repository-managed](home.claude/skills/browser-use/SKILL.md) |
| `codex-review` | Claude Code | [Repository-managed](home.claude/skills/codex-review/SKILL.md) |
| `eli5` | Codex, Claude Code | [anthropics/claude-plugins-community](https://github.com/anthropics/claude-plugins-community) |
| `frontend-design` | Codex, Claude Code | [anthropics/skills](https://github.com/anthropics/skills) |
| `grill-me` | Codex, Claude Code | [Repository-managed](home.codex/skills/grill-me/SKILL.md) |
| `grilling` | Codex, Claude Code | [Repository-managed](home.codex/skills/grilling/SKILL.md) |
| `modern-web-guidance` | Codex, Claude Code | [GoogleChrome/modern-web-guidance](https://github.com/GoogleChrome/modern-web-guidance) |
| `natural-japanese` | Codex, Claude Code | [coji/natural-japanese](https://github.com/coji/natural-japanese) |
| `playwright-cli` | Codex, Claude Code | [microsoft/playwright-cli](https://github.com/microsoft/playwright-cli) |
| `react-best-practices` | Codex, Claude Code | [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills) |
| `react-native-skills` | Codex, Claude Code | [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills) |
| `react-view-transitions` | Codex, Claude Code | [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills) |
| `write-plan-to-issue` | Codex, Claude Code | [Repository-managed](home.codex/skills/write-plan-to-issue/SKILL.md) |

Repository-scoped skills in `.agents/skills` support managing this inventory:

- [install-agent-skill](.agents/skills/install-agent-skill/SKILL.md): Install a GitHub skill for both agents.
- [update-agent-skill](.agents/skills/update-agent-skill/SKILL.md): Check for and apply updates to GitHub-sourced skills.

Inspect the installed user skills with:

```bash
gh skill list --dir home.codex/skills
gh skill list --dir home.claude/skills
```
