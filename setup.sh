#!/bin/sh

if [ ! -L ~/.tmuxinator -a -d ~/dotfiles/.tmuxinator ]; then
    ln -s ~/dotfiles/.tmuxinator ~/.tmuxinator
fi

mkdir -p ~/.config/git
mkdir -p ~/.config/karabiner
mkdir -p ~/.config/cmux
for file in .bash* .fzf.* .z* .gitconfig .psqlrc .tmux.conf Brewfile .config/git/ignore .config/karabiner/karabiner.json .config/cmux/cmux.json; do
    rm -i ~/$file
    ln -s $PWD/$file ~/$file
done

# Workaround for "The operation couldn’t be completed. Unable to locate a Java Runtime."
sudo ln -sfn $(brew --prefix)/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk

# Check vscode directory exists then link settings
if [ -d ~/Library/Application\ Support/Code/User ]; then
    for file in keybindings.json settings.json tasks.json; do
        rm -i ~/Library/Application\ Support/Code/User/$file
        ln -s $PWD/vscode/$file ~/Library/Application\ Support/Code/User/$file
    done
fi
