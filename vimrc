set nocompatible

call plug#begin('~/.vim/plugged')
Plug 'mileszs/ack.vim'
Plug 'Raimondi/delimitMate'
Plug 'tmhedberg/matchit'
Plug 'tpope/vim-markdown'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-git'
Plug 'tpope/vim-ragtag'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-commentary'
Plug 'vim-scripts/YankRing.vim'
Plug 'airblade/vim-gitgutter'
Plug 'qpkorr/vim-bufkill'
Plug 'junegunn/vim-emoji'
Plug 'joshdick/onedark.vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'prettier/vim-prettier', {
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue'] }
Plug 'w0rp/ale'
call plug#end()

filetype plugin indent on

syntax on

set encoding=utf-8
set shell=sh
set autoread
set ttyfast
set backspace=indent,eol,start
set hidden "dont require saving before switching buffers
set modeline
set nostartofline
set nobackup
set noswapfile
set undofile "persistent undo
set undodir=/tmp
set history=100 "keep 100 lines of history
set viminfo='10,:20,\"100,n~/.viminfo
set laststatus=2
"set mouse=a " enable mouse in terminal
"restore cursor position
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

"ui
set listchars=tab:▸\ ,eol:¬ "invisible chars
set nolist "dont show invisible chars by default
set noerrorbells visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=
set showcmd "show command in the last line of the screen
set wrap linebreak
set showbreak=↪\  "show at the beginning of wrapped lines
set cursorline

"search
set hlsearch " highlight the last searched term
set incsearch "find as you type
set ignorecase "http://stevelosh.com/blog/2010/09/coming-home-to-vim/
set smartcase

"indentation
set autoindent
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set shiftround

autocmd FileType python setlocal tabstop=4 noexpandtab
autocmd FileType javascript,javascript.jsx setlocal tabstop=4 noexpandtab
autocmd FileType javascript,javascript.jsx setlocal tabstop=2 shiftwidth=2 softtabstop=2


"completion
set wildmenu "command line completion
set wildignore=*.o,.DS_STORE,*.obj,*.pyc,*.class,_build,*.aux,*.bbl,*.blg,*/.git/*,*/.svn/*,*/node_modules/*
set wildmode=full
set completeopt-=preview
set pumheight=15 "limit completion menu height

" Add entries from .gitignore to wildignore
let filename = '.gitignore'
if filereadable(filename)
    let igstring = ''
    for oline in readfile(filename)
        let line = substitute(oline, '\s|\n|\r', '', "g")
        if line =~ '^#' | con | endif
        if line == '' | con  | endif
        if line =~ '^!' | con  | endif
        if line =~ '/$' | let igstring .= "," . line . "*" | con | endif
        let igstring .= "," . line
    endfor
    let execstring = "set wildignore=".substitute(igstring, '^,', '', "g")
    execute execstring
endif

" statusline
set statusline=%t " filename
set statusline+=%= " spacer
set statusline+=%y " filetype
set statusline+=\ (%l,%c) "(line, column)


" ack.vim
let g:ackprg = 'ag --nogroup --nocolor --column'

"awesome manpages
"see note [1] at http://crumbtrail.chesmart.in/post/5024677985/man-vim-dude
runtime! ftplugin/man.vim
nmap K :Man <cword><CR>

"quickfix window minimum height 3, max 10, autoadjusts to number of errors
au FileType qf call AdjustWindowHeight(3, 10)
function! AdjustWindowHeight(minheight, maxheight)
  exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
endfunction
au Filetype qf setlocal nolist nocursorline nowrap

"yankring
let g:yankring_history_dir = '/tmp'
let g:yankring_replace_n_pkey = 'm' "rebind so it doesn't conflict with c-p

"ctrlp
nnoremap <C-b> :CtrlPBuffer<cr>

"prettier-vim
let g:prettier#autoformat = 0
autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue PrettierAsync

"ale
let g:ale_fixers = {
\   'javascript': ['yarn eslint'],
\}
let g:ale_open_list = 1
let g:ale_completion_enabled = 1


function! <SID>StripTrailingWhitespaces()
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Do the business:
  %s/\s\+$//e
  " Clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction

let mapleader = ","
",space to clear search
nnoremap <leader><space> :noh<cr>
",W to remove all trailing whitespace
nnoremap <leader>W :call <SID>StripTrailingWhitespaces()<CR>
",i to toggle show invisibiles
nnoremap <leader>i :set list!<CR>
",n to toggle linenumbers
nnoremap <leader>n :set number! number?<cr>
" nnoremap <leader>t :NERDTreeTabsOpen<CR>
" nnoremap <leader>j :NERDTreeTabsFind<CR>
" Ale
nnoremap <C-b> :ALEGoToDefinition<cr>
",a to Ack the word under the cursor
nnoremap <leader>a :Ack <cword><CR>
nnoremap <leader>y :YRShow<CR>
nnoremap <leader>e :%s/:\([^:]\+\):/\=emoji#for(submatch(1), submatch(0))/g<CR>
noremap <up> <nop>
noremap <down> <nop>
noremap <left> <nop>
noremap <right> <nop>
vnoremap < <gv
vnoremap > >gv
" cycle through buffers with C-j and C-k
nnoremap <C-j> :bp<cr>
nnoremap <C-k> :bn<cr>
",s for search/replace
nnoremap <leader>s :%s///g<left><left><left>
" tabs
nnoremap <D-S-Left> :tabprevious<CR>
nnoremap <D-S-Right> :tabnext<CR>

cmap w!! w !sudo tee % >/dev/null


set background=dark
colorscheme onedark

if has('gui_running')
  cabbrev q <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'close' : 'q')<CR>
  " set guifont=Menlo\ Regular:h13
  " set guifont=Menlo\ for\ Powerline:h13
  " set guifont=Fira\ Mono\ for\ Powerline:h13
  " set guifont=Inconsolata:h15
  set guifont=Fira\ Mono:h14
  " set guifont=Inconsolata\ for\ Powerline:h15
  " set guifont=Source\ Code\ Pro\:h12
  set guioptions="" " hide toolbars, menu
  set columns=110 "initial screensize
  set fuopt=maxvert,maxhorz "set max size for fullscreen
endif
