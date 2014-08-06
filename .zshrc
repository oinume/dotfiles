#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...

export FIGNORE=".svn:~"
export EDITOR="vim"
export PAGER="less"
export FTP_PASSIVE_MODE="YES"

# zsh options
unsetopt correct noclobber

# alias
alias ahistory='history -E 1'
alias vag='vagrant'

_PATH="/usr/local/bin:/usr/local/sbin"

# tmuxinator
[ -f $HOME/.tmuxinator/tmuxinator.zsh ] && . $HOME/.tmuxinator/tmuxinator.zsh

# homebrew's ruby
PREFIX_RUBY=`brew --prefix ruby`
if [ -d "$PREFIX_RUBY/bin" ]; then
    _PATH="$PREFIX_RUBY/bin":$_PATH
fi

# pyenv
if [ -d $HOME/.pyenv ]; then
    #export PYENV_ROOT=$HOME/.pyenv
    if [ -d /usr/local/opt/pyenv ]; then
        source /usr/local/opt/pyenv/completions/pyenv.zsh
    fi
fi

# rbenv
if [ -d $HOME/.rbenv ]; then
    #export PYENV_ROOT=$HOME/.pyenv
    if [ -d /usr/local/opt/rbenv ]; then
        source /usr/local/opt/rbenv/completions/rbenv.zsh
    fi
fi

# nvm
NVM_DIR=`brew --prefix nvm`
if [ -d "$NVM_DIR" ]; then
    source $NVM_DIR/nvm.sh
fi

# nodebrew
if [ -d "$HOME/.nodebrew" ]; then
    _PATH=$HOME/.nodebrew/current/bin:$_PATH
fi

# MySQL
if [ -d /usr/local/mysql ]; then
    _PATH=/usr/local/mysql/bin:$_PATH
    #export DYLD_FALLBACK_LIBRARY_PATH=/usr/local/mysql/lib:$DYLD_FALLBACK_LIBRARY_PATH
fi

# Java
if [ -d /usr/local/java ]; then
    export JAVA_HOME=/usr/local/java
    _PATH=$_PATH:$JAVA_HOME/bin
fi
#export JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF-8
export MAVEN_OPTS="-Xms512m -Xmx512m -Xmn256m -XX:MaxPermSize=384m -XX:PermSize=384m"

# Go
if [ -d /usr/local/opt/go/libexec ]; then
    export GOROOT=/usr/local/opt/go/libexec
    export GOPATH=$HOME/go
    _PATH=$_PATH:$GOPATH/bin:/usr/local/opt/go/libexec/bin
fi

# PATH
if [ -n "$_PATH" ]; then
    export PATH="$_PATH:$PATH"
fi

# zaw
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':chpwd:*' recent-dirs-max 100 # cdrの履歴を保存する個数
zstyle ':chpwd:*' recent-dirs-default yes
zstyle ':completion:*' recent-dirs-insert both
zstyle ':filter-select:highlight' selected fg=cyan,bg=white,standout
zstyle ':filter-select' case-insensitive yes

if [ -f ~/zaw/zaw.zsh ]; then
    . ~/zaw/zaw.zsh
    bindkey '^xb' zaw
    bindkey '^@' zaw-cdr
    bindkey '^xa' zaw-ack
    bindkey '^xb' zaw-git-branches
    bindkey '^xh' zaw-history
    bindkey '^xt' zaw-tmux
    bindkey '^xs' zaw-ssh-hosts
fi

# percol
function exists { which $1 &> /dev/null }

if exists percol; then
    function percol_select_history() {
        local tac
        exists gtac && tac="gtac" || { exists tac && tac="tac" || { tac="tail -r" } }
        BUFFER=$(fc -l -n 1 | eval $tac | percol --query "$LBUFFER")
        CURSOR=$#BUFFER         # move cursor
        zle -R -c               # refresh
    }

    zle -N percol_select_history
    bindkey '^R' percol_select_history
fi

function git_author_ca() {
    export GIT_AUTHOR_NAME="oinuma-kazuhiro"
    export GIT_AUTHOR_EMAIL="oinuma_kazuhiro@cyberagent.co.jp"
    export GIT_COMMITTER_NAME=$GIT_AUTHOR_NAME
    export GIT_COMMITTER_EMAIL=$GIT_AUTHOR_EMAIL
}

function git_author_private() {
    export GIT_AUTHOR_NAME="oinume"
    export GIT_AUTHOR_EMAIL="oinume@gmail.com"
    export GIT_COMMITTER_NAME=$GIT_AUTHOR_NAME
    export GIT_COMMITTER_EMAIL=$GIT_AUTHOR_EMAIL
}
