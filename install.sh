#!/bin/bash

# Ask for sudo password in the beginning..
echo "Input your password:"
read -s yourpassword
echo $yourpassword | sudo -vS
if [ $? -ne 0 ]
then
    echo "FAIL: Password mismatch!"
    exit 1
else
    echo "Password correct!"
fi
#sudo -v

# Keep-alive: update existing `sudo` time stamp until `.osx` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

DOTFILES_ROOT="`pwd`"

echo "Create tmp under $DOTFILES_ROOT for temp files if it doesnt exist"
mkdir -p $DOTFILES_ROOT/tmp
if [ ! -d $DOTFILES_ROOT/tmp ]
then
    echo "FAIL: $DOTFILES_ROOT/tmp does not exist"
    exit 1
fi

echo "Check if $HOME/bin exists, if not create it"
mkdir -p $HOME/bin
if [ ! -d $HOME/bin ]
then
    echo "FAIL: $HOME/bin does not exist"
    exit 1
fi

#Install xcode
#xcode-select --install

echo ""
echo "Install Homebrew"
#Install HomeBrew
command -v brew >/dev/null 2>&1 || {
    echo "Installing Homebrew"
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}
if [ $? -ne 0 ]
then
    echo "FAIL: Homebrew install FAILED!"
    exit 1
else
    echo "Homebrew installed!"
fi

echo ""
echo "Brewing preparation"
brew update
brew doctor

echo ""
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
    echo "homebrew zsh exists"
fi

#Add zsh to shells if not there already
echo ""
if grep -Fxq "/usr/local/bin/zsh" /private/etc/shells
then
    echo "/usr/local/bin/zsh already exists in /private/etc/shells"
else
    echo "Add /usr/local/bin/zsh to /private/etc/shells"
    #echo "/usr/local/bin/zsh" | sudo tee -a /private/etc/shells
    echo $yourpassword | sudo -S sh -c "echo \"/usr/local/bin/zsh\" | tee -a /private/etc/shells"
fi

echo ""
echo "Check Homebrew python..."
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

echo ""
echo "Check Homebrew git"
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
fi

echo ""
echo "Begin Mercurial install from http://mercurial.berkwood.com"
cd $DOTFILES_ROOT/tmp
curl -O http://mercurial.berkwood.com/binaries/Mercurial-2.6.2-py2.7-macosx10.8.zip
if [ -f $DOTFILES_ROOT/tmp/Mercurial-2.6.2-py2.7-macosx10.8.zip ]
then
    unzip Mercurial-2.6.2-py2.7-macosx10.8.zip >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo $yourpassword | sudo -S installer -pkg $DOTFILES_ROOT/tmp/mercurial-2.6.2_20130606-py2.7-macosx10.8/mercurial-2.6.2+20130606-py2.7-macosx10.8.mpkg -target /
        if [ ! -f /usr/local/bin/hg ]; then
            echo "FAIL: Mercurial install FAILED!!"
            exit 1
        else
            echo "Mercurial installed!!"
        fi
    else
        echo "FAIL: Error unzipping Mercurial"
        exit 1
    fi
else
    echo "FAIL: Mercurial zip file not found"
    exit 1
fi

echo ""
echo "Update PATH"
export PATH=/usr/local/bin:$PATH

echo ""
echo "Check if Homebrew python is default"
PYTHON_PATH=$(which python)
if [ ! "$PYTHON_PATH" == "/usr/local/bin/python" ]
then
    echo "FAIL: Not homebrew python"
    exit 1
else
    echo "Homebrew Python is default"
fi

