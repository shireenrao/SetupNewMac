TFILES_ROOT="`pwd`"

echo ""                                                                            
#install vim                                                                       
echo "Begin Install vim"                                                           
cd $DOTFILES_ROOT/tmp                                                              
hg clone https://vim.googlecode.com/hg/ vim                                        
if [ $? -ne 0 ]; then                                                              
    echo "FAIL: Mercurial clone vim FAILED"                                        
    exit 1                                                                         
fi                                                                                 
cd vim/src                                                                         
#echo "make distclean"                                                             
#make distclean                                                                    
echo "./configure --enable-pythoninterp --with-features=huge --enable-gui=gtk2 --prefix=$HOME/opt/vim"
./configure --enable-pythoninterp --with-features=huge --enable-gui=gtk2 --prefix=$HOME/opt/vim >/dev/null 2>&1
echo "make"                                                                        
make >/dev/null 2>&1                                                               
if [ $? -ne 0 ]; then                                                              
    echo "FAIL: vim make FAILED"                                                   
    exit 1                                                                         
fi        
echo "make install"                                                                
make install >/dev/null 2>&1                                                       
if [ $? -ne 0 ]; then                                                           
    echo "FAIL: vim make install FAILED"                                        
    exit 1                                                                      
fi                                                                              
                                                                                
if [ -f $HOME/opt/vim/bin/vim ]                                                 
then                                                                            
    echo "vim build from source complete"                                       
    echo "Creating vim links to $HOME/bin"                                      
    ln -s $HOME/opt/vim/bin/vim $HOME/bin/vim                                   
    ln -s $HOME/opt/vim/bin/vim $HOME/bin/vi                                    
    echo "linking vim complete!"                                                
fi                                                                              
cd $DOTFILES_ROOT

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
        osascript -e "tell application \"Terminal\" to set current settings of front window to settings set \"Solarized Dark 
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
echo "link .vimrc and .vim to $HOME"                                            
ln -s $DOTFILES_ROOT/.vim $HOME/.vim                                            
ln -s $DOTFILES_ROOT/.vimrc $HOME/.vimrc                                        
echo "linking complete!"  



