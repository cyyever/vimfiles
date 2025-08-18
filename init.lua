vim.o.encoding = "utf-8"
vim.o.fileformats = "unix,dos"
vim.g.mapleader = ";"
require("config.lazy")

-- disable netrw at the very start of your init.lua for nvim-tree.lua
vim.g.loaded_netrw = "1"
vim.g.loaded_netrwPlugin = "1"

config = vim.env.MYVIMRC
config_dir = vim.fn.fnamemodify(config, ":p:h")
vim.opt.runtimepath:prepend(config_dir .. "/vimfiles/after")
vim.opt.runtimepath:prepend(config_dir .. "/vimfiles")
vim.o.packpath = vim.o.runtimepath

if vim.fn.exists("$eink_screen") and vim.env.eink_screen == 1 then
	vim.g.use_eink = 1
else
	vim.g.use_eink = 0
end

-- 设置写入文件编码
vim.o.fileencodings = "utf-8,gb18030,cp950,euc-tw"
vim.o.fileencoding = "utf-8"

-- 文件类型选项
vim.g.sql_type_default = "mysql"
vim.cmd("filetype plugin on")
vim.cmd("filetype indent on")

-- diff
vim.opt.diffopt:append("horizontal,algorithm:patience")

-- 增加检索路径
vim.opt.path:append(vim.env.HOME .. "/opt/bin")
vim.opt.path:append(vim.env.HOME .. "/opt/python/bin")
vim.opt.path:append(vim.env.HOME .. "/.local/bin")
vim.opt.path:append(vim.env.HOME .. "/opt/include")

vim.o.clipboard = "unnamed"

--备份文件
vim.o.backup = true
back_dir = vim.fn.stdpath("data") .. "/backup/"
if not vim.fn.isdirectory(back_dir) then
	vim.fn.mkdir(back_dir)
end
vim.o.backupdir = back_dir
--设置页号
vim.o.number = true

--缩进宽度
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.expandtab = true

--关键字搜索当前目录

vim.opt.complete:append("k*")

-- 补全选项
vim.o.wildignorecase = true
vim.o.infercase = true

--检索时的大小写处理
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.tagcase = "match"

-- provider
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
if vim.loop.os_uname().sysname == "Windows_NT" then
	vim.g.python3_host_prog = "python"
end
vim.g.node_host_prog = vim.env.HOME .. "/opt/node_modules/neovim/bin/cli.js"

vim.o.mouse = "r"

vim.cmd("source " .. config_dir .. "/vimfiles/vimrc")

if vim.g.use_eink == 1 then
	vim.cmd("colorscheme eink")
else
	vim.o.background = "dark" -- or "light" for light mode
	vim.cmd([[colorscheme gruvbox]])
end

-- config_update_tag_path = config_dir .. "/.update_tag"
-- if
-- 	not vim.fn.filereadable(config_update_tag_path)
-- 	or vim.fn.getftime(config) > vim.fn.getftime(config_update_tag_path)
-- then
-- 	vim.cmd("Lazy sync")
-- 	vim.fn.writefile({}, config_update_tag_path)
-- end
