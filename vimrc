set nocompatible " Use Vim defaults

filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'sbdchd/neoformat'
Plugin 'neomake/neomake'
Plugin 'benjie/neomake-local-eslint.vim'
Plugin 'elixir-lang/vim-elixir'
Plugin 'mileszs/ack.vim'
Plugin 'Raimondi/delimitMate'
Plugin 'nelstrom/vim-markdown-folding'
Plugin 'tmhedberg/matchit'
Plugin 'tpope/vim-markdown'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-git'
Plugin 'tpope/vim-ragtag'
Plugin 'tpope/vim-unimpaired'
Plugin 'vim-scripts/tComment'
Plugin 'YankRing.vim'
Plugin 'hail2u/vim-css3-syntax.git'
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'
Plugin 'mattn/emmet-vim'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'ajh17/VimCompletesMe'
Plugin 'sickill/vim-monokai'
Plugin 'qpkorr/vim-bufkill'
Plugin 'junegunn/vim-emoji'

call vundle#end()
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
set mouse=a " enable mouse in terminal
"restore cursor position
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

"ui
set laststatus=2 "alwasy show status line
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

"folding
set nofoldenable "dont fold by default
set foldmethod=indent
set foldlevel=99

"completion
set wildmenu "command line completion
set wildignore=*.o,.DS_STORE,*.obj,*.pyc,*.class,_build,*.aux,*.bbl,*.blg,*/.git/*,*/.svn/*,"ignore these files
set wildmode=full
set completeopt=longest,menu
set pumheight=15 "limit completion menu height
set omnifunc=syntaxcomplete#Complete

" Enable jsx in .js files
let g:jsx_ext_required = 0

" ack.vim
let g:ackprg = 'ag --nogroup --nocolor --column'

let g:neomake_javascript_enabled_makers = ['eslint']
let g:neomake_open_list = 2

" vim-ariline
let g:airline_powerline_fonts = 0
" let g:airline#extensions#tabline#enabled = 1 " show buffers in tabline if there's only 1 tab
let g:airline#extensions#hunks#enabled=0  " only show branch in git section
let g:airline_symbols = {}
let g:airline_symbols.maxlinenr = ''  " don't show the 3 horizontal bars after max line nr
let g:airline_theme = 'distinguished'

" autocmd Filetype objc,c,objcpp call SuperTabSetDefaultCompletionType("<c-x><c-o>")
" autocmd BufWritePost *.c,*.m,*.h call g:ClangUpdateQuickFix()
" autocmd BufRead,BufNewFile *.m set filetype=objc

autocmd Filetype javascript setlocal noexpandtab nosmartindent tabstop=2

autocmd! BufWritePost * Neomake

augroup fmt
    autocmd!
    autocmd BufWritePre *.js,*.jsx undojoin | Neoformat
augroup END

" Ocaml
let g:opamshare = substitute(system('opam config var share'),'\n$','','''')
execute "set rtp+=" . g:opamshare . "/merlin/vim"
set rtp^="/Users/j.poissonnier/.opam/system/share/ocp-indent/vim"

"awesome manpages
"see note [1] at http://crumbtrail.chesmart.in/post/5024677985/man-vim-dude
runtime! ftplugin/man.vim
nmap K :Man <cword><CR>

"ctrlp
let g:ctrlp_map = '<C-p>'
let g:ctrlp_max_depth = 5
let g:ctrlp_show_hidden = 1
let g:ctrlp_custom_ignore = {
      \ 'dir':  'node_modules',
      \}
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

"TComment
map <D-/> :TComment<cr>

"quickfix window minimum height 3, max 10, autoadjusts to number of errors
au FileType qf call AdjustWindowHeight(3, 10)
function! AdjustWindowHeight(minheight, maxheight)
  exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
endfunction
au Filetype qf setlocal nolist nocursorline nowrap

"yankring
let g:yankring_history_dir = '/tmp'

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
",a to Ack the word under the cursor
nnoremap <leader>a :Ack <cword><CR>
nnoremap <leader>y :YRShow<CR>
nnoremap <leader>e :%s/:\([^:]\+\):/\=emoji#for(submatch(1), submatch(0))/g<CR>
nnoremap <C-b> :CtrlPBuffer<CR>
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
nnoremap <leader>ro :call RopeOrganizeImports()<CR>
nnoremap <leader>g :call RopeGotoDefinition()<CR>
" tabs
nnoremap <D-S-Left> :tabprevious<CR>
nnoremap <D-S-Right> :tabnext<CR>

cmap w!! w !sudo tee % >/dev/null

set background=dark
colorscheme monokai

if has('gui_running')
  cabbrev q <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'close' : 'q')<CR>
  " set guifont=Menlo\ Regular:h13
  set guifont=Menlo\ for\ Powerline:h13
  " set guifont=Fira\ Mono\ for\ Powerline:h13
  set guifont=Inconsolata:h15
  " set guifont=Inconsolata\ for\ Powerline:h15
  " set guifont=Source\ Code\ Pro\:h12
  set guioptions="" " hide toolbars, menu
  set columns=110 "initial screensize
  set fuopt=maxvert,maxhorz "set max size for fullscreen
endif
