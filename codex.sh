#!/bin/sh

set -eu

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

mkdir -p ~/.codex
for entry in "$DOTFILES_DIR"/home.codex/*; do
    name=$(basename "$entry")
    if [ "$name" = "config.toml" ]; then
        echo "Skipped $entry"
        continue
    fi
    target="$HOME/.codex/$name"
    if [ -e "$target" ] || [ -L "$target" ]; then
        rm -rf "$target"
        echo "Removed $target"
    fi
    ln -s "$entry" "$target"
    echo "Linked $target -> $entry"
done
