set mouse=v                 " middle-click paste with 
set guicursor=n-v-c-i:block " block cursor
set nohlsearch              " highlight search 
"set ignorecase              " case insensitive 
set incsearch               " incremental search

set tabstop=4 softtabstop=4 " see multiple spaces as tabstops so <BS> does the right thing
set shiftwidth=4            " width for autoindents
set expandtab               " converts tabs to white space
set autoindent              " indent a new line the same amount as the line just typed

set number
set relativenumber          " add line numbers
set wildmode=longest,list   " get bash-like tab completions
filetype plugin indent on   " allow auto-indenting depending on file type
syntax on                   " syntax highlighting
set mouse=a                 " enable mouse click
set clipboard=unnamedplus   " using system clipboard
filetype plugin on
set cursorline              " highlight current cursorline
"set ttyfast                 " Speed up scrolling in Vim

set noswapfile            " disable creating swap file
set nobackup
set undodir=~/.vim/undodir
set undofile

set termguicolors
set scrolloff=12
set signcolumn=yes
"set cc=120                  " set an 120 column border for good coding style

" Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

  autocmd BufWritePost *.tex :silent exec "!pdflatex %"
endif

" REMAP
let mapleader=' '

nnoremap ZZ :bw<CR>
nnoremap ZQ :bd<CR>

" tabs
nnoremap <C-t> :tabnew<CR>
nnoremap <C-h> :tabprevious<CR>
nnoremap <C-l> :tabnext<CR>

