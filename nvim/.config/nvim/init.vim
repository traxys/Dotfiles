call plug#begin('~/.local/share/nvim/plugged')

Plug 'kyazdani42/nvim-web-devicons'
Plug 'romgrk/barbar.nvim'

Plug 'neovim/nvim-lspconfig'
Plug 'tjdevries/lsp_extensions.nvim'
"Plug 'RishabhRD/popfix'
"Plug 'RishabhRD/nvim-lsputils'
Plug 'glepnir/lspsaga.nvim'

Plug 'jdonaldson/vaxe'
Plug 'nvim-lua/lsp-status.nvim'
Plug 'peterhoeg/vim-qml'
Plug 'elixir-editors/vim-elixir'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'glepnir/galaxyline.nvim'
Plug 'drmikehenry/vim-headerguard'
Plug 'airblade/vim-gitgutter'
Plug 'rust-lang/rust.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'dart-lang/dart-vim-plugin'
Plug 'plasticboy/vim-markdown'
Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'}
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
Plug 'hashivim/vim-terraform'
Plug 'pearofducks/ansible-vim', { 'do': './UltiSnips/generate.sh' }
Plug 'kosayoda/nvim-lightbulb'
"keybind are gcc for commenting a line and gc for selection
Plug 'b3nj5m1n/kommentary'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/nvim-compe'
Plug 'teal-language/vim-teal'

call plug#end()

packadd termdebug

let g:vimsyn_embed = 'lPr'
lua << EOF

local saga = require 'lspsaga'
saga.init_lsp_saga()

require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;

  source = {
    path = true;
    buffer = true;
    calc = true;
    vsnip = true;
    nvim_lsp = true;
    nvim_lua = true;
    spell = true;
    tags = true;
    snippets_nvim = true;
    treesitter = true;
  };
}

local gl = require('galaxyline')
local gls = gl.section
gl.short_line_list = {'LuaTree','vista','dbui'}

local lsp_status = require('lsp-status')
lsp_status.register_progress()

local colors = {
  bg = '#282c34',
  yellow = '#fabd2f',
  cyan = '#008080',
  darkblue = '#081633',
  green = '#afd700',
  orange = '#FF8800',
  purple = '#5d4d7a',
  magenta = '#d16d9e',
  grey = '#c0c0c0',
  blue = '#0087d7',
  red = '#ec5f67',
  violet = '#6860e7'
}

local buffer_not_empty = function()
  if vim.fn.empty(vim.fn.expand('%:t')) ~= 1 then
    return true
  end
  return false
end

-- Start of line
gls.left[1] = {
  FirstElement = {
    provider = function() return '▋' end,
    highlight = {colors.blue,colors.yellow}
  },
}
-- Vim mode
gls.left[2] = {
  ViMode = {
    provider = function()
      local alias = {n = 'NORMAL ',i = 'INSERT ',c= 'COMMAND ',V= 'VISUAL ', [''] = 'VISUAL '}
      return alias[vim.fn.mode()]
    end,
    separator = '',
    separator_highlight = {colors.yellow,function()
      if not buffer_not_empty() then
        return colors.purple
      end
      return colors.darkblue
    end},
    highlight = {colors.violet,colors.yellow,'bold'},
  },
}
-- File Icon
gls.left[3] ={
  FileIcon = {
    provider = 'FileIcon',
    condition = buffer_not_empty,
    highlight = {require('galaxyline.provider_fileinfo').get_file_icon_color,colors.darkblue},
  },
}
-- File Name
gls.left[4] = {
  FileName = {
    provider = {'FileName'},
    condition = buffer_not_empty,
    separator = '',
    separator_highlight = {colors.purple,colors.darkblue},
    highlight = {colors.magenta,colors.darkblue}
  }
}
-- GIT
gls.left[5] = {
  GitIcon = {
    provider = function() return '  ' end,
    condition = buffer_not_empty,
    highlight = {colors.orange,colors.purple},
  }
}
gls.left[6] = {
  GitBranch = {
    provider = 'GitBranch',
    condition = buffer_not_empty,
    highlight = {colors.grey,colors.purple},
  }
}

local vcs = require('galaxyline.provider_vcs')

local is_file_diff = function ()
	if vcs.diff_add() ~= nil or vcs.diff_modified() ~= nil or vcs.diff_remove() ~= nil then
		return ''
	end
