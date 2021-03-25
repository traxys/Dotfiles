lua require("plugins")
lua require("tree_sitter")
lua require("lsp")
lua require("completion")

set termguicolors
colorscheme moonfly
set number
set tabstop=4
set shiftwidth=4
set ai
set scrolloff=7
set signcolumn=yes
set cmdheight=2
set hidden

set completeopt=menuone,noselect

let g:indentLine_concealcursor = 'inc'
let g:indentLine_conceallevel = 2
let g:indentLine_fileTypeExclude = ['markdown', 'json']

nnoremap <silent> bp <cmd>Telescope buffers<CR>
nnoremap <silent> ca <cmd>Telescope lsp_code_actions<CR>
nnoremap <silent> gr <cmd>Telescope lsp_references<CR>
nnoremap <silent> gW <cmd>Telescope lsp_workspace_symbols<CR>
nnoremap <silent> gF <cmd>Telescope lsp_document_symbols<CR>
nnoremap <silent> ft <cmd>Telescope file_browser<CR>
nnoremap <silent> ge <cmd>Telescope lsp_document_diagnostics<CR>
nnoremap <silent> mn <cmd>Telescope man_pages<CR>
nnoremap <silent> fg <cmd>Telescope git_files<CR>
nnoremap <silent> K  <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> ff <cmd>lua vim.lsp.buf.formatting()<CR>

nnoremap <silent> mk <cmd>Telescope keymaps<CR>

syntax enable
filetype plugin indent on
set omnifunc=v:lua.vim.lsp.omnifunc

set updatetime=300
autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()
autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()
autocmd CursorHold,CursorHoldI *.rs :lua require'lsp_extensions'.inlay_hints{}