" insert "", '', {}, (), []
inoremap " ""<Left>
inoremap ' ''<Left>
inoremap ( ()<Left>
inoremap [ []<Left>
inoremap { {}<Left>
inoremap {<CR> {<CR>}<Esc>O
inoremap {<Space> {  }<Left><Left>

" insert around selection
vnoremap " c""<Esc>P
vnoremap ' c''<Esc>P
vnoremap ( c()<Esc>P
vnoremap [ c[]<Esc>P
vnoremap { c{}<Esc>P

" save
nnoremap <C-s> :w<CR>

" center cursor
nnoremap <C-u> <C-u>zz
nnoremap <C-d> <C-d>zz
nnoremap <C-o> <C-o>zz
nnoremap <C-i> <C-i>zz
nnoremap n nzz
nnoremap N Nzz

" cursor to start/end
nnoremap H ^
vnoremap H ^
nnoremap L $
vnoremap L $

"" FIND AND REPLACE
" For local replace
nnoremap gr gd[{V%::s/<C-R>///gc<left><left><left>
" For global replace
nnoremap gR gD:%s/<C-R>///gc<left><left><left>

" Telecope
nnoremap <C-,> :Telescope git_files<CR>
nnoremap <C-<> :Telescope find_files<CR>
nnoremap <C-f> :Telescope live_grep<CR>
nnoremap <C-b> :Telescope buffers<CR>

" GitUI
nnoremap <Leader>g :Gitui<CR>

nnoremap tn :TSNodeUnderCursor<CR>

" codeium
imap <script><silent><nowait><expr> <C-x> codeium#Accept()

" TreeSitterPlayground
" nnoremap <Leader>p :TSPlaygroundToggle

" syntax highlighting for OpenCL files
au BufNewFile,BufRead *.cl set syntax=c

" syntax highlighting for Aback files
au BufNewFile,BufRead *.ab set syntax=aback

" PLUGIN MANAGEMENT
" vim-plug
call plug#begin()

" colour schemes
Plug 'rose-pine/neovim', { 'as': 'rose-pine' }

Plug 'rust-lang/rust.vim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'
Plug 'nvim-treesitter/nvim-treesitter-context'

if exists('g:vscode')
else
    Plug 'nvim-lualine/lualine.nvim'
    Plug 'kyazdani42/nvim-web-devicons'
endif

Plug 'airblade/vim-gitgutter'
Plug 'aspeddro/gitui.nvim'
Plug 'ThePrimeagen/vim-be-good'

" Telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.3' }

" syntax
Plug 'digitaltoad/vim-pug'


" LSP Support
Plug 'neovim/nvim-lspconfig'             " Required
Plug 'williamboman/mason.nvim'           " Optional
Plug 'williamboman/mason-lspconfig.nvim' " Optional

" Autocompletion Engine
Plug 'hrsh7th/nvim-cmp'         " Required
Plug 'hrsh7th/cmp-nvim-lsp'     " Required
Plug 'hrsh7th/cmp-buffer'       " Optional
Plug 'hrsh7th/cmp-path'         " Optional
Plug 'saadparwaiz1/cmp_luasnip' " Optional
Plug 'hrsh7th/cmp-nvim-lua'     " Optional

Plug 'VonHeikemen/lsp-zero.nvim', {'branch': 'v1.x'}

" Debug adapter
Plug 'mfussenegger/nvim-dap'
Plug 'nvim-neotest/nvim-nio',
Plug 'rcarriga/nvim-dap-ui'

call plug#end()

inoremap \t \t

" COLOR SCHEME 
set background=dark 
set t_Co=256
set t_ut=


lua <<EOF

-- LSP
-- Learn the keybindings, see :help lsp-zero-keybindings
-- Learn to configure LSP servers, see :help lsp-zero-api-showcase
local lsp = require('lsp-zero')
lsp.preset('recommended')
lsp.ensure_installed({
    'tsserver',
    'clangd',
    'rust_analyzer'
})

-- (Optional) Configure lua language server for neovim
lsp.nvim_workspace()
lsp.setup()

vim.diagnostic.config({
    -- always show error messages inline
    virtual_text = true,
})

-- Lualine
if not vim.g.vscode then
    require('lualine').setup({
        options = {
            theme = 'rose-pine'
        }
    })
end

-- rose-pine color scheme
require('rose-pine').setup({
	--- @usage 'main' | 'moon'
	dark_variant = 'main',
	bold_vert_split = false,
    dim_nc_background = true,
    disable_background = true,
	disable_float_background = true,
})

require('gitui').setup()

EOF

colorscheme rose-pine

" POWERLINE FONTS
set laststatus=2 " Always display the statusline in all windows
set showtabline=1 " Always display the tabline, even if there is only one tab
set noshowmode " Hide the default mode text (e.g. -- INSERT -- below the statusline)
let g:airline_powerline_fonts = 1
let g:airline#extensions#whitespace#enabled = 0

lua <<EOF

----------------
-- treesitter --
----------------

require('nvim-treesitter.configs').setup({
  ensure_installed = "all",

  auto_install = true,

  -- ignore_install = { "javascript" },

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- list of language that will be disabled
    -- disable = { "c", "rust" },

    additional_vim_regex_highlighting = false,
  },
})

local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.slj = {
  install_info = {
    url = "git@github.com:jkenda/tree-sitter-slj", -- local path or git repo
    branch = "main",
    files = {"src/parser.c"},
  },
  filetype = "slj", -- if filetype does not match the parser name
}

parser_config.odin = {
  install_info = {
    url = "git@github.com:ap29600/tree-sitter-odin.git", -- local path or git repo
    files = {"src/parser.c"},
  },
  filetype = "odin", -- if filetype does not match the parser name
}

parser_config.pug = {
  install_info = {
    url = "git@github.com:zealot128/tree-sitter-pug.git", -- local path or git repo
    branch = "main",
    files = {"src/parser.c"},
  },
  filetype = "pug", -- if filetype does not match the parser name
}

vim.filetype.add({ extension = { slj = "slj" } })
vim.filetype.add({ extension = { odin = "odin" } })
vim.filetype.add({ extension = { cl = "opencl" } })
vim.filetype.add({ extension = { wgsl = "wgsl" } })

vim.treesitter.language.register("c", "opencl")


---------
-- DAP --
---------

local dap = require "dap"
local ui = require "dapui"


ui.setup()

dap.adapters.gdb = {
    id = "gdb",
    type = "executable",
    command = "gdb",
    args = { "--quiet", "--interpreter=dap" },
}

-- opam install earlybird
dap.adapters.ocaml = {
	type = "executable",
	command = "ocamlearlybird",
	args = { "debug" },
	cwd = "${workspaceFolder}",
}

dap.configurations.ocaml = {}

vim.keymap.set("n", "<Leader>b" , dap.toggle_breakpoint)
vim.keymap.set("n", "<Leader>ru", dap.run_to_cursor)

vim.keymap.set("n", "<Leader>k", function()
    require("dapui").eval(nil, { enter = true })
end)

vim.keymap.set("n", "<F5>", dap.continue)
vim.keymap.set("n", "<F11>", dap.step_into)
vim.keymap.set("n", "<F10>", dap.step_over)
vim.keymap.set("n", "<C-<F11>>", dap.step_out)
-- vim.keymap.set("n", "<F5>", dap.step_back)
-- vim.keymap.set("n", "<F13>", dap.restart)

dap.listeners.before.attach.dapui_config = function()
    ui.open()
end
dap.listeners.before.launch.dapui_config = function()
    ui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
    ui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
    ui.close()
end

EOF
