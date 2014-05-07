#!/bin/sh

if [ ! -d ~/.zprezto ]; then
    ln -s ~/dotfiles/prezto ~/.zprezto
fi

for file in .z* .gitconfig; do
    rm -i ~/$file
    ln -s $PWD/$file ~/$file
done

