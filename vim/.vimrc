" display line number
set number
" always display status line
set laststatus=2

" :colorscheme solarized
set t_Co=256
"set background=dark
syntax on
" search result highlight
set hlsearch

set expandtab
set tabstop=2
set shiftwidth=2
set fileencoding=utf-8
set encoding=utf-8

set rtp+=$GOROOT/misc/vim
exe "set rtp+=".globpath($GOPATH, "src/github.com/nsf/gocode/vim")
set completeopt=menu,preview

let OSTYPE = system('kikuchi')
if OSTYPE == "Linux\n"
    noremap y y:wv<CR>
    noremap p :rv!<CR>p
endif

set viminfo='50,\"3000,:0,n~/.viminfo

au BufRead,BufNewFile /usr/local/etc/nginx/* set ft=nginx
au BufRead,BufNewFile */Vagrantfile set ft=ruby
au BufRead,BufNewFile */Gemfile set ft=ruby
au BufRead,BufNewFile */Gemfile.lock set ft=ruby

"--------------------------------------------------------------------------
" neobundle
"------------------------------------------------------------------
set nocompatible               " Be iMproved
filetype off                   " Required!


if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.vim/bundle/'))

  NeoBundle 'Shougo/neobundle.vim'

  " edit history, Undo/Redo history
  NeoBundle 'sjl/gundo.vim'
  " solarized
  NeoBundle 'altercation/vim-colors-solarized'
  " status line visual
  NeoBundle 'Lokaltog/vim-powerline.git'
  " filer
  "NeoBundle 'Shougo/vimfiler'
  "NeoBundle 'LustyExplorer'
  " asynchronous
  "NeoBundle 'Shougo/vimproc'
  "emmet notation
  NeoBundle 'mattn/emmet-vim'
  "NERDTree
  NeoBundle 'scrooloose/nerdtree'
  " Rubist love
  NeoBundle 'tpope/vim-endwise'
  " comment shortcut
  NeoBundle 'tomtom/tcomment_vim'
  " auto vim-indent-guides on
  let g:indent_guides_enable_on_vim_startup = 1
  " coloring log file
  NeoBundle 'vim-scripts/AnsiEsc.vim'
  " display useless one-byte spaece
  " NeoBundle 'bronson/vim-trailing-whitespace'
  " Docker syntax
  NeoBundle 'ekalinin/Dockerfile.vim'
  " angular syntax
  NeoBundle 'burnettk/vim-angular'
  " angular snippet
  NeoBundle 'matthewsimo/angular-vim-snippets'
  " typescript syntax
  NeoBundle 'leafgarland/typescript-vim'
  NeoBundle 'taichouchou2/vim-javascript'
  autocmd BufRead,BufNewFile *.ts set filetype=typescript
  " golang syntax
  NeoBundle 'fatih/vim-go'
  " vim-json syntax
  NeoBundle 'elzr/vim-json'
  " slim syntax
  NeoBundle 'slim-template/vim-slim'
  " coffee syntax
  NeoBundle 'kchmck/vim-coffee-script'
  " swift syntax
  NeoBundle 'kballard/vim-swift'
  " nginx syntax
  NeoBundle 'vim-scripts/nginx.vim'
  " tmux syntax
  NeoBundle 'keith/tmux.vim'
  " NeoBundle 'Shougo/vimproc.vim', {
  "       \ 'build' : {
  "       \     'windows' : 'tools\\update-dll-mingw',
  "       \     'cygwin' : 'make -f make_cygwin.mak',
  "       \     'mac' : 'make -f make_mac.mak',
  "       \     'linux' : 'make',
  "       \     'unix' : 'gmake',
  "       \    },
  "       \ }

  " NeoBundle 'Quramy/tsuquyomi'
  " elixir syntax
  NeoBundle 'elixir-lang/vim-elixir'
  " env syntax
  NeoBundle 'tpope/vim-dotenv'
  " less syntax
  NeoBundle 'groenewege/vim-less'
  " nix syntax
  NeoBundle 'LnL7/vim-nix'
  " fish syntax
  NeoBundle 'vim-scripts/fish-syntax'
  " git
  NeoBundle 'tpope/vim-fugitive'
  " Dash
  NeoBundle 'rizzatti/dash.vim'
  " Gradle syntax
  NeoBundle 'tfnico/vim-gradle'
  " Groovy syntax
  NeoBundle 'vim-scripts/groovy.vim'
  " Automatically update tags
  NeoBundle 'szw/vim-tags'
  let g:vim_tags_project_tags_command = "/usr/local/bin/ctags -f .tags -R . 2>/dev/null"
  let g:vim_tags_gems_tags_command = "/usr/local/bin/ctags -R -f .Gemfile.lock.tags `bundle show --paths` 2>/dev/null"
  set tags+=.tags
  set tags+=.Gemfile.lock.tags
  " protobuffer syntax
  NeoBundle 'uarun/vim-protobuf'

  NeoBundle 'pangloss/vim-javascript'
  NeoBundle 'mxw/vim-jsx'

call neobundle#end()

filetype plugin indent on     " Required!

" Display list when mutiple destination
nnoremap <C-]> g<C-]>

" NERDTree
nnoremap <silent><C-e> :NERDTreeToggle<CR>

""""""""""""""""""""""""""""""
" auto complete close bracket
""""""""""""""""""""""""""""""
"imap { {}<LEFT>
"imap [ []<LEFT>
"imap ( ()<LEFT>
""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""
" reopen vim from previous cursor position
""""""""""""""""""""""""""""""
if has("autocmd")
    autocmd BufReadPost *
    \ if line("'\"") > 0 && line ("'\"") <= line("$") |
    \   exe "normal! g'\"" |
    \ endif
endif
""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""
" display number of search result
""""""""""""""""""""""""""""""
nnoremap <expr> / _(":%s/<Cursor>/&/gn")

function! s:move_cursor_pos_mapping(str, ...)
    let left = get(a:, 1, "<Left>")
    let lefts = join(map(split(matchstr(a:str, '.*<Cursor>\zs.*\ze'), '.\zs'), 'left'), "")
    return substitute(a:str, '<Cursor>', '', '') . lefts
endfunction

function! _(str)
    return s:move_cursor_pos_mapping(a:str, "\<Left>")
endfunction
