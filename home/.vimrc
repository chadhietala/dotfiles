" Auto Update .vimrc -------------

set nocompatible
filetype off

augroup reload_vimrc " {
    autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END " }

" Spacing ------------------------
set tabstop=2
set shiftwidth=2
set expandtab
set ai

" Searching ---------------------
set hlsearch
set incsearch
set ignorecase
set smartcase

" Status Line
set showcmd
set ruler

" Sound ------------------------
set visualbell
set noerrorbells

" Insert New Line Method
map <S-Enter> O<ESC>
map <Enter> o<ESC>

" Highlighting ----------------
highlight WhitespaceEOL ctermbg=red guibg=grey
match WhitespaceEOL /\s\+$/

set number
