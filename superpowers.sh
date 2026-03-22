#!/usr/bin/env bash
# Install/update superpowers skills and commands into home.claude/
# https://github.com/obra/superpowers

set -euo pipefail

REPO_URL="https://github.com/obra/superpowers"
CLONE_DIR="$(mktemp -d)"
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET_DIR="$DOTFILES_DIR/home.claude"

echo "Cloning $REPO_URL ..."
git clone --depth 1 "$REPO_URL" "$CLONE_DIR"

echo "Copying commands ..."
mkdir -p "$TARGET_DIR/commands"
cp "$CLONE_DIR/commands/"*.md "$TARGET_DIR/commands/"

echo "Copying skills ..."
mkdir -p "$TARGET_DIR/skills"
cp -r "$CLONE_DIR/skills/"* "$TARGET_DIR/skills/"

echo "Cleaning up ..."
rm -rf "$CLONE_DIR"

echo "Done. Superpowers installed to $TARGET_DIR"
