---
name: update-agent-skill
description: Update GitHub-sourced agent skills tracked in this dotfiles repository by using `gh skill update`. Use when the user asks to refresh, upgrade, or check for updates to the skills under `home.codex/skills` and `home.claude/skills`.
---

# Update Agent Skill

Update repository-managed Codex and Claude Code skills while preserving local work.
This is the counterpart to `install-agent-skill`, which adds new skills to the same
managed directories.

## Workflow

1. Resolve the repository root so the commands below work from any subdirectory, and
   confirm it is this dotfiles repository:

   ```bash
   ROOT="$(git rev-parse --show-toplevel)"
   test -d "$ROOT/home.codex/skills" && test -d "$ROOT/home.claude/skills" || \
     echo "Not the dotfiles repository: $ROOT"
   ```

   Stop and ask the user for the dotfiles checkout path if either directory is missing.
2. Run `gh skill update --help` to verify that the installed GitHub CLI supports
   `--dir`, `--dry-run`, and `--all`. Do not rely on remembered flags if the CLI has changed.
3. Inspect the working tree before updating:

   ```bash
   git -C "$ROOT" status --short -- home.codex/skills home.claude/skills
   ```

   Stop and report the affected paths if either managed directory contains changes that
   predate this task. Do not overwrite or revert them.
4. Check for local customizations that are already committed. `gh skill update`
   re-downloads and overwrites a skill whenever the remote tree SHA differs, so committed
   edits are reverted just as silently as uncommitted ones — a plain update is not safe
   merely because the working tree is clean:

   ```bash
   git -C "$ROOT" log --oneline -- home.codex/skills home.claude/skills
   ```

   Report any commit that looks like a local edit rather than an import or an update run,
   and confirm with the user before updating the skill it touched.
5. For each managed directory, preview available updates:

   ```bash
   gh skill update --dry-run --dir "$ROOT/home.codex/skills"
   gh skill update --dry-run --dir "$ROOT/home.claude/skills"
   ```

   `gh skill update` exits 0 and prints `No installed skills found.` when it is pointed at
   a directory with no GitHub-sourced skills. Treat that output as a failure to locate the
   skills, not as "everything is up to date", and re-check `$ROOT` before continuing.
6. Update all GitHub-tracked skills non-interactively:

   ```bash
   gh skill update --all --dir "$ROOT/home.codex/skills"
   gh skill update --all --dir "$ROOT/home.claude/skills"
   ```

   Skills without `github-repo`, `github-path`, and `github-tree-sha` metadata may be
   skipped; report them rather than guessing their source.
7. Review the result with:

   ```bash
   git -C "$ROOT" status --short -- home.codex/skills home.claude/skills
   git -C "$ROOT" diff --check -- home.codex/skills home.claude/skills
   git -C "$ROOT" diff --stat -- home.codex/skills home.claude/skills
   ```

8. Summarize updated, unchanged, pinned, and skipped skills. Do not commit or publish
   unless the user asks.

## Guardrails

- Always pass `--dir "$ROOT/..."` rather than a bare relative path, so the commands do not
  depend on the current directory.
- Do not use `--force`. A plain update already overwrites files when the remote tree SHA
  differs; `--force` additionally re-downloads skills that `gh` would otherwise leave
  alone, widening the blast radius.
- Do not use `--unpin` unless the user explicitly asks to remove version pins.
- Update both managed directories even when they contain the same skill because each
  directory is tracked independently in this repository.
- Ignore `.system` skills and other manually maintained skills when `gh` reports that they
  lack GitHub source metadata.
