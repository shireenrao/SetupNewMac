#!/bin/bash

# Ask for sudo password in the beginning..
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.osx` has finished       
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

DOTFILES_ROOT="`pwd`"

echo "Create tmp under $DOTFILES_ROOT for temp files if it doesnt exist"
mkdir -p $DOTFILES_ROOT/tmp
if [ ! -f $DOTFILES_ROOT/tmp ]
then
    echo "FAIL: $DOTFILES_ROOT/tmp does not exist"
    exit 1

echo "Check if $HOME/bin exists, if not create it"
mkdir -p $HOME/bin
if [ ! -f $DOTFILES_ROOT/bin ]
then
    echo "FAIL: $DOTFILES_ROOT/bin does not exist"
    exit 1
fi

#Install xcode
#xcode-select --install

echo "Install Homebrew"
#Install HomeBrew
command -v brew >/dev/null 2>&1 || {
    echo "Installing Homebrew"
    ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go/install)"
}
if [ $? -ne 0 ]
then
    echo "FAIL: Homebrew install FAILED!"
    exit 1
else
    echo "Homebrew installed!"
fi

echo "Brewing preparation"
brew update
brew doctor

#Install zsh
echo "Check zsh..."

#Check zsh
if [ ! -f /usr/local/bin/zsh ]
then
    echo "Homebrew zsh not there.. Begin Install..."
    brew install zsh
    if [ ! -f /usr/local/bin/zsh ]
    then
       echo "FAIL: Homebrew zsh install failed"
       exit 1
    fi
else
    print "homebrew zsh exists"
fi

#Add zsh to shells if not there already
if grep -Fxq "/usr/local/bin/zsh" /private/etc/shells
then
    echo "/usr/local/bin/zsh already exists in /private/etc/shells"
else
    echo "Add /usr/local/bin/zsh to /private/etc/shells"
    echo "/usr/local/bin/zsh" | sudo tee -a /private/etc/shells
fi

if [ ! -f /usr/local/bin/python ]
then
    echo "Homebrew python does not exist.. begin install..."
    brew install python
    if [ ! -f /usr/local/bin/python ]
    then
        echo "Homebrew python install failed!"
        exit 1
    fi
else
    echo "Homebrew python exists"
fi

if [ ! -f /usr/local/bin/git ]
then
    echo "Homebrew git does not exist.. begin install..."
    brew install git
    if [ ! -f /usr/local/bin/git ]
    then
        echo "Homebrew git install failed!"
        exit 1
    fi
else
    echo "Homebrew git exists"
    exit 1
fi

cd $DOTFILES_ROOT/tmp
curl -O http://mercurial.berkwood.com/binaries/Mercurial-2.6.2-py2.7-macosx10.8.zip
if [ -f $DOTFILES_ROOT/tmp/Mercurial-2.6.2-py2.7-macosx10.8.zip ]
then
    unzip Mercurial-2.6.2-py2.7-macosx10.8.zip
    if [ $? -eq 0 ]; then
        sudo installer -pkg $DOTFILES_ROOT/tmp/mercurial-2.6.2_20130606-py2.7-macosx10.8/mercurial-2.6.2+20130606-py2.7-macosx10.8.mpkg -target /
        if [ ! -f /usr/local/bin/hg ]; then
            echo "FAIL: Mercurial install FAILED!!"
            exit 1
    else
        echo "FAIL: Error unzipping Mercurial"
        exit 1
    fi
else
    echo "FAIL: Mercurial zip file not found"
    exit 1
fi

#Source your zshrc to make sure your paths are setup
source $DOTFILES_ROOT/.myzshrc

#install vim
echo "Begin Install vim"
cd $DOTFILES_ROOT/tmp
hg clone https://vim.googlecode.com/hg/ vim
if [ $? -ne 0 ]; then
    echo "FAIL: Mercurial clone vim FAILED"
    exit 1
fi
cd vim/src
echo "make distclean"
make distclean
echo "./configure --enable-pythoninterp --with-features=huge --enable-gui=gtk2 --prefix=$HOME/opt/vim"
./configure --enable-pythoninterp --with-features=huge --enable-gui=gtk2 --prefix=$HOME/opt/vim
echo "make"
make
if [ $? -ne 0 ]; then
    echo "FAIL: vim make FAILED"
    exit 1
fi
echo "make install"
make install
if [ $? -ne 0 ]; then
    echo "FAIL: vim make install FAILED"
    exit 1
fi

if [ -f $HOME/opt/vim/bin/vim ]
then
    echo "Creating vim links to $HOME/bin"
    ln -s $HOME/opt/vim/bin/vim $HOME/bin/vim
    ln -s $HOME/opt/vim/bin/vim $HOME/bin/vi
fi
cd $DOTFILES_ROOT

#install Fonts
cd $DOTFILES_ROOT/tmp
echo "Get SourceCodePro Fonts for powerline"
svn export https://github.com/Lokaltog/powerline-fonts/trunk/SourceCodePro
if [ -d $DOTFILE_ROOT/tmp/SourceCodePro ]
then
    echo "Copying SourceCodePro Fonts"
    cp -f $DOTFILE_ROOT/tmp/SourceCodePro/*.otf $HOME/Library/Fonts
fi
#install Terminal Theme
echo "Get Solarize theme"
svn export https://github.com/altercation/solarized/trunk/osx-terminal.app-colors-solarized/xterm-256color
if [ -d $DOTFILE_ROOT/tmp/xterm-256color ]
then
    open "$DOTFILE_ROOT/tmp/xterm-256colo/Solarized\ Dark\ xterm-256color.terminal"
    sleep 1 # Wait a bit to make sure the theme is loaded
    defaults write com.apple.terminal "Default Window Settings" -string "Solarized\ Dark\ xterm-256color"
    defaults write com.apple.terminal "Startup Window Settings" -string "Solarized\ Dark\ xterm-256color"
fi

cd $DOTFILES_ROOT
#install vim plugins
echo "init and update local vim plugin submodules from Github"
git submodule init
git submodule update
echo "link .vimrc and .vim to $HOME"
ln -s $DOTFILES_ROOT/.vim $HOME/.vim
ln -s $DOTFILES_ROOT/.vimrc $HOME/.vimrc

#install prezto
cd $DOTFILES_ROOT
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
if [ $? -eq 0 ]; then
    ln -s ~/.zprezto/runcoms/zlogin ~/.zlogin
    ln -s ~/.zprezto/runcoms/zlogout ~/.zlogout
    ln -s ~/.zprezto/runcoms/zpreztorc ~/.zpreztorc
    ln -s ~/.zprezto/runcoms/zprofile ~/.zprofile
    ln -s ~/.zprezto/runcoms/zshenv ~/.zshenv
    ln -s ~/.zprezto/runcoms/zshrc ~/.zshrc
else
    echo "FAIL: git clone prezto FAILED"
    exit 1
fi

# below linking not working
#for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
#    ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
#done

echo "Change shell to /usr/local/bin/zsh"
chsh -s /usr/local/bin/zsh

exit 0
