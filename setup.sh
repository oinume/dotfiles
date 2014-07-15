#!/bin/sh

if [ ! -L ~/.zprezto -a -d ~/dotfiles/prezto ]; then
    ln -s ~/dotfiles/prezto ~/.zprezto
fi

if [ ! -L ~/zaw -a -d ~/dotfiles/zaw ]; then
    ln -s ~/dotfiles/zaw ~/zaw
fi

if [ ! -f ~/.percol.d/rc.py ]; then
    mkdir -p ~/.percol.d/
    ln -s $PWD/.percol.d/rc.py ~/.percol.d/rc.py
fi

if [ ! -L ~/.tmuxinator -a -d ~/dotfiles/.tmuxinator ]; then
    ln -s ~/dotfiles/.tmuxinator ~/.tmuxinator
fi

for file in .z* .gitconfig .tmux.conf; do
    rm -i ~/$file
    ln -s $PWD/$file ~/$file
done
