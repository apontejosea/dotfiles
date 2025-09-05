set ff=dos

"===================================================================
" Vundle
"==================================================================
set nocompatible               " be iMproved
filetype off                   " required!

if has('win32') || has('win64')
  set rtp+=~/vim/vimfiles/bundle/Vundle.vim
  call vundle#begin('$HOME/vim/vimfiles/bundle/')
else
  " Usual quickstart instructions
  set rtp+=~/.vim/vimfiles/bundle/Vundle.vim
  call vundle#begin('$HOME/.vim/vimfiles/bundle/')
endif

call vundle#begin('$HOME/.vim/vimfiles/bundle/')

" let Vundle manage Vundle
" required! 
Bundle 'gmarik/vundle'
" 
" My Bundles here:
"
" original repos on github
Bundle 'nelstrom/vim-markdown-folding'
Bundle 'maxmeyer/vim-taskjuggler.git'
Bundle 'scrooloose/nerdtree.git'
Bundle 'tpope/vim-fugitive'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'tpope/vim-rails.git'
Bundle 'vim-ruby/vim-ruby'
Bundle 'altercation/vim-colors-solarized'
Bundle 'vim-scripts/Vim-R-plugin'
Bundle 'godlygeek/tabular'
Bundle 'plasticboy/vim-markdown'
Bundle 'L9'
Bundle 'FuzzyFinder'
"  non github repos
Bundle 'git://git.wincent.com/command-t.git'
" " ...
Bundle "MarcWeber/vim-addon-mw-utils"
Bundle "tomtom/tlib_vim"
Bundle "garbas/vim-snipmate"
Bundle "SirVer/ultisnips.git"
Bundle "honza/vim-snippets"

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line


filetype plugin indent on     " required!

set nocompatible
if has("autocmd")
  filetype plugin indent on
endif


"===================================================================
" relocating swap files
"===================================================================
if has('win32') || has('win64')
  set backupdir=$USERPROFILE/vim/temp
  set dir=$USERPROFILE/vim/temp
else
  set backupdir=~/.vim/temp
  set dir=~/.vim/temp
endif


"===================================================================
" ...so that fugitive works
"===================================================================
set directory+=,~/tmp,$TMP


"===================================================================
" Autocompletion
"===================================================================
filetype plugin on
set ofu=syntaxcomplete#Complete

:imap jk <Esc>
:imap JK <Esc>

"===================================================================
" move chunks up/down
" this is not working as expected
"===================================================================
let @a = 'V}d}p'
nnoremap <A-J> @a
let @w = 'V}d{{p'
nnoremap <A-K> @w

nnoremap <A->> zr
nnoremap <A-lt> zm

nnoremap <A-p> gq}g;<C-O>


"===================================================================
" complete file path while typing
"===================================================================
set wildmode=longest,list,full
set wildmenu