echo ""
echo "Begin install powerline fonts"
cd $DOTFILES_ROOT/tmp
echo "Get SourceCodePro Fonts for powerline"
git clone https://github.com/Lokaltog/powerline-fonts
if [ $? -eq 0 ];then
    if [ -d $DOTFILES_ROOT/tmp/powerline-fonts/SourceCodePro ];then
        echo "Copying SourceCodePro Fonts"
        cp -f $DOTFILES_ROOT/tmp/powerline-fonts/SourceCodePro/*.otf $HOME/Library/Fonts
        echo "Copy Fonts complete!"
    else
        echo "FAIL: copying fonts!!"
    fi
else
    echo "FAIL: git clone powerline-fonts"
fi

echo ""
#install Terminal Theme
echo "Git clone Solarize theme"
git clone https://github.com/altercation/solarized
if [ $? -eq 0 ];then
    if [ -d $DOTFILES_ROOT/tmp/solarized/osx-terminal.app-colors-solarized/xterm-256color ]; then
        cd $DOTFILES_ROOT/tmp/solarized/osx-terminal.app-colors-solarized/xterm-256color
        echo "Import Solarized Darm theme"
        open "Solarized Dark xterm-256color.terminal"
        sleep 1 # Wait a bit to make sure the theme is loaded
        echo "Change theme to Solarized Dark"
        osascript -e "tell application \"Terminal\" to set current settings of back window to settings set \"Solarized Dark xterm-256color\"" 
        #defaults write com.apple.terminal "Default Window Settings" -string "Solarized Dark xterm-256color"
        #defaults write com.apple.terminal "Startup Window Settings" -string "Solarized Dark xterm-256color"
        #cp $DOTFILES_ROOT/.com.apple.Terminal.plist ~/Library/Preferences/com.apple.Terminal.plist
        echo "Theme settings complete!"
    fi
fi

echo ""
cd $DOTFILES_ROOT
#install vim plugins
echo "init and update local vim plugin submodules from Github"
git submodule init
git submodule update
cd $DOTFILES_ROOT/.vim/bundle/YouCompleteMe
git submodule update  --init --recursive
./install.sh --clang-completer

echo ""
echo "Begin installing MacVim"
if [ ! -f /usr/local/bin/mvim ]
then
    echo "Homebrew macvim does not exist.. begin install..."
    brew install macvim
    if [ ! -f /usr/local/bin/mvim ]
    then
        echo "Homebrew MacVim install failed!"
        exit 1
    else
        echo "MacVim install complete!"
        echo "Create symlinks for vim"
        ln -s /usr/local/bin/mvim $HOME/bin/vim
        ln -s /usr/local/bin/mvim $HOME/bin/vi
        #ln -s $DOTFILES_ROOT/.vim $HOME/.vim
        #ln -s $DOTFILES_ROOT/.vimrc $HOME/.vim
        echo "Symlinks done..."
    fi
else
    echo "Homebrew MacVim exists"
fi

echo ""
echo "Begin install prezto"
cd $DOTFILES_ROOT
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
if [ $? -eq 0 ]; then
    echo "link all zprezto config files..."
    ln -s ~/.zprezto/runcoms/zlogin ~/.zlogin
    ln -s ~/.zprezto/runcoms/zlogout ~/.zlogout
    ln -s ~/.zprezto/runcoms/zpreztorc ~/.zpreztorc
    ln -s ~/.zprezto/runcoms/zprofile ~/.zprofile
    ln -s ~/.zprezto/runcoms/zshenv ~/.zshenv
    ln -s ~/.zprezto/runcoms/zshrc ~/.zshrc
    echo "Linking complete!"
    echo "zprezto installed!!"
else
    echo "FAIL: git clone prezto FAILED"
    exit 1
fi

# below linking not working
#for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
#    ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
#done

echo ""
echo "Link homebrew apps to /Applications"
brew linkapps
echo "Linking complete..."

echo ""
echo "Install ipython"
pip install ipython
if [ $? -eq 0 ]; then
    echo "ipython installed..."
else
    echo "FAIL: ipython not installed"
fi

echo ""
user=$(whoami)
echo "Change shell for $user to /usr/local/bin/zsh"
echo $yourpassword | sudo -S chsh -s /usr/local/bin/zsh $user

echo ""
echo "Update Path"
echo "export PATH=$HOME/bin:$PATH" | tee -a ~/.zprezto/runcoms/zshrc
echo "Path fixed..."

echo ""
olddir=~/.dotfiles_old             # old dotfiles backup directory
files="vimrc vim bash_profile" # list of files/folders to symlink in homedir

# create dotfiles_old in homedir
echo "Creating $olddir for backup of any existing dotfiles in ~ ..."
mkdir -p $olddir
echo "done"

echo ""
# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks from the homedir to any files in the ~/dotfiles directory spec
for file in $files; do
    if [ -f ~/.$file ];
    then
        echo "Moving any existing dotfiles from ~ to $olddir"
        mv ~/.$file ~/.dotfiles_old/
    fi
done

echo ""
newfiles="vim vimrc functions aliases"
for file in $newfiles; do
    echo "Creating symlink to $file in home directory."
    ln -s $DOTFILES_ROOT/.$file ~/.$file
done

echo ""
echo "Add aliases and functions to your prezto .zshrc"
echo "source ~/.aliases" | tee -a ~/.zprezto/runcoms/zshrc
echo "source ~/.functions" | tee -a ~/.zprezto/runcoms/zshrc
echo "done..."
echo ""

echo "========================================================================"
echo "= Change the Font to Source Code Pro (a powerline compatible font) and ="
echo "= also make Solarized Dark your default theme! You can do this from    ="
echo "= your Terminal Preferences.                                           =".
echo "= Setup complete!!                                                     ="
echo "========================================================================"

exit 0