end

gls.left[7] = {
  GitModified = {
    provider = is_file_diff,
    highlight = {colors.green,colors.purple},
  }
}
gls.left[8] = {
  LeftEnd = {
    provider = function() return '' end,
    separator = '',
    separator_highlight = {colors.purple,colors.bg},
    highlight = {colors.purple,colors.purple}
  }
}

local lsp_diag_error = function() 
  local diagnostics = require('lsp-status/diagnostics')
  local buf_diagnostics = diagnostics()

  if buf_diagnostics.errors and buf_diagnostics.errors > 0 then
	return buf_diagnostics.errors .. ' '
  end
end
local lsp_diag_warn = function() 
  local diagnostics = require('lsp-status/diagnostics')
  local buf_diagnostics = diagnostics()

  if buf_diagnostics.warnings and buf_diagnostics.warnings > 0 then
	return buf_diagnostics.warnings .. ' '
  end
end
local has_lsp = function ()
	return #vim.lsp.buf_get_clients() ~= 0
end

local has_curent_func = function ()
	if not has_lsp then
		return false
	end
	local current_function = vim.b.lsp_current_function
	return current_function and current_function ~= ''
end
local lsp_current_func = function ()
    local current_function = vim.b.lsp_current_function
    if current_function and current_function ~= '' then
      return '(' .. current_function .. ') '
    end
end

gls.right[1] = {
	LspText = {
	    provider = function() return '' end,
		separator = '',
    	separator_highlight = {colors.darkblue,colors.bg},
    	highlight = {colors.grey,colors.darkblue},
	}
}
gls.right[2] = {
	LspError = {
		provider = lsp_diag_error,
		condition = has_lsp,
		icon = ' ',
    	highlight = {colors.grey,colors.darkblue},
	}
}
gls.right[3] = {
	LspWarning = {
		provider = lsp_diag_warn,
		condition = has_lsp,
		icon = ' ',
    	highlight = {colors.grey,colors.darkblue},
	}
}
gls.right[4] = {
	LspCurrentFunc = {
		provider = lsp_current_func,
		condition = has_current_func,
		icon = '𝒇',
    	highlight = {colors.grey,colors.darkblue},
	}
}
gls.right[5]= {
  FileFormat = {
    provider = 'FileFormat',
    separator = '',
    separator_highlight = {colors.darkblue,colors.purple},
    highlight = {colors.grey,colors.purple},
  }
}
gls.right[6] = {
  LineInfo = {
    provider = 'LineColumn',
    separator = ' | ',
    separator_highlight = {colors.darkblue,colors.purple},
    highlight = {colors.grey,colors.purple},
  },
}
gls.right[7] = {
  PerCent = {
    provider = 'LinePercent',
    separator = '',
    separator_highlight = {colors.darkblue,colors.purple},
    highlight = {colors.grey,colors.darkblue},
  }
}
gls.right[8] = {
  ScrollBar = {
    provider = 'ScrollBar',
    highlight = {colors.yellow,colors.purple},
  }
}

-- vim.lsp.callbacks['textDocument/codeAction'] = require'lsputil.codeAction'.code_action_handler
-- vim.lsp.callbacks['textDocument/references'] = require'lsputil.locations'.references_handler
-- vim.lsp.callbacks['textDocument/definition'] = require'lsputil.locations'.definition_handler
-- vim.lsp.callbacks['textDocument/declaration'] = require'lsputil.locations'.declaration_handler
-- vim.lsp.callbacks['textDocument/typeDefinition'] = require'lsputil.locations'.typeDefinition_handler
-- vim.lsp.callbacks['textDocument/implementation'] = require'lsputil.locations'.implementation_handler
-- vim.lsp.callbacks['textDocument/documentSymbol'] = require'lsputil.symbols'.document_handler
-- vim.lsp.callbacks['workspace/symbol'] = require'lsputil.symbols'.workspace_handler

