#!/bin/sh

if [ ! -L ~/.tmuxinator -a -d ~/dotfiles/.tmuxinator ]; then
    ln -s ~/dotfiles/.tmuxinator ~/.tmuxinator
fi

mkdir -p ~/.config/git
for file in .bash* .fzf.* .z* .gitconfig .psqlrc .tmux.conf Brewfile .config/git/ignore; do
    rm -i ~/$file
    ln -s $PWD/$file ~/$file
done

# Karabiner-Elements
mkdir -p ~/.config/karabiner
rm -i ~/.config/karabiner/karabiner.json
ln -s $PWD/karabiner/karabiner.json ~/.config/karabiner/karabiner.json

# Workaround for "The operation couldn’t be completed. Unable to locate a Java Runtime."
sudo ln -sfn $(brew --prefix)/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk

# Check vscode directory exists then link settings
if [ -d ~/Library/Application\ Support/Code/User ]; then
    for file in keybindings.json settings.json tasks.json; do
        rm -i ~/Library/Application\ Support/Code/User/$file
        ln -s $PWD/vscode/$file ~/Library/Application\ Support/Code/User/$file
    done
fi
