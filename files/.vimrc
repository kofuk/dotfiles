" Set up Vundle if Vundle exists
if isdirectory(expand('~/.vim/bundle/Vundle.vim'))
    set nocompatible
    filetype off
    set rtp+=~/.vim/bundle/Vundle.vim
    call vundle#begin()

    " Plugins
    Plugin 'VundleVim/Vundle.vim'
    Plugin 'ap/vim-css-color'
    Plugin 'udalov/kotlin-vim'

    call vundle#end()
endif

filetype plugin indent on

set noswapfile
set modeline

" Appearance
syntax on
set ambiwidth=double
set synmaxcol=200
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
set scrolloff=30

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

if has("diffopt")
    set diffopt=internal
endif

" Complation
inoremap { {}<LEFT><ENTER><ENTER><UP><TAB>
inoremap [ []<LEFT>
inoremap ( ()<LEFT>
inoremap " ""<LEFT>
inoremap ' ''<LEFT>

if has("autocmd")
    autocmd BufReadPost *
                \ if line("'\"") > 0 && line("'\"") <= line("$") |
                \   exe "normal! g'\"'" |
                \ endif
endif

source $VIMRUNTIME/macros/matchit.vim
