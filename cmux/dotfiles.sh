#!/bin/sh

set -eu

cwd="$HOME/dotfiles"

if [ ! -d "$cwd" ]; then
    echo "Directory not found: $cwd" >&2
    exit 1
fi

cmux workspace create \
    --name dotfiles \
    --cwd "$cwd" \
    --layout '{"pane":{"surfaces":[{"type":"terminal"},{"type":"terminal","focus":true}]}}' \
    --focus true
