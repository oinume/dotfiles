# AGENTS.md (CLAUDE.md)

This file provides guidance to AI coding agents when working with code in this repository.
`CLAUDE.md` is a symlink to this file.

## Repository Overview

Personal dotfiles repository managing configuration for bash, git, tmux, vim/editorconfig, fzf, psql, VS Code, and tmuxinator on macOS.

## Setup

```bash
git clone --recurse-submodules git@github.com:oinume/dotfiles.git
./setup.sh        # Symlinks dotfiles to $HOME
brew bundle install  # Install Homebrew packages from Brewfile
```

`setup.sh` creates symlinks from this repo to `$HOME` for all managed dotfiles (`.bash_profile`, `.gitconfig`, `.tmux.conf`, `.psqlrc`, `.editorconfig`, `.fzf.*`, `.tmuxinator/`, VS Code configs, etc.).

## Key Files

- **`.bash_profile`** — Main shell config. Initializes Homebrew, fzf, rbenv, NVM, mise, direnv, asdf, Go, GCloud SDK, and bash-powerline prompt. Contains custom fzf functions (`fbr`, `fshow`, `fco`, `fghpr`). Supports startup profiling via `BASH_PROFILE_PROFILING=1`.
- **`setup.sh`** — Installation script that symlinks dotfiles to `$HOME`.
- **`Brewfile`** — Homebrew dependencies (formulae, casks, VS Code extensions).
- **`macos.sh`** — macOS system defaults (Finder, keyboard, Dock preferences).
- **`.gitconfig`** — Git config with SSH signing via 1Password (`op-ssh-sign`), ghq root at `~/workspace`, and custom aliases (`amend`, `cleanup-branches`, `log-fancy`, etc.).
- **`.tmux.conf`** — Tmux with `Ctrl-T` prefix, vi copy-mode, mouse support, status bar at top.
- **`bash-powerline.sh`** — Custom bash prompt with git branch display.
- **`vscode/`** — VS Code settings, keybindings, and tasks (Go with gopls/gofumpt).
- **`go.sh`** — Go tool installation script.
- **`macos.sh`** — macOS system defaults configuration.
- **`raycast/`** — Raycast script commands and configs.

## Conventions

- Dotfiles live in the repo root (not in a subdirectory) and are symlinked to `$HOME` by `setup.sh`.
- Private/personal configs go in `.mine/`.
- Tmuxinator project configs go in `.tmuxinator/`. Work-specific configs (`.tmuxinator/work-*.yml`) are gitignored.
- The `bash-it/` directory exists but bash-it is currently disabled in `.bash_profile`.
- When adding a new dotfile, add it to `setup.sh`'s symlink loop and place it in the repo root.
- Git commits are signed with SSH keys via 1Password.
