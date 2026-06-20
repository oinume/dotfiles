# dotfiles

## Install

```bash
$ git clone https://github.com/oinume/dotfiles --recurse-submodules
$ cd dotfiles
$ ./setup.sh
```

## Install macOS applications with homebrew

```bash
brew bundle install
```

## Set up Claude Code

```
./claude.sh
```

Install Claude Code plugins

```
./claude-plugins.sh
```

## Set up Codex

```
./codex.sh
```

Install Codex plugins

```
./codex-plugins.sh
```

## Agent skills

Installing agent skills with `gh skill install <repo> <skill>`

Following skills are installed in this repo.

```
gh skill install vercel-labs/agent-skills react-best-practices
gh skill install anthropics/skills frontend-design
```
