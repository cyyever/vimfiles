vim.o.encoding='utf-8'
vim.g.loaded_netrw="1"
vim.g.loaded_netrwPlugin="1"
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
back_dir=vim.fn.stdpath('data')..'/backup//'
if not vim.fn.isdirectory(back_dir) then
  vim.fn.mkdir(back_dir)
end
--设置页号
vim.o.number=false

vim.opt.runtimepath:prepend(config_dir.."/vimfiles")
vim.opt.runtimepath:prepend(config_dir.."/vimfiles/after")
vim.o.packpath=vim.o.runtimepath
vim.cmd('source '..config_dir..'/vimfiles/vimrc')
