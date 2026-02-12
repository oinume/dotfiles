#!/bin/sh

set -eu

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

mkdir -p ~/.claude
for entry in "$DOTFILES_DIR"/my.claude/*; do
    name=$(basename "$entry")
    target="$HOME/.claude/$name"
    if [ -e "$target" ] || [ -L "$target" ]; then
        rm -rf "$target"
        echo "Removed $target"
    fi
    ln -s "$entry" "$target"
    echo "Linked $target -> $entry"
done
