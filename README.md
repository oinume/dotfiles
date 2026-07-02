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

Installing agent skills with `gh skill install <repo> <skill>`.

Example
```
gh skill install vercel-labs/agent-skills react-best-practices --agent codex --scope user
gh skill install vercel-labs/agent-skills react-best-practices --agent claude-code --scope user
```

Following skills are installed as user scope.

- anthropics/skills frontend-design
- microsoft/playwright-cli playwright-cli
- vercel-labes/agent-skills react-best-practices
- vercel-labs/agent-skills react-native-skills
- vercel-labs/agent-skills react-view-transitions
