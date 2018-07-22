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
  NeoBundle 'bronson/vim-trailing-whitespace'
  " git
  NeoBundle 'tpope/vim-fugitive'
  " Dash
  NeoBundle 'rizzatti/dash.vim'
  " silver searcher
  " NeoBundle 'mileszs/ack.vim'
  " if executable('ag')
  "   let g:ackprg = 'ag --vimgrep'
  " endif
  NeoBundle 'rking/ag.vim'
  " clang completion plugin
  NeoBundle 'justmao945/vim-clang'

  " Syntax Highlight
  NeoBundle 'vim-scripts/groovy.vim'
  NeoBundle 'tfnico/vim-gradle'
  NeoBundle 'vim-scripts/fish-syntax'
  NeoBundle 'LnL7/vim-nix'
  NeoBundle 'groenewege/vim-less'
  NeoBundle 'tpope/vim-dotenv'
  NeoBundle 'elixir-lang/vim-elixir'
  NeoBundle 'keith/tmux.vim'
  NeoBundle 'vim-scripts/nginx.vim'
  NeoBundle 'kballard/vim-swift'
  NeoBundle 'kchmck/vim-coffee-script'
  NeoBundle 'fatih/vim-go'
  NeoBundle 'elzr/vim-json'
  NeoBundle 'slim-template/vim-slim'
  NeoBundle 'leafgarland/typescript-vim'
  NeoBundle 'taichouchou2/vim-javascript'
  NeoBundle 'ekalinin/Dockerfile.vim'
  NeoBundle 'burnettk/vim-angular'
  NeoBundle 'matthewsimo/angular-vim-snippets'
  NeoBundle 'hashivim/vim-terraform'
  autocmd BufRead,BufNewFile *.ts set filetype=typescript
  NeoBundle 'cakebaker/scss-syntax.vim'
  NeoBundle 'bigbrozer/vim-nagios'
  autocmd BufRead,BufNewFile *.cfg set filetype=nagios
  NeoBundle 'udalov/kotlin-vim'

  " Automatically update tags
  NeoBundle 'szw/vim-tags'
  let g:vim_tags_project_tags_command = "/usr/local/bin/ctags -f .tags -R . 2>/dev/null"
  let g:vim_tags_gems_tags_command = "/usr/local/bin/ctags -R -f .Gemfile.lock.tags `bundle show --paths` 2>/dev/null"
  set tags+=.tags
  set tags+=.Gemfile.lock.tags
  " protobuffer syntax
  NeoBundle 'uarun/vim-protobuf'
  " gocode
  NeoBundle 'nsf/gocode'

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
