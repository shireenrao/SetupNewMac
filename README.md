# Automated New Mac Dev Environment Setup

This is a repo where one can clone and install all tools automatically

## install

Run this:
```sh
git clone https://github.com/shireenrao/SetupNewMac ~/.dotfiles
cd ~/.dotfiles
sh ./install.sh
```

If you are running the above 'git clone' command on a fresh system without
xcode command line tools, you will see your command fail and a pop-up window 
asking you to install the command line tools. Once install is done, Run the 
git clone command again. 

Once the install script finishes, Open Terminal Preferences and make the
Solarized Dark or Light theme the default terminal theme. Also change the font
to "Sauce Code Powerline". Close all terminal windows and open a new window.
You should see your terminal using the Solarized theme now. 

Run the following to finish installing vim with some neat plugins:
```sh
cd ~/.dotfiles
sh ./install_vim.sh
```

