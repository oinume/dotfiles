#!/bin/sh

set -eu

cwd="$HOME/workspace/oinume/blog"

if [ ! -d "$cwd" ]; then
    echo "Directory not found: $cwd" >&2
    exit 1
fi

cmux new-workspace \
    --name blog \
    --cwd "$cwd" \
    --focus true
