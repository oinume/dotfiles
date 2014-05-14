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

_PATH=/usr/local/bin:/usr/local/sbin

# pyenv
if [ -d $HOME/.pyenv ]; then
    #export PYENV_ROOT=$HOME/.pyenv
    if [ -d /usr/local/opt/pyenv ]; then
        source /usr/local/opt/pyenv/completions/pyenv.zsh
    fi
    _PATH=$HOME/.pyenv/shims:$_PATH
fi

# nvm
NVM_DIR=`brew --prefix nvm`
if [ -d "$NVM_DIR" ]; then
    source $NVM_DIR/nvm.sh
fi

# Java
if [ -d /usr/local/java ]; then
    export JAVA_HOME=/usr/local/java
    _PATH=$_PATH:$JAVA_HOME/bin
fi


# PATH
if [ -n "$_PATH" ]; then
    export PATH="$_PATH:$PATH"
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
