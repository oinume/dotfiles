#############################
# prompt
#############################
export PS_SYMBOL='$'

# If not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return;;
esac

function share_history {
    history -a
    history -c
    history -r
}

PROMPT_COMMAND="share_history"
shopt -u histappend
export HISTSIZE=20000
export PROMPT_DIRTRIM=2

BREW_PREFIX_DIR=$(/opt/homebrew/bin/brew --prefix)
BREW_CASKROOM_DIR=$BREW_PREFIX_DIR/Caskroom
HOMEBREW_NO_AUTO_UPDATE=1

alias k=kubectl

# local
[[ -r "$HOME/.bash_local" ]] && . "$HOME/.bash_local"

# bash-completion
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"
[[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"

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

# Load Bash It
source "$BASH_IT"/bash_it.sh

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
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
export FZF_DEFAULT_OPTS='--height 70% --border'

# Another CTRL-R script to insert the selected command from history into the command line/region
# re-wrote the script above
bind '"\C-r": "\C-x1\e^\er"'
bind -x '"\C-x1": __fzf_history';

__fzf_history () {
    __ehc $(history | fzf --tac --tiebreak=index | perl -ne 'm/^\s*([0-9]+)/ and print "!$1"')
}

__ehc()
{
if
        [[ -n $1 ]]
then
        bind '"\er": redraw-current-line'
        bind '"\e^": magic-space'
        READLINE_LINE=${READLINE_LINE:+${READLINE_LINE:0:READLINE_POINT}}${1}${READLINE_LINE:+${READLINE_LINE:READLINE_POINT}}
        READLINE_POINT=$(( READLINE_POINT + ${#1} ))
else
        bind '"\er":'
        bind '"\e^":'
fi
}

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

#############################
# bash-powerline
#############################
[ -f ~/dotfiles/bash-powerline.sh ] && . ~/dotfiles/bash-powerline.sh

#############################
# tmuxinator
#############################
[ -f ~/dotfiles/.tmuxinator/tmuxinator.bash ] && . ~/dotfiles/.tmuxinator/tmuxinator.bash

#############################
# completion
#############################
BASH_COMPLETION_DIR=/usr/local/etc/bash_completion.d

if [ -d /usr/local/bin ]; then
    _PATH=$_PATH:/usr/local/bin
fi

if [ -d $BASH_COMPLETION_DIR ]; then
    source $BASH_COMPLETION_DIR/git-completion.bash
fi

# Go
if [ -d /opt/homebrew/opt/go/libexec ]; then
    export GOROOT=/opt/homebrew/opt/go/libexec
#    export GOROOT=/opt/homebrew/Cellar/go@1.21/1.21.8/libexec
    export GOPATH=$HOME/go
    _PATH=$_PATH:$GOPATH/bin:$GOROOT/bin
fi


#############################
# google-cloud-sdk
#############################

if [ -d "$BREW_CASKROOM_DIR/google-cloud-sdk/latest/google-cloud-sdk" ]; then
    source "$BREW_CASKROOM_DIR/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc"
    source "$BREW_CASKROOM_DIR/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc"
fi

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
if [ -f /opt/homebrew/bin/rbenv ]; then
    eval "$(/opt/homebrew/bin/rbenv init - bash)"
    _PATH=$_PATH:$HOME/.rbenv/shims
fi

# JDK
JAVA_HOME=$(/usr/libexec/java_home -v "1.8")
if [ -d "$JAVA_HOME" ]; then
    _PATH=$_PATH:$JAVA_HOME/bin
fi

# Android
if [ -d ~/Library/Android/sdk/platform-tools ]; then
    _PATH=~/Library/Android/sdk/platform-tools:$_PATH
fi

# Flutter
if [ -d ~/.pub-cache/bin/ ]; then
    _PATH=$_PATH:~/.pub-cache/bin
fi

# nvm
export NVM_DIR="$HOME/.nvm"
function detect_nvmrc() {
    if [[ $PWD == $PREV_PWD ]]; then
        return
    fi

    PREV_PWD=$PWD
    [[ -f ".nvmrc" ]] && nvm use
}

if [ -s "/usr/local/opt/nvm/nvm.sh" ]; then
    . "/usr/local/opt/nvm/nvm.sh"
    PROMPT_COMMAND="$PROMPT_COMMAND;detect_nvmrc"
fi

if [ -s "/opt/homebrew/opt/nvm/nvm.sh" ]; then
    . "/opt/homebrew/opt/nvm/nvm.sh"
    PROMPT_COMMAND="$PROMPT_COMMAND;detect_nvmrc" 
fi

[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# dart
if [ -d /usr/local/opt/ruby ]; then
    _PATH=$_PATH:$HOME/.pub-cache/bin
fi

# Homebrew (/opt/homebrew)
if [ -d /opt/homebrew ]; then
    _PATH=/opt/homebrew/bin:$_PATH
fi

# PATH
if [ -n "$_PATH" ]; then
    export PATH="$_PATH:$PATH"
fi

# direnv
eval "$(direnv hook bash)"

# This loads nvm bash_completion
if [ -s "$NVM_DIR/bash_completion" ]; then
    . "$NVM_DIR/bash_completion"
fi
