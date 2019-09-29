syntax on

set completeopt=menu,preview
set encoding=utf-8
set expandtab
set fileencoding=utf-8
set hlsearch
set laststatus=2
set nocompatible
set number
set rtp+=$GOROOT/misc/vim
set shiftwidth=2
set t_Co=256
set tabstop=2
set viminfo='50,\"3000,:0,n~/.viminfo

exe "set rtp+=".globpath($GOPATH, "src/github.com/mdempsky/gocode/vim")

au BufRead,BufNewFile /usr/local/etc/nginx/* set ft=nginx
au BufRead,BufNewFile */Vagrantfile set ft=ruby
au BufRead,BufNewFile */Gemfile set ft=ruby
au BufRead,BufNewFile */Gemfile.lock set ft=ruby
au BufRead,BufNewFile */Brewfile set ft=ruby
au BufRead,BufNewFile */Dangerfile set ft=ruby
au BufRead,BufNewFile */.htmlhintrc set ft=ruby

let mapleader = "\<Space>"

filetype off

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
  NeoBundle 'posva/vim-vue'

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

  NeoBundle 'prabirshrestha/async.vim'
  NeoBundle 'prabirshrestha/asyncomplete.vim'
  NeoBundle 'prabirshrestha/asyncomplete-lsp.vim'
  NeoBundle 'prabirshrestha/vim-lsp'

  " SQLFmt
  NeoBundle 'mattn/vim-sqlfmt'

call neobundle#end()

filetype plugin indent on

nnoremap <C-]> g<C-]>
nnoremap <silent><C-e> :NERDTreeToggle<CR>
let g:NERDTreeNodeDelimiter = "\u00a0"

if has("autocmd")
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal! g'\"" |
  \ endif
endif

nnoremap <expr> / _(":%s/<Cursor>/&/gn")

function! s:move_cursor_pos_mapping(str, ...)
  let left = get(a:, 1, "<Left>")
  let lefts = join(map(split(matchstr(a:str, '.*<Cursor>\zs.*\ze'), '.\zs'), 'left'), "")
  return substitute(a:str, '<Cursor>', '', '') . lefts
endfunction

function! _(str)
  return s:move_cursor_pos_mapping(a:str, "\<Left>")
endfunction

if executable('go-langserver')
  au User lsp_setup call lsp#register_server({
    \ 'name': 'go-langserver',
    \ 'cmd': {server_info->['go-langserver', '-mode', 'stdio']},
    \ 'whitelist': ['go'],
    \ })
endif

nmap <silent> <Leader>d :LspDefinition<CR>
nmap <silent> <Leader>i :LspImplementation<CR>

if has('vim_starting')
  let &t_SI .= "\e[6 q"
  let &t_EI .= "\e[2 q"
  let &t_SR .= "\e[4 q"
endif
