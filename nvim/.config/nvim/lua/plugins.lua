local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
  execute 'packadd packer.nvim'
end

vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
	use {'wbthomason/packer.nvim', opt = true}

	use 'kyazdani42/nvim-web-devicons'
	use 'ryanoasis/vim-devicons'

	-- Generic Language Plugins
	use 'neovim/nvim-lspconfig'
	use 'nvim-lua/lsp_extensions.nvim'
	use 'glepnir/lspsaga.nvim'
	use 'nvim-lua/lsp-status.nvim'
	use 'editorconfig/editorconfig-vim'
	use 'majutsushi/tagbar'
	use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
	use 'hrsh7th/vim-vsnip'
	use 'hrsh7th/nvim-compe'
	use 'onsails/lspkind-nvim'

	-- Specific Langs
	use 'peterhoeg/vim-qml'
	use 'elixir-editors/vim-elixir'
	use 'octol/vim-cpp-enhanced-highlight'
	use 'drmikehenry/vim-headerguard'
	use 'rust-lang/rust.vim'
	use 'dart-lang/dart-vim-plugin'
	use 'plasticboy/vim-markdown'
	use 'dpelle/vim-Grammalecte'
	use 'dpelle/vim-LanguageTool'
	use 'posva/vim-vue'
	use 'cespare/vim-toml'
	use 'hashivim/vim-terraform'
	use {'pearofducks/ansible-vim', run = "./UltiSnips/generate.sh"}

	-- Git
	use 'airblade/vim-gitgutter'
	use 'tpope/vim-fugitive'
	use 'junegunn/gv.vim'

	-- Misc
	use 'andymass/vim-matchup'
	use 'Yggdroot/indentLine'
	use 'b3nj5m1n/kommentary'
	use 'andweeb/presence.nvim'
	use 'kosayoda/nvim-lightbulb' 

	-- Inteface
	use 'romgrk/barbar.nvim'
	use 'glepnir/galaxyline.nvim'
	use {'ms-jpq/chadtree', branch = 'chad', run = 'python3 -m chadtree deps'}

	-- Theme
	use 'bluz71/vim-moonfly-colors'
end)
