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

PROMPT_COMMAND='share_history'
shopt -u histappend
export HISTSIZE=2000
export PROMPT_DIRTRIM=2

# bash-completion
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

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

# IntelliJ IDEA
alias idea="/Applications/IntelliJ\ IDEA.app/Contents/MacOS/idea"

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

if [ -d $BASH_COMPLETION_DIR ]; then
    source $BASH_COMPLETION_DIR/git-completion.bash
fi

# Go
if [ -d /usr/local/opt/go/libexec ]; then
    export GOROOT=/usr/local/opt/go/libexec
    export GOPATH=$HOME/go
    _PATH=$_PATH:$GOPATH/bin:$GOROOT/bin
fi

# google-cloud-sdk
if [ -d /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk ]; then
  source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc"
  source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc"
fi

# Google App Engine
if [ -d /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/platform/google_appengine ]; then
    _PATH=$_PATH:/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/platform/google_appengine
fi

#if [ -d ~/go_appengine ]; then
#    _PATH=$_PATH:~/go_appengine
#fi

# Ruby
if [ -d /usr/local/opt/ruby ]; then
    _PATH=$_PATH:/usr/local/opt/ruby/bin
fi

# JDK
JAVA_HOME=$(/usr/libexec/java_home -v "1.8")
if [ -d "$JAVA_HOME" ]; then
    _PATH=$_PATH:$JAVA_HOME/bin
fi

# nodebrew
if [ -d "$HOME/.nodebrew" ]; then
    _PATH=$HOME/.nodebrew/current/bin:$_PATH
fi

# Homebrew (/opt/homebrew)
if [ -d /opt/homebrew ]; then
    _PATH=/opt/homebrew/bin:$_PATH
fi

# direnv
eval "$(direnv hook bash)"

#
# Source extra configuration file
#
[ -f ~/.bash_profile.local ] && . ~/.bash_profile.local

#############################
# fasd
#############################
eval "$(fasd --init auto)"
# unalias z
# z() {
#   if [[ -z "$*" ]]; then
#     cd "$(fasd_cd -d | fzf -1 -0 --no-sort --tac +m | sed 's/^[0-9,.]* *//')"
#   else
#     cd "$(fasd_cd -d | fzf --query="$*" -1 -0 --no-sort --tac +m | sed 's/^[0-9,.]* *//')"
#   fi
# }
# Requires fasd: https://github.com/clvv/fasd
_fzf_fasd() {
  if [[ -z "$*" ]]; then
    cd "$(fasd_cd -d | fzf -1 -0 --no-sort --tac +m | sed 's/^[0-9,.]* *//')"
  else
    cd "$(fasd_cd -d | fzf --query="$*" -1 -0 --no-sort --tac +m | sed 's/^[0-9,.]* *//')"
  fi
}

bind -x '"\C-@": _fzf_fasd';

# PATH
if [ -n "$_PATH" ]; then
    export PATH="$_PATH:$PATH"
fi
