packadd termdebug

let g:vimsyn_embed = 'lPr'
lua require("plugins")
lua require("cfg")
"luafile ~/.config/nvim/plugins.lua
"luafile ~/.config/nvim/initl.lua

inoremap <silent><expr> <CR>      compe#confirm('<CR>')

set completeopt=menuone,noinsert,noselect
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
