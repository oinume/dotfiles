#!/bin/sh

# if [ ! -L ~/.zprezto -a -d ~/dotfiles/prezto ]; then
#     ln -s ~/dotfiles/prezto ~/.zprezto
# fi

# if [ ! -L ~/zaw -a -d ~/dotfiles/zaw ]; then
#     ln -s ~/dotfiles/zaw ~/zaw
# fi

# if [ ! -f ~/.percol.d/rc.py ]; then
#     mkdir -p ~/.percol.d/
#     ln -s $PWD/.percol.d/rc.py ~/.percol.d/rc.py
# fi

if [ ! -L ~/.tmuxinator -a -d ~/dotfiles/.tmuxinator ]; then
    ln -s ~/dotfiles/.tmuxinator ~/.tmuxinator
fi

for file in .bash* .fzf.* .z* .gitconfig .psqlrc .tmux.conf Brewfile .config/git/ignore; do
    rm -i ~/$file
    ln -s $PWD/$file ~/$file
done

# Workaround for "The operation couldn’t be completed. Unable to locate a Java Runtime."
sudo ln -sfn $(brew --prefix)/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk