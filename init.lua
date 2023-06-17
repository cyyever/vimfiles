vim.o.encoding='utf-8'
-- vim.g.loaded_netrw="1"
-- vim.g.loaded_netrwPlugin="1"
-- 设置写入文件编码
vim.o.fileencodings="utf-8,gb18030,cp950,euc-tw"
vim.o.fileencoding="utf-8"

config=vim.env.MYVIMRC
config_dir=vim.fn.fnamemodify(config,":p:h")
config_update_tag_path=config_dir..'/.update_tag'
if not vim.fn.filereadable(config_update_tag_path) or vim.fn.localtime() > vim.fn.getftime(config_update_tag_path)+3600 then
  if vim.fn.executable('git') then
    vim.fn.writefile({},config_update_tag_path)
    vim.fn.system('cd '..config_dir..' && git pull && git submodule update --init')
	if vim.v.shell_error then
      vim.cmd('exec source '..config_dir.."/vimrc")
    end
  end
end
-- diff
vim.opt.diffopt:append("horizontal,algorithm:patience")

vim.o.clipboard="unnamed"

--备份文件
vim.o.backup=true
back_dir=vim.fn.stdpath('data')..'/backup/'
if not vim.fn.isdirectory(back_dir) then
  vim.fn.mkdir(back_dir)
end
vim.o.backupdir=back_dir
--设置页号
vim.o.number=true

vim.opt.runtimepath:prepend(config_dir.."/vimfiles/after")
vim.opt.runtimepath:prepend(config_dir.."/vimfiles")
vim.o.packpath=vim.o.runtimepath

local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function()
      local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
      ts_update()
    end,
  }
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- optional
    },
  }

end)

if vim.g.use_eink==0 then
  require'nvim-treesitter.configs'.setup {
    ensure_installed ="all",
    auto_install = true,
    highlight = {
      enable = true,

      -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
      -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
      -- Using this option may slow down your editor, and you may see some duplicate highlights.
      -- Instead of true it can also be a list of languages
      additional_vim_regex_highlighting = false,
    },
  }
else
  require'nvim-treesitter.configs'.setup {
    highlight = {
      enable = false,

      -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
      -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
      -- Using this option may slow down your editor, and you may see some duplicate highlights.
      -- Instead of true it can also be a list of languages
      additional_vim_regex_highlighting = false,
    },
  }
end
require("nvim-tree").setup()

vim.cmd('source '..config_dir..'/vimfiles/vimrc')
