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
cd $DOTFILES_ROOT                                                               
#install vim plugins                                                            
echo "init and update local vim plugin submodules from Github"                  
git submodule init                                                              
git submodule update                                                            
echo "link .vimrc and .vim to $HOME"                                            
ln -s $DOTFILES_ROOT/.vim $HOME/.vim                                            
ln -s $DOTFILES_ROOT/.vimrc $HOME/.vimrc                                        
echo "linking complete!"  