require'nvim-treesitter.configs'.setup {
  	ensure_installed = "all",     -- one of "all", "language", or a list of languages
 	highlight = {
    	enable = true,              -- false will disable the whole extension
    	disable = {"elixir", "teal"},  -- list of language that will be disabled
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
local lspconfig = require'lspconfig'

local on_attach_vim = function(client)
  --require'completion'.on_attach(client)
  lsp_status.on_attach(client)
end

--local capabilities = lsp_status.capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

lspconfig.rust_analyzer.setup{
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
	},
	capabilities = capabilities
}
lspconfig.texlab.setup{
	on_attach=on_attach_vim,
	capabilities = capabilities
}
lspconfig.elixirls.setup{
	on_attach=on_attach_vim,
	cmd = {"elixir-ls"},
	filetypes = { "elixir", "eelixir", "ex" },
	capabilities = capabilities
}
lspconfig.jsonls.setup{
	on_attach=on_attach_vim,
	cmd = { "json-languageserver", "--stdio" },
	capabilities = capabilities
}
lspconfig.dartls.setup{
	on_attach=on_attach_vim,
	capabilities = capabilities
}
lspconfig.sqlls.setup{
	on_attach=on_attach_vim,
	cmd = {"/home/traxys/.cache/nvim/nvim_lsp/sqlls/node_modules/.bin/sql-language-server", "up", "--method", "stdio"},
	capabilities = capabilities
}
lspconfig.terraformls.setup{
	on_attach=on_attach_vim,
	capabilities = capabilities
}
lspconfig.vimls.setup{
	on_attach=on_attach_vim,
	capabilities = capabilities
}
lspconfig.yamlls.setup{
	on_attach=on_attach_vim,
	capabilities = capabilities
}
lspconfig.dockerls.setup{
	on_attach=on_attach_vim,
	capabilities = capabilities
}
lspconfig.html.setup{
	on_attach=on_attach_vim,
	capabilities = capabilities
}
lspconfig.bashls.setup{
	on_attach=on_attach_vim,
	capabilities = capabilities
}
require'lspconfig'.sumneko_lua.setup{
  cmd = {"/home/traxys/bin/lua-language-server"},
	on_attach=on_attach_vim,
	capabilities = capabilities
}
--require'lspconfig'.jdtls.setup{on_attach=on_attach_vim}
--require "nvim-treesitter.parsers".get_parser_configs().markdown = nil

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif vim.fn.call("vsnip#available", {1}) == 1 then
    return t "<Plug>(vsnip-expand-or-jump)"
  else
    return t "<Tab>"
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
    return t "<Plug>(vsnip-jump-prev)"
  else
    return t "<S-Tab>"
  end
end

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
EOF

inoremap <silent><expr> <CR>      compe#confirm('<CR>')

"set completeopt=menuone,noinsert,noselect
set completeopt=menu,menuone,noselect
set shortmess+=c

nnoremap <silent><leader>cd <cmd>lua require'lspsaga.diagnostic'.show_line_diagnostics()<CR>
nnoremap <silent> [e <cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()<CR>
nnoremap <silent> ]e <cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()<CR>

nnoremap <silent> gh <cmd>lua require'lspsaga.provider'.lsp_finder()<CR>
nnoremap <silent> gd <cmd>lua require'lspsaga.provider'.preview_definition()<CR>
nnoremap <silent> K <cmd>lua require('lspsaga.hover').render_hover_doc()<CR>
nnoremap <silent> gr    		<cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> <c-k> 		<cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> gF    		<cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    		<cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> gT    		<cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> ff    		<cmd>lua vim.lsp.buf.formatting()<CR>
nnoremap <silent><leader>rn <cmd>lua require('lspsaga.rename').rename()<CR>
nnoremap <silent>ca <cmd>lua require('lspsaga.codeaction').code_action()<CR>
vnoremap <silent>ca <cmd>'<,'>lua require('lspsaga.codeaction').range_code_action()<CR>

noremap b n

noremap s l
noremap n k
noremap t j
noremap h h
noremap <c-n> <PageUp>
noremap <c-t> <PageDown>

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
set scrolloff=7

nmap <silent> ft :CHADopen<CR>
nmap <silent> bp :BufferPick<CR>
nmap <silent> ct :TagbarToggle<CR>

let g:diagnostic_enable_virtual_text = 1
let g:diagnostic_trimmed_virtual_text = '40'
" Set updatetime for CursorHold
" 300ms of no cursor movement to trigger CursorHold
set updatetime=300
" Show diagnostic popup on cursor hold
autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()
autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()

autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *
\ lua require'lsp_extensions'.inlay_hints{ prefix = '', highlight = "Comment" }
