" .vimrc file by Srinivas Nyayapati 
"  Based on bits from all over 

"  Automatic reloading of .vimrc 
autocmd! bufwritepost .vimrc source %

" Better copy & paste
" When you want to paste large blocks of code into vim, press F2 before you
" paste. At the bottom you should see ``-- INSERT (paste) --``.
set pastetoggle=<F2>
set clipboard=unnamed

" Shows word with $ at end when you do a cw or C
set cpoptions+=$

" Mouse and backspace
set mouse=a " on OSX press ALT and click
set bs=2 " make backspace behave like normal again


" Rebind <Leader> key
" I like to have it here becuase it is easier to reach than the default and
" " it is next to ``m`` and ``n`` which I use for navigating between tabs.
let mapleader = ","


" Bind nohl
" Removes highlight of your last search
" ``<C>`` stands for ``CTRL`` and therefore ``<C-n>`` stands for ``CTRL+n``
noremap <C-n> :nohl<CR>
vnoremap <C-n> :nohl<CR>
inoremap <C-n> :nohl<CR>


" Quicksave command
""" noremap <C-Z> :update<CR>
""" vnoremap <C-Z> <C-C>:update<CR>
""" inoremap <C-Z> <C-O>:update<CR>


"" Quick quit command
noremap <Leader>e :quit<CR> " Quit current window
noremap <Leader>E :qa!<CR> " Quit all windows


" bind Ctrl+<movement> keys to move around the windows, instead of using
" Ctrl+w + <movement>
" Every unnecessary keystroke that can be saved is good for your health :)
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h


"" easier moving between tabs
map <Leader>n <esc>:tabprevious<CR>
map <Leader>m <esc>:tabnext<CR>


" map sort function to a key
vnoremap <Leader>s :sort<CR>


" easier moving of code blocks
" Try to go into visual mode (v), thenselect several lines of code here and
" then press ``>`` several times.
vnoremap < <gv " better indentation
vnoremap > >gv " better indentation


"" Show whitespace
"" MUST be inserted BEFORE the colorscheme command
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
au InsertLeave * match ExtraWhitespace /\s\+$/


" Color scheme
"" mkdir -p ~/.vim/colors && cd ~/.vim/colors
"" wget -O wombat256mod.vim
"" http://www.vim.org/scripts/download_script.php?src_id=13400
set t_Co=256
"color wombat256mod
" Use solarized dark
"syntax enable
"set background=dark
"colorscheme solarized


" Enable syntax highlighting
" You need to reload this file for the change to apply
filetype off
filetype plugin indent on
syntax on


" Showing line numbers and length
set number " show line numbers
set tw=79 " width of document (used by gd)
set nowrap " don't automatically wrap on load
set fo-=t " don't automatically wrap text when typing
set colorcolumn=80
highlight ColorColumn ctermbg=233


" easier formatting of paragraphs
vmap Q gq
nmap Q gqap

" Useful settings
set history=700
set undolevels=700


" Real programmers don't use TABs but spaces
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround
set expandtab


" Make search case insensitive
set hlsearch
set incsearch
set ignorecase
set smartcase


" Disable stupid backup and swap files - they trigger too many events
" for file system watchers
set nobackup
set nowritebackup
set noswapfile

" Setup Pathogen to manage your plugins
"" mkdir -p ~/.vim/autoload ~/.vim/bundle
"" curl -so ~/.vim/autoload/pathogen.vim
"" https://raw.github.com/tpope/vim-pathogen/HEAD/autoload/pathogen.vim
"" Now you can install any plugin into a .vim/bundle/plugin-name/ folder
let g:pathogen_disabled = []
call add(g:pathogen_disabled, 'python-mode')
call pathogen#infect()

"syntax enable
set background=dark
let g:solarized_termcolors=256
colorscheme solarized

""" Map F3 to NerdTree
"" map <F3> :NERDTreeToggle<CR>
"
"" Execute python script
""au BufRead *.py nmap <F3> :!python %
"" ConqueShell Mappings
""nmap <F4> :ConqueTermSplit bash
""nmap <F5> :ConqueTermVSplit bash
""nmap <F6> :ConqueTermSplit ipython
""nmap <F7> :ConqueTermVSplit ipython
""nmap <F8> :execute 'ConqueTermSplit ipython '.expand('%:p')
""nmap <F9> :execute 'ConqueTermVSplit ipython '.expand('%:p')
""let g:ConqueTerm_EscKey = ''
"
"" "
"" ============================================================================
"" " Python IDE Setup
"" "
"" ============================================================================
"
"
" settings for powerline 
" cd ~/.vim.bundle
" git cline git://github.com/Lokaltog/powerline.git
set rtp+=~/.vim/bundle/powerline/powerline/bindings/vim
set guifont=Source\ Code\ Pro\ for\ Powerline:h15
let g:Powerline_symbols = 'fancy'
set encoding=utf-8
"set t_Co=256
set fillchars+=stl:\ ,stlnc:\
set term=xterm-256color
set termencoding=utf-8
set laststatus=2

