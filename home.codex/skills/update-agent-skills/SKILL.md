---
name: update-agent-skills
description: Update GitHub-sourced agent skills tracked in this dotfiles repository by using `gh skill update`. Use when the user asks to refresh, upgrade, or check for updates to the skills under `home.codex/skills` and `home.claude/skills`.
---

# Update Agent Skills

Update repository-managed Codex and Claude Code skills while preserving local work.

## Workflow

1. Resolve the repository root with `git rev-parse --show-toplevel` and confirm it is this dotfiles repository.
2. Run `gh skill update --help` to verify that the installed GitHub CLI supports `--dir`, `--dry-run`, and `--all`. Do not rely on remembered flags if the CLI has changed.
3. Inspect the working tree before updating:

   ```bash
   git status --short -- home.codex/skills home.claude/skills
   ```

   Stop and report the affected paths if either managed directory contains changes that predate this task. Do not overwrite or revert them.
4. For each existing managed directory, preview available updates:

   ```bash
   gh skill update --dry-run --dir home.codex/skills
   gh skill update --dry-run --dir home.claude/skills
   ```

5. Update all GitHub-tracked skills non-interactively:

   ```bash
   gh skill update --all --dir home.codex/skills
   gh skill update --all --dir home.claude/skills
   ```

   Skills without `github-repo`, `github-path`, and `github-tree-sha` metadata may be skipped; report them rather than guessing their source.
6. Review the result with:

   ```bash
   git status --short -- home.codex/skills home.claude/skills
   git diff --check -- home.codex/skills home.claude/skills
   git diff --stat -- home.codex/skills home.claude/skills
   ```

7. Summarize updated, unchanged, pinned, and skipped skills. Do not commit or publish unless the user asks.

## Guardrails

- Do not use `--force`; it can overwrite local modifications.
- Do not use `--unpin` unless the user explicitly asks to remove version pins.
- Update both managed directories even when they contain the same skill because each directory is tracked independently in this repository.
- Ignore `.system` skills and other manually maintained skills when `gh` reports that they lack GitHub source metadata.
