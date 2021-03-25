local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

require('lspkind').init({})

require'lspconfig'.rust_analyzer.setup{
	on_attach=on_attach_vim,
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
}

require'lspconfig'.jsonls.setup{
        cmd = { "json-languageserver", "--stdio" },
}
require'lspconfig'.bashls.setup{}
