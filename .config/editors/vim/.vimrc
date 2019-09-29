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
au BufRead,BufNewFile *.ts set filetype=typescript
au BufRead,BufNewFile *.cfg set filetype=nagios

let g:vim_tags_project_tags_command = "/usr/local/bin/ctags -f .tags -R . 2>/dev/null"
let g:vim_tags_gems_tags_command = "/usr/local/bin/ctags -R -f .Gemfile.lock.tags `bundle show --paths` 2>/dev/null"
set tags+=.tags
set tags+=.Gemfile.lock.tags

let mapleader = "\<Space>"

filetype off

if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

" auto vim-indent-guides on
let g:indent_guides_enable_on_vim_startup = 1

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

if &compatible
  set nocompatible
endif
" Add the dein installation directory into runtimepath
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

if dein#load_state('~/.cache/dein')
  call dein#begin('~/.cache/dein')

  let s:vim_dir = expand('~/.vim')
  let s:toml = s:vim_dir . '/dein.toml'
  call dein#load_toml(s:toml, {'lazy': 9})

  call dein#add('~/.cache/dein/repos/github.com/Shougo/dein.vim')
  call dein#add('Shougo/deoplete.nvim')
  if !has('nvim')
    call dein#add('roxma/nvim-yarp')
    call dein#add('roxma/vim-hug-neovim-rpc')
  endif

  call dein#end()
  call dein#save_state()
endif

filetype plugin indent on
syntax enable

