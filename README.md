# Automated New Mac Dev Environment Setup

This is a repo where one can install the following tools automatically

* Homebrew
  * zsh
  * python 2.x
  * git
  * MacVim
* Mercurial
* Powerline Font Source Code Pro
* Solarize Terminal Theme
* Vim Plugins
  * Vundle
  * Powerline
  * Ctrlp
  * Vim-colors-solarized
  * Syntastic
  * YouCompleteMe
* Prezto
* iPython

## install

Make sure you have Xcode and command line tools installed. In case you don't
have them installed, You can run the following to install the command line
tools first and then run the same command again to install XCode:

```sh
xcode-select --install
```

Before you proceed with cloning this repo and running the instll script, make
sure you accept XCode's license. You can do that from the command line:

```sh
sudo xcodebuild -license
```

To Run my install script, run this (read below in case you want a logfile):
```sh
git clone https://github.com/shireenrao/SetupNewMac ~/.dotfiles
cd ~/.dotfiles
sh ./install.sh
```

You may want to review what was executed. You can create a logfile of what was
done by running the install.sh script like this instead:
```sh
sh ./install.sh 2>&1 | tee -a logfile
```

If you are running the above 'git clone' command on a fresh system without
xcode command line tools, you will see your command fail and a pop-up window 
asking you to install the command line tools. Once install is done, Run the 
git clone command again. 

Once the install script finishes, Open Terminal Preferences and make the
Solarized Dark or Light theme the default terminal theme. Also change the font
to "Sauce Code Powerline". Close all terminal windows and open a new window.
You should see your terminal using the Solarized theme now. 


