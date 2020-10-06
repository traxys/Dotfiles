call plug#begin('~/.local/share/nvim/plugged')

Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
Plug 'nvim-lua/diagnostic-nvim'
Plug 'tjdevries/lsp_extensions.nvim'
Plug 'RishabhRD/popfix'
Plug 'RishabhRD/nvim-lsputils'

Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'vim-airline/vim-airline'
"Plug 'vim-airline/vim-airline-themes'
Plug 'drmikehenry/vim-headerguard'
"Plug 'Soares/base16.nvim'
Plug 'airblade/vim-gitgutter'
Plug 'rust-lang/rust.vim'
" Plug 'lervag/vimtex'
Plug 'editorconfig/editorconfig-vim'
Plug 'dart-lang/dart-vim-plugin'
" Plug 'rhysd/vim-clang-format'
Plug 'plasticboy/vim-markdown'
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ryanoasis/vim-devicons'
Plug 'Yggdroot/indentLine'
Plug 'luochen1990/rainbow'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'
Plug 'dpelle/vim-Grammalecte'
Plug 'dpelle/vim-LanguageTool'
"Plug 'tyru/eskk.vim'
"Plug 'tyru/skkdict.vim'
Plug 'andymass/vim-matchup'
" Plug 'mattn/emmet-vim'
Plug 'majutsushi/tagbar'
"Plug 'edwinb/idris2-vim'
Plug 'posva/vim-vue'
"Plug 'pangloss/vim-javascript'
"Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'cespare/vim-toml'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'bluz71/vim-moonfly-colors'

call plug#end()

packadd termdebug

let g:vimsyn_embed = 'lPr'
lua << EOF

vim.lsp.callbacks['textDocument/codeAction'] = require'lsputil.codeAction'.code_action_handler
vim.lsp.callbacks['textDocument/references'] = require'lsputil.locations'.references_handler
vim.lsp.callbacks['textDocument/definition'] = require'lsputil.locations'.definition_handler
vim.lsp.callbacks['textDocument/declaration'] = require'lsputil.locations'.declaration_handler
vim.lsp.callbacks['textDocument/typeDefinition'] = require'lsputil.locations'.typeDefinition_handler
vim.lsp.callbacks['textDocument/implementation'] = require'lsputil.locations'.implementation_handler
vim.lsp.callbacks['textDocument/documentSymbol'] = require'lsputil.symbols'.document_handler
vim.lsp.callbacks['workspace/symbol'] = require'lsputil.symbols'.workspace_handler

local on_attach_vim = function()
  require'completion'.on_attach()
  require'diagnostic'.on_attach()
end
require'nvim-treesitter.configs'.setup {
  	ensure_installed = "all",     -- one of "all", "language", or a list of languages
 	highlight = {
    	enable = true,              -- false will disable the whole extension
    	disable = {},  -- list of language that will be disabled
  	},
	refactor = {
      	highlight_definitions = { enable = true },
      	highlight_current_scope = { enable = false },
	  	smart_rename = {
        	enable = true,
        	keymaps = {
          		smart_rename = "grr",
        	},
      	},
    },
}
require'nvim_lsp'.rust_analyzer.setup{
	on_attach=on_attach_vim,
	settings = {
		["rust-analyzer"] = {
			cargo = {
				allFeatures = true
			},
			updates = {
				channel = "nightly"
			}
		}
	}
}
require'nvim_lsp'.texlab.setup{on_attach=on_attach_vim}
require'nvim_lsp'.elixirls.setup{on_attach=on_attach_vim}
require'nvim_lsp'.jsonls.setup{on_attach=on_attach_vim}
require'nvim_lsp'.dartls.setup{on_attach=on_attach_vim}
require'nvim_lsp'.sqlls.setup{
	on_attach=on_attach_vim,
	cmd = {"/home/traxys/.cache/nvim/nvim_lsp/sqlls/node_modules/.bin/sql-language-server", "up", "--method", "stdio"}
}
require'nvim_lsp'.terraformls.setup{on_attach=on_attach_vim}
require'nvim_lsp'.vimls.setup{on_attach=on_attach_vim}
require'nvim_lsp'.yamlls.setup{on_attach=on_attach_vim}
require'nvim_lsp'.dockerls.setup{on_attach=on_attach_vim}
require'nvim_lsp'.html.setup{on_attach=on_attach_vim}
EOF

inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

set completeopt=menuone,noinsert,noselect
set shortmess+=c

nmap <silent> [c :PrevDiagnosticCycle<CR>
nmap <silent> ]c :NextDiagnosticCycle<CR>

nnoremap <silent> gd    		<cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     		<cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gr    		<cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> <c-k> 		<cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> gF    		<cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    		<cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> gT    		<cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> ff    		<cmd>lua vim.lsp.buf.formatting()<CR>
nnoremap <silent> <leader>rn    <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> ca    		<cmd>lua vim.lsp.buf.code_action()<CR>

let g:diagnostic_enable_underline = 1

set omnifunc=v:lua.vim.lsp.omnifunc

"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

syntax enable
filetype plugin indent on
let g:base16_color_overrides = { 'Pmenu' : 'bg=black'}
let g:base16_transparent_background = 1
let g:grammalecte_cli_py = '/usr/bin/grammalecte-cli'
let g:vim_markdown_conceal_code_blocks = 0
"let g:base16_airline=1

let g:eskk#large_dictionary = {
    \   'path': '/usr/share/skk/SKK-JISYO.L',
    \   'sorted': 1,
    \   'encoding': 'euc-jp',
    \}

let g:indentLine_setColors = 0
colorscheme moonfly
set number

set tabstop=4
set shiftwidth=4
set ai

set statusline+=%#warningmsg#
set statusline+=%*

" let g:rainbow_active = 1

" let g:rustfmt_autosave = 1

let g:tex_flavor  = 'latex'
let g:tex_conceal = ''
let g:vimtex_latexmk_continuous = 1
let g:vimtex_compiler_progname = 'nvr'
let g:vimtex_view_method = 'zathura'

let g:airline_powerline_fonts = 1

let g:vim_markdown_folding_disabled = 1

let g:indentLine_fileTypeExclude = ['markdown', 'json']

set hidden
set cmdheight=2
set updatetime=300
set shortmess+=c
set signcolumn=yes

nmap <silent> ft :NERDTreeToggle<CR>
nmap <silent> ct :TagbarToggle<CR>

let g:diagnostic_enable_virtual_text = 1
let g:diagnostic_trimmed_virtual_text = '40'
" Set updatetime for CursorHold
" 300ms of no cursor movement to trigger CursorHold
set updatetime=300
" Show diagnostic popup on cursor hold
autocmd CursorHold * lua vim.lsp.util.show_line_diagnostics()

autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *
\ lua require'lsp_extensions'.inlay_hints{ prefix = '', highlight = "Comment" }
