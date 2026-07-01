-- ~/.config/nvim/init.lua
-- Neovim 0.12+ / vim.pack + tree-sitter-manager.nvim 構成

--------------------------------------------------
-- リーダーキー（プラグイン読み込み前に設定すること）
--------------------------------------------------
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

--------------------------------------------------
-- 基本オプション
--------------------------------------------------
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.signcolumn = 'yes'
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.undofile = true

--------------------------------------------------
-- プラグイン定義（vim.pack）
--------------------------------------------------
vim.pack.add({
  { src = 'https://github.com/folke/tokyonight.nvim' },
  { src = 'https://github.com/nvim-lua/plenary.nvim' },
  { src = 'https://github.com/nvim-tree/nvim-web-devicons' },
  { src = 'https://github.com/nvim-tree/nvim-tree.lua' },
  { src = 'https://github.com/romus204/tree-sitter-manager.nvim' }, -- ← nvim-treesitter の置き換え
  { src = 'https://github.com/neovim/nvim-lspconfig' },
  { src = 'https://github.com/williamboman/mason.nvim' },
  { src = 'https://github.com/nvim-telescope/telescope.nvim' },
  { src = 'https://github.com/nvim-lualine/lualine.nvim' },
  { src = 'https://github.com/lewis6991/gitsigns.nvim' },
  { src = 'https://github.com/folke/which-key.nvim' },
})

--------------------------------------------------
-- 使用する言語（パーサ & ハイライト対象）
-- ここを自分の使う言語に合わせて編集してください
--------------------------------------------------
local languages = { 'lua', 'python', 'javascript', 'typescript', 'go', 'json', 'bash', 'markdown' }

--------------------------------------------------
-- 各プラグインの setup
--------------------------------------------------
vim.cmd.colorscheme('tokyonight')

require('mason').setup()
require('lualine').setup()
require('gitsigns').setup()
require('which-key').setup()
require('telescope').setup()

-- Treesitter パーサ管理（旧 nvim-treesitter の置き換え）
--   :TSManager   パーサ管理 UI を開く
--   :TSInstall   パーサを個別にインストール
--   :TSUninstall パーサを削除
require('tree-sitter-manager').setup({
  ensure_installed = languages, -- 起動時に未導入パーサを自動インストール
  highlight = languages,        -- ここに挙げた言語でハイライト有効化
})

-- 折りたたみ（treesitter ベース・Neovim コア機能）
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldenable = false -- 起動直後は折りたたまない

--------------------------------------------------
-- LSP（Neovim 0.12 ネイティブ API）
-- サーバ本体は :Mason から入れる（例: lua-language-server, pyright）
--------------------------------------------------
vim.lsp.enable({ 'lua_ls', 'pyright' }) -- 使う言語サーバに合わせて編集

-- LSP 関連キーマップ（バッファ単位で設定）
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local opts = { buffer = args.buf }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  end,
})

--------------------------------------------------
-- キーマップ（Telescope）
--------------------------------------------------
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep,  { desc = 'Live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers,    { desc = 'Buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags,  { desc = 'Help tags' })
