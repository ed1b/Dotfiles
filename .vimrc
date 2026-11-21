set nocompatible

call plug#begin('~/.vim/plugged')
Plug 'dracula/vim'
call plug#end()

syntax on
filetype plugin indent on

if has('termguicolors')
  set termguicolors
endif

let g:dracula_colorterm = 1
colorscheme dracula
set background=dark
set number
set mouse=a
