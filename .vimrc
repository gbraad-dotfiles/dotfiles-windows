set nocompatible

" Python
set pythonthreedll=$HOME/AppData/Local/Programs/Python/Python39/python39.dll
set pythonthreehome=$HOME/AppData/Local/Programs/Python/Python39/

set shortmess=AI

" For Windows
set rtp^=$HOME/.vim

" Powerline
set rtp+=$HOME/.local/lib/python2.7/site-packages/powerline/bindings/vim
set rtp^=$HOME/.vim
set langmenu=en_US
let $LANG = 'en_US'
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim
set guioptions-=T

" Appearance
colorscheme Tomorrow-Night-Bright
set guifont=Source\ Code\ Pro
"set guifont=Source\ Code\ Pro\ for\ Powerline
"set cursorline
set laststatus=2
set showtabline=2
set noshowmode
set number
nmap <C-N><C-N> :set invnumber<CR>
set numberwidth=5
set cpoptions+=n
"highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE
"nmap <C-N><C-N><C-N> :set relativenumber
"set fillchars+=vert:\|
hi! VertSplit guifg=bg guibg=bg gui=NONE
"hi! VertSplit ctermfg=bg ctermbg=bg term=NONE
hi! NonText guifg=bg
"hi! NonText ctermfg=bg
" Set background else termux will use orange
hi Normal ctermbg=black

" Nerdtree
let g:NERDTreeWinPos = "right"
"nmap <C-N><C-T> :NERDTree
nnoremap <silent> <expr> <F6> g:NERDTree.IsOpen() ? "\:NERDTreeClose<CR>" : bufexists(expand('%')) ? "\:NERDTreeFind<CR>" : "\:NERDTree<CR>"

syntax enable
filetype plugin on

" search subfolders and tabcomplete
set path+=**
set wildmenu

" for browsing
let g:netrw_banner=0
let g:netrw_browse_split=4
let g:netrw_altv=1
let g:netrw_liststyle=3
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'

" gitgutter colors
let g:gitgutter_override_sign_column_highlight = 0
highlight clear SignColumn
highlight GitGutterAdd ctermfg=2
highlight GitGutterChange ctermfg=3
highlight GitGutterDelete ctermfg=1
highlight GitGutterChangeDelete ctermfg=4
