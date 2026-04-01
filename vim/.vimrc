" ── basics ───────────────────────────────────────────────────────────────────
set nocompatible
syntax on
filetype plugin indent on

set number
set relativenumber
set cursorline
set showcmd
set wildmenu

" ── indentation ───────────────────────────────────────────────────────────────
set expandtab
set tabstop=2
set shiftwidth=2
set autoindent
set smartindent

" ── search ────────────────────────────────────────────────────────────────────
set incsearch
set hlsearch
set ignorecase
set smartcase
nnoremap <Esc><Esc> :nohlsearch<CR>

" ── editing ───────────────────────────────────────────────────────────────────
set backspace=indent,eol,start
set scrolloff=5
set encoding=utf-8
set hidden

" ── splits ────────────────────────────────────────────────────────────────────
set splitbelow
set splitright
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
