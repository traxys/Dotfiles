local lsp_status = require('lsp-status')
lsp_status.register_progress()

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities = vim.tbl_extend('keep', capabilities, lsp_status.capabilities)

require('lspkind').init({})

require'lspconfig'.rust_analyzer.setup{
	on_attach=lsp_status.on_attach,
	settings = {
		["rust-analyzer"] = {
			cargo = {
				allFeatures = true
			},
			updates = {
				channel = "nightly"
			},
		}
	},
	capabilities = capabilities
}

require'lspconfig'.jsonls.setup{
	on_attach=lsp_status.on_attach,
    cmd = { "json-languageserver", "--stdio" },
	capabilities = capabilities
}
require'lspconfig'.bashls.setup{
	on_attach=lsp_status.on_attach,
	capabilities = capabilities
}
require'lspconfig'.clangd.setup{
	on_attach = lsp_status.on_attach,
	handlers = lsp_status.extensions.clangd.setup(),
	init_options = { clangdFileStatus = true},
	capabilities = capabilities
}
