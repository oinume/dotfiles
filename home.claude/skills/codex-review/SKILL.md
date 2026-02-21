---
allowed-tools: Bash(codex review:*)
description: Run code review using codex review command
---

Run `codex review` to review code changes based on the user's request. Source with `. ~/.bash_local` then check `lcodex` function is available. If `lcodex` is available, use it instead of `codex`.

### Usage

- Review uncommitted changes: `codex review --uncommitted`
- Review against a base branch: `codex review --base <branch>`
- Review a specific commit: `codex review --commit <sha>`
- With custom instructions: `codex review --base main "Focus on error handling"`

### Behavior

1. If the user specifies a branch or commit, use the corresponding flag.
2. If no specific target is given, default to `codex review --uncommitted`.
3. If the user provides review instructions, pass them as the prompt argument.
4. Output the review results as-is without modification.
