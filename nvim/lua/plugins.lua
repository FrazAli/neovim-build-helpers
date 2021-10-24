local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use { 'kyazdani42/nvim-tree.lua',
  	requires = {
                     {'kyazdani42/nvim-web-devicons'}
                   },
        config = function() require'nvim-tree'.setup {} end
      }
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use {
        'nvim-telescope/telescope.nvim', opt = false,
        cmd = {'Telescope'},
        requires = {
		     {'nvim-lua/plenary.nvim'},
                     {'sharkdp/fd', opt = false}
	           },
        config = require("telescope").seeup()
      }

  -- Automatically set up your configuration after cloning packer.nvim
  if packer_bootstrap then
    require('packer').sync()
  end
end)

