#!/bin/sh

defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowTabView -bool true
defaults write com.apple.finder AppleShowAllFiles YES
chflags nohidden ~/Library

# Change KeyRepeat speed
defaults write -g InitialKeyRepeat -int 15
defaults write -g KeyRepeat -int 2

# Change screencapture save location
mkdir -p ~/Documents/screenshot && defaults write com.apple.screencapture location ~/Documents/screenshot

defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick 0
# タップでクリック
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking 1
# 副ボタンのクリック「右下隅をクリック」
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick 2

# Dockの画面上の位置を「左」にする
defaults write com.apple.dock orientation -string "left"
# Dockのサイズ
defaults write com.apple.dock tilesize -int 37
# Dock拡大オン
defaults write com.apple.dock magnification -bool true
# Dock拡大サイズ
defaults write com.apple.dock largesize -int 58
