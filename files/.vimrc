" Set up Vundle if Vundle exists
if isdirectory(expand('~/.vim/bundle/Vundle.vim'))
    set nocompatible
    filetype off
    set rtp+=~/.vim/bundle/Vundle.vim
    call vundle#begin()

    " Plugins
    Plugin 'VundleVim/Vundle.vim'

    call vundle#end()
endif

filetype plugin indent on

set noswapfile
set modeline

" Appearance
syntax on
set number
set cursorline
set cursorcolumn
set virtualedit=onemore
set showmatch
set laststatus=2
set wildmode=list:longest
set list listchars=tab:\▸\-,eol:↲,trail:-
set colorcolumn=80
set ruler
set showcmd
set cmdheight=1

" Search
set ignorecase
set smartcase
set incsearch
set wrapscan
set hlsearch

" Indent
set tabstop=4
set autoindent
set expandtab
set shiftwidth=4
set backspace=indent,eol,start
