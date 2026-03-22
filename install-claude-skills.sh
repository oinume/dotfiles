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
REPOS=(
  "https://github.com/obra/superpowers"
  "https://github.com/microsoft/playwright-cli"
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
  local repo_url="$1"
  local diff_only="${2:-false}"
  local clone_dir
  clone_dir="$(mktemp -d)"

  echo "==> Cloning $repo_url ..."
  git clone --depth 1 --quiet "$repo_url" "$clone_dir"

  echo "--- Diff from previous install ---"

  if [ -d "$clone_dir/commands" ]; then
    show_diff "$clone_dir/commands" "$TARGET_DIR/commands" "commands"
  fi

  if [ -d "$clone_dir/skills" ]; then
    show_diff "$clone_dir/skills" "$TARGET_DIR/skills" "skills"
  fi

  echo "----------------------------------"

  if [ "$diff_only" = "false" ]; then
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

    echo "    Done: $repo_url"
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
