#!/usr/bin/env bash
# Install/update Claude Code skills and commands from multiple repos into home.claude/
#
# Usage:
#   ./install-claude-skills.sh              # Show diff then install all configured repos
#   ./install-claude-skills.sh <repo-url>   # Show diff then install a specific repo by URL
#   ./install-claude-skills.sh --diff       # Show diff only, do not install

set -euo pipefail

# List of repos to install skills/commands from.
# Each repo is expected to have skills/ and/or commands/ directories at its root.
# Use "repo_url#skill_name" to install only a specific skill from a repo.
REPOS=(
  "https://github.com/obra/superpowers"
  "https://github.com/microsoft/playwright-cli"
  "https://github.com/anthropics/skills#skill-creator"
)

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET_DIR="$DOTFILES_DIR/home.claude"

show_diff() {
  local src="$1"
  local dst="$2"
  local label="$3"

  if [ ! -d "$dst" ]; then
    echo "    [new] $label/ (no existing files)"
    return
  fi

  local diff_output
  diff_output="$(diff -rq "$dst" "$src" 2>/dev/null || true)"

  if [ -z "$diff_output" ]; then
    echo "    [unchanged] $label/"
    return
  fi

  echo "    [changes] $label/:"
  # Show unified diff for changed/new files
  diff -ru "$dst" "$src" 2>/dev/null || true
}

install_repo() {
  local entry="$1"
  local diff_only="${2:-false}"
  local clone_dir
  clone_dir="$(mktemp -d)"

  # Parse "repo_url#skill_name" format
  local repo_url="${entry%%#*}"
  local skill_name=""
  if [[ "$entry" == *"#"* ]]; then
    skill_name="${entry##*#}"
  fi

  echo "==> Cloning $repo_url ..."
  git clone --depth 1 --quiet "$repo_url" "$clone_dir"

  echo "--- Diff from previous install ---"

  if [ -n "$skill_name" ]; then
    # Selective: only a specific skill
    if [ -d "$clone_dir/skills/$skill_name" ]; then
      show_diff "$clone_dir/skills/$skill_name" "$TARGET_DIR/skills/$skill_name" "skills/$skill_name"
    else
      echo "    [error] skills/$skill_name not found in $repo_url"
    fi
  else
    # Full: all commands and skills
    if [ -d "$clone_dir/commands" ]; then
      show_diff "$clone_dir/commands" "$TARGET_DIR/commands" "commands"
    fi

    if [ -d "$clone_dir/skills" ]; then
      show_diff "$clone_dir/skills" "$TARGET_DIR/skills" "skills"
    fi
  fi

  echo "----------------------------------"

  if [ "$diff_only" = "false" ]; then
    if [ -n "$skill_name" ]; then
      # Selective: copy only the specified skill
      if [ -d "$clone_dir/skills/$skill_name" ]; then
        echo "    Copying skills/$skill_name ..."
        mkdir -p "$TARGET_DIR/skills"
        cp -r "$clone_dir/skills/$skill_name" "$TARGET_DIR/skills/"
      fi
    else
      # Full: copy all commands and skills
      if [ -d "$clone_dir/commands" ]; then
        echo "    Copying commands ..."
        mkdir -p "$TARGET_DIR/commands"
        cp "$clone_dir/commands/"*.md "$TARGET_DIR/commands/"
      fi

      if [ -d "$clone_dir/skills" ]; then
        echo "    Copying skills ..."
        mkdir -p "$TARGET_DIR/skills"
        cp -r "$clone_dir/skills/"* "$TARGET_DIR/skills/"
      fi
    fi

    echo "    Done: $entry"
  fi

  echo "    Cleaning up ..."
  rm -rf "$clone_dir"
}

DIFF_ONLY=false
REPO_ARG=""

for arg in "$@"; do
  case "$arg" in
    --diff) DIFF_ONLY=true ;;
    *) REPO_ARG="$arg" ;;
  esac
done

if [ -n "$REPO_ARG" ]; then
  install_repo "$REPO_ARG" "$DIFF_ONLY"
else
  for repo in "${REPOS[@]}"; do
    install_repo "$repo" "$DIFF_ONLY"
  done
  if [ "$DIFF_ONLY" = "false" ]; then
    echo ""
    echo "All skills installed to $TARGET_DIR"
  fi
fi
