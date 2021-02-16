set laststatus=2
set noshowmode

"set rtp+=$HOME/.local/lib/python2.7/site-packages/powerline/bindings/vim
set rtp^=$HOME/.vim
set langmenu=en_US
let $LANG = 'en_US'
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim
set guioptions-=T

colorscheme Tomorrow-Night-Bright

set guifont=Source\ Code\ Pro\ for\ Powerline 10
"set cursorline 
set number
nmap <C-N><C-N> :set invnumber<CR>
set numberwidth=5
set cpoptions+=n
"highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE
"nmap <C-N><C-N><C-N> :set relativenumber

nmap <C-N><C-T> :NERDTree

"set fillchars+=vert:\|
hi! VertSplit guifg=bg guibg=bg gui=NONE
"hi! VertSplit ctermfg=bg ctermbg=bg term=NONE
hi! NonText guifg=bg
"hi! NonText ctermfg=bg

"execute pathogen#infect()
