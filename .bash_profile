#export ANYENV_ROOT="/Users/oinuma/.anyenv"
#export PATH=$PATH:"/Users/oinuma/.anyenv/bin"
#eval "$(anyenv init -)"
#export PATH="$(brew --prefix homebrew/php/php71)/bin:$PATH"

#############################
# prompt
#############################
#source ~/dotfiles/.git-prompt.sh
#export PROMPT='\w \[\e[1;32m$(__git_ps1 "git:%s") \[\e[0m\]\$ '
#export PROMPT_COMMAND='__git_ps1 "\w" "\\\$ "'
export PS_SYMBOL='$'

# If not running interactively, don't do anything
case $- in
  *i*) ;;
    *) return;;
esac

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
# fzf
#############################
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
export FZF_DEFAULT_OPTS='--height 60% --border'

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
#bind '"\C-r": " \C-e\C-u\C-y\ey\C-u`__fzf_history__`\e\C-e\er\e^"'

# Ctrl-@ - cd into the selected directory
bind '"\C-@": " \C-e\C-u`__fzf_cd__`\e\C-e\er\C-m"'

#############################
# enhancd
#############################
export ENHANCD_DIR=$HOME/dotfiles/enhancd
[ -f ~/dotfiles/enahancd/init.sh ] && . ~/dotfiles/enhancd/init.sh

#############################
# bash-powerline
#############################
[ -f ~/dotfiles/bash-powerline.sh ] && . ~/dotfiles/bash-powerline.sh
