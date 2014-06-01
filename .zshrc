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

_PATH="/usr/local/bin:/usr/local/sbin"

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
    export DYLD_FALLBACK_LIBRARY_PATH=/usr/local/mysql/lib:$DYLD_FALLBACK_LIBRARY_PATH
fi

# Java
if [ -d /usr/local/java ]; then
    export JAVA_HOME=/usr/local/java
    _PATH=$_PATH:$JAVA_HOME/bin
fi
export JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF-8
export MAVEN_OPTS="-Xms512m -Xmx512m -Xmn256m -XX:MaxPermSize=384m -XX:PermSize=384m"

# PATH
if [ -n "$_PATH" ]; then
    export PATH="$_PATH:$PATH"
fi

# zaw
if [ -f ~/zaw/zaw.zsh ]; then
    . ~/zaw/zaw.zsh
    bindkey '^xb' zaw
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

# alias
alias ahistory='history -E 1'
