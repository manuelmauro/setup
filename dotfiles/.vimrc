set nocompatible              " be iMproved, required
filetype off                  " required

"set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
"alternatively, pass a path where Vundle should install plugins
"let path = '~/some/path/here'
"call vundle#rc(path)

"Base plugins
"let Vundle manage Vundle, required
Plugin 'gmarik/vundle'
"Git wrapper so awesome, it should be illegal
Plugin 'tpope/vim-fugitive'
"Fuzzy file, buffer, mru, tag, etc finder.
Plugin 'kien/ctrlp.vim'
"A tree explorer plugin for navigating the filesystem 
Plugin 'scrooloose/nerdtree'
"Syntax checking hacks for vim
Plugin 'scrooloose/syntastic'
"snipMate.vim aims to be a concise vim script that implements some of TextMate's
"snippets features in Vim.
"dependencies
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
"plugin
Plugin 'garbas/vim-snipmate'
"snippets
Plugin 'honza/vim-snippets'

"JavaScript plugins

"Node plugins
"Tools and environment to make Vim superb for developing with Node.js.
Plugin 'moll/vim-node'
"snippets
Plugin 'jamescarr/snipmate-nodejs'

"Haskell plugins
"Vim plugin for Haskell development
Plugin 'bitc/vim-hdevtools' 


"All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on     " required
"To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList          - list configured plugins
" :PluginInstall(!)    - install (update) plugins
" :PluginSearch(!) foo - search (or refresh cache first) for foo
" :PluginClean(!)      - confirm (or auto-approve) removal of unused plugins
"
" see :h vundle for more details or wiki for FAQ
" NOTE: comments after Plugin commands are not allowed.
" Put your stuff after this line

"NERDTree bugfix
let g:NERDTreeDirArrows=0
"Show hidden files in NERDTree
let NERDTreeShowHidden=1

"Configuration settings
"Turn on line numbering. Turn it off with "set nonu" 
set nu 

"Html and XML indentation
let g:html_indent_inctags = "html,body,head,tbody"
autocmd FileType html setlocal shiftwidth=2 tabstop=2
autocmd FileType xml setlocal shiftwidth=2 tabstop=2

"Git commit guidelines 
autocmd Filetype gitcommit setlocal spell textwidth=72

"Window navigation remap
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

"Set syntax on
syntax on

if $COLORTERM == 'gnome-terminal'
      set t_Co=256
endif

"Indent automatically depending on filetype
set autoindent

"Case insensitive search
set ignorecase
set smartcase

"Incremental search
set incsearch
"Highlight search
set hls

set tabstop=4
set softtabstop=4
set shiftwidth=4
set textwidth=80

"Always uses spaces instead of tabs
set expandtab                   
"Indent instead of tab at start of line
set smarttab
"Round spaces to nearest shiftwidth multiple
set shiftround
"Don't convert spaces to tabs
set nojoinspaces

colors morning

