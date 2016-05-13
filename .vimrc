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


let OSTYPE = system('kikuchi')
if OSTYPE == "Linux\n"
    noremap y y:wv<CR>
    noremap p :rv!<CR>p
endif

set viminfo='50,\"3000,:0,n~/.viminfo

au BufRead,BufNewFile /etc/nginx/* set ft=nginx


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
  "NeoBundle 'mattn/emmet-vim'
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