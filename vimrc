set nocompatible " Use Vim defaults

filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'ack.vim'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'AutoTag'
Plugin 'Raimondi/delimitMate'
Plugin 'nelstrom/vim-markdown-folding'
Plugin 'tpope/vim-markdown'
Plugin 'tpope/vim-repeat'
Plugin 'edsono/vim-matchit'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-git'
Plugin 'altercation/vim-colors-solarized'
Plugin 'vim-scripts/tComment'
Plugin 'YankRing.vim'
Plugin 'tpope/vim-ragtag'
Plugin 'hail2u/vim-css3-syntax.git'
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'
Plugin 'scrooloose/syntastic.git'
Plugin 'mattn/emmet-vim'
Plugin 'valloric/YouCompleteMe'

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
"restore cursor position
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

"ui
set laststatus=2 "alwasy show status line
set statusline=%<%f\ %h%m%r%y%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P
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
let g:SuperTabContextTextFileTypeExclusions = ['typoscript']
let g:SuperTabDefaultCompletionType = 'context'
let g:SuperTabContextDefaultCompletionType = '<c-x><c-o>'

"clang
" let g:clang_use_library=1
" let g:clang_complete_copen=1
" let g:clang_periodic_quickfix=1
" let g:clang_library_path = '/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib'

" Enable jsx in .js files
let g:jsx_ext_required = 0

" Syntastic
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_loc_list_height = 5
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_check_on_open = 0
let g:syntastic_error_symbol = '❌'
let g:syntastic_style_error_symbol = '⁉️'
let g:syntastic_warning_symbol = '⚠️'
let g:syntastic_style_warning_symbol = '💩'

highlight link SyntasticErrorSign SignColumn
highlight link SyntasticWarningSign SignColumn
highlight link SyntasticStyleErrorSign SignColumn
highlight link SyntasticStyleWarningSign SignColumn

" autocmd Filetype objc,c,objcpp call SuperTabSetDefaultCompletionType("<c-x><c-o>")
" autocmd BufWritePost *.c,*.m,*.h call g:ClangUpdateQuickFix()
" autocmd BufRead,BufNewFile *.m set filetype=objc

autocmd Filetype javascript.jsx set tabstop=2 shiftwidth=2

"objc
"https://github.com/b4winckler/vim-objc/blob/master/ftplugin/objc.vim
"Search for include files inside frameworks (used for gf etc.)
" autocmd Filetype objc,objcpp setlocal includeexpr=substitute(v:fname,'\\([^/]\\+\\)/\\(.\\+\\)','/System/Library/Frameworks/\\1.framework/Headers/\\2','')

"awesome manpages
"see note [1] at http://crumbtrail.chesmart.in/post/5024677985/man-vim-dude
runtime! ftplugin/man.vim
nmap K :Man <cword><CR>

"ctrlp
let g:ctrlp_map = '<leader>t'
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

au FileType javascript command! Dash call SearchDash('javascript:')
au FileType python command! Dash call SearchDash('python2:')
au FileType html command! Dash call SearchDash('html:')
au FileType css command! Dash call SearchDash('css:')
map <leader>d :Dash<cr>
function SearchDash(lib)
  let s:url = "dash://".a:lib.expand("<cword>")
  execute "silent ! /usr/bin/open ". s:url
  redraw!
endfunction

let mapleader = ","
nnoremap <leader>b :CtrlPBuffer<CR>
",space to clear search
nnoremap <leader><space> :noh<cr>
",W to remove all trailing whitespace
nnoremap <leader>W :call <SID>StripTrailingWhitespaces()<CR>
",i to toggle show invisibiles
nnoremap <leader>i :set list!<CR>
",n to toggle linenumbers
nnoremap <leader>n :set number! number?<cr>
",a to Ack the word under the cursor
nnoremap <leader>a :Ack <cword><CR>
nnoremap <leader>y :YRShow<CR>
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
nnoremap <leader>d :Dash<CR>

cmap w!! w !sudo tee % >/dev/null

set background=dark
colorscheme solarized

if has('gui_running')
    " set guifont=Menlo\ Regular:h12
    " set guifont=Inconsolata-dz:h12
    " set guifont=Inconsolata\ for\ Powerline:h14
    set guifont=Inconsolata:h15
    " set guifont=Source\ Code\ Pro\:h12
    set guioptions="" " hide toolbars, menu
    set columns=110 "initial screensize
    set fuopt=maxvert,maxhorz "set max size for fullscreen
endif

