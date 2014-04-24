#!/bin/bash

# Ask for sudo password in the beginning..
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.osx` has finished       
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

DOTFILES_ROOT="`pwd`"

echo "Create tmp under $DOTFILES_ROOT for temp files"
mkdir $DOTFILES_ROOT/tmp

echo "Check if $HOME/bin exists"
if ![-d $HOME/bin ]
then
    echo "Creating $HOME/bin"
    mkdir $HOME/bin
else
    echo "$HOME/bin exists"
fi

#Install xcode
#xcode-select --install

echo "Install Homebrew"
#Install HomeBrew
ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"

echo "Install zsh"
#Install zsh
brew install zsh

#Add zsh to shells
echo "Add /usr/local/bin/zsh to /private/etc/shells"
echo "/usr/local/bin/zsh" | sudo tee -a /private/etc/shells

brew install python
brew install mercurial git

#Source your zshrc to make sure your paths are setup
source $DOTFILES_ROOT/.myzshrc

#install vim
echo "Begin Install vim"
cd $DOTFILES_ROOT/tmp
hg clone https://vim.googlecode.com/hg/ vim
cd vim/src
echo "make distclean"
make distclean
echo "./configure --enable-pythoninterp --with-features=huge --enable-gui=gtk2 --prefix=$HOME/opt/vim"
./configure --enable-pythoninterp --with-features=huge --enable-gui=gtk2 --prefix=$HOME/opt/vim
echo "make"
make
echo "make install"
make install

if [-f $HOME/opt/vim/bin/vim ]
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
ln -s .vim $HOME/.vim
ln -s .vimrc $HOME/.vimrc

#install prezto
cd $DOTFILES_ROOT
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
    ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done

echo "Change shell to /usr/local/bin/zsh"
chsh -s /usr/local/bin/zsh

