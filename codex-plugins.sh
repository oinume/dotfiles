#!/bin/sh

set -eu

# Install Codex plugins from configured marketplace snapshots.
# Marketplaces and the installed-plugin state are managed by codex itself
# and intentionally not version-controlled.
if ! command -v codex >/dev/null 2>&1; then
    echo "codex command not found; skipping plugin installation"
    exit 0
fi

plugins="
superpowers@openai-curated
"
existing_plugins=$(codex plugin list 2>/dev/null || true)
printf '%s\n' "$plugins" | while read -r plugin; do
    [ -z "$plugin" ] && continue
    # `codex plugin list` prints one line per plugin, e.g.
    #   superpowers@openai-curated  installed, enabled  5.1.3  /path/...
    #   superpowers@openai-curated  not installed              /path/...
    status_line=$(printf '%s\n' "$existing_plugins" | grep "^$plugin[[:space:]]" || true)
    if [ -n "$status_line" ] && ! printf '%s\n' "$status_line" | grep -q "not installed"; then
        echo "Plugin already installed: $plugin"
    else
        echo "Installing plugin: $plugin"
        codex plugin add "$plugin"
    fi
done