"===================================================================
" Automatically closes brakets
" Taken from:
" http://vim.wikia.com/wiki/Automatically_append_closing_characters
"===================================================================
inoremap {      {}<Left>
inoremap {<CR>  {<CR>}<Esc>O

inoremap {{     {
inoremap {}     {}

inoremap        (  ()<Left>
inoremap <expr> )  strpart(getline('.'), col('.')-1, 1) == ")" ? "\<Right>" : ")"

" Incomplete example moving the cursor after insertion.
" DO NOT USE, use a plugin instead.
function! MoveLeft()
  let newpos = getpos('.')
  let newpos[2] -= 1
  if (newpos[2] < 1)
    let newpos[2] = 1
  endif
  call setpos('.', newpos)
  return ""
endfunction
inoremap ( ()<C-R>=MoveLeft()<CR>

let $MYVIMRC = '$USERPROFILE\vim\_vimrc'

"===================================================================
" Tab characters
"===================================================================
:set tabstop=2
:set shiftwidth=2
:set expandtab

nnoremap <Tab> >>_
nnoremap <S-Tab> <<_
inoremap <S-Tab> <C-D>
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv


"===================================================================
" navigate buffers
"===================================================================
:nnoremap <C-n> :bnext<CR>
:nnoremap <C-p> :bprevious<CR>


"===================================================================
" Return characters in normal mode 
"===================================================================
map <S-Enter> O<Esc>
map <CR> o<Esc>


"===================================================================
"===================================================================
set nocompatible
syntax enable
filetype plugin on
filetype indent on

"set nocompatible
source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
behave mswin

set hidden


"===================================================================
" Move lines up/down 
"===================================================================
nnoremap <A-j> :m+<CR>==
nnoremap <A-k> :m-2<CR>==
inoremap <A-j> <Esc>:m+<CR>==gi
inoremap <A-k> <Esc>:m-2<CR>==gi
vnoremap <A-j> :m'>+<CR>gv=gv
vnoremap <A-k> :m-2<CR>gv=gv

"===================================================================
" Navigating tabs 
"===================================================================
:nnoremap <F7> :tabp<CR>
:nnoremap <F8> :tabn<CR>
 
"===================================================================
" solarized color scheme
"===================================================================
syntax enable
set background=light
colorscheme solarized
if has('gui_running')
  set background=light
else
  set background=dark
endif
call togglebg#map("<F6>")
let g:solarized_italic=0    "default value is 1

let mapleader = ","

"===================================================================
" show row numbers
"===================================================================
:set number


"===================================================================
"  VimOutliner
"===================================================================
filetype plugin indent on
syntax on
runtime! ftdetect\*.vim
au BufEnter *.otl setlocal tabstop = 2
au BufEnter *.otl setlocal shiftwidth = 2



"===================================================================
"  Indentation
"===================================================================
set autoindent


"===================================================================
" Macro for date insertion
"===================================================================
"noremap <A-d> strftime("%m/%d/%y")
"
:nnoremap <F5> "=strftime("%m/%d/%y")<CR>P
:inoremap <F5> <C-R>=strftime("%m/%d/%y")<CR>

:inoremap <A-3> #' 
:nnoremap <A-3> i#' <Esc>


"===================================================================
" Swap words
"===================================================================
:nnoremap <silent> gw "_yiw:s/\(\%#\w\+\)\(\W\+\)\(\w\+\)/\3\2\1/<CR><c-o><c-l>
" This version will work across newlines:
:nnoremap <silent> gw "_yiw:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><c-o><c-l>


"===================================================================
" Code Folding
"===================================================================
autocmd FileType R 
      \ set foldmethod=expr | 
      \ set foldexpr=getline(v:lnum)=~'^\\s*#\'''

augroup vimrc
  au BufReadPre * setlocal foldmethod=indent
"  au BufWinEnter * if &fdm == 'indent' | setlocal foldmethod=manual | endif
augroup END

au BufWinLeave ?* mkview
au BufWinEnter ?* silent loadview

"function! MarkdownFolds()
"  let thisline = getline(v:lnum)
"  if match(thisline, "^##") >= 0
"    return ">2"
"  elseif match(thisline, "^#") >= 0
"    return ">1"
"  else
"    return "="
"  endif
"endfunction
"function! MarkdownFoldText()
"  let foldsize = (v:foldend-v:foldstart)
"  return getline(v:foldstart).' ('.foldsize.' lines)'
"endfunction
"autocmd FileType Rmd
"      \ set foldtext=MarkdownFoldText() |
"      \ set foldcolumn=3 |
"      \ set foldmethod=expr | 
"      \ set foldexpr=MarkdownFolds()

"===================================================================
" auto wraping text
"===================================================================
" set formatoptions-=tcqro
"
" 
" " http://www.derekwyatt.org/vim/the-vimrc-file/
" set textwidth=120
" 
augroup vimrc_autocmds
  autocmd BufEnter * set textwidth=70
  autocmd BufEnter *.R set textwidth=140
augroup END


" Increase history of executed commands (:).
set history=1000

" Increase number of possible undos.
set undolevels=1000


set diffexpr=MyDifference()
function MyDifference()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let eq = ''
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      let cmd = '""' . $VIMRUNTIME . '\diff"'
      let eq = '"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
endfunction


"===================================================================
" Enable the installation of vimballs (vba files)
"===================================================================
" call vimball#Vimball("%:p:h")

function! VO2MD()
  let lines = []
  let was_body = 0
  for line in getline(1,'$')
    if line =~ '^\t*[^:\t]'
      let indent_level = len(matchstr(line, '^\t*'))
      if was_body " <= remove this line to have body lines separated
        call add(lines, '')
      endif " <= remove this line to have body lines separated
      call add(lines, substitute(line, '^\(\t*\)\([^:\t].*\)', '\=repeat("#", indent_level + 1)." ".submatch(2)', ''))
      call add(lines, '')
      let was_body = 0
    else
      call add(lines, substitute(line, '^\t*: ', '', ''))
      let was_body = 1
    endif
  endfor
  silent %d _
  call setline(1, lines)
endfunction

function! MD2VO()
  let lines = []
  for line in getline(1,'$')
    if line =~ '^\s*$'
      continue
    endif
    if line =~ '^#\+'
      let indent_level = len(matchstr(line, '^#\+')) - 1
      call add(lines, substitute(line, '^#\(#*\) ', repeat("\<Tab>", indent_level), ''))
    else
      call add(lines, substitute(line, '^', repeat("\<Tab>", indent_level) . ': ', ''))
    endif
  endfor
  silent %d _
  call setline(1, lines)
endfunction

