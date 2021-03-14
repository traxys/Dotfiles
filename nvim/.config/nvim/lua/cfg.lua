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
  	ensure_installed = {"rust", "c", "cpp", "json", "lua", "python", "toml"},
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
			},
			procMacro = {
				enable = true
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
