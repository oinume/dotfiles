#!/bin/sh

set -eu

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

mkdir -p ~/.claude
for entry in "$DOTFILES_DIR"/home.claude/*; do
    name=$(basename "$entry")
    target="$HOME/.claude/$name"
    if [ -e "$target" ] || [ -L "$target" ]; then
        rm -rf "$target"
        echo "Removed $target"
    fi
    ln -s "$entry" "$target"
    echo "Linked $target -> $entry"
done

# Install Claude Code marketplaces and plugins.
# installed_plugins.json / known_marketplaces.json are managed by claude itself
# and intentionally not version-controlled (noisy timestamps & commit SHAs).
if ! command -v claude >/dev/null 2>&1; then
    echo "claude command not found; skipping plugin installation"
    exit 0
fi

marketplaces="
claude-plugins-official|anthropics/claude-plugins-official
anthropic-agent-skills|anthropics/skills
phpstorm-marketplace|jetbrains/phpstorm-claude-marketplace
openai-codex|openai/codex-plugin-cc
"
existing_marketplaces=$(claude plugin marketplace list 2>/dev/null || true)
printf '%s\n' "$marketplaces" | while IFS='|' read -r name repo; do
    [ -z "$name" ] && continue
    if printf '%s\n' "$existing_marketplaces" | grep -q "❯ $name$"; then
        echo "Marketplace already added: $name"
    else
        echo "Adding marketplace: $name ($repo)"
        claude plugin marketplace add "$repo"
    fi
done

plugins="
codex@openai-codex
gopls-lsp@claude-plugins-official
playwright@claude-plugins-official
"
existing_plugins=$(claude plugin list 2>/dev/null || true)
printf '%s\n' "$plugins" | while read -r plugin; do
    [ -z "$plugin" ] && continue
    if printf '%s\n' "$existing_plugins" | grep -q "❯ $plugin$"; then
        echo "Plugin already installed: $plugin"
    else
        echo "Installing plugin: $plugin"
        claude plugin install "$plugin"
    fi
done
