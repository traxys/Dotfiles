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

	use {'kyazdani42/nvim-web-devicons'}

	use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
	use { 'neovim/nvim-lspconfig' }

	use { 'kosayoda/nvim-lightbulb' }
	use { 'Yggdroot/indentLine'} 
	use {
  		'lewis6991/gitsigns.nvim',
  		requires = {
    			'nvim-lua/plenary.nvim'
  		},
		config = function()
    			require('gitsigns').setup()
  		end
	}

	use { 'bluz71/vim-moonfly-colors' }
	use { 'hrsh7th/nvim-compe' }

	use {'nvim-lua/lsp_extensions.nvim'}

	use {
  		'nvim-telescope/telescope.nvim',
  		requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
	}

	use 'drmikehenry/vim-headerguard'
	use 'andymass/vim-matchup'
	use 'b3nj5m1n/kommentary'
	use 'onsails/lspkind-nvim'

end)
