" 行番号表示
set number
" 常にステータスラインを表示
set laststatus=2

" :colorscheme solarized
set t_Co=256
"set background=dark
syntax on
" 検索結果のハイライト
set hlsearch
" ハイライトを消す
" nnoremap <esc> :noh<CR>

set expandtab
set tabstop=2
set shiftwidth=2
set fileencoding=utf-8


let OSTYPE = system('kikuchi')
if OSTYPE == "Linux\n"
    noremap y y:wv<CR>
    noremap p :rv!<CR>p
endif

set viminfo='50,\"3000,:0,n~/.viminfo

au BufRead,BufNewFile /usr/local/etc/nginx/* set ft=nginx


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

  " 編集履歴管理, Undo/Redo 履歴管理
  NeoBundle 'sjl/gundo.vim'
  " solarized
  NeoBundle 'altercation/vim-colors-solarized'
  " ステータスラインの見た目
  NeoBundle 'Lokaltog/vim-powerline.git'
  " filer
  "NeoBundle 'Shougo/vimfiler'
  "NeoBundle 'LustyExplorer'
  " asynchronous
  "NeoBundle 'Shougo/vimproc'
  "emmet記法
  NeoBundle 'mattn/emmet-vim'
  "NERDTree
  NeoBundle 'scrooloose/nerdtree'
  " Ruby向けにendを自動挿入してくれる
  NeoBundle 'tpope/vim-endwise'
  " コメントON/OFFを手軽に実行
  NeoBundle 'tomtom/tcomment_vim'
  " vimを立ち上げたときに、自動的にvim-indent-guidesをオンにする
  let g:indent_guides_enable_on_vim_startup = 1
  " ログファイルを色づけしてくれる
  NeoBundle 'vim-scripts/AnsiEsc.vim'
  " 行末の半角スペースを可視化
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


call neobundle#end()

filetype plugin indent on     " Required!

" NERDTree
nnoremap <silent><C-e> :NERDTreeToggle<CR>

""""""""""""""""""""""""""""""
" 自動的に閉じ括弧を入力
""""""""""""""""""""""""""""""
"imap { {}<LEFT>
"imap [ []<LEFT>
"imap ( ()<LEFT>
""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""
" 最後のカーソル位置を復元する
""""""""""""""""""""""""""""""
if has("autocmd")
    autocmd BufReadPost *
    \ if line("'\"") > 0 && line ("'\"") <= line("$") |
    \   exe "normal! g'\"" |
    \ endif
endif
""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""
" 検索時に件数を表示する
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
