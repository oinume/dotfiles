#!/bin/sh

defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowTabView -bool true
defaults write com.apple.finder AppleShowAllFiles YES
shell: chflags nohidden ~/Library

# Change KeyRepeat speed
defaults write -g InitialKeyRepeat -int 15
defaults write -g KeyRepeat -int 2

# Change screencapture save location
mkdir -p ~/Documents/screenshot && defaults write com.apple.screencapture location ~/Documents/screenshot
