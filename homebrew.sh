# Check for Homebrew,Install if we don't have it
if test ! $(which brew); then
    echo "Installing homebrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update homebrew recipes
printf "Update recipes? [Y/n]: " && read ANS
if [ "${ANS}" = "Y" ]; then
    brew update
fi

# Upgrade all
printf "Upgrade? [Y/n]: " && read ANS
if [ "${ANS}" = "Y" ]; then
    brew upgrade
fi

# Add Repository
brew tap homebrew/dupes
brew tap homebrew/versions
brew tap homebrew/binary
brew tap thoughtbot/formulae
brew tap caskroom/fonts

packages=(

    # GNU core utilities (those that come with OS X are outdated)
    coreutils

    # GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
    findutils

    # recent versions of some OS X tools
    homebrew/dupes/grep

    # Shell
    zsh
    zsh-completions
    bash
    peco

    # Multiplexe
    tmux
    reattach-to-user-namespace

    # Git
    git
    hub
    gitsh
    gist
    tig

    # Image
    imagemagick
    graphicsmagick

    # Database
    redis
    sqlite

    # Utils
    autoconf
    proctools
    automake
    openssl
    libyaml
    readline
    direnv
    xz

    # Tools
    ack
    ag
    ctags
    curl
    dtrx
    fswatch
    nkf
    rmtrash
    tree
    wget
    htop-osx
    jq
    lv
    ant
    maven
    mercurial
    ngrep
    pstree
    pv
    rlwrap
    watch
    osxfuse

    # Languages
    ruby
    rbenv
    ruby-build
    go
    python
    python3
    pyenv
    pyenv-virtualenv
    pyenv-virtualenvwrapper
    pyenv-which-ext
    nodebrew

    # ops
    ansible
    boot2docker
    csshx
    packer
)

echo "installing binaries..."
brew install ${packages[@]} && brew cleanup

# Casks
brew install caskroom/cask/brew-cask

# Apps
apps=(

    # Launcher
    alfred

    # Browser

    # Communication
    slack
    skype

    # VM
    virtualbox
    vagrant

    # Java
    java7
    java

    # etc ...
    appcleaner
    dropbox
    google-drive
    karabiner
    sketch
    slate
    xtrafinder
    quitter

    # development
    iterm2
    intellij-idea
    imageoptim
    sourcetree
    sequel-pro
    gyazo
    charles
    mysqlworkbench
    percona-toolkit
    sshfs

    kindle
    osxfuse
    licecap
    packer
    vlc
    mitmproxy
)

# Install apps to /Applications
echo "installing applications..."
brew cask install --appdir="/Applications" ${apps[@]}

# We need to link it
brew cask alfred link

# fonts
fonts=(
    font-m-plus
    font-source-code-pro
    font-clear-sans
    font-roboto
)

# install fonts
echo "installing fonts..."
brew cask install ${fonts[@]}