"" Settings for vim-powerline
"" cd ~/.vim/bundle
"" git clone git://github.com/Lokaltog/vim-powerline.git
""set laststatus=2


" Settings for ctrlp
" cd ~/.vim/bundle
" git clone https://github.com/kien/ctrlp.vim.git
let g:ctrlp_max_height = 30
set wildignore+=*.pyc
set wildignore+=*_build/*
set wildignore+=*/coverage/*


"" Settings for python-mode
"" I am not using python-mode anymore
"" Using jedi-vim
"" Make sure you disable the plugin
"" Either by moving the plugin folder to pluginname~
"" or use pathogen_disabled as shown above #infect
"" cd ~/.vim/bundle
"" git clone https://github.com/klen/python-mode
""map <Leader>g :call RopeGotoDefinition()<CR>
""let ropevim_enable_shortcuts = 1
""let g:pymode_rope_goto_def_newwin = "vnew"
""let g:pymode_rope_extended_complete = 1
""let g:pymode_breakpoint = 0
""let g:pymode_syntax = 1
""let g:pymode_syntax_builtin_objs = 0
""let g:pymode_syntax_builtin_funcs = 0
""map <Leader>b Oimport ipdb; ipdb.set_trace() # BREAKPOINT<C-c>

" Settings for jedi-vim
" cd ~/.vim/bundle
"" git clone git://github.com/davidhalter/jedi-vim.git
"" The first thing you need after that is an up-to-date version of Jedi. You can
"" either get it via pip install jedi or with 'git submodule update --init' in
"" your jedi-vim repository.
let g:jedi#related_names_command = "<leader>z"
let g:jedi#popup_on_dot = 0
let g:jedi#popup_select_first = 0
let g:jedi#use_tabs_not_buffers = 0
let g:jedi#use_splits_not_buffers = "left"
map <Leader>b Oimport ipdb; ipdb.set_trace() # BREAKPOINT<C-c>

"" Better navigating through omnicomplete option list
"" See
"" http://stackoverflow.com/questions/2170023/how-to-map-keys-for-popup-menu-in-vim
set completeopt=longest,menuone
function! OmniPopup(action)
   if pumvisible()
        if a:action == 'j'
            return "\<C-N>"
        elseif a:action == 'k'
            return "\<C-P>"
        endif
   endif
   return a:action
endfunction

inoremap <silent><C-j> <C-R>=OmniPopup('j')<CR>
inoremap <silent><C-k> <C-R>=OmniPopup('k')<CR>


" Python folding
" mkdir -p ~/.vim/ftplugin
" wget -O ~/.vim/ftplugin/python_editing.vim
" http://www.vim.org/scripts/download_script.php?src_id=5492
"set nofoldenable
