" OPTIONS
syntax on                 " enable syntax highlighting
set number                " show line numbers
set relativenumber        " show relative line numbers
set tabstop=4             " show tab width to 4 spaces
set shiftwidth=4          " set indentation wdith to 4 spaces
set expandtab             " use spaces instead of tabs 
set cursorline            " highlight the current line
set background=dark
set notermguicolors
set clipboard=unnamedplus

" clipboard
nnoremap <C-@> :call system("wl-copy", @")<CR>

" KEYBINDS
nmap ; :
imap jk <ESC>
