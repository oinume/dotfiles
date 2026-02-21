#############################
# Profiling
# Usage: BASH_PROFILE_PROFILING=1 bash -l
#############################
if [[ ${BASH_PROFILE_PROFILING:-0} -eq 1 ]]; then
    if [[ -n "${EPOCHREALTIME+set}" ]]; then
        _bp_get_ms() {
            local t=$EPOCHREALTIME sec frac
            sec=${t%.*}; frac=${t#*.}; frac=${frac:0:3}
            while [[ ${#frac} -lt 3 ]]; do frac="${frac}0"; done
            printf '%d' "$(( 10#$sec * 1000 + 10#$frac ))"
        }
    elif command -v gdate &>/dev/null; then
        _bp_get_ms() {
            local t
            t=$(gdate +%s%3N)
            printf '%d' "$t"
        }
    else
        _bp_get_ms() { printf '%d' "$(( $(date +%s) * 1000 ))"; }
    fi
    _bp_start=$(_bp_get_ms)
    _bp_prev=$_bp_start
    _bp_log() {
        local now total section
        now=$(_bp_get_ms)
        total=$(( now - _bp_start ))
        section=$(( now - _bp_prev ))
        printf "\033[33m[profile] %6d ms (+%4d ms)\033[0m %s\n" "$total" "$section" "$1" >&2
        _bp_prev=$now
    }
else
    _bp_log() { :; }
fi

#############################
# prompt and history
#############################
export PS_SYMBOL='$'

# If not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return;;
esac

# Cached eval: caches the output of slow `eval "$(cmd)"` calls.
# Cache is invalidated when the binary's mtime changes.
__cached_eval() {
    local cmd="$1"
    local cache_dir="${HOME}/.cache/bash_startup"
    local cache_key
    cache_key=$(echo "$cmd" | tr ' /' '__')
    local cache_file="${cache_dir}/${cache_key}"
    local bin_path
    bin_path=$(command -v "${cmd%% *}" 2>/dev/null)

    mkdir -p "$cache_dir"

    if [ -s "$cache_file" ] && [ -n "$bin_path" ] && [ "$cache_file" -nt "$bin_path" ]; then
        source "$cache_file"
    else
        local output
        output=$(eval "$cmd" 2>/dev/null)
        if [ -n "$output" ]; then
            echo "$output" > "$cache_file"
            eval "$output"
        fi
    fi
}

function share_history {
    history -a
    history -c
    history -r
}

PROMPT_COMMAND="share_history"
shopt -u histappend
export HISTSIZE=20000
export PROMPT_DIRTRIM=2
export BASH_SILENCE_DEPRECATION_WARNING=1

_bp_log "prompt/history"

#############################
# alias
#############################
alias k=kubectl
alias cdproducts='cd ~/workspace/oinume/products'
alias gco='git co main'
alias gps='git push'
alias gpl='git pull --prune'

_bp_log "alias"

#BREW_PREFIX_DIR=$(/opt/homebrew/bin/brew --prefix)
# Hardcoded to avoid slow `brew --prefix` call
if [ -d /opt/homebrew ]; then
    BREW_PREFIX_DIR=/opt/homebrew
elif [ -d /usr/local/Homebrew ]; then
    BREW_PREFIX_DIR=/usr/local
fi
BREW_CASKROOM_DIR=$BREW_PREFIX_DIR/Caskroom
HOMEBREW_NO_AUTO_UPDATE=1

_bp_log "brew --prefix"

# local
[[ -r "$HOME/.bash_local" ]] && . "$HOME/.bash_local"

_bp_log ".bash_local"

# bash-completion
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"
[[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"

_bp_log "bash-completion"

#############################
# bash-it
#############################

# Path to the bash it configuration
export BASH_IT="$HOME/dotfiles/bash-it"

# Lock and Load a custom theme file.
# Leave empty to disable theming.
# location /.bash_it/themes/
export BASH_IT_THEME=''

# (Advanced): Change this to the name of your remote repo if you
# cloned bash-it with a remote other than origin such as `bash-it`.
# export BASH_IT_REMOTE='bash-it'

# Your place for hosting Git repos. I use this for private repos.
export GIT_HOSTING='git@git.domain.com'

# Don't check mail when opening terminal.
unset MAILCHECK

# Change this to your console based IRC client of choice.
export IRC_CLIENT='irssi'

# Set this to the command you use for todo.txt-cli
export TODO="t"

# Set this to false to turn off version control status checking within the prompt for all themes
export SCM_CHECK=true

# Set Xterm/screen/Tmux title with only a short hostname.
# Uncomment this (or set SHORT_HOSTNAME to something else),
# Will otherwise fall back on $HOSTNAME.
#export SHORT_HOSTNAME=$(hostname -s)

# Set Xterm/screen/Tmux title with only a short username.
# Uncomment this (or set SHORT_USER to something else),
# Will otherwise fall back on $USER.
#export SHORT_USER=${USER:0:8}

# Set Xterm/screen/Tmux title with shortened command and directory.
# Uncomment this to set.
#export SHORT_TERM_LINE=true

# Set vcprompt executable path for scm advance info in prompt (demula theme)
# https://github.com/djl/vcprompt
#export VCPROMPT_EXECUTABLE=~/.vcprompt/bin/vcprompt

# (Advanced): Uncomment this to make Bash-it reload itself automatically
# after enabling or disabling aliases, plugins, and completions.
# export BASH_IT_AUTOMATIC_RELOAD_AFTER_CONFIG_CHANGE=1

# Uncomment this to make Bash-it create alias reload.
# export BASH_IT_RELOAD_LEGACY=1

# Load bash-it (disabled on 2026/2/11)
#source "$BASH_IT"/bash_it.sh

_bp_log "bash-it"

#############################
# Mac
#############################
_ARCH=$(uname -m)
_OS=$(uname -s)
if [ $_OS = "Darwin" ]; then
    alias abrew="arch -arch arm64e /opt/homebrew/bin/brew"
    alias xbrew="arch -arch x86_64 /usr/local/bin/brew"
    alias aexec="arch -arch arm64"
    alias xexec="arch -arch x86_64"
fi

#############################
# fzf
#############################
# TODO: Remove fzf.bash
#[ -f ~/.fzf.bash ] && source ~/.fzf.bash
__cached_eval "$BREW_PREFIX_DIR/bin/fzf --bash"
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
export FZF_DEFAULT_OPTS='--height 70% --border'

_bp_log "fzf"

# fbr - checkout git branch (including remote branches), sorted by most recent commit, limit 30 last branches
function fbr() {
    local branches branch
    branches=$(git for-each-ref --count=30 --sort=-committerdate refs/heads/ --format="%(refname:short)") &&
    branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
    git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# fshow - git commit browser
function fshow() {
    git log --graph --color=always \
        --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
    fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
        --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF"
}

# fco - checkout git branch/tag
fco() {
    local tags branches target
    branches=$(
      git --no-pager branch --all \
        --format="%(if)%(HEAD)%(then)%(else)%(if:equals=HEAD)%(refname:strip=3)%(then)%(else)%1B[0;34;1mbranch%09%1B[m%(refname:short)%(end)%(end)" \
      | sed '/^$/d') || return
    tags=$(
      git --no-pager tag | awk '{print "\x1b[35;1mtag\x1b[m\t" $1}') || return
    target=$(
      (echo "$branches"; echo "$tags") |
      fzf --no-hscroll --no-multi -n 2 \
          --ansi) || return
    git checkout $(awk '{print $2}' <<<"$target" )
}


# fco_preview - checkout git branch/tag, with a preview showing the commits between the tag/branch and HEAD
fco_preview() {
    local tags branches target
    branches=$(
      git --no-pager branch --all \
        --format="%(if)%(HEAD)%(then)%(else)%(if:equals=HEAD)%(refname:strip=3)%(then)%(else)%1B[0;34;1mbranch%09%1B[m%(refname:short)%(end)%(end)" \
      | sed '/^$/d') || return
    tags=$(
      git --no-pager tag | awk '{print "\x1b[35;1mtag\x1b[m\t" $1}') || return
    target=$(
      (echo "$branches"; echo "$tags") |
      fzf --no-hscroll --no-multi -n 2 \
          --ansi --preview="git --no-pager log -150 --pretty=format:%s '..{2}'") || return
    git checkout $(awk '{print $2}' <<<"$target" )
}

# fghpr - list pull requests with search query, then open selected pull-request with browser
# Use like `fghpr -A '@me' -s closed`
fghpr() {
    gh pr list "$@" --json number,title -q '.[] | "\(.number) \(.title)"' \
    | fzf --delimiter=' ' --with-nth=2.. \
    | awk '{print $1}' \
    | xargs -I {} gh pr view -w {}
}

#############################
# bash-powerline
#############################
[ -f ~/dotfiles/bash-powerline.sh ] && . ~/dotfiles/bash-powerline.sh

_bp_log "bash-powerline"

#############################
# tmuxinator
#############################
[ -f ~/dotfiles/.tmuxinator/tmuxinator.bash ] && . ~/dotfiles/.tmuxinator/tmuxinator.bash

_bp_log "tmuxinator"

#############################
# completion
#############################
if [ -d /usr/local/bin ]; then
    _PATH=$_PATH:/usr/local/bin
fi

# git completion (source after fzf to override fzf's generic path completion)
if [ -r "$BREW_PREFIX_DIR/etc/bash_completion.d/git-completion.bash" ]; then
    source "$BREW_PREFIX_DIR/etc/bash_completion.d/git-completion.bash"
elif [ -r "$BREW_PREFIX_DIR/share/bash-completion/completions/git" ]; then
    source "$BREW_PREFIX_DIR/share/bash-completion/completions/git"
fi

_bp_log "completion (git)"

# docker completion
if [ -r "$BREW_PREFIX_DIR/etc/bash_completion.d/docker" ]; then
    source "$BREW_PREFIX_DIR/etc/bash_completion.d/docker"
fi
if [ -r "$BREW_PREFIX_DIR/etc/bash_completion.d/docker-compose" ]; then
    source "$BREW_PREFIX_DIR/etc/bash_completion.d/docker-compose"
fi

_bp_log "completion (docker)"

# gh completion
if command -v gh &> /dev/null; then
    eval "$(gh completion -s bash)"
fi

_bp_log "completion (gh)"

#############################
# Go
#############################
if [ -d /opt/homebrew/opt/go/libexec ]; then
    export GOROOT=/opt/homebrew/opt/go/libexec
    export GOPATH=$HOME/go
    _PATH=$_PATH:$GOPATH/bin:$GOROOT/bin
fi
if command -v gocomplete &> /dev/null; then
    complete -C "$(command -v gocomplete)" go
fi
_bp_log "completion (go)"


#############################
# google-cloud-sdk
#############################

if [ -d "$BREW_CASKROOM_DIR/google-cloud-sdk/latest/google-cloud-sdk" ]; then
    source "$BREW_CASKROOM_DIR/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc"
    source "$BREW_CASKROOM_DIR/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc"
fi

_bp_log "google-cloud-sdk"

function gcloud_projects() {
    gcloud projects list
}

function gcloud_set_project() {
    gcloud config set project $1
}

# JetBrains
_PATH=$_PATH:/Users/oinume/Library/Application\ Support/JetBrains/Toolbox/scripts

#############################
# Kubernetes
#############################
function enable_kubectl_completion() {
#  source <(kubectl completion bash)
    source "$(gcloud info --format='value(config.paths.sdk_root)')/path.bash.inc" && source "$(gcloud info --format='value(config.paths.sdk_root)')/completion.bash.inc"
}

# Ruby
if [ -d /usr/local/opt/ruby ]; then
    _PATH=$_PATH:/usr/local/opt/ruby/bin
fi

# rbenv
# if [ -f /opt/homebrew/bin/rbenv ]; then
#     __cached_eval "/opt/homebrew/bin/rbenv init - bash"
#     _PATH=$_PATH:$HOME/.rbenv/shims
# fi

_bp_log "rbenv"

# JDK
JAVA_HOME=$(/usr/libexec/java_home -v "1.8")
if [ -d "$JAVA_HOME" ]; then
    _PATH=$_PATH:$JAVA_HOME/bin
fi

_bp_log "JDK (java_home)"

# Android
if [ -d ~/Library/Android/sdk/platform-tools ]; then
    _PATH=~/Library/Android/sdk/platform-tools:$_PATH
fi

# Flutter
if [ -d ~/.pub-cache/bin/ ]; then
    _PATH=$_PATH:~/.pub-cache/bin
fi

# nvm
# export NVM_DIR="$HOME/.nvm"
# function detect_nvmrc() {
#     if [[ $PWD == $PREV_PWD ]]; then
#         return
#     fi

#     PREV_PWD=$PWD
#     [[ -f ".nvmrc" ]] && nvm use
# }

# if [ -s "/usr/local/opt/nvm/nvm.sh" ]; then
#     . "/usr/local/opt/nvm/nvm.sh"
#     PROMPT_COMMAND="$PROMPT_COMMAND;detect_nvmrc"
# fi

# if [ -s "/opt/homebrew/opt/nvm/nvm.sh" ]; then
#     . "/opt/homebrew/opt/nvm/nvm.sh"
#     PROMPT_COMMAND="$PROMPT_COMMAND;detect_nvmrc"
# fi

# [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

_bp_log "nvm"

# # asdf
# if [ -x "$BREW_PREFIX_DIR/bin/asdf" ]; then
#     . "$BREW_PREFIX_DIR/opt/asdf/libexec/asdf.sh"
#     . "$BREW_PREFIX_DIR/etc/bash_completion.d/asdf"
# fi

# mise
if [ -x "$BREW_PREFIX_DIR/bin/mise" ]; then
    __cached_eval "$BREW_PREFIX_DIR/bin/mise activate bash"
    . "$BREW_PREFIX_DIR/etc/bash_completion.d/mise"
fi

_bp_log "mise"

# wtp
if [ -x "$BREW_PREFIX_DIR/bin/wtp" ]; then
    __cached_eval "wtp shell-init bash"
fi

_bp_log "wtp"

# git-wt
if [ -d "$BREW_PREFIX_DIR/Cellar/git-wt" ]; then
    __cached_eval "$(git wt --init bash)"
fi

_bp_log "git-wt"

# dart
if [ -d /usr/local/opt/ruby ]; then
    _PATH=$_PATH:$HOME/.pub-cache/bin
fi

# antigravity
if [ -d ~/.antigravity/antigravity/bin ]; then
    _PATH=$_PATH:$HOME/.antigravity/antigravity/bin
fi

# Homebrew (/opt/homebrew)
if [ -d /opt/homebrew ]; then
    _PATH=/opt/homebrew/bin:$_PATH
fi

if [ -d $HOME/.local/bin ]; then
    _PATH=$HOME/.local/bin:$_PATH
fi

# PATH
if [ -n "$_PATH" ]; then
    export PATH="$_PATH:$PATH"
fi

# direnv
__cached_eval "direnv hook bash"

_bp_log "direnv"

# pnpm
export PNPM_HOME="~/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

_bp_log "===== TOTAL ====="

# Cleanup profiling functions
if [[ ${BASH_PROFILE_PROFILING:-0} -eq 1 ]]; then
    unset -f _bp_get_ms _bp_log
    unset _bp_start _bp_prev
fi
