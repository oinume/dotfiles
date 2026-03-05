#!/usr/bin/env bash

# Claude Code statusLine command
# Mirrors the bash-powerline.sh prompt style:
#   <cwd> <git-info>  [model]

# Ensure Homebrew binaries (e.g., jq, git) are on PATH
for brew_prefix in /opt/homebrew/bin /usr/local/bin; do
  [[ -x "$brew_prefix/jq" ]] && export PATH="$brew_prefix:$PATH" && break
done

# ANSI colors (will appear dimmed in the status line)
COLOR_CWD='\033[0;34m'    # blue
COLOR_GIT='\033[0;36m'    # cyan
COLOR_MODEL='\033[0;33m'  # yellow
RESET='\033[m'

# Read JSON from stdin
input=$(cat)

# Extract cwd and model from JSON
cwd=$(echo "$input" | jq -r '.cwd // .workspace.current_dir // ""')
model=$(echo "$input" | jq -r '.model.display_name // ""')

# Shorten the path: keep last 2 components (mirrors PROMPT_DIRTRIM=2)
short_cwd=$(echo "$cwd" | awk -F'/' '{
    n = NF
    if (n <= 2) {
        print $0
    } else {
        print "..." "/" $(n-1) "/" $n
    }
}')
# Replace $HOME prefix with ~
home="$HOME"
short_cwd="${short_cwd/#$home/\~}"

# Git info (mirrors bash-powerline.sh logic, skips optional locks)
SYMBOL_GIT_BRANCH=''
SYMBOL_GIT_MODIFIED='*'
SYMBOL_GIT_PUSH='↑'
SYMBOL_GIT_PULL='↓'

git_info=""
if command -v git &>/dev/null && git -C "$cwd" rev-parse --git-dir &>/dev/null 2>&1; then
    ref=$(env LANG=C git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null)
    if [[ -n "$ref" ]]; then
        ref="${SYMBOL_GIT_BRANCH}${ref}"
    else
        ref=$(env LANG=C git -C "$cwd" describe --tags --always 2>/dev/null)
    fi

    if [[ -n "$ref" ]]; then
        marks=""
        while IFS= read -r line; do
            if [[ $line =~ ^## ]]; then
                [[ $line =~ ahead\ ([0-9]+) ]] && marks+=" ${SYMBOL_GIT_PUSH}${BASH_REMATCH[1]}"
                [[ $line =~ behind\ ([0-9]+) ]] && marks+=" ${SYMBOL_GIT_PULL}${BASH_REMATCH[1]}"
            else
                marks="${SYMBOL_GIT_MODIFIED}${marks}"
                break
            fi
        done < <(env LANG=C git -C "$cwd" -c gc.auto=0 status --porcelain --branch 2>/dev/null)
        git_info=" ${ref}${marks}"
    fi
fi

# Build and print the status line
printf "${COLOR_CWD}%s${RESET}" "$short_cwd"
if [[ -n "$git_info" ]]; then
    printf "${COLOR_GIT}%s${RESET}" "$git_info"
fi
if [[ -n "$model" ]]; then
    printf "  ${COLOR_MODEL}[%s]${RESET}" "$model"
fi
