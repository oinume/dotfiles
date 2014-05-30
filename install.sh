#!/bin/sh

if [ ! -L ~/.zprezto -a -d ~/dotfiles/prezto ]; then
    ln -s ~/dotfiles/prezto ~/.zprezto
fi

if [ ! -L ~/zaw -a -d ~/dotfiles/zaw ]; then
    ln -s ~/dotfiles/zaw ~/zaw
fi

for file in .z* .gitconfig .tmux.conf; do
    rm -i ~/$file
    ln -s $PWD/$file ~/$file
done

